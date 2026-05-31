import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';

class OnboardingProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double progress;

  const OnboardingProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Row(
        children: List.generate(totalSteps, (index) {
          Color barColor;
          if (index < currentStep) {
            barColor = AppColor.fgMuted;
          } else if (index == currentStep) {
            barColor = AppColor.cyan;
          } else {
            barColor = AppColor.surface;
          }
          return Expanded(
            child: Container(
              height: 3,
              margin: EdgeInsets.only(
                right: index < totalSteps - 1 ? 4 : 0,
              ),
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
