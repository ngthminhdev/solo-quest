import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/weekly_summary_model.dart';
import '../../models/progress_model.dart';
import '../../models/log_entry_model.dart';
import '../../services/weekly_summary_service.dart';
import '../../services/progress_service.dart';
import '../../services/log_service.dart';
import '../../services/service_providers.dart';

class WeeklySummaryPageState extends BasePageState {
  final AppLoadState loadState;
  final WeeklySummaryModel? summary;
  final ProgressModel? progress;
  final List<LogEntryModel> recentLogs;
  final List<bool> enabledSuggestions;
  final String? errorMessage;

  WeeklySummaryPageState({
    this.loadState = AppLoadState.idle,
    this.summary,
    this.progress,
    this.recentLogs = const [],
    this.enabledSuggestions = const [true, true, true, true],
    this.errorMessage,
    super.isLockedPage,
  });

  @override
  WeeklySummaryPageState updateState({
    AppLoadState? loadState,
    WeeklySummaryModel? summary,
    ProgressModel? progress,
    List<LogEntryModel>? recentLogs,
    List<bool>? enabledSuggestions,
    String? errorMessage,
    bool? isLockedPage,
  }) {
    return WeeklySummaryPageState(
      loadState: loadState ?? this.loadState,
      summary: summary ?? this.summary,
      progress: progress ?? this.progress,
      recentLogs: recentLogs ?? this.recentLogs,
      enabledSuggestions: enabledSuggestions ?? this.enabledSuggestions,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  bool get hasSummary => summary != null;

  int get streakDays => progress?.streakDays ?? 0;

  int get enabledSuggestionCount =>
      enabledSuggestions.where((e) => e).length;
}

class WeeklySummaryPageModel extends BasePageModel<WeeklySummaryPageState> {
  WeeklySummaryPageModel({
    required this.weeklySummaryService,
    required this.progressService,
    required this.logService,
  }) : super(WeeklySummaryPageState());

  final WeeklySummaryService weeklySummaryService;
  final ProgressService progressService;
  final LogService logService;

  Future<void> loadWeeklySummary() async {
    state = state.updateState(loadState: AppLoadState.loading);

    try {
      final results = await Future.wait([
        weeklySummaryService.getCurrentWeekSummary(),
        progressService.getProgress(),
        logService.getLogs(),
      ]);

      final summary = results[0] as WeeklySummaryModel;
      final progress = results[1] as ProgressModel;
      final allLogs = results[2] as List<LogEntryModel>;

      final recentLogs = allLogs.take(10).toList();

      state = state.updateState(
        loadState: AppLoadState.ready,
        summary: summary,
        progress: progress,
        recentLogs: recentLogs,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: 'Không thể tải dữ liệu tuần: ${e.toString()}',
      );
    }
  }

  Future<void> refreshWeeklySummary() async {
    try {
      final results = await Future.wait([
        weeklySummaryService.getCurrentWeekSummary(),
        progressService.getProgress(),
        logService.getLogs(),
      ]);

      final summary = results[0] as WeeklySummaryModel;
      final progress = results[1] as ProgressModel;
      final allLogs = results[2] as List<LogEntryModel>;

      final recentLogs = allLogs.take(10).toList();

      state = state.updateState(
        summary: summary,
        progress: progress,
        recentLogs: recentLogs,
      );
    } catch (_) {}
  }

  void toggleSuggestion(int index) {
    final current = List<bool>.from(state.enabledSuggestions);
    if (index >= 0 && index < current.length) {
      current[index] = !current[index];
      state = state.updateState(enabledSuggestions: current);
    }
  }
}

final weeklySummaryPageProvider =
    StateNotifierProvider<WeeklySummaryPageModel, WeeklySummaryPageState>(
        (ref) {
  return WeeklySummaryPageModel(
    weeklySummaryService: ref.read(weeklySummaryServiceProvider),
    progressService: ref.read(progressServiceProvider),
    logService: ref.read(logServiceProvider),
  );
});
