import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solo_quest/constants/app_spacing.dart';
import 'dart:developer' as developer;

import '../../core/network/api_exception.dart';

import '../../constants/app_color.dart';
import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../models/quest_model.dart';
import '../../core/timer/countdown_session.dart';
import '../../core/timer/countdown_timer_service.dart';
import '../../extensions/localization_extension.dart';
import '../../constants/app_radius.dart';
import '../../routes/routes_config.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/skeleton/skeleton_home_page.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../../widgets/app_dialog/quest_completion_dialog.dart';
import '../../widgets/app_bottom_sheet/snooze_quest_sheet.dart';
import '../../widgets/app_bottom_sheet/skip_quest_sheet.dart';
import '../main/main_page_model.dart';
import 'home_page_model.dart';
import 'widgets/daily_progress_card.dart';
import 'widgets/home_insight_card.dart';
import 'widgets/active_quest_section.dart';
import 'widgets/upcoming_quest_section.dart';
import 'widgets/snoozed_quest_section.dart';
import 'widgets/completed_quest_section.dart';
import 'widgets/skipped_quest_section.dart';
import 'widgets/daily_review_cta_card.dart';
import 'widgets/home_summary_footer.dart';
import 'widgets/home_empty_quest_view.dart';

class HomePage extends BasePage<HomePageModel, HomePageState> {
  HomePage({super.key}) : super(provider: homePageProvider);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState
    extends BasePageConsumerState<HomePage, HomePageModel, HomePageState> {
  static const _tabIndex = 0;
  bool _settleListenerSet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryLoadIfSettled();
    });
  }

  void _tryLoadIfSettled() {
    final settled = ref.read(mainPageProvider.select((s) => s.settledIndex));
    if (settled == _tabIndex) {
      pageModel.loadHomeData();
    }
  }

  @override
  void onBuild() {
    if (!_settleListenerSet) {
      _settleListenerSet = true;
      ref.listen(mainPageProvider.select((s) => s.settledIndex), (prev, next) {
        if (next == _tabIndex && prev != _tabIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pageModel.loadHomeData();
          });
        }
      });
    }

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

    if (state.loadState == AppLoadState.loading && !state.hasAnyQuest) {
      return AppScaffold(
        showBottomNav: false,
        body: const SkeletonHomePage(),
      );
    }

    if (state.loadState == AppLoadState.error && !state.hasAnyQuest) {
      return AppScaffold(
        showBottomNav: false,
        body: AppErrorState(
          message: state.errorMessage ?? 'Không thể tải dữ liệu hôm nay',
          onRetry: pageModel.loadHomeData,
        ),
      );
    }

    if (!state.hasAnyQuest && state.loadState == AppLoadState.ready) {
      return AppScaffold(
        showBottomNav: false,
        body: const HomeEmptyQuestView(),
      );
    }

    return AppScaffold(
      showBottomNav: false,
      scroll: false,
      body: RefreshIndicator(
        backgroundColor: AppColor.surface,
        color: AppColor.cyan,
        onRefresh: () async {
          if (state.loadState == AppLoadState.loading) return;
          await pageModel.loadHomeData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              DailyProgressCard(
                progress: state.progress,
                completedToday: state.completedTodayQuestCount,
                totalToday: state.totalTodayQuestCount,
                completionRate: state.todayCompletionRate,
              ),
              HomeInsightCard(insight: state.todayInsight),
              ActiveQuestSection(
                quests: state.activeQuests,
                allCompleted: state.allCompleted,
                pendingActions: state.pendingActions,
                onTap: _openQuestDetail,
                onStart: _handleStartQuest,
                onComplete: _handleCompleteQuest,
                onSnooze: _handleSnoozeQuest,
                onSkip: _handleSkipQuest,
                onViewReason: _showQuestReason,
              ),
              UpcomingQuestSection(
                quests: state.upcomingQuests,
                pendingActions: state.pendingActions,
                onTap: _openQuestDetail,
                onStart: _handleStartQuest,
                onComplete: _handleCompleteQuest,
              ),
              SnoozedQuestSection(
                quests: state.snoozedQuests,
                onTap: _openQuestDetail,
              ),
              CompletedQuestSection(
                quests: state.completedQuests,
                onTap: _openQuestDetail,
              ),
              SkippedQuestSection(
                quests: state.skippedQuests,
                onTap: _openQuestDetail,
              ),
              if (state.shouldShowDailyReviewCta)
                DailyReviewCtaCard(
                  hasReviewed: false,
                  onTap: () {
                    Navigator.of(context).pushNamed(RoutesConfig.dailyReview);
                  },
                ),
              HomeSummaryFooter(
                completedCount: state.completedTodayQuestCount,
                totalCount: state.totalTodayQuestCount,
                earnedExp: state.earnedExpToday,
                streakDays: state.streakDays,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openQuestDetail(QuestModel quest) {
    Navigator.of(
      context,
    ).pushNamed(RoutesConfig.questDetail, arguments: {'id': quest.id});
  }

  Future<void> _handleStartQuest(QuestModel quest) async {
    developer.log('[QUEST ACTION] start tapped: id=${quest.id}');
    
    // Check countdown eligibility
    if (isCountdownEligible(quest)) {
      final timerService = ref.read(countdownTimerServiceProvider.notifier);
      final activeSession = ref.read(countdownTimerServiceProvider);
      final l10n = context.l10n;

      if (activeSession != null &&
          activeSession.status == CountdownStatus.running &&
          activeSession.questId != quest.id) {
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
        await pageModel.startQuest(quest.id);
        developer.log('[QUEST ACTION] start success: id=${quest.id}');
        if (mounted) {
          AppToastService.success(context, 'Đã bắt đầu bộ đếm giờ');
          _openQuestDetail(quest);
        }
      } catch (e) {
        developer.log('[QUEST ACTION] start failed: $e');
        if (mounted) {
          AppToastService.error(context, 'Không thể bắt đầu bộ đếm');
        }
      }
      return;
    }

    // Normal non-countdown quest start flow
    try {
      await pageModel.startQuest(quest.id);
      developer.log('[QUEST ACTION] start success: id=${quest.id}');
      if (mounted) {
        AppToastService.success(context, 'Đã bắt đầu quest');
      }
    } catch (e) {
      developer.log('[QUEST ACTION] start failed: $e');
      if (e is ApiException && e.rawBody != null) {
        developer.log('[QUEST ACTION] raw response: ${e.rawBody}');
      }
      if (mounted) {
        AppToastService.error(context, 'Không thể bắt đầu quest');
      }
    }
  }

  Future<void> _handleCompleteQuest(QuestModel quest) async {
    developer.log('[QUEST ACTION] complete tapped: id=${quest.id}');
    await QuestCompletionDialog.show(
      context: context,
      exp: quest.exp,
      onDone: () async {
        try {
          await pageModel.completeQuest(quest.id);
          developer.log(
            '[QUEST ACTION] complete success: id=${quest.id}, expGained=${quest.exp}',
          );
          if (mounted) {
            AppToastService.success(context, 'Quest đã hoàn thành');
          }
        } catch (e) {
          developer.log('[QUEST ACTION] complete failed: $e');
          if (e is ApiException && e.rawBody != null) {
            developer.log('[QUEST ACTION] raw response: ${e.rawBody}');
          }
          if (mounted) {
            AppToastService.error(context, 'Không thể hoàn thành quest');
          }
        }
      },
    );
  }

  Future<void> _handleSnoozeQuest(QuestModel quest) async {
    final minutes = await SnoozeQuestSheet.show(context);
    if (minutes == null) return;

    developer.log('[QUEST ACTION] snooze tapped: id=${quest.id}, minutes=$minutes');
    try {
      await pageModel.snoozeQuest(quest.id, minutes: minutes);
      developer.log('[QUEST ACTION] snooze success: id=${quest.id}');
      if (mounted) {
        AppToastService.success(context, 'Đã hoãn. Solo sẽ nhắc lại sau $minutes phút.');
      }
    } catch (e) {
      developer.log('[QUEST ACTION] snooze failed: $e');
      if (e is ApiException && e.rawBody != null) {
        developer.log('[QUEST ACTION] raw response: ${e.rawBody}');
      }
      if (mounted) {
        AppToastService.error(context, 'Không thể hoãn quest');
      }
    }
  }

  Future<void> _handleSkipQuest(QuestModel quest) async {
    final reason = await SkipQuestSheet.show(context);
    if (reason == null) return;

    developer.log('[QUEST ACTION] skip tapped: id=${quest.id}');
    try {
      await pageModel.skipQuest(quest.id, reason: reason);
      developer.log('[QUEST ACTION] skip success: id=${quest.id}');
      if (mounted) {
        AppToastService.success(context, 'Đã bỏ qua quest');
      }
    } catch (e) {
      developer.log('[QUEST ACTION] skip failed: $e');
      if (e is ApiException && e.rawBody != null) {
        developer.log('[QUEST ACTION] raw response: ${e.rawBody}');
      }
      if (mounted) {
        AppToastService.error(context, 'Không thể bỏ qua quest');
      }
    }
  }

  void _showQuestReason(QuestModel quest) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColor.bgRaised,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vì sao có nhiệm vụ này?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColor.fg,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              quest.reason ??
                  'Nhiệm vụ này được đề xuất dựa trên lịch sinh hoạt và mục tiêu hôm nay của bạn.',
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.fgSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
