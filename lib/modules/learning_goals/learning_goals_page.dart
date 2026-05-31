import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import '../../models/learning_goal_model.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../../widgets/app_dialog/app_confirm_dialog.dart';
import 'learning_goals_page_model.dart';
import 'widgets/learning_goal_summary_card.dart';
import 'widgets/learning_goal_category_selector.dart';
import 'widgets/learning_goal_list_section.dart';
import 'widgets/learning_goal_form_sheet.dart';
import 'widgets/learning_goal_progress_sheet.dart';
import 'constants/learning_goals_constants.dart';

class LearningGoalsPage
    extends BasePage<LearningGoalsPageModel, LearningGoalsPageState> {
  LearningGoalsPage({super.key})
      : super(provider: learningGoalsPageProvider);

  @override
  ConsumerState<LearningGoalsPage> createState() => _LearningGoalsPageState();
}

class _LearningGoalsPageState extends BasePageConsumerState<LearningGoalsPage,
    LearningGoalsPageModel, LearningGoalsPageState> {
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

    if (state.loadState == AppLoadState.loading && !state.hasGoals) {
      return Scaffold(
        backgroundColor: AppColor.bg,
        appBar: _buildAppBar(),
        body: const AppLoading(message: 'Đang tải mục tiêu học tập...'),
      );
    }

    if (state.loadState == AppLoadState.error && !state.hasGoals) {
      return Scaffold(
        backgroundColor: AppColor.bg,
        appBar: _buildAppBar(),
        body: AppErrorState(
          message: state.errorMessage ?? 'Không thể tải mục tiêu học tập',
          onRetry: pageModel.loadGoals,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: AppColor.cyan,
        backgroundColor: AppColor.bgRaised,
        onRefresh: pageModel.refreshGoals,
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
                  LearningGoalsConstants.pageSubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.fgMuted,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.s16),

              // Summary card
              if (state.hasGoals)
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

              // Category filter
              if (state.categories.isNotEmpty)
                LearningGoalCategorySelector(
                  categories: state.categories,
                  selectedCategory: state.selectedCategory,
                  onChanged: pageModel.selectCategory,
                ),

              const SizedBox(height: AppSpacing.s16),

              // Goal list
              LearningGoalListSection(
                goals: state.filteredGoals,
                onEdit: _handleEditGoal,
                onDelete: _handleDeleteGoal,
                onUpdateProgress: _handleUpdateProgress,
              ),

              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleAddGoal,
        backgroundColor: AppColor.cyan,
        foregroundColor: AppColor.bgDeep,
        icon: const Icon(Icons.add),
        label: Text(
          LearningGoalsConstants.addGoalButton,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.bgRaised,
      elevation: 0,
      title: Text(
        LearningGoalsConstants.pageTitle,
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
    );
  }

  Future<void> _handleAddGoal() async {
    final result = await LearningGoalFormSheet.show(context);

    if (result != null && mounted) {
      final goal = LearningGoalModel(
        id: '',
        title: result.title,
        description: result.description,
        category: result.category,
        targetMinutesPerDay: result.targetMinutesPerDay,
        deadline: result.deadline,
        progress: 0.0,
        isActive: result.isActive,
      );

      final success = await pageModel.addGoal(goal);

      if (mounted) {
        if (success) {
          AppToastService.success(
            context,
            LearningGoalsConstants.toastAddSuccess,
          );
        } else {
          AppToastService.error(
            context,
            LearningGoalsConstants.toastAddFailed,
          );
        }
      }
    }
  }

  Future<void> _handleEditGoal(LearningGoalModel goal) async {
    final result = await LearningGoalFormSheet.show(
      context,
      initialGoal: goal,
    );

    if (result != null && mounted) {
      final updatedGoal = goal.copyWith(
        title: result.title,
        description: result.description,
        category: result.category,
        targetMinutesPerDay: result.targetMinutesPerDay,
        deadline: result.deadline,
        isActive: result.isActive,
      );

      final success = await pageModel.updateGoal(updatedGoal);

      if (mounted) {
        if (success) {
          AppToastService.success(
            context,
            LearningGoalsConstants.toastUpdateSuccess,
          );
        } else {
          AppToastService.error(
            context,
            LearningGoalsConstants.toastUpdateFailed,
          );
        }
      }
    }
  }

  Future<void> _handleDeleteGoal(LearningGoalModel goal) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: LearningGoalsConstants.deleteConfirmTitle,
      message: LearningGoalsConstants.deleteConfirmMessage,
    );

    if (confirmed == true && mounted) {
      final success = await pageModel.deleteGoal(goal.id);

      if (mounted) {
        if (success) {
          AppToastService.success(
            context,
            LearningGoalsConstants.toastDeleteSuccess,
          );
        } else {
          AppToastService.error(
            context,
            LearningGoalsConstants.toastDeleteFailed,
          );
        }
      }
    }
  }

  Future<void> _handleUpdateProgress(LearningGoalModel goal) async {
    final progress = await LearningGoalProgressSheet.show(
      context,
      goal: goal,
    );

    if (progress != null && mounted) {
      final success = await pageModel.updateGoalProgress(goal.id, progress);

      if (mounted) {
        if (success) {
          AppToastService.success(
            context,
            LearningGoalsConstants.toastProgressSuccess,
          );
        } else {
          AppToastService.error(
            context,
            LearningGoalsConstants.toastProgressFailed,
          );
        }
      }
    }
  }
}
