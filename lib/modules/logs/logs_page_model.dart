import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
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
    this.loadState = AppLoadState.idle,
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
      final logs = await logService.getLogs();
      logs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = state.updateState(
        loadState: AppLoadState.ready,
        logs: logs,
      );
      _applyFilters();
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: 'Không thể tải nhật ký: ${e.toString()}',
      );
    }
  }

  Future<void> refreshLogs() async {
    try {
      final logs = await logService.getLogs();
      logs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = state.updateState(logs: logs);
      _applyFilters();
    } catch (_) {}
  }

  void selectDate(DateTime date) {
    state = state.updateState(selectedDate: date);
    _applyFilters();
  }

  void selectType(LogEntryType? type) {
    state = state.updateState(
      selectedType: type,
      clearSelectedType: type == null,
    );
    _applyFilters();
  }

  void clearFilter() {
    state = state.updateState(
      selectedDate: DateTime.now(),
      clearSelectedType: true,
    );
    _applyFilters();
  }

  void _applyFilters() {
    final selectedDate = state.selectedDate;
    final selectedType = state.selectedType;

    var filtered = state.logs.where((log) {
      final sameDate = _isSameDate(log.createdAt, selectedDate);
      if (!sameDate) return false;

      if (selectedType != null && log.type != selectedType) {
        return false;
      }

      return true;
    }).toList();

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    state = state.updateState(filteredLogs: filtered);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

final logsPageProvider =
    StateNotifierProvider<LogsPageModel, LogsPageState>((ref) {
  return LogsPageModel(
    logService: ref.read(logServiceProvider),
  );
});
