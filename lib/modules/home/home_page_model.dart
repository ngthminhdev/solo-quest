import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../core/utils/app_time_formatter.dart';
import '../../models/quest_model.dart';
import '../../models/enums/quest_enums.dart';
import '../../models/progress_model.dart';
import '../../models/reminder_setting_model.dart';
import '../../models/enums/reminder_enums.dart';
import '../../core/api/dto/user_dto.dart';
import '../../services/quest_service.dart';
import '../../services/progress_service.dart';
import '../../services/log_service.dart';
import '../../services/auth_service.dart';
import '../../services/reminder_service.dart';
import '../../core/api/services/user_api_service.dart';
import '../../services/service_providers.dart';

class HomePageState extends BasePageState {
  final AppLoadState loadState;
  final List<QuestModel> activeQuests;
  final List<QuestModel> upcomingQuests;
  final List<QuestModel> snoozedQuests;
  final List<QuestModel> completedQuests;
  final ProgressModel? progress;
  final DailyStatusDto? dailyStatus;
  final String? userDisplayName;
  final String? errorMessage;
  final String? todayInsight;
  final Map<String, QuestActionType> pendingActions;
  final ReminderSettingModel? dailyReviewReminder;

  HomePageState({
    this.loadState = AppLoadState.loading,
    this.activeQuests = const [],
    this.upcomingQuests = const [],
    this.snoozedQuests = const [],
    this.completedQuests = const [],
    this.progress,
    this.dailyStatus,
    this.userDisplayName,
    this.errorMessage,
    this.todayInsight,
    this.pendingActions = const {},
    this.dailyReviewReminder,
    super.isLockedPage,
  });

  int get totalTodayQuestCount {
    return activeQuests.length +
        upcomingQuests.length +
        snoozedQuests.length +
        completedQuests.length;
  }

  int get completedTodayQuestCount => completedQuests.length;

  double get todayCompletionRate {
    if (totalTodayQuestCount == 0) return 0.0;
    return completedTodayQuestCount / totalTodayQuestCount;
  }

  bool get hasAnyQuest =>
      activeQuests.isNotEmpty ||
      upcomingQuests.isNotEmpty ||
      snoozedQuests.isNotEmpty ||
      completedQuests.isNotEmpty;

  bool get allCompleted =>
      completedQuests.isNotEmpty &&
      activeQuests.isEmpty &&
      upcomingQuests.isEmpty;

  bool get hasCheckedInToday => dailyStatus?.hasCheckedIn ?? false;
  bool get hasReviewedToday => dailyStatus?.hasReviewed ?? false;

  bool get shouldShowDailyReviewCta {
    if (hasReviewedToday) return false;

    if (dailyReviewReminder?.status != ReminderStatus.enabled) return false;

    final startTime = dailyReviewReminder?.startTime;
    if (startTime == null) return false;

    final now = DateTime.now();
    final parts = startTime.split(':');
    if (parts.length != 2) return false;

    final reminderHour = int.tryParse(parts[0]);
    final reminderMinute = int.tryParse(parts[1]);
    if (reminderHour == null || reminderMinute == null) return false;

    final reminderTime = DateTime(
      now.year,
      now.month,
      now.day,
      reminderHour,
      reminderMinute,
    );

    return now.isAfter(reminderTime);
  }

  @override
  HomePageState updateState({
    AppLoadState? loadState,
    List<QuestModel>? activeQuests,
    List<QuestModel>? upcomingQuests,
    List<QuestModel>? snoozedQuests,
    List<QuestModel>? completedQuests,
    ProgressModel? progress,
    DailyStatusDto? dailyStatus,
    String? userDisplayName,
    String? errorMessage,
    String? todayInsight,
    bool? isLockedPage,
    Map<String, QuestActionType>? pendingActions,
    ReminderSettingModel? dailyReviewReminder,
  }) {
    return HomePageState(
      loadState: loadState ?? this.loadState,
      activeQuests: activeQuests ?? this.activeQuests,
      upcomingQuests: upcomingQuests ?? this.upcomingQuests,
      snoozedQuests: snoozedQuests ?? this.snoozedQuests,
      completedQuests: completedQuests ?? this.completedQuests,
      progress: progress ?? this.progress,
      dailyStatus: dailyStatus ?? this.dailyStatus,
      userDisplayName: userDisplayName ?? this.userDisplayName,
      errorMessage: errorMessage ?? this.errorMessage,
      todayInsight: todayInsight ?? this.todayInsight,
      isLockedPage: isLockedPage ?? this.isLockedPage,
      pendingActions: pendingActions ?? this.pendingActions,
      dailyReviewReminder: dailyReviewReminder ?? this.dailyReviewReminder,
    );
  }
}

class HomePageModel extends BasePageModel<HomePageState> {
  HomePageModel({
    required this.questService,
    required this.progressService,
    required this.logService,
    required this.authService,
    required this.reminderService,
    UserApiService? userApiService,
  }) : _userApiService = userApiService ?? UserApiService(),
       super(HomePageState());

