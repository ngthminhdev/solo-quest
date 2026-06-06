import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../../../helpers/time_helper.dart';
import '../../../extensions/localization_extension.dart';
import '../constants/onboarding_constants.dart';
import '../models/onboarding_data.dart';

class OnboardingRemindersStep extends StatelessWidget {
  final OnboardingData data;
  final ValueChanged<int> onBreakIntervalChanged;
  final ValueChanged<String> onBreakDurationChanged;
  final ValueChanged<String> onWaterModeChanged;
  final ValueChanged<String> onQuietAfterChanged;

  const OnboardingRemindersStep({
    super.key,
    required this.data,
    required this.onBreakIntervalChanged,
    required this.onBreakDurationChanged,
    required this.onWaterModeChanged,
    required this.onQuietAfterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep6Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.onboardingStep6Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 13,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildBreakQuestSection(context),
        const SizedBox(height: AppSpacing.lg),
        _buildBreakDurationSection(context),
        const SizedBox(height: AppSpacing.lg),
        _buildWaterQuestSection(context),
        const SizedBox(height: AppSpacing.lg),
        _buildQuietAfterSection(context),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.onboardingStep6SystemNote,
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

  Widget _buildBreakQuestSection(BuildContext context) {
    final l10n = context.l10n;
    const breakIntervalOptions = ['60', '90', '120'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep6BreakQuestLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.onboardingStep6BreakQuestDesc,
          style: const TextStyle(fontSize: 12, color: AppColor.fgSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: breakIntervalOptions.map((option) {
            final isSelected = data.breakReminderInterval == int.parse(option);
            return GestureDetector(
              onTap: () => onBreakIntervalChanged(int.parse(option)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.cyanDim : AppColor.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: isSelected ? AppColor.cyan : AppColor.border,
                  ),
                ),
                child: Text(
                  l10n.onboardingStep6BreakIntervalOpt(option),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColor.cyan : AppColor.fgSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBreakDurationSection(BuildContext context) {
    final l10n = context.l10n;
    const breakDurationOptions = ['3', '5', '10'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep6BreakDurationLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: breakDurationOptions.map((option) {
            final isSelected = data.breakDuration == option;
            return GestureDetector(
              onTap: () => onBreakDurationChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.cyanDim : AppColor.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: isSelected ? AppColor.cyan : AppColor.border,
                  ),
                ),
                child: Text(
                  l10n.onboardingStep6DurationOpt(option),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColor.cyan : AppColor.fgSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWaterQuestSection(BuildContext context) {
    final l10n = context.l10n;
    final waterReminderModes = [
      OnboardingStepOption('fixed', l10n.onboardingStep6WaterModeFixed),
      OnboardingStepOption('random', l10n.onboardingStep6WaterModeRandom),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep6WaterQuestLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.onboardingStep6WaterQuestDesc,
          style: const TextStyle(fontSize: 12, color: AppColor.fgSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: waterReminderModes.map((mode) {
            final isSelected = data.waterReminderMode == mode.key;
            return Expanded(
              child: GestureDetector(
                onTap: () => onWaterModeChanged(mode.key),
                child: Container(
                  margin: EdgeInsets.only(
                    right: mode == waterReminderModes.first ? AppSpacing.xs : 0,
                    left: mode == waterReminderModes.last ? AppSpacing.xs : 0,
                  ),
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.cyanDim : AppColor.surface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: isSelected ? AppColor.cyan : AppColor.border,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      mode.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColor.cyan
                            : AppColor.fgSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (data.waterReminderMode == 'random')
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              l10n.onboardingStep6WaterQuestNote,
              style: const TextStyle(fontSize: 11, color: AppColor.fgMuted),
            ),
          ),
      ],
    );
  }

  Widget _buildQuietAfterSection(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep6QuietAfterLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        GestureDetector(
          onTap: () async {
            final picked = await TimeHelper.pickTime(
              context,
              currentTime: data.quietAfterTime.isNotEmpty
                  ? data.quietAfterTime
                  : '22:00',
            );
            if (picked != null) onQuietAfterChanged(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColor.border),
            ),
            child: Row(
              children: [
                const Icon(
                  RemixIcons.time_line,
                  size: 18,
                  color: AppColor.fgMuted,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  TimeHelper.formatOrFallback(
                    data.quietAfterTime.isNotEmpty
                        ? data.quietAfterTime
                        : '22:00',
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColor.fg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.onboardingStep6QuietAfterNote,
          style: const TextStyle(fontSize: 11, color: AppColor.fgMuted),
        ),
      ],
    );
  }
}
