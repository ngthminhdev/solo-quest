import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../constants/daily_review_constants.dart';

class DailyReviewDifficultyCard extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onChanged;

  const DailyReviewDifficultyCard({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            DailyReviewConstants.sectionDifficulty,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              color: AppColor.fgMuted,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Row(
            children: [
              _DiffOption(
                value: 'light',
                label: DailyReviewConstants.diffLight,
                icon: RemixIcons.plant_line,
                isSelected: selected == 'light',
                onTap: () => onChanged('light'),
              ),
              const SizedBox(width: AppSpacing.s8),
              _DiffOption(
                value: 'fit',
                label: DailyReviewConstants.diffFit,
                icon: RemixIcons.checkbox_circle_line,
                isSelected: selected == 'fit',
                onTap: () => onChanged('fit'),
              ),
              const SizedBox(width: AppSpacing.s8),
              _DiffOption(
                value: 'heavy',
                label: DailyReviewConstants.diffHeavy,
                icon: RemixIcons.boxing_line,
                isSelected: selected == 'heavy',
                onTap: () => onChanged('heavy'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiffOption extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DiffOption({
    required this.value,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s12,
            horizontal: AppSpacing.s8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.cyanDim : AppColor.surface,
            border: Border.all(
              color: isSelected ? AppColor.cyan : AppColor.border,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColor.cyan : AppColor.fgMuted,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColor.cyan : AppColor.fgSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
