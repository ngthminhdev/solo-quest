import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../core/network/api_exception.dart';
import '../../models/schedule_model.dart';
import '../../services/schedule_service.dart';
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
  }) : super(ScheduleEditorPageState());

  final ScheduleService scheduleService;

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
      if (kDebugMode) {
        debugPrint('[ScheduleEditor] loadSchedule error: $e');
      }
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: _userFriendlyError(e, 'load'),
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
      if (kDebugMode) {
        debugPrint('[ScheduleEditor] refreshSchedule error: $e');
      }
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: _userFriendlyError(e, 'load'),
      );
    }
  }

  Future<bool> addBlock(ScheduleBlockModel block) async {
    try {
      state = state.updateState(isLockedPage: true);

      await scheduleService.addScheduleBlock(block);

      await loadSchedule();

      state = state.updateState(isLockedPage: false);
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ScheduleEditor] addBlock error: $e');
      }
      state = state.updateState(
        isLockedPage: false,
        errorMessage: _userFriendlyError(e, 'create'),
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
      if (kDebugMode) {
        debugPrint('[ScheduleEditor] updateBlock error: $e');
      }
      state = state.updateState(
        isLockedPage: false,
        errorMessage: _userFriendlyError(e, 'update'),
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
      if (kDebugMode) {
        debugPrint('[ScheduleEditor] deleteBlock error: $e');
      }
      state = state.updateState(
        isLockedPage: false,
        errorMessage: _userFriendlyError(e, 'delete'),
      );
      return false;
    }
  }

  String _userFriendlyError(Object error, String action) {
    if (error is ApiException) {
      switch (error.statusCode) {
        case 400:
          return error.message;
        case 401:
          return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
        case 404:
          return 'Không tìm thấy lịch sinh hoạt này.';
        case 500:
          return 'Lỗi server. Vui lòng thử lại sau.';
        default:
          if (error.error == 'network_error') {
            return 'Không có kết nối mạng. Vui lòng kiểm tra mạng.';
          }
          return error.message;
      }
    }
    return 'Không thể $action lịch sinh hoạt. Vui lòng thử lại.';
  }
}

final scheduleEditorPageProvider =
    StateNotifierProvider<ScheduleEditorPageModel, ScheduleEditorPageState>(
        (ref) {
  return ScheduleEditorPageModel(
    scheduleService: ref.read(scheduleServiceProvider),
  );
});
