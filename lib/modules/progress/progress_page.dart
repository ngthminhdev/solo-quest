import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import '../../extensions/localization_extension.dart';
import '../../routes/routes_config.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/skeleton/skeleton_progress_page.dart';
import 'package:remixicon/remixicon.dart';

import '../main/main_page_model.dart';
import 'progress_page_model.dart';
import 'widgets/summary_hero_card.dart';
import 'widgets/exp_explain_card.dart';
import 'widgets/exp_breakdown_card.dart';
import 'widgets/streak_safety_card.dart';
import 'widgets/weekly_chart_card.dart';
import 'widgets/xp_history_card.dart';
import 'widgets/progress_link_card.dart';
import 'widgets/progress_empty_view.dart';

class ProgressPage extends BasePage<ProgressPageModel, ProgressPageState> {
  ProgressPage({super.key}) : super(provider: progressPageProvider);

  @override
  ConsumerState<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState
    extends
        BasePageConsumerState<
          ProgressPage,
          ProgressPageModel,
          ProgressPageState
        > {
  static const _tabIndex = 2;
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
      pageModel.loadProgress();
    }
  }

  @override
  void onBuild() {
    if (!_settleListenerSet) {
      _settleListenerSet = true;
      ref.listen(mainPageProvider.select((s) => s.settledIndex), (prev, next) {
        if (next == _tabIndex && prev != _tabIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pageModel.loadProgress();
          });
        }
      });
    }
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    if (state.loadState == AppLoadState.loading && !state.hasProgress) {
      return AppScaffold(
        showBottomNav: false,
        body: const SkeletonProgressPage(),
      );
    }

    if (state.loadState == AppLoadState.error && !state.hasProgress) {
      return AppScaffold(
        showBottomNav: false,
        body: AppErrorState(
          message: state.errorMessage ?? context.l10n.progressError,
          onRetry: pageModel.loadProgress,
        ),
      );
    }

    final progress = state.progress;
    if (progress == null) {
      return AppScaffold(showBottomNav: false, body: const ProgressEmptyView());
    }

    return AppScaffold(
      showBottomNav: false,
      scroll: false,
      body: RefreshIndicator(
        color: AppColor.cyan,
        backgroundColor: AppColor.bgRaised,
        onRefresh: pageModel.refreshProgress,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppSpacing.s32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SummaryHeroCard(progress: progress),
              StreakSafetyCard(progress: progress),
              if (progress.weeklyDailyData.isNotEmpty)
                WeeklyChartCard(
                  dailyData: progress.weeklyDailyData,
                  weeklyTotal: progress.weeklyTotalCompleted,
                  weeklyPlanned: progress.weeklyTotalPlanned,
                  avgRate: progress.weeklyCompletionRate,
                ),
              if (state.hasXPHistory)
                XPHistoryCard(
                  transactions: state.xpHistory!.transactions,
                ),
              const ExpBreakdownCard(),
              const ExpExplainCard(),
              // TODO: Re-enable habit insights when backend provides per-type completion rates
              // _buildHabitSection(context),
              _buildLinksSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // Temporarily disabled - mock data was misleading
  // Re-enable when backend provides per-type completion rates with denominators
  // Widget _buildHabitSection(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(
  //           AppSpacing.s16,
  //           AppSpacing.s20,
  //           AppSpacing.s16,
  //           AppSpacing.s8,
  //         ),
  //         child: Row(
  //           children: [
  //             Container(
  //               width: 8,
  //               height: 8,
  //               decoration: const BoxDecoration(
  //                 color: AppColor.violet,
  //                 shape: BoxShape.circle,
  //               ),
  //             ),
  //             const SizedBox(width: AppSpacing.s6),
  //             Text(
  //               context.l10n.progressHabitTitle,
  //               style: TextStyle(
  //                 fontFamily: 'Roboto',
  //                 fontSize: 11,
  //                 fontWeight: FontWeight.w800,
  //                 letterSpacing: 0.8,
  //                 color: AppColor.fgMuted,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       ...ProgressHabitInsights.getInsights().map(
  //         (insight) => HabitInsightCard(insight: insight),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildLinksSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s20,
            AppSpacing.s16,
            AppSpacing.s8,
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColor.fgMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.s6),
              Text(
                context.l10n.progressLinksTitle,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: AppColor.fgMuted,
                ),
              ),
            ],
          ),
        ),
        ProgressLinkCard(
          icon: RemixIcons.calendar_line,
          iconColor: AppColor.violet,
          iconBg: AppColor.violetDim,
          title: context.l10n.progressWeeklySummary,
          desc: context.l10n.progressWeeklySummaryDesc,
          onTap: () =>
              Navigator.pushNamed(context, RoutesConfig.weeklySummary),
        ),
        ProgressLinkCard(
          icon: RemixIcons.list_settings_line,
          iconColor: AppColor.warn,
          iconBg: AppColor.warnDim,
          title: context.l10n.progressQuestRules,
          desc: context.l10n.progressQuestRulesDesc,
          onTap: () =>
              Navigator.pushNamed(context, RoutesConfig.questRules),
        ),
      ],
    );
  }
}
