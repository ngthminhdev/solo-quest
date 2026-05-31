import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../constants/onboarding_constants.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.step4Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          OnboardingConstants.step4Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 13,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          OnboardingConstants.mainGoalsLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ..._buildGoalOptions(),
        const SizedBox(height: AppSpacing.xl),
        Text(
          OnboardingConstants.step4SystemNote,
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

  List<Widget> _buildGoalOptions() {
    final goals = [
      _GoalOption(
        value: 'Uống Nước',
        name: 'Uống Nước',
        desc: 'Xây dựng thói quen uống nước đều đặn',
        icon: RemixIcons.drop_line,
        color: AppColor.chipWaterBg,
      ),
      _GoalOption(
        value: 'Vận Động',
        name: 'Vận Động',
        desc: 'Vận động và tập thể dục hàng ngày',
        icon: RemixIcons.run_line,
        color: AppColor.chipMovementBg,
      ),
      _GoalOption(
        value: 'Học Tập',
        name: 'Học Tập',
        desc: 'Dành thời gian học và xây dựng kỹ năng',
        icon: RemixIcons.book_open_line,
        color: AppColor.chipLearningBg,
      ),
      _GoalOption(
        value: 'Chánh Niệm',
        name: 'Chánh Niệm',
        desc: 'Thiền và quản lý căng thẳng',
        icon: RemixIcons.heart_line,
        color: AppColor.violetDim,
      ),
      _GoalOption(
        value: 'Ngủ Tốt Hơn',
        name: 'Ngủ Tốt Hơn',
        desc: 'Thói quen ngủ tốt hơn',
        icon: RemixIcons.moon_line,
        color: AppColor.chipSleepBg,
      ),
      _GoalOption(
        value: 'Tập Trung Tốt Hơn',
        name: 'Tập Trung Tốt Hơn',
        desc: 'Giảm phân tâm, tăng hiệu suất',
        icon: RemixIcons.focus_2_line,
        color: AppColor.dangerDim,
      ),
      _GoalOption(
        value: 'Giảm Cân',
        name: 'Giảm Cân',
        desc: 'Kiểm soát cân nặng lành mạnh',
        icon: RemixIcons.scales_line,
        color: AppColor.warnDim,
      ),
      _GoalOption(
        value: 'Kỷ Luật Hơn',
        name: 'Kỷ Luật Hơn',
        desc: 'Xây dựng thói quen và nề nếp',
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
