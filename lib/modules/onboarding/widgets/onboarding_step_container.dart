import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';

class OnboardingStepContainer extends StatelessWidget {
  final Widget child;

  const OnboardingStepContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: child,
    );
  }
}
