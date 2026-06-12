import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import '../../routes/routes_config.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../../extensions/localization_extension.dart';
import 'weekly_summary_page_model.dart';
import 'widgets/weekly_summary_header.dart';
import 'widgets/weekly_score_card.dart';
import 'widgets/weekly_stats_grid.dart';
import 'widgets/weekly_completion_chart.dart';
import 'widgets/weekly_insights_section.dart';
import 'widgets/weekly_quest_ranking.dart';
import 'widgets/weekly_adjust_section.dart';
import 'widgets/weekly_suggestions_section.dart';
import 'widgets/weekly_schedule_preview.dart';
import 'widgets/weekly_protection_card.dart';
import 'widgets/weekly_links_row.dart';

class WeeklySummaryPage
    extends BasePage<WeeklySummaryPageModel, WeeklySummaryPageState> {
  WeeklySummaryPage({super.key}) : super(provider: weeklySummaryPageProvider);

  @override
  ConsumerState<WeeklySummaryPage> createState() => _WeeklySummaryPageState();
}

class _WeeklySummaryPageState extends BasePageConsumerState<WeeklySummaryPage,
    WeeklySummaryPageModel, WeeklySummaryPageState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.loadWeeklySummary();
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;
    final l10n = context.l10n;

    if (state.loadState == AppLoadState.loading) {
      return AppScaffold(
        title: l10n.weeklySummaryPageTitle,
        showBackButton: true,
        body: AppLoading(message: l10n.weeklySummaryLoading),
      );
    }

    if (state.loadState == AppLoadState.error) {
      return AppScaffold(
        title: l10n.weeklySummaryPageTitle,
        showBackButton: true,
        body: AppErrorState(
          message: state.errorMessage ?? l10n.weeklySummaryError,
          onRetry: pageModel.loadWeeklySummary,
        ),
      );
    }

    final summary = state.summary;
    if (summary == null) {
      return AppScaffold(
        title: l10n.weeklySummaryPageTitle,
        showBackButton: true,
        body: Center(child: Text(l10n.weeklySummaryNoData)),
      );
    }

    return AppScaffold(
      scroll: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WeeklySummaryHeader(summary: summary),
          const SizedBox(height: AppSpacing.s16),
          WeeklyScoreCard(summary: summary),
          const SizedBox(height: AppSpacing.s16),
          WeeklyStatsGrid(summary: summary),
          const SizedBox(height: AppSpacing.s16),
          WeeklyCompletionChart(summary: summary),
          const SizedBox(height: AppSpacing.s16),
          WeeklyInsightsSection(summary: summary),
          const SizedBox(height: AppSpacing.s16),
          WeeklyQuestRanking(summary: summary),
          const SizedBox(height: AppSpacing.s16),
          WeeklyAdjustSection(summary: summary),
          const SizedBox(height: AppSpacing.s16),
          WeeklySuggestionsSection(
            summary: summary,
            enabledSuggestions: state.enabledSuggestions,
            onToggle: pageModel.toggleSuggestion,
          ),
          const SizedBox(height: AppSpacing.s16),
          WeeklySchedulePreview(summary: summary),
          const SizedBox(height: AppSpacing.s16),
          const WeeklyProtectionCard(),
          const SizedBox(height: AppSpacing.s16),
          _buildApplyButton(context, state),
          const SizedBox(height: AppSpacing.s12),
          _buildManualButton(context),
          const SizedBox(height: AppSpacing.s16),
          WeeklyLinksRow(
            onRulesTap: () =>
                Navigator.pushNamed(context, RoutesConfig.questRules),
            onRemindersTap: () =>
                Navigator.pushNamed(context, RoutesConfig.reminderSettings),
          ),
          const SizedBox(height: AppSpacing.s32),
        ],
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context, WeeklySummaryPageState state) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: GestureDetector(
        onTap: () {
          AppToastService.info(
            context,
            'Tính năng áp dụng tự động sẽ được thêm sau.',
          );
        },
        child: Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColor.weeklyChartGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColor.cyan.withValues(alpha: 0.24),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '${l10n.weeklySummaryCtaApply} (${state.enabledSuggestionCount})',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColor.bgDeep,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildManualButton(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, RoutesConfig.scheduleEditor),
        child: Container(
          height: 44,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.transparent,
            border: Border.all(color: AppColor.border),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            l10n.weeklySummaryCtaManual,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.fg,
            ),
          ),
        ),
      ),
    );
  }
}
