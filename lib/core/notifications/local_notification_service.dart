import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../../models/quest_model.dart';
import '../../../routes/routes_config.dart';
import '../../../config/app_session.dart';
import '../../../core/timer/countdown_session.dart';
import 'notification_ids.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  final StreamController<String> _tapController = StreamController<String>.broadcast();

  Stream<String> get onTapStream => _tapController.stream;

  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      tz.initializeTimeZones();
      const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );
      await _plugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      final androidImplementation = _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[LocalNotificationService] Init error: $e');
      }
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    _tapController.add(payload);

    final navigator = AppSession.navigatorKey.currentState;
    if (navigator == null) return;

    try {
      if (payload.startsWith(NotificationIds.prefixQuestSnooze)) {
        final questId = payload.substring(NotificationIds.prefixQuestSnooze.length);
        navigator.pushNamed(RoutesConfig.questDetail, arguments: {'id': questId});
      } else if (payload.startsWith(NotificationIds.prefixCountdown)) {
        final id = payload.substring(NotificationIds.prefixCountdown.length);
        if (id.startsWith('break_time') || id.contains(':')) {
          navigator.pushNamed(RoutesConfig.home);
        } else {
          navigator.pushNamed(RoutesConfig.questDetail, arguments: {'id': id});
        }
      } else if (payload.startsWith(NotificationIds.prefixQuestReminder)) {
        final questId = payload.substring(NotificationIds.prefixQuestReminder.length);
        navigator.pushNamed(RoutesConfig.questDetail, arguments: {'id': questId});
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('[LocalNotificationService] Tap navigation error: $e');
      }
    }
  }

  // ─── Quest snooze ────────────────────────────────────────────────

  Future<void> scheduleQuestSnoozeNotification(QuestModel quest) async {
    if (!_initialized) return;

    final notificationId = NotificationIds.questSnooze(quest.id);

    await _plugin.cancel(notificationId);

    final scheduledTime = _resolveSnoozeTime(quest.snoozedUntil);

    try {
      final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);
      await _plugin.zonedSchedule(
        notificationId,
        'Đến giờ quay lại nhiệm vụ',
        quest.title,
        tzTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'quest_snooze_channel',
            'Quest Snooze Reminders',
            channelDescription: 'Notifications for snoozed quest reminders',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: '${NotificationIds.prefixQuestSnooze}${quest.id}',
      );
      if (kDebugMode) {
        developer.log(
          '[LocalNotificationService] Snooze notification scheduled for quest ${quest.id} at $scheduledTime',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('[LocalNotificationService] Schedule snooze error: $e');
      }
    }
  }

  Future<void> cancelQuestSnoozeNotification(String questId) async {
    if (!_initialized) return;
    final notificationId = NotificationIds.questSnooze(questId);
    try {
      await _plugin.cancel(notificationId);
      if (kDebugMode) {
        developer.log(
          '[LocalNotificationService] Snooze notification cancelled for quest $questId',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('[LocalNotificationService] Cancel snooze error: $e');
      }
    }
  }

  DateTime _resolveSnoozeTime(DateTime? snoozedUntil) {
    return LocalNotificationService.resolveSnoozeTime(snoozedUntil);
  }

  static DateTime resolveSnoozeTime(DateTime? snoozedUntil) {
    if (snoozedUntil != null && snoozedUntil.isAfter(DateTime.now())) {
      return snoozedUntil;
    }

    if (snoozedUntil != null) {
      if (kDebugMode) {
        developer.log(
          '[LocalNotificationService] snoozedUntil ($snoozedUntil) is in the past, '
          'falling back to now + 10 seconds',
        );
      }
      return DateTime.now().add(const Duration(seconds: 10));
    }

    if (kDebugMode) {
      developer.log(
        '[LocalNotificationService] snoozedUntil is null, falling back to now + 10 minutes',
      );
    }
    return DateTime.now().add(const Duration(minutes: 10));
  }

  // ─── Countdown timer ─────────────────────────────────────────────

  Future<void> scheduleCountdownNotification(CountdownSession session) async {
    if (!_initialized) return;

    final idString = session.questId ?? session.sessionId;
    final notificationId = NotificationIds.countdown(idString);

    try {
      final tzTime = tz.TZDateTime.from(session.endAt, tz.local);
      await _plugin.zonedSchedule(
        notificationId,
        'Hết giờ',
        '${session.title} đã kết thúc.',
        tzTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'countdown_completion_channel',
            'Countdown Completion',
            channelDescription: 'Notifications for completed countdown quests',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: '${NotificationIds.prefixCountdown}$idString',
      );
      if (kDebugMode) {
        developer.log(
          '[LocalNotificationService] Countdown notification scheduled for quest $idString at ${session.endAt}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('[LocalNotificationService] Schedule countdown error: $e');
      }
    }
  }

  Future<void> cancelCountdownNotification(String questId) async {
    if (!_initialized) return;
    final notificationId = NotificationIds.countdown(questId);
    try {
      await _plugin.cancel(notificationId);
      if (kDebugMode) {
        developer.log(
          '[LocalNotificationService] Countdown notification cancelled for quest $questId',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('[LocalNotificationService] Cancel countdown error: $e');
      }
    }
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) return;
    try {
      await _plugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'fcm_foreground_channel',
            'FCM Foreground Notifications',
            channelDescription: 'Notifications received while the app is in the foreground',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: payload,
      );
    } catch (e) {
      if (kDebugMode) {
        developer.log('[LocalNotificationService] Show notification error: $e');
      }
    }
  }
}