  final QuestService questService;
  final ProgressService progressService;
  final LogService logService;
  final AuthService authService;
  final ReminderService reminderService;
  final UserApiService _userApiService;

  String? _lastLoadedDate;

  Future<void> loadHomeData() async {
    final todayStr = AppTimeFormatter.todayLocalDateQuery();
    final dateChanged = _lastLoadedDate != null && _lastLoadedDate != todayStr;
    if (dateChanged && kDebugMode) {
      developer.log('[HOME] Date changed from $_lastLoadedDate to $todayStr, force reload');
    }
    _lastLoadedDate = todayStr;

    state = state.updateState(loadState: AppLoadState.loading);

    // Load all data in parallel, handle failures independently
    final results = await Future.wait([
      _loadQuests().catchError((e) {
        if (kDebugMode) developer.log('[HOME] Failed to load quests: $e');
        return <QuestModel>[];
      }),
      _loadProgress().catchError((e) {
        if (kDebugMode) developer.log('[HOME] Failed to load progress: $e');
        return null as ProgressModel?;
      }),
      _loadDailyStatus().catchError((e) {
        if (kDebugMode) developer.log('[HOME] Failed to load daily status: $e');
        return null as DailyStatusDto?;
      }),
      _loadUserName().catchError((e) {
        if (kDebugMode) developer.log('[HOME] Failed to load user name: $e');
        return null as String?;
      }),
      _loadDailyReviewReminder().catchError((e) {
        if (kDebugMode) developer.log('[HOME] Failed to load daily review reminder: $e');
        return null as ReminderSettingModel?;
      }),
    ]);

    final allQuests = results[0] as List<QuestModel>;
    final progress = results[1] as ProgressModel?;
    final dailyStatus = results[2] as DailyStatusDto?;
    final userName = results[3] as String?;
    final dailyReviewReminder = results[4] as ReminderSettingModel?;

    // Featured quest selection priority:
    // 1. first in_progress quest (status == active)
    // 2. first pending quest with highest priority if priority exists
    // 3. first pending quest
    QuestModel? featuredQuest;
    final activeQuestsList = allQuests.where((q) => q.isActive).toList();
    if (activeQuestsList.isNotEmpty) {
      featuredQuest = activeQuestsList.first;
    } else {
      final pendingQuestsList = allQuests.where((q) => q.isPending).toList();
      if (pendingQuestsList.isNotEmpty) {
        final sortedPending = List<QuestModel>.from(pendingQuestsList);
        sortedPending.sort((a, b) {
          if (a.isImportant != b.isImportant) {
            return a.isImportant ? -1 : 1;
          }
          final diffCompare = b.difficulty.index.compareTo(a.difficulty.index);
          if (diffCompare != 0) {
            return diffCompare;
          }
          // Sort by reminder time if both have it
          if (a.reminderTime != null && b.reminderTime != null) {
            return a.reminderTime!.compareTo(b.reminderTime!);
          }
          // Quests with reminder time come before those without
          if (a.reminderTime != null) return -1;
          if (b.reminderTime != null) return 1;
          return 0;
        });
        featuredQuest = sortedPending.first;
      }
    }

    if (featuredQuest != null) {
      developer.log(
        '[HOME] Featured quest: id=${featuredQuest.id}, title=${featuredQuest.title}, status=${featuredQuest.status.name}',
      );
    } else {
      developer.log('[HOME] Featured quest: id=none, title=none, status=none');
    }

    // Upcoming list shows remaining non-completed, non-snoozed quests (excluding the featured one)
    final upcoming = allQuests.where((q) {
      if (featuredQuest != null && q.id == featuredQuest.id) {
        return false;
      }
      return q.isPending || q.isActive;
    }).toList();

    // Separate snoozed quests
    final snoozed = allQuests.where((q) => q.isSnoozed).toList();

    developer.log('[HOME] Upcoming quest count: ${upcoming.length}');

    final completed = allQuests.where((q) => q.isCompleted).toList();

    state = state.updateState(
      loadState: AppLoadState.ready,
      activeQuests: featuredQuest != null ? [featuredQuest] : [],
      upcomingQuests: upcoming,
      snoozedQuests: snoozed,
      completedQuests: completed,
      progress: progress,
      dailyStatus: dailyStatus,
      userDisplayName: userName,
      todayInsight: _buildInsight(dailyStatus),
      dailyReviewReminder: dailyReviewReminder,
    );
  }

  Future<List<QuestModel>> _loadQuests() async {
    if (kDebugMode) {
      final localDate = AppTimeFormatter.todayLocalDateQuery();
      developer.log('[HOME] loading quests for localDate=$localDate');
    }
    return await questService.getTodayQuests();
  }

  Future<ProgressModel?> _loadProgress() async {
    return await progressService.getProgress();
  }

  Future<DailyStatusDto?> _loadDailyStatus() async {
    return await _userApiService.getDailyStatus();
  }

  Future<String?> _loadUserName() async {
    final user = await authService.getCurrentUser();
    return user?.name;
  }

