import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import '../../models/schedule_model.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../../widgets/app_dialog/app_confirm_dialog.dart';
import 'schedule_editor_page_model.dart';
import 'widgets/schedule_summary_card.dart';
import 'widgets/schedule_block_list_section.dart';
import 'widgets/schedule_block_form_sheet.dart';
import 'constants/schedule_editor_constants.dart';

class ScheduleEditorPage
    extends BasePage<ScheduleEditorPageModel, ScheduleEditorPageState> {
  ScheduleEditorPage({super.key}) : super(provider: scheduleEditorPageProvider);

  @override
  ConsumerState<ScheduleEditorPage> createState() =>
      _ScheduleEditorPageState();
}

class _ScheduleEditorPageState extends BasePageConsumerState<
    ScheduleEditorPage, ScheduleEditorPageModel, ScheduleEditorPageState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.loadSchedule();
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    if (state.loadState == AppLoadState.loading && !state.hasBlocks) {
      return Scaffold(
        backgroundColor: AppColor.bg,
        appBar: AppBar(
          backgroundColor: AppColor.bgRaised,
          elevation: 0,
          title: Text(
            ScheduleEditorConstants.pageTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.fg,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColor.fg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const AppLoading(message: 'Đang tải lịch sinh hoạt...'),
      );
    }

    if (state.loadState == AppLoadState.error && !state.hasBlocks) {
      return Scaffold(
        backgroundColor: AppColor.bg,
        appBar: AppBar(
          backgroundColor: AppColor.bgRaised,
          elevation: 0,
          title: Text(
            ScheduleEditorConstants.pageTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.fg,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColor.fg),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: AppErrorState(
          message: state.errorMessage ?? 'Không thể tải lịch sinh hoạt',
          onRetry: pageModel.loadSchedule,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        backgroundColor: AppColor.bgRaised,
        elevation: 0,
        title: Text(
          ScheduleEditorConstants.pageTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColor.fg,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.fg),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        color: AppColor.cyan,
        backgroundColor: AppColor.bgRaised,
        onRefresh: pageModel.refreshSchedule,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s16),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                child: Text(
                  ScheduleEditorConstants.pageSubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.fgMuted,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.s16),

              // Summary card
              if (state.hasBlocks)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                  child: ScheduleSummaryCard(
                    totalBlocks: state.totalBlocks,
                    fixedBlockCount: state.fixedBlockCount,
                    flexibleBlockCount: state.flexibleBlockCount,
                  ),
                ),

              const SizedBox(height: AppSpacing.s20),

              // Block list
              ScheduleBlockListSection(
                blocks: state.blocks,
                onEdit: _handleEditBlock,
                onDelete: _handleDeleteBlock,
              ),

              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleAddBlock,
        backgroundColor: AppColor.cyan,
        foregroundColor: AppColor.bgDeep,
        icon: const Icon(Icons.add),
        label: Text(
          ScheduleEditorConstants.addBlockButton,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddBlock() async {
    final result = await ScheduleBlockFormSheet.show(context);

    if (result != null && mounted) {
      final block = ScheduleBlockModel(
        id: '',
        title: result.title,
        type: result.type,
        timeRange: TimeRangeModel(
          start: result.start,
          end: result.end,
        ),
        weekdays: result.weekdays,
        isFlexible: result.isFlexible,
      );

      final success = await pageModel.addBlock(block);

      if (mounted) {
        if (success) {
          AppToastService.success(
            context,
            ScheduleEditorConstants.toastAddSuccess,
          );
        } else {
          AppToastService.error(
            context,
            ScheduleEditorConstants.toastAddFailed,
          );
        }
      }
    }
  }

  Future<void> _handleEditBlock(ScheduleBlockModel block) async {
    final result = await ScheduleBlockFormSheet.show(
      context,
      initialBlock: block,
    );

    if (result != null && mounted) {
      final updatedBlock = block.copyWith(
        title: result.title,
        type: result.type,
        timeRange: TimeRangeModel(
          start: result.start,
          end: result.end,
        ),
        weekdays: result.weekdays,
        isFlexible: result.isFlexible,
      );

      final success = await pageModel.updateBlock(updatedBlock);

      if (mounted) {
        if (success) {
          AppToastService.success(
            context,
            ScheduleEditorConstants.toastUpdateSuccess,
          );
        } else {
          AppToastService.error(
            context,
            ScheduleEditorConstants.toastUpdateFailed,
          );
        }
      }
    }
  }

  Future<void> _handleDeleteBlock(ScheduleBlockModel block) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: ScheduleEditorConstants.deleteConfirmTitle,
      message: ScheduleEditorConstants.deleteConfirmMessage,
    );

    if (confirmed == true && mounted) {
      final success = await pageModel.deleteBlock(block.id);

      if (mounted) {
        if (success) {
          AppToastService.success(
            context,
            ScheduleEditorConstants.toastDeleteSuccess,
          );
        } else {
          AppToastService.error(
            context,
            ScheduleEditorConstants.toastDeleteFailed,
          );
        }
      }
    }
  }
}
