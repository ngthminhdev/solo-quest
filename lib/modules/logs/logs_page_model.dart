import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../core/utils/app_time_formatter.dart';
import '../../models/log_entry_model.dart';
import '../../models/enums/log_enums.dart';
import '../../services/log_service.dart';
import '../../services/service_providers.dart';

class LogsPageState extends BasePageState {
  final AppLoadState loadState;
  final List<LogEntryModel> logs;
  final List<LogEntryModel> filteredLogs;
  final DateTime selectedDate;
  final LogEntryType? selectedType;
  final String? errorMessage;

  LogsPageState({
    this.loadState = AppLoadState.loading,
    this.logs = const [],
    this.filteredLogs = const [],
    DateTime? selectedDate,
    this.selectedType,
    this.errorMessage,
    super.isLockedPage,
  }) : selectedDate = selectedDate ?? DateTime.now();

  factory LogsPageState.initial() {
    return LogsPageState(
      selectedDate: DateTime.now(),
    );
  }

  int get totalLogCount => filteredLogs.length;

  int get completedQuestCount => filteredLogs
      .where((e) => e.type == LogEntryType.questCompleted)
      .length;

  int get skippedQuestCount =>
      filteredLogs.where((e) => e.type == LogEntryType.questSkipped).length;

  int get earnedExp =>
      filteredLogs.fold<int>(0, (sum, e) => sum + (e.expChanged ?? 0));

  bool get hasLogs => filteredLogs.isNotEmpty;

  @override
  LogsPageState updateState({
    AppLoadState? loadState,
    List<LogEntryModel>? logs,
    List<LogEntryModel>? filteredLogs,
    DateTime? selectedDate,
    LogEntryType? selectedType,
    bool clearSelectedType = false,
    String? errorMessage,
    bool? isLockedPage,
  }) {
    return LogsPageState(
      loadState: loadState ?? this.loadState,
      logs: logs ?? this.logs,
      filteredLogs: filteredLogs ?? this.filteredLogs,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedType:
          clearSelectedType ? null : selectedType ?? this.selectedType,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }
}

class LogsPageModel extends BasePageModel<LogsPageState> {
  LogsPageModel({
    required this.logService,
  }) : super(LogsPageState.initial());

  final LogService logService;

  Future<void> loadLogs() async {
    state = state.updateState(loadState: AppLoadState.loading);

    try {
      final dateStr = AppTimeFormatter.formatDateOnly(state.selectedDate) ?? '';

      final logs = await logService.getLogs(
        date: dateStr,
        type: state.selectedType?.apiValue,
      );
      logs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = state.updateState(
        loadState: AppLoadState.ready,
        logs: logs,
        filteredLogs: logs,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: 'Unable to load logs: ${e.toString()}',
      );
    }
  }

  Future<void> refreshLogs() async {
    try {
      final dateStr = AppTimeFormatter.formatDateOnly(state.selectedDate) ?? '';

      final logs = await logService.getLogs(
        date: dateStr,
        type: state.selectedType?.apiValue,
      );
      logs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = state.updateState(
        logs: logs,
        filteredLogs: logs,
      );
    } catch (_) {}
  }

  void selectDate(DateTime date) {
    state = state.updateState(selectedDate: date);
    loadLogs(); // Reload with new date filter from backend
  }

  void selectType(LogEntryType? type) {
    state = state.updateState(
      selectedType: type,
      clearSelectedType: type == null,
    );
    loadLogs(); // Reload with new type filter from backend
  }

  void clearFilter() {
    state = state.updateState(
      selectedDate: DateTime.now(),
      clearSelectedType: true,
    );
    loadLogs(); // Reload without filters
  }
}

final logsPageProvider =
    StateNotifierProvider<LogsPageModel, LogsPageState>((ref) {
  return LogsPageModel(
    logService: ref.read(logServiceProvider),
  );
});
