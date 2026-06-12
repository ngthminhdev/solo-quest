import 'dart:async';
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
import '../../core/api/dto/daily_quest_generation_dto.dart';
import '../../services/quest_service.dart';
import '../../services/progress_service.dart';
import '../../services/log_service.dart';
import '../../services/auth_service.dart';
import '../../services/reminder_service.dart';
import '../../core/api/services/user_api_service.dart';
import '../../core/api/services/ai_api_service.dart';
import '../../services/service_providers.dart';

/// Async daily-quest generation phase shown on Home.
enum HomeGenerationPhase {
  /// No generation in progress; show quests or the normal empty view.
  idle,

  /// A background generation job is running; show the generating card and poll.
  generating,

  /// Polling exceeded the client budget while still generating; show a light
  /// "try again / pull to refresh" message. Not an error.
  slow,

  /// Generation failed or the job went stale; show a retry action.
  failed,
}

class HomePageState extends BasePageState {
  final AppLoadState loadState;
  final List<QuestModel> activeQuests;
  final List<QuestModel> upcomingQuests;
  final List<QuestModel> snoozedQuests;
  final List<QuestModel> completedQuests;
  final List<QuestModel> skippedQuests;
  final ProgressModel? progress;
  final DailyStatusDto? dailyStatus;
  final String? userDisplayName;
  final String? errorMessage;
  final String? todayInsight;
  final Map<String, QuestActionType> pendingActions;
  final ReminderSettingModel? dailyReviewReminder;

  // ── Async quest generation ──
  final HomeGenerationPhase generationPhase;
  final String? generationJobId;
  final String? generationMessage;

  HomePageState({
    this.loadState = AppLoadState.loading,
    this.activeQuests = const [],
    this.upcomingQuests = const [],
    this.snoozedQuests = const [],
    this.completedQuests = const [],
    this.skippedQuests = const [],
    this.progress,
    this.dailyStatus,
    this.userDisplayName,
    this.errorMessage,
    this.todayInsight,
    this.pendingActions = const {},
    this.dailyReviewReminder,
    this.generationPhase = HomeGenerationPhase.idle,
    this.generationJobId,
    this.generationMessage,
    super.isLockedPage,
  });

  /// True while a background generation job is being polled.
  bool get isGeneratingQuests =>
      generationPhase == HomeGenerationPhase.generating;
  bool get isGenerationSlow => generationPhase == HomeGenerationPhase.slow;
  bool get isGenerationFailed => generationPhase == HomeGenerationPhase.failed;

  int get totalTodayQuestCount {
    // Use BE daily status if available for accurate count
    if (dailyStatus != null) {
      return dailyStatus!.totalCount;
    }
    // Fallback to counting visible quests
    return activeQuests.length +
        upcomingQuests.length +
        snoozedQuests.length +
        completedQuests.length +
        skippedQuests.length;
  }

  int get completedTodayQuestCount {
    // Use BE daily status if available
    if (dailyStatus != null) {
      return dailyStatus!.completedCount;
    }
    return completedQuests.length;
  }

  double get todayCompletionRate {
    // Use BE daily status if available
    if (dailyStatus != null) {
      return dailyStatus!.completionRate;
    }
    if (totalTodayQuestCount == 0) return 0.0;
    return completedTodayQuestCount / totalTodayQuestCount;
  }

  int get earnedExpToday {
    // Use BE daily status if available
    if (dailyStatus != null) {
      return dailyStatus!.earnedExpToday;
    }
    return 0;
  }

  int get streakDays {
    if (dailyStatus != null) {
      return dailyStatus!.streakDays;
    }
    return progress?.streakDays ?? 0;
  }

