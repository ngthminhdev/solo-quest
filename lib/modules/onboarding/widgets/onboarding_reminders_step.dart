import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../../../helpers/time_helper.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.step6Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          OnboardingConstants.step6Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 13,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildBreakQuestSection(),
        const SizedBox(height: AppSpacing.lg),
        _buildBreakDurationSection(),
        const SizedBox(height: AppSpacing.lg),
        _buildWaterQuestSection(),
        const SizedBox(height: AppSpacing.lg),
        _buildQuietAfterSection(context),
        const SizedBox(height: AppSpacing.xl),
        Text(
          OnboardingConstants.step6SystemNote,
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

  Widget _buildBreakQuestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.breakQuestLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          OnboardingConstants.breakQuestDesc,
          style: const TextStyle(
            fontSize: 12,
            color: AppColor.fgSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: OnboardingConstants.breakIntervalOptions.map((option) {
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
                  'Mỗi $option phút',
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

  Widget _buildBreakDurationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.breakDurationLabel,
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
          children: OnboardingConstants.breakDurationOptions.map((option) {
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
                  '$option phút',
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

  Widget _buildWaterQuestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.waterQuestLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          OnboardingConstants.waterQuestDesc,
          style: const TextStyle(
            fontSize: 12,
            color: AppColor.fgSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: OnboardingConstants.waterReminderModes.map((mode) {
            final isSelected = data.waterReminderMode == mode;
            return Expanded(
              child: GestureDetector(
                onTap: () => onWaterModeChanged(mode),
                child: Container(
                  margin: EdgeInsets.only(
                    right: mode == OnboardingConstants.waterReminderModes.first
                        ? AppSpacing.xs
                        : 0,
                    left: mode == OnboardingConstants.waterReminderModes.last
                        ? AppSpacing.xs
                        : 0,
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
                      mode,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColor.cyan : AppColor.fgSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (data.waterReminderMode == 'Ngẫu nhiên')
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              OnboardingConstants.waterQuestNote,
              style: const TextStyle(
                fontSize: 11,
                color: AppColor.fgMuted,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuietAfterSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.quietAfterLabel,
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
                    fontFamily: 'Exo2',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          OnboardingConstants.quietAfterNote,
          style: const TextStyle(
            fontSize: 11,
            color: AppColor.fgMuted,
          ),
        ),
      ],
    );
  }
}
