import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../../../extensions/localization_extension.dart';
import '../models/onboarding_data.dart';

class OnboardingWelcomeStep extends StatelessWidget {
  final OnboardingData data;

  const OnboardingWelcomeStep({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final welcomeSteps = [
      l10n.onboardingWelcomeStep1,
      l10n.onboardingWelcomeStep2,
      l10n.onboardingWelcomeStep3,
      l10n.onboardingWelcomeStep4,
      l10n.onboardingWelcomeStep5,
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, 0.2),
          radius: 0.8,
          colors: [AppColor.cyanGlow, AppColor.bgDeep],
          stops: [0.0, 0.6],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.bgDeep,
                  boxShadow: const [
                    BoxShadow(
                      color: AppColor.cyanGlow,
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: AppColor.violetGlow,
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/icons/app_icon_foreground.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Greeting with user name
              Text(
                l10n.onboardingWelcomeGreeting(data.displayName),
                style: AppTextStyle.h1.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.onboardingWelcomeTitle,
                style: AppTextStyle.h2.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: AppColor.fgSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.onboardingWelcomeSubtitle,
                style: AppTextStyle.body.copyWith(
                  color: AppColor.fgSecondary,
                  fontSize: 13,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              ...welcomeSteps.asMap().entries.map(
                (entry) => _buildStepItem(entry.key + 1, entry.value),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.onboardingWelcomeHint,
                style: AppTextStyle.monoLabel.copyWith(
                  color: AppColor.fgMuted,
                  fontSize: 11,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(int num, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.cyanDim,
            ),
            child: Center(
              child: Text(
                '$num',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColor.cyan,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text, style: AppTextStyle.body.copyWith(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
