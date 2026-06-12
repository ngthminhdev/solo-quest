import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/quest_model.dart';
import '../../models/enums/quest_enums.dart';
import '../../services/local_storage_service.dart';
import '../../services/service_providers.dart';
import '../../modules/home/home_page_model.dart';
import '../../modules/quest_detail/quest_detail_page_model.dart';
import '../notifications/local_notification_service.dart';
import 'countdown_session.dart';

class CountdownTimerService extends StateNotifier<CountdownSession?> with WidgetsBindingObserver {
  final Ref _ref;
  late final LocalStorageService _localStorageService;
  Timer? _ticker;

  static const String _storageKey = 'active_countdown_session';

  CountdownTimerService(this._ref) : super(null) {
    _localStorageService = _ref.read(localStorageServiceProvider);
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  LocalNotificationService get _notificationService =>
      _ref.read(localNotificationServiceProvider);

  Future<void> _init() async {
    await _loadPersistedSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkExpirationOnResume();
    }
  }

  Future<void> _loadPersistedSession() async {
    try {
      final jsonStr = await _localStorageService.getString(_storageKey);
      if (!mounted) return;
      if (jsonStr != null) {
        final Map<String, dynamic> jsonMap = json.decode(jsonStr);
        final session = CountdownSession.fromJson(jsonMap);
        
        if (session.status == CountdownStatus.running) {
          final now = DateTime.now();
          if (now.isAfter(session.endAt)) {
            final expiredSession = session.copyWith(status: CountdownStatus.expired);
            if (!mounted) return;
            state = expiredSession;
            await _persistSession(expiredSession);
            _vibrate();
          } else {
            if (!mounted) return;
            state = session;
            _startTicker();
          }
        } else {
          if (!mounted) return;
          state = session;
        }
      }
    } catch (e) {
      debugPrint('[CountdownTimerService] Error loading session: $e');
    }
  }

  Future<void> _checkExpirationOnResume() async {
    if (state == null) return;
    await _loadPersistedSession();
  }

  Future<void> _persistSession(CountdownSession? session) async {
    if (session == null) {
      await _localStorageService.remove(_storageKey);
    } else {
      await _localStorageService.setString(_storageKey, json.encode(session.toJson()));
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final current = state;
      if (current == null || current.status != CountdownStatus.running) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();
      if (now.isAfter(current.endAt)) {
        timer.cancel();
        final expiredSession = current.copyWith(status: CountdownStatus.expired);
        state = expiredSession;
        await _persistSession(expiredSession);
        _vibrate();
      } else {
        state = current.copyWith();
      }
    });
  }

  void _vibrate() {
    HapticFeedback.vibrate();
  }

  Future<void> startSession(QuestModel quest) async {
    if (!isCountdownEligible(quest)) {
      throw Exception('Quest is not eligible for countdown');
    }

    final now = DateTime.now();
    final durationMinutes = quest.estimatedMinutes;
    final endAt = now.add(Duration(minutes: durationMinutes));
    
    final newSession = CountdownSession(
      sessionId: 'session_${now.millisecondsSinceEpoch}',
      questId: quest.id,
      title: quest.title,
      type: quest.type,
      durationMinutes: durationMinutes,
      startedAt: now,
      endAt: endAt,
      status: CountdownStatus.running,
    );

    state = newSession;
    await _persistSession(newSession);

    await _notificationService.scheduleCountdownNotification(newSession);

    _startTicker();
  }

  Future<void> completeSession() async {
    final current = state;
    if (current == null) return;

    if (current.status == CountdownStatus.completed) return;

    final completedSession = current.copyWith(status: CountdownStatus.completed);
    state = completedSession;
    await _persistSession(null);
    state = null;

    _ticker?.cancel();

    try {
      final idString = current.questId ?? current.sessionId;
      await _notificationService.cancelCountdownNotification(idString);
    } catch (e) {
      debugPrint('[CountdownTimerService] Error cancelling notification: $e');
    }

    if (current.source != 'reminder_setting' && current.questId != null) {
      final questService = _ref.read(questServiceProvider);
      await questService.completeQuest(current.questId!);
    }

    try {
      _ref.read(homePageProvider.notifier).loadHomeData();
    } catch (_) {}

    try {
      final detailState = _ref.read(questDetailPageProvider);
      if (current.questId != null && detailState.quest?.id == current.questId) {
        _ref.read(questDetailPageProvider.notifier).loadQuest(current.questId!);
      }
    } catch (_) {}
  }

  Future<void> cancelSession() async {
    final current = state;
    if (current == null) return;

    _ticker?.cancel();
    
    try {
      final idString = current.questId ?? current.sessionId;
      await _notificationService.cancelCountdownNotification(idString);
    } catch (e) {
      debugPrint('[CountdownTimerService] Error cancelling notification: $e');
    }

    await _persistSession(null);
    state = null;
  }

  Future<void> startReminderSession({
    required String title,
    required int durationMinutes,
    required String source,
    required String reminderType,
  }) async {
    final now = DateTime.now();
    final endAt = now.add(Duration(minutes: durationMinutes));
    
    final newSession = CountdownSession(
      sessionId: 'break_time:${now.millisecondsSinceEpoch}',
      title: title,
      type: QuestType.breakTime,
      durationMinutes: durationMinutes,
      startedAt: now,
      endAt: endAt,
      status: CountdownStatus.running,
      source: source,
      reminderType: reminderType,
    );

    state = newSession;
    await _persistSession(newSession);

    await _notificationService.scheduleCountdownNotification(newSession);

    _startTicker();
  }

  Duration getRemainingTime() {
    final current = state;
    if (current == null) return Duration.zero;
    final remaining = current.endAt.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

final countdownTimerServiceProvider = StateNotifierProvider<CountdownTimerService, CountdownSession?>((ref) {
  return CountdownTimerService(ref);
});
