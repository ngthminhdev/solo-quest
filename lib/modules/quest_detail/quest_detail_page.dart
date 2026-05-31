import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_spacing.dart';
import '../../models/quest_model.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../../widgets/app_dialog/quest_completion_dialog.dart';
import '../../widgets/app_bottom_sheet/snooze_quest_sheet.dart';
import '../../widgets/app_bottom_sheet/skip_quest_sheet.dart';
import 'quest_detail_page_model.dart';
import 'widgets/quest_detail_header.dart';
import 'widgets/quest_detail_status_card.dart';
import 'widgets/quest_detail_reason_card.dart';
import 'widgets/quest_detail_instruction_card.dart';
import 'widgets/quest_detail_action_bar.dart';
import 'widgets/quest_detail_history_section.dart';

class QuestDetailPage extends BasePage<QuestDetailPageModel, QuestDetailPageState> {
  final String questId;

  QuestDetailPage({
    super.key,
    required this.questId,
  }) : super(provider: questDetailPageProvider);

  @override
  ConsumerState<QuestDetailPage> createState() => _QuestDetailPageState();
}

class _QuestDetailPageState
    extends BasePageConsumerState<QuestDetailPage, QuestDetailPageModel, QuestDetailPageState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.loadQuest(widget.questId);
    });
  }

  @override
  void onBuild() {
    listen((previous, next) {
      if (previous?.loadState == AppLoadState.loading &&
          next.loadState == AppLoadState.error &&
          next.errorMessage != null) {
        AppToastService.error(context, next.errorMessage!);
      }
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    if (state.loadState == AppLoadState.loading && !state.hasQuest) {
      return AppScaffold(
        title: 'Chi Tiết Nhiệm Vụ',
        body: const AppLoading(message: 'Đang tải nhiệm vụ...'),
      );
    }

    if (state.loadState == AppLoadState.error || !state.hasQuest) {
      return AppScaffold(
        title: 'Chi Tiết Nhiệm Vụ',
        body: AppErrorState(
          message: state.errorMessage ?? 'Không thể tải nhiệm vụ',
          onRetry: () => pageModel.loadQuest(widget.questId),
        ),
      );
    }

    final quest = state.quest!;

    return AppScaffold(
      title: 'Chi Tiết Nhiệm Vụ',
      scroll: false,
      bottom: QuestDetailActionBar(
        quest: quest,
        isLoading: state.isLockedPage,
        onStart: () => _handleStartQuest(quest),
        onComplete: () => _handleCompleteQuest(quest),
        onSnooze: () => _handleSnoozeQuest(quest),
        onSkip: () => _handleSkipQuest(quest),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon, title, status
            QuestDetailHeader(quest: quest),

            const SizedBox(height: AppSpacing.s8),

            // Quick stats
            QuestDetailStatusCard(quest: quest),

            const SizedBox(height: AppSpacing.s20),

            // Mission / Instruction
            QuestDetailInstructionCard(quest: quest),

            const SizedBox(height: AppSpacing.s20),

            // Reason card
            QuestDetailReasonCard(reason: quest.reason),

            const SizedBox(height: AppSpacing.s20),

            // History section
            QuestDetailHistorySection(logs: state.logs),

            const SizedBox(height: AppSpacing.s20),
          ],
        ),
      ),
    );
  }

  Future<void> _handleStartQuest(QuestModel quest) async {
    try {
      await pageModel.startQuest();
      if (mounted) {
        AppToastService.success(context, 'Đã bắt đầu: ${quest.title}');
      }
    } catch (e) {
      if (mounted) {
        AppToastService.error(context, 'Không thể bắt đầu nhiệm vụ');
      }
    }
  }

  Future<void> _handleCompleteQuest(QuestModel quest) async {
    await QuestCompletionDialog.show(
      context: context,
      exp: quest.exp,
      onDone: () async {
        try {
          await pageModel.completeQuest();
          if (mounted) {
            AppToastService.success(
              context,
              'Hoàn thành nhiệm vụ +${quest.exp} EXP',
            );
          }
        } catch (e) {
          if (mounted) {
            AppToastService.error(context, 'Không thể hoàn thành nhiệm vụ');
          }
        }
      },
    );
  }

  Future<void> _handleSnoozeQuest(QuestModel quest) async {
    final minutes = await SnoozeQuestSheet.show(context);
    if (minutes == null) return;

    try {
      await pageModel.snoozeQuest(minutes: minutes);
      if (mounted) {
        AppToastService.warning(context, 'Đã hoãn nhiệm vụ $minutes phút');
      }
    } catch (e) {
      if (mounted) {
        AppToastService.error(context, 'Không thể hoãn nhiệm vụ');
      }
    }
  }

  Future<void> _handleSkipQuest(QuestModel quest) async {
    final reason = await SkipQuestSheet.show(context);
    if (reason == null) return;

    try {
      await pageModel.skipQuest(reason: reason);
      if (mounted) {
        AppToastService.warning(context, 'Đã bỏ qua nhiệm vụ');
      }
    } catch (e) {
      if (mounted) {
        AppToastService.error(context, 'Không thể bỏ qua nhiệm vụ');
      }
    }
  }
}
