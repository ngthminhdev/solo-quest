// UI reactivated with local/placeholder data; backend integration pending

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import '../../extensions/localization_extension.dart';
import '../../models/learning_goal_model.dart';
import '../../widgets/app_dialog/app_confirm_dialog.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../../widgets/skeleton/skeleton_home_page.dart';
import 'learning_goals_page_model.dart';
import 'widgets/active_goal_card.dart';
import 'widgets/learning_goal_category_selector.dart';
import 'widgets/learning_goal_form_sheet.dart';
import 'widgets/learning_goal_list_section.dart';
import 'widgets/learning_goal_progress_sheet.dart';
import 'widgets/learning_goal_summary_card.dart';

class LearningGoalsPage
    extends BasePage<LearningGoalsPageModel, LearningGoalsPageState> {
  LearningGoalsPage({super.key}) : super(provider: learningGoalsPageProvider);

  @override
  ConsumerState<LearningGoalsPage> createState() => _LearningGoalsPageState();
}

class _LearningGoalsPageState
    extends
        BasePageConsumerState<
          LearningGoalsPage,
          LearningGoalsPageModel,
          LearningGoalsPageState
        > {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.loadGoals();
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;
    return AppScaffold(
      showBottomNav: false,
      scroll: false,
      body: _buildContent(state),
    );
  }

  Widget _buildContent(LearningGoalsPageState state) {
    final l10n = context.l10n;

    if (state.loadState == AppLoadState.loading && !state.hasGoals) {
      return const SkeletonHomePage();
    }

    if (state.loadState == AppLoadState.error && !state.hasGoals) {
      return AppErrorState(
        message: state.errorMessage ?? l10n.lgErrorLoadFailed,
        onRetry: pageModel.loadGoals,
      );
    }

    return RefreshIndicator(
      backgroundColor: AppColor.surface,
      color: AppColor.cyan,
      onRefresh: pageModel.refreshGoals,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: AppSpacing.s16,
          bottom: AppSpacing.s16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const LearningGoalsHeader(),
            // const SizedBox(height: AppSpacing.s16),
            if (state.hasGoals) ...[
              // Active goal card (first active goal)
              if (state.goals.any((g) => g.isActive && g.progress < 1.0))
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                  child: ActiveGoalCard(
                    goal: state.goals.firstWhere(
                      (g) => g.isActive && g.progress < 1.0,
                    ),
                    isMainGoal: true,
                    onViewRoadmap: () {},
                    onSync: () {},
                    onPause: () {},
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                child: LearningGoalSummaryCard(
                  totalGoals: state.totalGoals,
                  activeGoals: state.activeGoals,
                  completedGoals: state.completedGoals,
                  averageProgress: state.averageProgress,
                ),
              ),

              const SizedBox(height: AppSpacing.s16),

              if (state.categories.isNotEmpty) ...[
                LearningGoalCategorySelector(
                  categories: state.categories,
                  selectedCategory: state.selectedCategory,
                  onChanged: pageModel.selectCategory,
                ),
                const SizedBox(height: AppSpacing.s12),
              ],

              LearningGoalListSection(
                goals: state.filteredGoals,
                onEdit: (goal) => _handleEditGoal(goal),
                onDelete: (goal) => _handleDeleteGoal(goal),
                onUpdateProgress: (goal) => _handleUpdateProgress(goal),
              ),
            ],

            // Add goal button if no goals
            if (!state.hasGoals)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s16,
                  vertical: AppSpacing.s16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _handleAddGoal,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.lgAddGoalButton),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.cyan,
                      side: BorderSide(color: AppColor.primaryBorder),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAddGoal() async {
    final l10n = context.l10n;
    final result = await LearningGoalFormSheet.show(context);
    if (result == null) return;

    final goal = LearningGoalModel(
      id: '',
      title: result.title,
      description: result.description,
      category: result.category,
      targetMinutesPerDay: result.targetMinutesPerDay,
      deadline: result.deadline,
      isActive: result.isActive,
    );

    final success = await pageModel.addGoal(goal);

    if (!mounted) return;

    if (success) {
      AppToastService.success(context, l10n.lgToastAddSuccess);
    } else {
      AppToastService.error(context, l10n.lgToastAddFailed);
    }
  }

  Future<void> _handleEditGoal(LearningGoalModel goal) async {
    final l10n = context.l10n;
    final result = await LearningGoalFormSheet.show(context, initialGoal: goal);
    if (result == null) return;

    final updatedGoal = LearningGoalModel(
      id: goal.id,
      title: result.title,
      description: result.description,
      category: result.category,
      targetMinutesPerDay: result.targetMinutesPerDay,
      deadline: result.deadline,
      isActive: result.isActive,
    );

    final success = await pageModel.updateGoal(updatedGoal);

    if (!mounted) return;

    if (success) {
      AppToastService.success(context, l10n.lgToastUpdateSuccess);
    } else {
      AppToastService.error(context, l10n.lgToastUpdateFailed);
    }
  }

  Future<void> _handleDeleteGoal(LearningGoalModel goal) async {
    final l10n = context.l10n;
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: l10n.lgDeleteConfirmTitle,
      message: l10n.lgDeleteConfirmMessage,
      confirmText: l10n.commonDelete,
      cancelText: l10n.commonCancel,
      confirmColor: AppColor.danger,
    );
    if (confirmed != true) return;

    final success = await pageModel.deleteGoal(goal.id);

    if (!mounted) return;

    if (success) {
      AppToastService.success(context, l10n.lgToastDeleteSuccess);
    } else {
      AppToastService.error(context, l10n.lgToastDeleteFailed);
    }
  }

  Future<void> _handleUpdateProgress(LearningGoalModel goal) async {
    final l10n = context.l10n;
    final newProgress = await LearningGoalProgressSheet.show(
      context,
      goal: goal,
    );
    if (newProgress == null) return;

    final success = await pageModel.updateGoalProgress(goal.id, newProgress);

    if (!mounted) return;

    if (success) {
      AppToastService.success(context, l10n.lgToastProgressSuccess);
    } else {
      AppToastService.error(context, l10n.lgToastProgressFailed);
    }
  }
}
