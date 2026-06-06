import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_spacing.dart';
import '../../routes/routes_config.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../profile/profile_page_model.dart';
import 'daily_review_page_model.dart';
import '../../extensions/localization_extension.dart';
import 'widgets/daily_review_header.dart';
import 'widgets/daily_review_summary_card.dart';
import 'widgets/review_mood_selector_card.dart';
import 'widgets/review_energy_selector_card.dart';
import 'widgets/review_satisfaction_selector_card.dart';
import 'widgets/review_reflection_card.dart';
import 'widgets/review_tomorrow_priority_card.dart';
import 'widgets/daily_review_submit_bar.dart';

class DailyReviewPage
    extends BasePage<DailyReviewPageModel, DailyReviewPageState> {
  DailyReviewPage({super.key}) : super(provider: dailyReviewPageProvider);

  @override
  ConsumerState<DailyReviewPage> createState() => _DailyReviewPageState();
}

class _DailyReviewPageState extends BasePageConsumerState<DailyReviewPage,
    DailyReviewPageModel, DailyReviewPageState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.loadDailyReview();
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    if (state.loadState == AppLoadState.loading) {
      return AppScaffold(
        title: context.l10n.dailyReviewPageTitle,
        showBackButton: true,
        body: AppLoading(message: context.l10n.dailyReviewLoading),
      );
    }

    if (state.loadState == AppLoadState.error) {
      return AppScaffold(
        title: context.l10n.dailyReviewPageTitle,
        showBackButton: true,
        body: AppErrorState(
          message: state.errorMessage ?? context.l10n.dailyReviewToastFailed,
          onRetry: pageModel.loadDailyReview,
        ),
      );
    }

    return AppScaffold(
      scroll: false,
      bottom: DailyReviewSubmitBar(
        canSubmit: state.canSubmit,
        isLoading: state.isLockedPage,
        hasReviewed: state.hasReviewedToday,
        onSubmit: _handleSubmit,
        onViewWeekly: () =>
            Navigator.pushNamed(context, RoutesConfig.weeklySummary),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DailyReviewHeader(),
                  const SizedBox(height: AppSpacing.s14),
                  DailyReviewSummaryCard(
                    completedCount: state.completedQuestCount,
                    skippedCount: state.skippedQuestCount,
                    earnedExp: state.earnedExp,
                    completionRate: state.completionRate,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  ReviewMoodSelectorCard(
                    value: state.mood,
                    onChanged: pageModel.setMood,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  ReviewEnergySelectorCard(
                    value: state.energyLevel,
                    onChanged: pageModel.setEnergyLevel,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  ReviewSatisfactionSelectorCard(
                    value: state.satisfaction,
                    onChanged: pageModel.setSatisfaction,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  ReviewReflectionCard(
                    value: state.reflection,
                    onChanged: pageModel.setReflection,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  ReviewTomorrowPriorityCard(
                    value: state.tomorrowPriority,
                    onChanged: pageModel.setTomorrowPriority,
                  ),
                  const SizedBox(height: AppSpacing.s32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final state = read;

    if (!state.canSubmit) {
      AppToastService.warning(context, context.l10n.dailyReviewToastMissing);
      return;
    }

    final success = await pageModel.submitReview();

    if (!mounted) return;

    if (success) {
      // Invalidate profile provider to refresh hasReviewedToday status
      ref.invalidate(profilePageProvider);

      AppToastService.success(context, context.l10n.dailyReviewToastSuccess);
      Navigator.pop(context);
    } else {
      AppToastService.error(context, context.l10n.dailyReviewToastFailed);
    }
  }
}