  Future<ReminderSettingModel?> _loadDailyReviewReminder() async {
    try {
      final settings = await reminderService.getReminderSettings();
      return settings.firstWhere(
        (s) => s.type == ReminderType.dailyReview,
        orElse: () => settings.firstWhere(
          (s) => s.id == 'daily-review',
          orElse: () => throw Exception('Daily review reminder not found'),
        ),
      );
    } catch (e) {
      if (kDebugMode) developer.log('[HOME] Failed to load daily review reminder: $e');
      return null;
    }
  }

  String _buildInsight(DailyStatusDto? dailyStatus) {
    if (dailyStatus == null) {
      return 'Chào mừng bạn đến với SoloQuest! Hãy bắt đầu ngày mới với những nhiệm vụ nhỏ.';
    }
    if (!dailyStatus.hasCheckedIn) {
      return 'Bạn chưa check-in sáng nay. Hãy bắt đầu ngày mới bằng việc check-in nhé!';
    }
    if (dailyStatus.todayCompletedQuests > 0) {
      return 'Tuyệt vời! Bạn đã hoàn thành ${dailyStatus.todayCompletedQuests} nhiệm vụ hôm nay. Tiếp tục nào!';
    }
    return 'Ngày mới bắt đầu! Hãy hoàn thành các nhiệm vụ hôm nay để duy trì streak.';
  }

  Future<void> startQuest(String questId) async {
    final updatedActions = Map<String, QuestActionType>.from(
      state.pendingActions,
    );
    updatedActions[questId] = QuestActionType.start;
    state = state.updateState(
      pendingActions: updatedActions,
      isLockedPage: true,
    );

    try {
      await questService.startQuest(questId);
      await loadHomeData();
    } catch (e) {
      if (kDebugMode) developer.log('[HOME] startQuest failed: $e');
      state = state.updateState(errorMessage: 'Không thể bắt đầu nhiệm vụ');
      rethrow;
    } finally {
      final finalActions = Map<String, QuestActionType>.from(
        state.pendingActions,
      );
      finalActions.remove(questId);
      state = state.updateState(
        pendingActions: finalActions,
        isLockedPage: false,
      );
    }
  }

  Future<void> completeQuest(
    String questId, {
    String? note,
    String? mood,
  }) async {
    final updatedActions = Map<String, QuestActionType>.from(
      state.pendingActions,
    );
    updatedActions[questId] = QuestActionType.complete;
    state = state.updateState(
      pendingActions: updatedActions,
      isLockedPage: true,
    );

    try {
      await questService.completeQuest(questId, note: note, mood: mood);
      await loadHomeData();
    } catch (e) {
      if (kDebugMode) developer.log('[HOME] completeQuest failed: $e');
      state = state.updateState(errorMessage: 'Không thể hoàn thành nhiệm vụ');
      rethrow;
    } finally {
      final finalActions = Map<String, QuestActionType>.from(
        state.pendingActions,
      );
      finalActions.remove(questId);
      state = state.updateState(
        pendingActions: finalActions,
        isLockedPage: false,
      );
    }
  }

  Future<void> snoozeQuest(String questId, {required int minutes}) async {
    final updatedActions = Map<String, QuestActionType>.from(
      state.pendingActions,
    );
    updatedActions[questId] = QuestActionType.snooze;
    state = state.updateState(
      pendingActions: updatedActions,
      isLockedPage: true,
    );

    try {
      await questService.snoozeQuest(questId, minutes: minutes);
      await loadHomeData();
    } catch (e) {
      if (kDebugMode) developer.log('[HOME] snoozeQuest failed: $e');
      state = state.updateState(errorMessage: 'Không thể hoãn nhiệm vụ');
      rethrow;
    } finally {
      final finalActions = Map<String, QuestActionType>.from(
        state.pendingActions,
      );
      finalActions.remove(questId);
      state = state.updateState(
        pendingActions: finalActions,
        isLockedPage: false,
      );
    }
  }

  Future<void> skipQuest(String questId, {required String reason}) async {
    final updatedActions = Map<String, QuestActionType>.from(
      state.pendingActions,
    );
    updatedActions[questId] = QuestActionType.skip;
    state = state.updateState(
      pendingActions: updatedActions,
      isLockedPage: true,
    );

    try {
      await questService.skipQuest(questId, reason: reason);
      await loadHomeData();
    } catch (e) {
      if (kDebugMode) developer.log('[HOME] skipQuest failed: $e');
      state = state.updateState(errorMessage: 'Không thể bỏ qua nhiệm vụ');
      rethrow;
    } finally {
      final finalActions = Map<String, QuestActionType>.from(
        state.pendingActions,
      );
      finalActions.remove(questId);
      state = state.updateState(
        pendingActions: finalActions,
        isLockedPage: false,
      );
    }
  }
}

final homePageProvider = StateNotifierProvider<HomePageModel, HomePageState>((
  ref,
) {
  return HomePageModel(
    questService: ref.read(questServiceProvider),
    progressService: ref.read(progressServiceProvider),
    logService: ref.read(logServiceProvider),
    authService: ref.read(authServiceProvider),
    reminderService: ref.read(reminderServiceProvider),
  );
});
