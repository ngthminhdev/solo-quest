import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/schedule_model.dart';
import '../../models/log_entry_model.dart';
import '../../models/enums/log_enums.dart';
import '../../services/schedule_service.dart';
import '../../services/log_service.dart';
import '../../services/service_providers.dart';

class ScheduleEditorPageState extends BasePageState {
  final AppLoadState loadState;
  final List<ScheduleBlockModel> blocks;
  final String? errorMessage;

  ScheduleEditorPageState({
    this.loadState = AppLoadState.idle,
    this.blocks = const [],
    this.errorMessage,
    super.isLockedPage,
  });

  @override
  ScheduleEditorPageState updateState({
    AppLoadState? loadState,
    List<ScheduleBlockModel>? blocks,
    String? errorMessage,
    bool? isLockedPage,
  }) {
    return ScheduleEditorPageState(
      loadState: loadState ?? this.loadState,
      blocks: blocks ?? this.blocks,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  bool get hasBlocks => blocks.isNotEmpty;

  int get totalBlocks => blocks.length;

  int get flexibleBlockCount =>
      blocks.where((block) => block.isFlexible).length;

  int get fixedBlockCount =>
      blocks.where((block) => !block.isFlexible).length;
}

class ScheduleEditorPageModel extends BasePageModel<ScheduleEditorPageState> {
  ScheduleEditorPageModel({
    required this.scheduleService,
    required this.logService,
  }) : super(ScheduleEditorPageState());

  final ScheduleService scheduleService;
  final LogService logService;

  Future<void> loadSchedule() async {
    try {
      state = state.updateState(loadState: AppLoadState.loading);

      final blocks = await scheduleService.getScheduleBlocks();

      state = state.updateState(
        loadState: AppLoadState.ready,
        blocks: blocks,
        errorMessage: null,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshSchedule() async {
    try {
      final blocks = await scheduleService.getScheduleBlocks();

      state = state.updateState(
        loadState: AppLoadState.ready,
        blocks: blocks,
        errorMessage: null,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> addBlock(ScheduleBlockModel block) async {
    try {
      state = state.updateState(isLockedPage: true);

      await scheduleService.addScheduleBlock(block);

      // Add log entry
      await logService.addLog(
        LogEntryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
          type: LogEntryType.ruleUpdated,
          title: 'Đã thêm block lịch: ${block.title}',
          description: 'Thời gian: ${block.timeRange}',
        ),
      );

      await loadSchedule();

      state = state.updateState(isLockedPage: false);
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateBlock(ScheduleBlockModel block) async {
    try {
      state = state.updateState(isLockedPage: true);

      await scheduleService.updateScheduleBlock(block);

      await loadSchedule();

      state = state.updateState(isLockedPage: false);
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteBlock(String blockId) async {
    try {
      state = state.updateState(isLockedPage: true);

      await scheduleService.deleteScheduleBlock(blockId);

      await loadSchedule();

      state = state.updateState(isLockedPage: false);
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final scheduleEditorPageProvider =
    StateNotifierProvider<ScheduleEditorPageModel, ScheduleEditorPageState>((ref) {
  return ScheduleEditorPageModel(
    scheduleService: ref.read(scheduleServiceProvider),
    logService: ref.read(logServiceProvider),
  );
});
