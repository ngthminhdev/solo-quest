import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../constants/onboarding_constants.dart';
import '../models/onboarding_data.dart';

class OnboardingRewardsStep extends StatelessWidget {
  final OnboardingData data;
  final ValueChanged<String> onRewardToggled;

  const OnboardingRewardsStep({
    super.key,
    required this.data,
    required this.onRewardToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingConstants.step7Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          OnboardingConstants.step7Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 13,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          OnboardingConstants.rewardsLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ..._buildRewardOptions(),
        const SizedBox(height: AppSpacing.xl),
        Text(
          OnboardingConstants.step7SystemNote,
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

  List<Widget> _buildRewardOptions() {
    final rewards = [
      _RewardOption(
        value: 'Chơi game 45 phút',
        name: 'Chơi game 45 phút',
        desc: 'Mở khóa thời gian chơi game',
        icon: RemixIcons.gamepad_line,
      ),
      _RewardOption(
        value: 'Xem phim 1 tập',
        name: 'Xem phim 1 tập',
        desc: 'Mở khóa thời gian giải trí',
        icon: RemixIcons.movie_line,
      ),
      _RewardOption(
        value: 'Nghỉ ngơi 30 phút',
        name: 'Nghỉ ngơi 30 phút',
        desc: 'Thời gian thư giãn không làm gì',
        icon: RemixIcons.zzz_line,
      ),
      _RewardOption(
        value: 'Mạng xã hội 20 phút',
        name: 'Mạng xã hội 20 phút',
        desc: 'Mở khóa thời gian lướt MXH',
        icon: RemixIcons.smartphone_line,
      ),
      _RewardOption(
        value: 'Ăn món yêu thích',
        name: 'Ăn món yêu thích',
        desc: 'Tự thưởng một bữa ngon',
        icon: RemixIcons.restaurant_line,
      ),
      _RewardOption(
        value: 'Tự tạo reward',
        name: 'Tự tạo reward',
        desc: 'Tùy chỉnh phần thưởng riêng',
        icon: RemixIcons.edit_line,
      ),
    ];

    return rewards.map((reward) {
      final isSelected = data.preferredRewards.contains(reward.value);
      return GestureDetector(
        onTap: () => onRewardToggled(reward.value),
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
                child:
                    Icon(reward.icon, size: 20, color: AppColor.fgSecondary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColor.cyan : AppColor.fg,
                      ),
                    ),
                    Text(
                      reward.desc,
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

class _RewardOption {
  final String value;
  final String name;
  final String desc;
  final IconData icon;

  const _RewardOption({
    required this.value,
    required this.name,
    required this.desc,
    required this.icon,
  });
}
