import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/learning_goal_model.dart';
import '../../../widgets/app_section_header/app_section_header.dart';
import 'learning_goal_card.dart';
import 'learning_goals_empty_view.dart';

class LearningGoalListSection extends StatelessWidget {
  final List<LearningGoalModel> goals;
  final ValueChanged<LearningGoalModel> onEdit;
  final ValueChanged<LearningGoalModel> onDelete;
  final ValueChanged<LearningGoalModel> onUpdateProgress;

  const LearningGoalListSection({
    super.key,
    required this.goals,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdateProgress,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (goals.isEmpty) {
      return const LearningGoalsEmptyView();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: AppSectionHeader(title: l10n.lgSectionTitle),
        ),
        const SizedBox(height: AppSpacing.s12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          itemCount: goals.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.s10),
          itemBuilder: (context, index) {
            final goal = goals[index];
            return LearningGoalCard(
              goal: goal,
              onEdit: () => onEdit(goal),
              onDelete: () => onDelete(goal),
              onUpdateProgress: () => onUpdateProgress(goal),
            );
          },
        ),
      ],
    );
  }
}
