import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../constants/onboarding_constants.dart';
import '../models/onboarding_data.dart';

class OnboardingWelcomeStep extends StatelessWidget {
  final OnboardingData data;

  const OnboardingWelcomeStep({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, 0.2),
          radius: 0.8,
          colors: [
            AppColor.cyanGlow,
            AppColor.bgDeep,
          ],
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
                  gradient: AppColor.levelGradient,
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
                child: const Icon(
                  RemixIcons.star_line,
                  size: 32,
                  color: AppColor.bgDeep,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                OnboardingConstants.step0Title,
                style: AppTextStyle.h1.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                OnboardingConstants.step0Subtitle,
                style: AppTextStyle.body.copyWith(
                  color: AppColor.fgSecondary,
                  fontSize: 13,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              ...OnboardingConstants.step0Steps.asMap().entries.map(
                    (entry) => _buildStepItem(entry.key + 1, entry.value),
                  ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                OnboardingConstants.step0Hint,
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
                style: const TextStyle(
                  fontFamily: 'Exo2',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColor.cyan,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.body.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
