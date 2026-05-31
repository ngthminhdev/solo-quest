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
import 'daily_review_page_model.dart';
import 'constants/daily_review_constants.dart';
import 'widgets/daily_review_header.dart';
import 'widgets/daily_review_summary_card.dart';
import 'widgets/daily_mood_selector_card.dart';
import 'widgets/daily_review_quest_section.dart';
import 'widgets/daily_review_difficulty_card.dart';
import 'widgets/daily_review_chip_selector_card.dart';
import 'widgets/daily_review_tomorrow_card.dart';
import 'widgets/daily_review_note_card.dart';
import 'widgets/daily_review_insight_card.dart';
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
        title: DailyReviewConstants.pageTitle,
        showBackButton: true,
        body: const AppLoading(message: 'Đang tải dữ liệu hôm nay...'),
      );
    }

    if (state.loadState == AppLoadState.error) {
      return AppScaffold(
        title: DailyReviewConstants.pageTitle,
        showBackButton: true,
        body: AppErrorState(
          message: state.errorMessage ?? DailyReviewConstants.toastFailed,
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
              padding: const EdgeInsets.only(bottom: AppSpacing.s16),
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
                  DailyReviewQuestSection(
                    completedCount: state.completedQuestCount,
                    skippedCount: state.skippedQuestCount,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  DailyReviewDifficultyCard(
                    selected: state.difficulty,
                    onChanged: pageModel.setDifficulty,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  DailyReviewChipSelectorCard(
                    title: DailyReviewConstants.sectionHelpful,
                    options: DailyReviewConstants.questTypeChips,
                    selected: state.helpfulQuests,
                    onToggle: pageModel.toggleHelpfulQuest,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  DailyReviewChipSelectorCard(
                    title: DailyReviewConstants.sectionAnnoying,
                    options: [
                      ...DailyReviewConstants.questTypeChips,
                      ...DailyReviewConstants.annoyingExtraChips,
                    ],
                    selected: state.annoyingQuests,
                    onToggle: pageModel.toggleAnnoyingQuest,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  DailyMoodSelectorCard(
                    mood: state.mood,
                    energyLevel: state.energyLevel,
                    satisfactionLevel: state.satisfactionLevel,
                    onMoodChanged: pageModel.setMood,
                    onEnergyChanged: pageModel.setEnergyLevel,
                    onSatisfactionChanged: pageModel.setSatisfactionLevel,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  DailyReviewTomorrowCard(
                    selected: state.tomorrowAdjustments,
                    onToggle: pageModel.toggleTomorrowAdjustment,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  DailyReviewNoteCard(
                    value: state.note,
                    onChanged: pageModel.setNote,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  const DailyReviewInsightCard(),
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
      AppToastService.warning(context, DailyReviewConstants.toastMissing);
      return;
    }

    final success = await pageModel.submitReview();

    if (!mounted) return;

    if (success) {
      AppToastService.success(context, DailyReviewConstants.toastSuccess);
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesConfig.home,
        (route) => false,
      );
    } else {
      AppToastService.error(context, DailyReviewConstants.toastFailed);
    }
  }
}
