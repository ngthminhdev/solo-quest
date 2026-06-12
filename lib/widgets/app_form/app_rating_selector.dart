import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';

class AppRatingSelector extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final ValueChanged<int> onChanged;
  final Color? activeColor;

  const AppRatingSelector({
    super.key,
    required this.label,
    required this.value,
    this.maxValue = 5,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(maxValue, (index) {
            final rating = index + 1;
            final isActive = rating <= value;
            return GestureDetector(
              onTap: () => onChanged(rating),
              child: Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(right: index < maxValue - 1 ? 8 : 0),
                decoration: BoxDecoration(
                  color: isActive
                      ? (activeColor ?? AppColor.cyanDim)
                      : AppColor.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: isActive
                        ? (activeColor ?? AppColor.cyan).withValues(alpha:0.3)
                        : AppColor.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$rating',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? (activeColor ?? AppColor.cyan)
                          : AppColor.fgMuted,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
