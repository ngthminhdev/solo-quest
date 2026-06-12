import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../../../extensions/localization_extension.dart';
import '../models/onboarding_data.dart';

class OnboardingGoalsStep extends StatelessWidget {
  final OnboardingData data;
  final ValueChanged<String> onGoalToggled;

  const OnboardingGoalsStep({
    super.key,
    required this.data,
    required this.onGoalToggled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep4Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.onboardingStep4Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 13,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.onboardingStep4MainGoalsLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ..._buildGoalOptions(context),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.onboardingStep4SystemNote,
          style: TextStyle(
            fontSize: 11,
            color: AppColor.fgMuted,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<Widget> _buildGoalOptions(BuildContext context) {
    final l10n = context.l10n;
    final goals = [
      _GoalOption(
        value: 'health',
        name: l10n.onboardingGoalHealth,
        desc: l10n.onboardingGoalHealthDesc,
        icon: RemixIcons.heart_pulse_line,
        color: AppColor.chipWaterBg,
      ),
      _GoalOption(
        value: 'movement',
        name: l10n.onboardingGoalFitness,
        desc: l10n.onboardingGoalFitnessDesc,
        icon: RemixIcons.run_line,
        color: AppColor.chipMovementBg,
      ),
      _GoalOption(
        value: 'learning',
        name: l10n.onboardingGoalLearning,
        desc: l10n.onboardingGoalLearningDesc,
        icon: RemixIcons.book_open_line,
        color: AppColor.chipLearningBg,
      ),
      _GoalOption(
        value: 'mindfulness',
        name: l10n.onboardingGoalMindfulness,
        desc: l10n.onboardingGoalMindfulnessDesc,
        icon: RemixIcons.heart_line,
        color: AppColor.violetDim,
      ),
      _GoalOption(
        value: 'sleep',
        name: l10n.onboardingGoalSleep,
        desc: l10n.onboardingGoalSleepDesc,
        icon: RemixIcons.moon_line,
        color: AppColor.chipSleepBg,
      ),
      _GoalOption(
        value: 'productivity',
        name: l10n.onboardingGoalFocus,
        desc: l10n.onboardingGoalFocusDesc,
        icon: RemixIcons.focus_2_line,
        color: AppColor.dangerDim,
      ),
      _GoalOption(
        value: 'weight_loss',
        name: l10n.onboardingGoalWeight,
        desc: l10n.onboardingGoalWeightDesc,
        icon: RemixIcons.scales_line,
        color: AppColor.warnDim,
      ),
      _GoalOption(
        value: 'productivity',
        name: l10n.onboardingGoalDiscipline,
        desc: l10n.onboardingGoalDisciplineDesc,
        icon: RemixIcons.shield_check_line,
        color: AppColor.chipMovementBg,
      ),
    ];

    return goals.map((goal) {
      final isSelected = data.mainGoals.contains(goal.value);
      return GestureDetector(
        onTap: () => onGoalToggled(goal.value),
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
                  color: goal.color,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(goal.icon, size: 20, color: AppColor.fgSecondary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColor.cyan : AppColor.fg,
                      ),
                    ),
                    Text(
                      goal.desc,
                      style: TextStyle(
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
                    ? Icon(
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
    }).toList();
  }
}

class _GoalOption {
  final String value;
  final String name;
  final String desc;
  final IconData icon;
  final Color color;

  const _GoalOption({
    required this.value,
    required this.name,
    required this.desc,
    required this.icon,
    required this.color,
  });
}
