import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../../../helpers/time_helper.dart';
import '../constants/onboarding_constants.dart';
import '../models/onboarding_data.dart';

class OnboardingScheduleStep extends StatelessWidget {
  final OnboardingData data;
  final ValueChanged<String> onWakeUpChanged;
  final ValueChanged<String> onTargetSleepChanged;
  final ValueChanged<String> onFreeTimeStartChanged;
  final ValueChanged<String> onFreeTimeEndChanged;
  final ValueChanged<String> onLearningTimeChanged;
  final ValueChanged<String> onMovementTimeChanged;

  const OnboardingScheduleStep({
    super.key,
    required this.data,
    required this.onWakeUpChanged,
    required this.onTargetSleepChanged,
    required this.onFreeTimeStartChanged,
    required this.onFreeTimeEndChanged,
    required this.onLearningTimeChanged,
    required this.onMovementTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.step5Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          OnboardingConstants.step5Subtitle,
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
          label: OnboardingConstants.wakeUpLabel,
          value: data.wakeUpTime,
          onChanged: onWakeUpChanged,
          defaultTime: '07:00',
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildTimeField(
          context: context,
          label: OnboardingConstants.targetSleepLabel,
          value: data.targetSleepTime,
          onChanged: onTargetSleepChanged,
          defaultTime: '23:00',
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildFreeTimeRangeSection(context),
        const SizedBox(height: AppSpacing.lg),
        _buildChipSection(
          label: OnboardingConstants.learningTimeLabel,
          options: OnboardingConstants.learningTimeOptions,
          selected: data.learningTimePreference,
          onChanged: onLearningTimeChanged,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildChipSection(
          label: OnboardingConstants.movementTimeLabel,
          options: OnboardingConstants.movementTimeOptions,
          selected: data.movementTimePreference,
          onChanged: onMovementTimeChanged,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          OnboardingConstants.step5SystemNote,
          style: const TextStyle(
            fontFamily: 'Exo2',
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
                    fontFamily: 'Exo2',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.freeTimeRangeLabel,
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
                label: OnboardingConstants.fromLabel,
                value: data.freeTimeStart,
                defaultTime: '20:00',
                onChanged: onFreeTimeStartChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildTimePickerField(
                context: context,
                label: OnboardingConstants.toLabel,
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
        Text(
          label,
          style: AppTextStyle.caption.copyWith(fontSize: 12),
        ),
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
                    fontFamily: 'Exo2',
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
    required List<String> options,
    required String selected,
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
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: options.map((option) {
            final isSelected = selected == option;
            return GestureDetector(
              onTap: () => onChanged(option),
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
                  option,
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
}
