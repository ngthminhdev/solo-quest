import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../../../helpers/time_helper.dart';
import '../constants/onboarding_constants.dart';
import '../models/onboarding_data.dart';

class OnboardingWorkStudyStep extends StatelessWidget {
  final OnboardingData data;
  final ValueChanged<String> onMainActivityChanged;
  final ValueChanged<String> onWorkScheduleChanged;
  final ValueChanged<String> onWorkStartTimeChanged;
  final ValueChanged<String> onWorkEndTimeChanged;
  final ValueChanged<String> onFreeTimeChanged;

  const OnboardingWorkStudyStep({
    super.key,
    required this.data,
    required this.onMainActivityChanged,
    required this.onWorkScheduleChanged,
    required this.onWorkStartTimeChanged,
    required this.onWorkEndTimeChanged,
    required this.onFreeTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.step2Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          OnboardingConstants.step2Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 13,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildMainActivitySection(),
        const SizedBox(height: AppSpacing.lg),
        _buildWorkScheduleSection(context),
        const SizedBox(height: AppSpacing.lg),
        _buildFreeTimeSection(),
        const SizedBox(height: AppSpacing.xl),
        Text(
          OnboardingConstants.step2SystemNote,
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

  Widget _buildMainActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.mainActivityLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...OnboardingConstants.mainActivityOptions.map((option) {
          final isSelected = data.mainActivity == option;
          return GestureDetector(
            onTap: () => onMainActivityChanged(option),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                isSelected ? AppColor.cyan : AppColor.fg,
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
                      color:
                          isSelected ? AppColor.cyan : Colors.transparent,
                      border: Border.all(
                        color:
                            isSelected ? AppColor.cyan : AppColor.border,
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

  Widget _buildWorkScheduleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.workScheduleLabel,
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
              child: _buildTimeField(
                context: context,
                label: OnboardingConstants.workStartTimeLabel,
                value: data.workStartTime,
                onChanged: onWorkStartTimeChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildTimeField(
                context: context,
                label: OnboardingConstants.workEndTimeLabel,
                value: data.workEndTime,
                onChanged: onWorkEndTimeChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: OnboardingConstants.workScheduleOptions.map((option) {
            final isSelected = data.workScheduleType == option;
            return GestureDetector(
              onTap: () => onWorkScheduleChanged(option),
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

  Widget _buildFreeTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.freeTimeLabel,
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
          children: OnboardingConstants.freeTimeOptions.map((option) {
            final isSelected = data.freeTimePreference == option;
            return GestureDetector(
              onTap: () => onFreeTimeChanged(option),
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

  Widget _buildTimeField({
    required BuildContext context,
    required String label,
    required String value,
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
              currentTime: value.isNotEmpty ? value : '08:00',
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
                    value.isNotEmpty ? value : '08:00',
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
}
