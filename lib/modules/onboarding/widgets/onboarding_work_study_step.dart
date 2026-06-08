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

class OnboardingWorkStudyStep extends StatelessWidget {
  final OnboardingData data;
  final ValueChanged<String> onMainActivityChanged;
  final ValueChanged<String> onWorkScheduleChanged;
  final ValueChanged<String> onWorkStartTimeChanged;
  final ValueChanged<String> onWorkEndTimeChanged;
  final ValueChanged<String> onFreeTimeToggled;

  const OnboardingWorkStudyStep({
    super.key,
    required this.data,
    required this.onMainActivityChanged,
    required this.onWorkScheduleChanged,
    required this.onWorkStartTimeChanged,
    required this.onWorkEndTimeChanged,
    required this.onFreeTimeToggled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep2Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.onboardingStep2Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 13,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildMainActivitySection(context),
        const SizedBox(height: AppSpacing.lg),
        _buildWorkScheduleSection(context),
        const SizedBox(height: AppSpacing.lg),
        _buildFreeTimeSection(context),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.onboardingStep2SystemNote,
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

  Widget _buildMainActivitySection(BuildContext context) {
    final l10n = context.l10n;
    final mainActivityOptions = [
      OnboardingStepOption('software_engineer', l10n.onboardingStep2ActivityDeveloper),
      OnboardingStepOption('student', l10n.onboardingStep2ActivityStudent),
      OnboardingStepOption('office_worker', l10n.onboardingStep2ActivityOffice),
      OnboardingStepOption('freelancer', l10n.onboardingStep2ActivityFreelancer),
      OnboardingStepOption('other', l10n.onboardingStep2ActivityOther),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep2MainActivityLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...mainActivityOptions.map((option) {
          final isSelected = data.mainActivity == option.key;
          return GestureDetector(
            onTap: () => onMainActivityChanged(option.key),
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
                          option.label,
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
                          isSelected ? AppColor.cyan : AppColor.transparent,
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
    final l10n = context.l10n;
    final workScheduleOptions = [
      OnboardingStepOption('weekdays', l10n.onboardingStep2ScheduleWeekday),
      OnboardingStepOption('monday_to_saturday', l10n.onboardingStep2ScheduleMonSat),
      OnboardingStepOption('full_week', l10n.onboardingStep2ScheduleFullWeek),
      OnboardingStepOption('flexible', l10n.onboardingStep2ScheduleFlexible),
      OnboardingStepOption('night_shift', l10n.onboardingStep2ScheduleNight),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep2WorkScheduleLabel,
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
                label: l10n.onboardingStep2WorkStartTimeLabel,
                value: data.workStartTime,
                onChanged: onWorkStartTimeChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildTimeField(
                context: context,
                label: l10n.onboardingStep2WorkEndTimeLabel,
                value: data.workEndTime,
                onChanged: onWorkEndTimeChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        OnboardingChipSelector(
          options: workScheduleOptions,
          selected: data.workScheduleType,
          onChanged: onWorkScheduleChanged,
          layoutMode: ChipLayoutMode.wrap,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.onboardingStep2ScheduleHelper,
          style: AppTextStyle.caption.copyWith(
            color: AppColor.fgMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildFreeTimeSection(BuildContext context) {
    final l10n = context.l10n;
    final freeTimeOptions = [
      OnboardingStepOption('early_morning', l10n.onboardingStep2FreeTimeEarlyMorning),
      OnboardingStepOption('lunch', l10n.onboardingStep2FreeTimeNoon),
      OnboardingStepOption('after_work', l10n.onboardingStep2FreeTimeAfterWork),
      OnboardingStepOption('evening', l10n.onboardingStep2FreeTimeEvening),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep2FreeTimeLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        OnboardingChipSelector(
          options: freeTimeOptions,
          selected: data.preferredFreeTimes,
          onChanged: onFreeTimeToggled,
          layoutMode: ChipLayoutMode.equalWidthGrid,
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
