import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';

class DailyReviewChipSelectorCard extends StatelessWidget {
  final String title;
  final List<String> options;
  final List<String> selected;
  final ValueChanged<String> onToggle;

  const DailyReviewChipSelectorCard({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              color: AppColor.fgMuted,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: options.map((option) {
              final isSelected = selected.contains(option);
              return GestureDetector(
                onTap: () => onToggle(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s14,
                    vertical: AppSpacing.s8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.violetDim : AppColor.surface,
                    border: Border.all(
                      color: isSelected ? AppColor.violet : AppColor.border,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColor.violet : AppColor.fgSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
