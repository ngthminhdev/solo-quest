import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../models/quest_model.dart';
import '../../routes/routes_config.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../../widgets/app_dialog/quest_completion_dialog.dart';
import '../../widgets/app_bottom_sheet/snooze_quest_sheet.dart';
import '../../widgets/app_bottom_sheet/skip_quest_sheet.dart';
import 'home_page_model.dart';
import 'widgets/daily_progress_card.dart';
import 'widgets/home_insight_card.dart';
import 'widgets/active_quest_section.dart';
import 'widgets/upcoming_quest_section.dart';
import 'widgets/completed_quest_section.dart';
import 'widgets/home_empty_quest_view.dart';

class HomePage extends BasePage<HomePageModel, HomePageState> {
  HomePage({super.key}) : super(provider: homePageProvider);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageConsumerState<HomePage, HomePageModel, HomePageState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.loadHomeData();
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

    if (state.loadState == AppLoadState.loading && !state.hasAnyQuest) {
      return AppScaffold(
        showBottomNav: false,
        body: const AppLoading(message: 'Đang tải dữ liệu...'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
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
              onTap: _openQuestDetail,
              onStart: _handleStartQuest,
              onComplete: _handleCompleteQuest,
              onSnooze: _handleSnoozeQuest,
              onSkip: _handleSkipQuest,
              onViewReason: _showQuestReason,
            ),
            UpcomingQuestSection(
              quests: state.upcomingQuests,
              onTap: _openQuestDetail,
              onStart: _handleStartQuest,
              onComplete: _handleCompleteQuest,
            ),
            CompletedQuestSection(
              quests: state.completedQuests,
              onTap: _openQuestDetail,
            ),
          ],
        ),
      ),
    );
  }

  void _openQuestDetail(QuestModel quest) {
    Navigator.of(context).pushNamed(
      RoutesConfig.questDetail,
      arguments: {'id': quest.id},
    );
  }

  Future<void> _handleStartQuest(QuestModel quest) async {
    try {
      await pageModel.startQuest(quest.id);
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
          await pageModel.completeQuest(quest.id);
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
      await pageModel.snoozeQuest(quest.id, minutes: minutes);
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
      await pageModel.skipQuest(quest.id, reason: reason);
      if (mounted) {
        AppToastService.warning(context, 'Đã bỏ qua nhiệm vụ');
      }
    } catch (e) {
      if (mounted) {
        AppToastService.error(context, 'Không thể bỏ qua nhiệm vụ');
      }
    }
  }

  void _showQuestReason(QuestModel quest) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF0F1629),
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
                color: Color(0xFFE8ECF4),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              quest.reason ?? 'Nhiệm vụ này được đề xuất dựa trên lịch sinh hoạt và mục tiêu hôm nay của bạn.',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8B95A8),
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
