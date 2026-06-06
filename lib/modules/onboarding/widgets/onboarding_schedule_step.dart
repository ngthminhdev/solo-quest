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
import 'onboarding_chip_selector.dart';

class OnboardingScheduleStep extends StatelessWidget {
  final OnboardingData data;
  final ValueChanged<String> onWakeUpChanged;
  final ValueChanged<String> onTargetSleepChanged;
  final ValueChanged<String> onFreeTimeStartChanged;
  final ValueChanged<String> onFreeTimeEndChanged;
  final ValueChanged<String> onLearningTimeToggled;
  final ValueChanged<String> onMovementTimeToggled;

  const OnboardingScheduleStep({
    super.key,
    required this.data,
    required this.onWakeUpChanged,
    required this.onTargetSleepChanged,
    required this.onFreeTimeStartChanged,
    required this.onFreeTimeEndChanged,
    required this.onLearningTimeToggled,
    required this.onMovementTimeToggled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final learningTimeOptions = [
      OnboardingStepOption('morning', l10n.onboardingTimeEarlyMorning),
      OnboardingStepOption('lunch', l10n.onboardingTimeNoon),
      OnboardingStepOption('evening', l10n.onboardingTimeEveningGeneral),
    ];

    final movementTimeOptions = [
      OnboardingStepOption('morning', l10n.onboardingTimeEarlyMorning),
      OnboardingStepOption('lunch', l10n.onboardingTimeNoon),
      OnboardingStepOption('evening', l10n.onboardingTimeEveningGeneral),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep5Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.onboardingStep5Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 13,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildTimeField(
          context: context,
          label: l10n.onboardingStep5WakeUpLabel,
          value: data.wakeUpTime,
          onChanged: onWakeUpChanged,
          defaultTime: '07:00',
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildTimeField(
          context: context,
          label: l10n.onboardingStep5TargetSleepLabel,
          value: data.targetSleepTime,
          onChanged: onTargetSleepChanged,
          defaultTime: '23:00',
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFreeTimeRangeSection(context),
        const SizedBox(height: AppSpacing.lg),
        _buildChipSection(
          label: l10n.onboardingStep5LearningTimeLabel,
          options: learningTimeOptions,
          selected: data.learningTimePreferences,
          onChanged: onLearningTimeToggled,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildChipSection(
          label: l10n.onboardingStep5MovementTimeLabel,
          options: movementTimeOptions,
          selected: data.movementTimePreferences,
          onChanged: onMovementTimeToggled,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.onboardingStep5SystemNote,
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

  Widget _buildTimeField({
    required BuildContext context,
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    required String defaultTime,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
              currentTime: value.isNotEmpty ? value : defaultTime,
            );
            if (picked != null) onChanged(picked);
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
                    value.isNotEmpty ? value : defaultTime,
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
      ],
    );
  }

  Widget _buildFreeTimeRangeSection(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep5FreeTimeRangeLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildTimePickerField(
                context: context,
                label: l10n.onboardingStep5FromLabel,
                value: data.freeTimeStart,
                defaultTime: '20:00',
                onChanged: onFreeTimeStartChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildTimePickerField(
                context: context,
                label: l10n.onboardingStep5ToLabel,
                value: data.freeTimeEnd,
                defaultTime: '22:00',
                onChanged: onFreeTimeEndChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimePickerField({
    required BuildContext context,
    required String label,
    required String value,
    required String defaultTime,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.caption.copyWith(fontSize: 12)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final picked = await TimeHelper.pickTime(
              context,
              currentTime: value.isNotEmpty ? value : defaultTime,
            );
            if (picked != null) onChanged(picked);
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
                    value.isNotEmpty ? value : defaultTime,
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
      ],
    );
  }

  Widget _buildChipSection({
    required String label,
    required List<OnboardingStepOption> options,
    required List<String> selected,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        OnboardingChipSelector(
          options: options,
          selected: selected,
          onChanged: onChanged,
          layoutMode: ChipLayoutMode.equalWidthRow,
        ),
      ],
    );
  }
}
