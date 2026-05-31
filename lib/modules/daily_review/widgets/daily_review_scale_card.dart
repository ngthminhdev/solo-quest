import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';

class DailyReviewScaleCard extends StatelessWidget {
  final String title;
  final int? selectedValue;
  final ValueChanged<int> onChanged;
  final String minLabel;
  final String maxLabel;
  final Color selectedColor;

  const DailyReviewScaleCard({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.onChanged,
    required this.minLabel,
    required this.maxLabel,
    this.selectedColor = AppColor.cyan,
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
          Row(
            children: List.generate(5, (index) {
              final value = index + 1;
              final isSelected = selectedValue == value;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(value),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index < 4 ? AppSpacing.s6 : 0,
                    ),
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? selectedColor.withAlpha(40)
                          : AppColor.surface,
                      border: Border.all(
                        color: isSelected ? selectedColor : AppColor.border,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$value',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? selectedColor : AppColor.fgMuted,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minLabel,
                style: const TextStyle(fontSize: 11, color: AppColor.fgMuted),
              ),
              Text(
                maxLabel,
                style: const TextStyle(fontSize: 11, color: AppColor.fgMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
