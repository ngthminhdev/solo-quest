import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_spacing.dart';
import '../../models/quest_model.dart';
import '../../models/enums/quest_enums.dart';
import 'package:remixicon/remixicon.dart';
import '../../core/timer/countdown_session.dart';
import '../../core/timer/countdown_timer_service.dart';
import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import '../../extensions/localization_extension.dart';
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
    final countdownSession = ref.watch(countdownTimerServiceProvider);
    final isCurrentTimer = countdownSession != null &&
        countdownSession.questId == quest.id &&
        countdownSession.status == CountdownStatus.running;

    return AppScaffold(
      title: 'Chi Tiết Nhiệm Vụ',
      scroll: false,
      bottom: isCurrentTimer
          ? null
          : QuestDetailActionBar(
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

            // Countdown Timer Card
            _buildCountdownCard(context, quest),

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

  Widget _buildCountdownCard(BuildContext context, QuestModel quest) {
    final countdownSession = ref.watch(countdownTimerServiceProvider);
    final isCurrentTimer = countdownSession != null && countdownSession.questId == quest.id;
    final l10n = context.l10n;

    if (isCurrentTimer) {
      final remaining = ref.read(countdownTimerServiceProvider.notifier).getRemainingTime();
      final totalSeconds = countdownSession.durationMinutes * 60;
      final remainingSeconds = remaining.inSeconds;
      final progress = totalSeconds > 0 ? (1.0 - (remainingSeconds / totalSeconds)).clamp(0.0, 1.0) : 0.0;

      final minutesStr = remaining.inMinutes.toString().padLeft(2, '0');
      final secondsStr = (remaining.inSeconds % 60).toString().padLeft(2, '0');
      final timeStr = '$minutesStr:$secondsStr';

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColor.bgRaised,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColor.borderGlowCyan),
          boxShadow: const [
            BoxShadow(
              color: AppColor.cyanGlow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(RemixIcons.time_line, color: AppColor.cyan, size: 20),
                    const SizedBox(width: AppSpacing.s8),
                    Text(
                      l10n.timerRemaining,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColor.fgSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  timeStr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColor.cyan,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColor.surface,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColor.cyan),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await ref.read(countdownTimerServiceProvider.notifier).completeSession();
                        if (mounted) {
                          AppToastService.success(context, l10n.statusCompleted);
                        }
                      } catch (_) {
                        if (mounted) {
                          AppToastService.error(context, 'Không thể hoàn thành nhiệm vụ');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.success,
                      foregroundColor: AppColor.bgDeep,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      minimumSize: const Size(0, 40),
                    ),
                    child: Text(
                      l10n.timerComplete,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => ref.read(countdownTimerServiceProvider.notifier).cancelSession(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.danger,
                      side: const BorderSide(color: AppColor.danger),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      minimumSize: const Size(0, 40),
                    ),
                    child: Text(
                      l10n.timerStop,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (isCountdownEligible(quest)) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColor.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.timerDuration}: ${quest.estimatedMinutes} ${l10n.rewardsClaimDialogMinutes}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fg,
                  ),
                ),
                const Icon(RemixIcons.time_line, color: AppColor.fgSecondary, size: 20),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _handleStartCountdown(quest),
                icon: const Icon(RemixIcons.play_line, size: 16),
                label: Text(l10n.timerStart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.cyan,
                  foregroundColor: AppColor.bgDeep,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  minimumSize: const Size(0, 44),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _handleStartCountdown(QuestModel quest) async {
    final timerService = ref.read(countdownTimerServiceProvider.notifier);
    final activeSession = ref.read(countdownTimerServiceProvider);
    final l10n = context.l10n;

    if (activeSession != null && activeSession.status == CountdownStatus.running && activeSession.questId != quest.id) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColor.bgRaised,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          title: Text(
            l10n.timerConfirmReplace,
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.fg,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                l10n.commonCancel,
                style: const TextStyle(color: AppColor.fgSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                l10n.commonConfirm,
                style: const TextStyle(color: AppColor.cyan),
              ),
            ),
          ],
        ),
      );

      if (confirm != true) return;
      await timerService.cancelSession();
    }

    try {
      await timerService.startSession(quest);
      // Call quest start API if pending/snoozed (pending convention)
      if (quest.status == QuestStatus.pending || quest.status == QuestStatus.snoozed) {
        await pageModel.startQuest();
      }
      if (mounted) {
        AppToastService.success(context, 'Đã bắt đầu bộ đếm giờ');
      }
    } catch (e) {
      if (mounted) {
        AppToastService.error(context, 'Không thể bắt đầu bộ đếm');
      }
    }
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
        AppToastService.warning(context, 'Đã hoãn. Solo sẽ nhắc lại sau $minutes phút.');
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
