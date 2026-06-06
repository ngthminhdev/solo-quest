import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/progress_model.dart';
import '../../models/quest_model.dart';
import '../../models/log_entry_model.dart';
import '../../models/xp_transaction_model.dart';
import '../../services/progress_service.dart';
import '../../services/quest_service.dart';
import '../../services/log_service.dart';
import '../../services/service_providers.dart';

class ProgressPageState extends BasePageState {
  final AppLoadState loadState;
  final ProgressModel? progress;
  final List<QuestModel> completedQuests;
  final List<LogEntryModel> recentLogs;
  final XPHistoryModel? xpHistory;
  final AppLoadState xpHistoryLoadState;
  final String? errorMessage;

  ProgressPageState({
    this.loadState = AppLoadState.loading,
    this.progress,
    this.completedQuests = const [],
    this.recentLogs = const [],
    this.xpHistory,
    this.xpHistoryLoadState = AppLoadState.idle,
    this.errorMessage,
    super.isLockedPage,
  });

  @override
  ProgressPageState updateState({
    AppLoadState? loadState,
    ProgressModel? progress,
    List<QuestModel>? completedQuests,
    List<LogEntryModel>? recentLogs,
    XPHistoryModel? xpHistory,
    AppLoadState? xpHistoryLoadState,
    String? errorMessage,
    bool? isLockedPage,
  }) {
    return ProgressPageState(
      loadState: loadState ?? this.loadState,
      progress: progress ?? this.progress,
      completedQuests: completedQuests ?? this.completedQuests,
      recentLogs: recentLogs ?? this.recentLogs,
      xpHistory: xpHistory ?? this.xpHistory,
      xpHistoryLoadState: xpHistoryLoadState ?? this.xpHistoryLoadState,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  bool get hasProgress => progress != null;
  bool get hasXPHistory => xpHistory != null && xpHistory!.transactions.isNotEmpty;

  int get completedTodayCount => completedQuests.length;

  int get recentActivityCount => recentLogs.length;
}

class ProgressPageModel extends BasePageModel<ProgressPageState> {
  ProgressPageModel({
    required this.progressService,
    required this.questService,
    required this.logService,
  }) : super(ProgressPageState());

  final ProgressService progressService;
  final QuestService questService;
  final LogService logService;

  Future<void> loadProgress() async {
    state = state.updateState(loadState: AppLoadState.loading);

    try {
      final results = await Future.wait([
        progressService.getProgress(),
        questService.getCompletedQuests(),
        logService.getLogs(),
      ]);

      final progress = results[0] as ProgressModel;
      final completed = results[1] as List<QuestModel>;
      final allLogs = results[2] as List<LogEntryModel>;

      final recentLogs = allLogs.length > 10 ? allLogs.sublist(0, 10) : allLogs;

      state = state.updateState(
        loadState: AppLoadState.ready,
        progress: progress,
        completedQuests: completed,
        recentLogs: recentLogs,
      );

      // Load XP history in background (non-blocking)
      _loadXPHistory();
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
      );
    }
  }

  Future<void> _loadXPHistory() async {
    state = state.updateState(xpHistoryLoadState: AppLoadState.loading);

    try {
      final xpHistory = await progressService.getXPHistory(limit: 20);
      state = state.updateState(
        xpHistoryLoadState: AppLoadState.ready,
        xpHistory: xpHistory,
      );
    } catch (e) {
      // XP history is optional, don't block the page if it fails
      state = state.updateState(xpHistoryLoadState: AppLoadState.error);
    }
  }

  Future<void> refreshProgress() async {
    try {
      final results = await Future.wait([
        progressService.getProgress(),
        questService.getCompletedQuests(),
        logService.getLogs(),
      ]);

      final progress = results[0] as ProgressModel;
      final completed = results[1] as List<QuestModel>;
      final allLogs = results[2] as List<LogEntryModel>;

      final recentLogs = allLogs.length > 10 ? allLogs.sublist(0, 10) : allLogs;

      state = state.updateState(
        progress: progress,
        completedQuests: completed,
        recentLogs: recentLogs,
      );

      // Refresh XP history too
      _loadXPHistory();
    } catch (_) {}
  }
}

final progressPageProvider =
    StateNotifierProvider<ProgressPageModel, ProgressPageState>((ref) {
      return ProgressPageModel(
        progressService: ref.read(progressServiceProvider),
        questService: ref.read(questServiceProvider),
        logService: ref.read(logServiceProvider),
      );
    });
