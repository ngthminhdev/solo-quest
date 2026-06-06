import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../../../extensions/localization_extension.dart';
import '../constants/onboarding_constants.dart';
import '../models/onboarding_data.dart';
import 'onboarding_chip_selector.dart';

class OnboardingHealthActivityStep extends StatelessWidget {
  final OnboardingData data;
  final ValueChanged<String> onActivityLevelChanged;
  final ValueChanged<String> onLastWorkoutChanged;
  final ValueChanged<String> onLimitationToggled;

  const OnboardingHealthActivityStep({
    super.key,
    required this.data,
    required this.onActivityLevelChanged,
    required this.onLastWorkoutChanged,
    required this.onLimitationToggled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep3Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.onboardingStep3Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 13,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildActivityLevelSection(context),
        const SizedBox(height: AppSpacing.lg),
        _buildLastWorkoutSection(context),
        const SizedBox(height: AppSpacing.lg),
        _buildLimitationsSection(context),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.onboardingStep3SystemNote,
          style: const TextStyle(
            fontSize: 11,
            color: AppColor.fgMuted,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActivityLevelSection(BuildContext context) {
    final l10n = context.l10n;
    final options = [
      _ActivityOption(
        value: 'very_little',
        name: l10n.onboardingStep3ActivityLevelLittle,
        desc: l10n.onboardingStep3ActivityLevelLittleDesc,
        icon: RemixIcons.rest_time_line,
      ),
      _ActivityOption(
        value: 'occasional',
        name: l10n.onboardingStep3ActivityLevelOccasional,
        desc: l10n.onboardingStep3ActivityLevelOccasionalDesc,
        icon: RemixIcons.walk_line,
      ),
      _ActivityOption(
        value: 'regular',
        name: l10n.onboardingStep3ActivityLevelRegular,
        desc: l10n.onboardingStep3ActivityLevelRegularDesc,
        icon: RemixIcons.run_line,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep3ActivityLevelLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...options.map((opt) {
          final isSelected = data.activityLevel == opt.value;
          return GestureDetector(
            onTap: () => onActivityLevelChanged(opt.value),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.xs),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.cyanDim : AppColor.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isSelected ? AppColor.cyan : AppColor.border,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColor.surfaceHover,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(
                      opt.icon,
                      size: 20,
                      color: AppColor.fgSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opt.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColor.cyan : AppColor.fg,
                          ),
                        ),
                        Text(
                          opt.desc,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.fgSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColor.cyan : AppColor.transparent,
                      border: Border.all(
                        color: isSelected ? AppColor.cyan : AppColor.border,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            RemixIcons.check_line,
                            size: 14,
                            color: AppColor.bgDeep,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLastWorkoutSection(BuildContext context) {
    final l10n = context.l10n;
    final lastWorkoutOptions = [
      OnboardingStepOption('today', l10n.onboardingStep3LastWorkoutToday),
      OnboardingStepOption('this_week', l10n.onboardingStep3LastWorkoutWeek),
      OnboardingStepOption('longer_ago', l10n.onboardingStep3LastWorkoutLonger),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep3LastWorkoutLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        OnboardingChipSelector(
          options: lastWorkoutOptions,
          selected: data.lastWorkout,
          onChanged: onLastWorkoutChanged,
          layoutMode: ChipLayoutMode.equalWidthRow,
        ),
      ],
    );
  }

  Widget _buildLimitationsSection(BuildContext context) {
    final l10n = context.l10n;
    final limitationOptions = [
      OnboardingStepOption('back_pain', l10n.onboardingStep3LimitationBackPain),
      OnboardingStepOption(
        'eye_strain',
        l10n.onboardingStep3LimitationEyeStrain,
      ),
      OnboardingStepOption(
        'low_energy',
        l10n.onboardingStep3LimitationLowEnergy,
      ),
      OnboardingStepOption('busy', l10n.onboardingStep3LimitationBusy),
      OnboardingStepOption('none', l10n.onboardingStep3LimitationNone),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep3HealthLimitationsLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        OnboardingChipSelector(
          options: limitationOptions,
          selected: data.healthLimitations,
          onChanged: onLimitationToggled,
          layoutMode: ChipLayoutMode.wrap,
        ),
      ],
    );
  }
}

class _ActivityOption {
  final String value;
  final String name;
  final String desc;
  final IconData icon;

  const _ActivityOption({
    required this.value,
    required this.name,
    required this.desc,
    required this.icon,
  });
}
