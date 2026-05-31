import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../constants/onboarding_constants.dart';
import '../models/onboarding_data.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.step3Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          OnboardingConstants.step3Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 13,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildActivityLevelSection(),
        const SizedBox(height: AppSpacing.lg),
        _buildLastWorkoutSection(),
        const SizedBox(height: AppSpacing.lg),
        _buildLimitationsSection(),
        const SizedBox(height: AppSpacing.xl),
        Text(
          OnboardingConstants.step3SystemNote,
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

  Widget _buildActivityLevelSection() {
    final options = [
      _ActivityOption(
        value: 'Rất ít',
        name: 'Rất ít',
        desc: 'Hầu như không vận động, ngồi nhiều',
        icon: RemixIcons.rest_time_line,
      ),
      _ActivityOption(
        value: 'Thỉnh thoảng',
        name: 'Thỉnh thoảng',
        desc: 'Đi bộ nhẹ, vận động 1–2 lần/tuần',
        icon: RemixIcons.walk_line,
      ),
      _ActivityOption(
        value: 'Đều đặn',
        name: 'Đều đặn',
        desc: 'Tập luyện 3–5 lần/tuần',
        icon: RemixIcons.run_line,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.activityLevelLabel,
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
                    child: Icon(opt.icon, size: 20, color: AppColor.fgSecondary),
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
                      color: isSelected ? AppColor.cyan : Colors.transparent,
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

  Widget _buildLastWorkoutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.lastWorkoutLabel,
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
          children: OnboardingConstants.lastWorkoutOptions.map((option) {
            final isSelected = data.lastWorkout == option;
            return GestureDetector(
              onTap: () => onLastWorkoutChanged(option),
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

  Widget _buildLimitationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.healthLimitationsLabel,
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
          children: OnboardingConstants.healthLimitationOptions.map((option) {
            final isSelected = data.healthLimitations.contains(option);
            return GestureDetector(
              onTap: () => onLimitationToggled(option),
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