  bool get hasAnyQuest =>
      activeQuests.isNotEmpty ||
      upcomingQuests.isNotEmpty ||
      snoozedQuests.isNotEmpty ||
      completedQuests.isNotEmpty ||
      skippedQuests.isNotEmpty;

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
    List<QuestModel>? skippedQuests,
    ProgressModel? progress,
    DailyStatusDto? dailyStatus,
    String? userDisplayName,
    String? errorMessage,
    String? todayInsight,
    bool? isLockedPage,
    Map<String, QuestActionType>? pendingActions,
    ReminderSettingModel? dailyReviewReminder,
    HomeGenerationPhase? generationPhase,
    String? generationJobId,
    String? generationMessage,
    bool clearGenerationJobId = false,
    bool clearGenerationMessage = false,
  }) {
    return HomePageState(
      loadState: loadState ?? this.loadState,
      activeQuests: activeQuests ?? this.activeQuests,
      upcomingQuests: upcomingQuests ?? this.upcomingQuests,
      snoozedQuests: snoozedQuests ?? this.snoozedQuests,
      completedQuests: completedQuests ?? this.completedQuests,
      skippedQuests: skippedQuests ?? this.skippedQuests,
      progress: progress ?? this.progress,
      dailyStatus: dailyStatus ?? this.dailyStatus,
      userDisplayName: userDisplayName ?? this.userDisplayName,
      errorMessage: errorMessage ?? this.errorMessage,
      todayInsight: todayInsight ?? this.todayInsight,
      isLockedPage: isLockedPage ?? this.isLockedPage,
      pendingActions: pendingActions ?? this.pendingActions,
      dailyReviewReminder: dailyReviewReminder ?? this.dailyReviewReminder,
      generationPhase: generationPhase ?? this.generationPhase,
      generationJobId: clearGenerationJobId
          ? null
          : generationJobId ?? this.generationJobId,
      generationMessage: clearGenerationMessage
          ? null
          : generationMessage ?? this.generationMessage,
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
    AiApiService? aiApiService,
    Duration pollInterval = const Duration(seconds: 10),
    int maxPolls = 10,
    Duration tabRefreshDebounce = const Duration(milliseconds: 450),
    Duration tabRefreshCacheTtl = const Duration(seconds: 20),
    Duration loadTimeout = const Duration(seconds: 20),
  }) : _userApiService = userApiService ?? UserApiService(),
       _aiApiService = aiApiService ?? AiApiService(),
       _pollInterval = pollInterval,
       _maxPolls = maxPolls,
       _tabRefreshDebounce = tabRefreshDebounce,
       _tabRefreshCacheTtl = tabRefreshCacheTtl,
       _loadTimeout = loadTimeout,
       super(HomePageState());

  final QuestService questService;
  final ProgressService progressService;
  final LogService logService;
  final AuthService authService;
  final ReminderService reminderService;
  final UserApiService _userApiService;
  final AiApiService _aiApiService;

  String? _lastLoadedDate;
  DateTime? _lastSuccessfulLoadAt;
  Future<void>? _loadFuture;
  DateTime? _loadStartedAt;
  Timer? _tabRefreshTimer;
  int _loadRequestVersion = 0;

  /// Optimistic quest states applied locally right after a user action
  /// (complete/start/snooze/skip). Kept for [_mutationOverlayWindow] so a stale
  /// read-after-write from the backend can't revert the UI — e.g. a quest the
  /// user just completed snapping back to active on the immediate reload.
  final Map<String, _PendingQuestMutation> _pendingMutations = {};
  static const Duration _mutationOverlayWindow = Duration(seconds: 20);

  // ── Async generation polling ──
  // Poll status every [_pollInterval] (10s) up to [_maxPolls] (10) times,
  // i.e. ~100s of automatic polling. After that, stop and let the user
  // pull-to-refresh; the backend may keep working (AI up to ~600s).
  final Duration _pollInterval;
  final int _maxPolls;
  final Duration _tabRefreshDebounce;
  final Duration _tabRefreshCacheTtl;
  final Duration _loadTimeout;
  Timer? _pollTimer;
  int _pollCount = 0;
  bool _isPolling = false;
  bool _pollInFlight = false;
  bool _disposed = false;
  bool _starting = false; // a generate-today POST is in flight

  static const String _generatingMessage =
      'Solo đang cá nhân hóa nhiệm vụ cho bạn.';
  static const String _slowMessage =
      'Quest vẫn đang được tạo. Bạn có thể kéo để làm mới sau.';
  static const String _failedMessage =
      'Không thể tạo quest hôm nay. Hãy thử lại nhé.';

  /// Test-only: whether the polling timer is currently active.
  @visibleForTesting
  bool get isPolling => _isPolling;

  @visibleForTesting
  int get pollCount => _pollCount;

  void scheduleTabVisibleRefresh() {
    if (_disposed) return;
    final todayStr = AppTimeFormatter.todayLocalDateQuery();
    final dateChanged = _lastLoadedDate != null && _lastLoadedDate != todayStr;
    final hasFreshCache =
        _lastSuccessfulLoadAt != null &&
        !dateChanged &&
        DateTime.now().difference(_lastSuccessfulLoadAt!) < _tabRefreshCacheTtl;

    // A previous load is still running. Normally we let it finish, but if it has
    // been in flight longer than [_loadTimeout] it is effectively stuck (e.g. a
    // stalled request). Force a fresh load so the tab can recover instead of
    // being pinned on the skeleton forever.
    final loadInFlight = _loadFuture != null;
    final staleInFlight =
        loadInFlight &&
        _loadStartedAt != null &&
        DateTime.now().difference(_loadStartedAt!) > _loadTimeout;

    if (hasFreshCache || _isPolling) return;
    if (loadInFlight && !staleInFlight) return;

    _tabRefreshTimer?.cancel();
    _tabRefreshTimer = Timer(_tabRefreshDebounce, () {
      _tabRefreshTimer = null;
      if (_disposed) return;
      unawaited(
        loadHomeData(
          forceRefresh: staleInFlight,
          showLoading:
              !state.hasAnyQuest &&
              state.generationPhase == HomeGenerationPhase.idle,
        ),
      );
    });
  }

  Future<void> loadHomeData({
    bool autoGenerateIfEmpty = true,
    bool forceRefresh = false,
    bool showLoading = true,
  }) {
    _tabRefreshTimer?.cancel();
    _tabRefreshTimer = null;

    final activeLoad = _loadFuture;
    if (!forceRefresh && activeLoad != null) return activeLoad;

    final future = _loadHomeDataInternal(
      autoGenerateIfEmpty: autoGenerateIfEmpty,
      showLoading: showLoading,
    );
    _loadFuture = future;
    _loadStartedAt = DateTime.now();
    return future.whenComplete(() {
      if (identical(_loadFuture, future)) {
        _loadFuture = null;
        _loadStartedAt = null;
      }
    });
  }

  Future<void> _loadHomeDataInternal({
    required bool autoGenerateIfEmpty,
    required bool showLoading,
  }) async {
    final requestVersion = ++_loadRequestVersion;
    final todayStr = AppTimeFormatter.todayLocalDateQuery();
    final dateChanged = _lastLoadedDate != null && _lastLoadedDate != todayStr;
    if (dateChanged && kDebugMode) {
      developer.log(
        '[HOME] Date changed from $_lastLoadedDate to $todayStr, force reload',
      );
    }
    _lastLoadedDate = todayStr;

    if (showLoading) {
      state = state.updateState(loadState: AppLoadState.loading);
    }

    // Load all data in parallel, handle failures independently
    final previousQuests = _currentQuestSnapshot();
    Object? questLoadError;
    // Each source is bounded by [_loadTimeout] so a single stalled request can
    // never leave [_loadFuture] (and the skeleton) hanging forever.
    final results = await Future.wait([
      _loadQuests().timeout(_loadTimeout).catchError((e) {
        if (kDebugMode) developer.log('[HOME] Failed to load quests: $e');
        questLoadError = e;
        return previousQuests;
      }),
      _loadProgress().timeout(_loadTimeout).catchError((e) {
        if (kDebugMode) developer.log('[HOME] Failed to load progress: $e');
        return null as ProgressModel?;
      }),
      _loadDailyStatus().timeout(_loadTimeout).catchError((e) {
        if (kDebugMode) developer.log('[HOME] Failed to load daily status: $e');
        return null as DailyStatusDto?;
      }),
      _loadUserName().timeout(_loadTimeout).catchError((e) {
        if (kDebugMode) developer.log('[HOME] Failed to load user name: $e');
        return null as String?;
      }),
      _loadDailyReviewReminder().timeout(_loadTimeout).catchError((e) {
        if (kDebugMode) {
          developer.log('[HOME] Failed to load daily review reminder: $e');
        }
        return null as ReminderSettingModel?;
      }),
    ]);

    // Overlay any still-fresh optimistic mutations so a stale read-after-write
    // from the backend can't revert a quest the user just completed/started.
    final allQuests = _applyMutationOverlay(results[0] as List<QuestModel>);
    final progress = results[1] as ProgressModel?;
    final dailyStatus = results[2] as DailyStatusDto?;
    final userName = results[3] as String?;
    final dailyReviewReminder = results[4] as ReminderSettingModel?;

    if (_disposed || requestVersion != _loadRequestVersion) return;

    if (questLoadError != null && previousQuests.isEmpty) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: 'Không thể tải nhiệm vụ hôm nay',
      );
      return;
    }

    final sections = _buildQuestSections(allQuests);

    developer.log(
      '[HOME] Quest breakdown: total=${allQuests.length}, '
      'active=${sections.active.length}, upcoming=${sections.upcoming.length}, '
      'snoozed=${sections.snoozed.length}, completed=${sections.completed.length}, skipped=${sections.skipped.length}',
    );

    final hasQuests = allQuests.isNotEmpty;
    final nextDailyStatus =
        dailyStatus ?? _dailyStatusFromQuests(allQuests, state.dailyStatus);

    state = state.updateState(
      loadState: AppLoadState.ready,
      activeQuests: sections.active,
      upcomingQuests: sections.upcoming,
      snoozedQuests: sections.snoozed,
      completedQuests: sections.completed,
      skippedQuests: sections.skipped,
      progress: progress,
      dailyStatus: nextDailyStatus,
      userDisplayName: userName,
      todayInsight: _buildInsight(nextDailyStatus),
      dailyReviewReminder: dailyReviewReminder,
      // Quests are present → clear any generation UI.
      generationPhase: hasQuests ? HomeGenerationPhase.idle : null,
    );
    _lastSuccessfulLoadAt = DateTime.now();

    // When today has no quests, find out whether a generation job is running
    // (e.g. started right after onboarding) and resume polling, or kick one
    // off. Skip if we are already generating/polling so we don't double-run.
    if (autoGenerateIfEmpty &&
        !hasQuests &&
        !_isPolling &&
        state.generationPhase != HomeGenerationPhase.generating) {
      await _resumeOrStartGeneration(todayStr);
    } else if (hasQuests) {
      _stopPolling();
    }
  }

  /// Pull-to-refresh entry point: cancels any in-flight polling, resets the
  /// poll counter, then reloads. If a job is still generating it restarts
  /// polling from the first attempt.
  Future<void> refresh() async {
    final shouldCheckGenerationStatus =
        state.generationPhase != HomeGenerationPhase.idle ||
        (state.generationJobId?.isNotEmpty ?? false);
    final date = AppTimeFormatter.todayLocalDateQuery();

    _stopPolling();

    if (shouldCheckGenerationStatus) {
      final handled = await _refreshGenerationStatus(date);
      if (handled) return;
    }

    await loadHomeData(forceRefresh: true, showLoading: false);
  }

  Future<bool> _refreshGenerationStatus(String date) async {
    _logQuestGen('pull refresh status check date=$date');

    final status = await _aiApiService.getTodayGenerationStatus(date: date);
    if (_disposed) return true;

    final s = status?.status;
    if (s == null) return false;

    _logQuestGen('poll status=$s');

    if (s == DailyQuestGenerationStatus.completed) {
      _logQuestGen('completed -> reload quests');
      _setGenerationIdle();
      await loadHomeData(
        autoGenerateIfEmpty: false,
        forceRefresh: true,
        showLoading: false,
      );
      return true;
    }

    if (s == DailyQuestGenerationStatus.generating) {
      _startGenerationPolling(date, jobId: status?.jobId);
      return true;
    }

    if (s == DailyQuestGenerationStatus.failed ||
        s == DailyQuestGenerationStatus.stale) {
      _setGenerationFailed();
      return true;
    }

    if (s == DailyQuestGenerationStatus.notStarted) {
      _stopPolling();
      _setGenerationIdle();
      await generateTodayQuests();
      return true;
    }

    return false;
  }

  /// Inspects the generation job status for [date] and either resumes polling,
  /// shows a retry/failed state, or starts a fresh generation when none exists.
  Future<void> _resumeOrStartGeneration(String date) async {
    if (_isPolling) return;

    // Optimistically show the generating state so we never flash the empty
    // view while probing the job status.
    state = state.updateState(
      generationPhase: HomeGenerationPhase.generating,
      generationMessage: _generatingMessage,
    );

    final status = await _aiApiService.getTodayGenerationStatus(date: date);
    if (_disposed) return;
    final s = status?.status;

    if (s == DailyQuestGenerationStatus.generating) {
      _logQuestGen('poll status=generating');
      _startGenerationPolling(date, jobId: status?.jobId);
      return;
    }
    if (s == DailyQuestGenerationStatus.failed ||
        s == DailyQuestGenerationStatus.stale) {
      _logQuestGen('poll status=$s');
      _setGenerationFailed();
      return;
    }
    if (s == DailyQuestGenerationStatus.completed) {
      _logQuestGen('poll status=completed');
      _logQuestGen('completed -> reload quests');
      _setGenerationIdle();
      await loadHomeData(
        autoGenerateIfEmpty: false,
        forceRefresh: true,
        showLoading: false,
      );
      return;
    }

    // not_started or status unavailable → start a generation job.
    await generateTodayQuests();
  }

  /// Starts (or restarts on retry) daily quest generation.
  ///
  /// - 200 → quests are ready/existed; reloads Home.
  /// - 202 → a background job started; begins polling.
  /// - null → hard failure; shows the retry state.
  Future<void> generateTodayQuests({bool force = false}) async {
    // Guard double-tap / concurrent starts.
    if (_isPolling || _starting) return;
    _starting = true;

    try {
      final date = AppTimeFormatter.todayLocalDateQuery();
      state = state.updateState(
        generationPhase: HomeGenerationPhase.generating,
        generationMessage: _generatingMessage,
      );
      _logQuestGen('start generate today');

      final outcome = await _aiApiService.generateTodayQuests(
        preferAI: true,
        force: force,
        replacePendingOnly: true,
        date: date,
      );

      if (_disposed) return;

      if (outcome == null) {
        _setGenerationFailed();
        return;
      }

      if (outcome.isGenerating) {
        _logQuestGen('generate response 202 jobId=${outcome.job!.jobId}');
        _startGenerationPolling(date, jobId: outcome.job!.jobId);
        return;
      }

      // 200: quests ready or already existed → reload Home data.
      _setGenerationIdle();
      await loadHomeData(
        autoGenerateIfEmpty: false,
        forceRefresh: true,
        showLoading: false,
      );
    } finally {
      _starting = false;
    }
  }

  /// Retry after a failed/stale/slow generation (MVP: prefer_ai + force).
  Future<void> retryGeneration() async {
    _stopPolling();
    // Allow retry even from the generating-stuck UI.
    state = state.updateState(generationPhase: HomeGenerationPhase.idle);
    await generateTodayQuests(force: true);
  }

  // ── Polling ──

  void _startGenerationPolling(String date, {String? jobId}) {
    _stopPolling();
    _isPolling = true;
    _pollCount = 0;
    _pollInFlight = false;
    state = state.updateState(
      generationPhase: HomeGenerationPhase.generating,
      generationJobId: jobId,
      generationMessage: _generatingMessage,
    );
    _logQuestGen('start polling date=$date');
    _pollTimer = Timer.periodic(_pollInterval, (_) => _onPollTick(date));
  }

  Future<void> _onPollTick(String date) async {
    if (_disposed) {
      _stopPolling();
      return;
    }
    if (!_isPolling || _pollInFlight) return;

    _pollInFlight = true;
    _pollCount++;
    _logQuestGen('poll attempt $_pollCount/$_maxPolls');

    try {
      final status = await _aiApiService.getTodayGenerationStatus(date: date);
      if (_disposed) {
        _stopPolling();
        return;
      }
      // Transient status error → keep polling on the next tick until budget.
      if (status == null) {
        if (_pollCount >= _maxPolls) _markGenerationSlow();
        return;
      }

      _logQuestGen('poll status=${status.status}');

      switch (status.status) {
        case DailyQuestGenerationStatus.completed:
          _stopPolling();
          _logQuestGen('completed -> reload quests');
          _setGenerationIdle();
          await loadHomeData(
            autoGenerateIfEmpty: false,
            forceRefresh: true,
            showLoading: false,
          );
          break;
        case DailyQuestGenerationStatus.failed:
        case DailyQuestGenerationStatus.stale:
          _setGenerationFailed();
          break;
        case DailyQuestGenerationStatus.notStarted:
          // Job vanished; stop without looping forever.
          _stopPolling();
          _setGenerationIdle();
          break;
        case DailyQuestGenerationStatus.generating:
        default:
          if (_pollCount >= _maxPolls) {
            _markGenerationSlow();
          }
          break;
      }
    } finally {
      _pollInFlight = false;
    }
  }

  void _stopPolling() {
    final hadPolling = _isPolling || _pollTimer != null || _pollCount > 0;
    _pollTimer?.cancel();
    _pollTimer = null;
    _isPolling = false;
    _pollInFlight = false;
    _pollCount = 0;
    if (hadPolling) _logQuestGen('cancel polling');
  }

  void _setGenerationIdle() {
    state = state.updateState(
      generationPhase: HomeGenerationPhase.idle,
      clearGenerationJobId: true,
      clearGenerationMessage: true,
    );
  }

  void _markGenerationSlow() {
    _logQuestGen('poll budget exhausted');
    _stopPolling();
    if (!_disposed) {
      state = state.updateState(
        generationPhase: HomeGenerationPhase.slow,
        clearGenerationJobId: true,
        generationMessage: _slowMessage,
      );
    }
  }

  void _setGenerationFailed() {
    _stopPolling();
    state = state.updateState(
      generationPhase: HomeGenerationPhase.failed,
      clearGenerationJobId: true,
      generationMessage: _failedMessage,
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _tabRefreshTimer?.cancel();
    _stopPolling();
    super.dispose();
  }

  void _logQuestGen(String message) {
    if (kDebugMode) developer.log('[QUEST_GEN] $message');
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
      if (kDebugMode) {
        developer.log('[HOME] Failed to load daily review reminder: $e');
      }
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
      final updatedQuest = await questService.startQuest(questId);
      applyQuestUpdate(updatedQuest, refreshInBackground: false);
      await loadHomeData(
        autoGenerateIfEmpty: false,
        forceRefresh: true,
        showLoading: false,
      );
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
      final updatedQuest = await questService.completeQuest(
        questId,
        note: note,
        mood: mood,
      );
      applyQuestUpdate(updatedQuest, refreshInBackground: false);
      await loadHomeData(
        autoGenerateIfEmpty: false,
        forceRefresh: true,
        showLoading: false,
      );
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
      final updatedQuest = await questService.snoozeQuest(
        questId,
        minutes: minutes,
      );
      applyQuestUpdate(updatedQuest, refreshInBackground: false);
      await loadHomeData(
        autoGenerateIfEmpty: false,
        forceRefresh: true,
        showLoading: false,
      );
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
      final updatedQuest = await questService.skipQuest(
        questId,
        reason: reason,
      );
      applyQuestUpdate(updatedQuest, refreshInBackground: false);
      await loadHomeData(
        autoGenerateIfEmpty: false,
        forceRefresh: true,
        showLoading: false,
      );
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

  void applyQuestUpdate(
    QuestModel updatedQuest, {
    bool refreshInBackground = true,
  }) {
    _applyQuestUpdate(updatedQuest);
    if (refreshInBackground) {
      unawaited(
        loadHomeData(
          autoGenerateIfEmpty: false,
          forceRefresh: true,
          showLoading: false,
        ),
      );
    }
  }

  void _applyQuestUpdate(QuestModel updatedQuest) {
    // Remember this optimistic state so the next (possibly stale) reload won't
    // overwrite it. The action API's response is authoritative for the write.
    _recordMutation(updatedQuest);

    final quests = _currentQuestSnapshot();
    final index = quests.indexWhere((quest) => quest.id == updatedQuest.id);
    if (index == -1) return;

    quests[index] = updatedQuest;
    final sections = _buildQuestSections(quests);
    final nextDailyStatus = _dailyStatusFromQuests(quests, state.dailyStatus);

    state = state.updateState(
      loadState: AppLoadState.ready,
      activeQuests: sections.active,
      upcomingQuests: sections.upcoming,
      snoozedQuests: sections.snoozed,
      completedQuests: sections.completed,
      skippedQuests: sections.skipped,
      dailyStatus: nextDailyStatus,
      todayInsight: _buildInsight(nextDailyStatus),
      generationPhase: quests.isNotEmpty ? HomeGenerationPhase.idle : null,
    );
    _lastSuccessfulLoadAt = DateTime.now();
  }

  /// Records a quest the user just acted on so subsequent reloads keep showing
  /// it for [_mutationOverlayWindow], even if the backend briefly returns the
  /// pre-action (stale) state due to replica lag or caching.
  void _recordMutation(QuestModel quest) {
    _pendingMutations[quest.id] = _PendingQuestMutation(
      quest: quest,
      at: DateTime.now(),
    );
  }

  /// Drops mutations older than [_mutationOverlayWindow] so we never mask the
  /// real server state indefinitely (e.g. an edit made from another device).
  void _prunePendingMutations() {
    if (_pendingMutations.isEmpty) return;
    final now = DateTime.now();
    _pendingMutations.removeWhere(
      (_, m) => now.difference(m.at) > _mutationOverlayWindow,
    );
  }

  /// Replaces freshly-loaded quests with their optimistic version while a
  /// mutation is still in its overlay window. Once the backend reflects the
  /// same status (it caught up), the overlay for that quest is dropped.
  List<QuestModel> _applyMutationOverlay(List<QuestModel> quests) {
    _prunePendingMutations();
    if (_pendingMutations.isEmpty) return quests;

    return quests.map((quest) {
      final mutation = _pendingMutations[quest.id];
      if (mutation == null) return quest;
      if (quest.status == mutation.quest.status) {
        // Server caught up to our optimistic write → overlay no longer needed.
        _pendingMutations.remove(quest.id);
        return quest;
      }
      // Server read is still stale; keep the optimistic quest on screen.
      return mutation.quest;
    }).toList();
  }

  List<QuestModel> _currentQuestSnapshot() {
    final byId = <String, QuestModel>{};
    for (final quest in [
      ...state.activeQuests,
      ...state.upcomingQuests,
      ...state.snoozedQuests,
      ...state.completedQuests,
      ...state.skippedQuests,
    ]) {
      byId[quest.id] = quest;
    }
    return byId.values.toList();
  }

  _HomeQuestSections _buildQuestSections(List<QuestModel> allQuests) {
    // Collect all actionable (pending + active) quests.
    // Exclude completed, skipped, and snoozed quests.
    final pendingQuests = allQuests
        .where((q) => q.isPending || q.isActive)
        .toList();

    // Sort by reminder_time ascending (quests without reminder time go last).
    pendingQuests.sort((a, b) {
      final aTime = a.reminderTime;
      final bTime = b.reminderTime;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return aTime.compareTo(bTime);
    });

    final now = DateTime.now();
    QuestModel? featuredQuest;

    if (pendingQuests.isNotEmpty) {
      // Prefer earliest overdue quest (reminder_time <= now).
      final overdueIndex = pendingQuests.indexWhere(
        (q) => q.reminderTime != null && q.reminderTime!.isBefore(now),
      );
      final firstOverdue = overdueIndex >= 0
          ? pendingQuests[overdueIndex]
          : null;
      final firstUpcoming = pendingQuests.first;

      // If there's an overdue quest, pick the earliest one.
      // Otherwise pick the earliest upcoming one.
      featuredQuest = firstOverdue ?? firstUpcoming;
    }

    if (featuredQuest != null) {
      developer.log(
        '[HOME] Featured quest: id=${featuredQuest.id}, title=${featuredQuest.title}, '
        'status=${featuredQuest.status.name}, reminderTime=${featuredQuest.reminderTime}',
      );
    } else {
      developer.log('[HOME] Featured quest: id=none, title=none, status=none');
    }

    final upcoming = pendingQuests.where((q) {
      if (featuredQuest != null && q.id == featuredQuest.id) return false;
      return true;
    }).toList();

    developer.log('[HOME] Upcoming quest count: ${upcoming.length}');

    return _HomeQuestSections(
      active: featuredQuest != null ? [featuredQuest] : [],
      upcoming: upcoming,
      snoozed: allQuests.where((q) => q.isSnoozed).toList(),
      completed: allQuests.where((q) => q.isCompleted).toList(),
      skipped: allQuests.where((q) => q.isSkipped).toList(),
    );
  }

  DailyStatusDto? _dailyStatusFromQuests(
    List<QuestModel> quests,
    DailyStatusDto? current,
  ) {
    if (current == null) return null;

    final completedCount = quests.where((q) => q.isCompleted).length;
    final skippedCount = quests.where((q) => q.isSkipped).length;
    final pendingCount = quests.where((q) => q.isPending).length;
    final activeCount = quests.where((q) => q.isActive).length;
    final snoozedCount = quests.where((q) => q.isSnoozed).length;
    final totalCount = quests.length;

    return DailyStatusDto(
      hasCheckedIn: current.hasCheckedIn,
      hasReviewed: current.hasReviewed,
      totalCount: totalCount,
      completedCount: completedCount,
      skippedCount: skippedCount,
      pendingCount: pendingCount,
      activeCount: activeCount,
      snoozedCount: snoozedCount,
      completionRate: totalCount == 0 ? 0 : completedCount / totalCount,
      earnedExpToday: current.earnedExpToday,
      streakDays: current.streakDays,
    );
  }
}

/// A short-lived snapshot of a quest right after a user action, used to keep
/// the optimistic UI from being reverted by a stale backend read.
class _PendingQuestMutation {
  const _PendingQuestMutation({required this.quest, required this.at});

  final QuestModel quest;
  final DateTime at;
}

class _HomeQuestSections {
  const _HomeQuestSections({
    required this.active,
    required this.upcoming,
    required this.snoozed,
    required this.completed,
    required this.skipped,
  });

  final List<QuestModel> active;
  final List<QuestModel> upcoming;
  final List<QuestModel> snoozed;
  final List<QuestModel> completed;
  final List<QuestModel> skipped;
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
