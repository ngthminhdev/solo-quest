import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../constants/learning_goals_constants.dart';

class LearningGoalCategorySelector extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const LearningGoalCategorySelector({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Row(
        children: [
          _CategoryChip(
            label: LearningGoalsConstants.filterAll,
            isSelected: selectedCategory == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: AppSpacing.s8),
          ...categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.s8),
              child: _CategoryChip(
                label: category,
                isSelected: selectedCategory == category,
                onTap: () => onChanged(category),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.cyanDim : AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: isSelected ? AppColor.cyan : AppColor.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColor.cyan : AppColor.fgMuted,
          ),
        ),
      ),
    );
  }
}
