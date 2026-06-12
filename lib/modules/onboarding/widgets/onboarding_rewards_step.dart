import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../../../extensions/localization_extension.dart';
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
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboardingStep7Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.onboardingStep7Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 13,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.onboardingStep7RewardsLabel,
          style: AppTextStyle.captionBold.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
            letterSpacing: 0.06,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ..._buildRewardOptions(context),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.onboardingStep7SystemNote,
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

  List<Widget> _buildRewardOptions(BuildContext context) {
    final l10n = context.l10n;
    final rewards = [
      _RewardOption(
        value: 'Chơi game 45 phút',
        name: l10n.onboardingRewardGame,
        desc: l10n.onboardingRewardGameDesc,
        icon: RemixIcons.gamepad_line,
      ),
      _RewardOption(
        value: 'Xem phim 1 tập',
        name: l10n.onboardingRewardMovie,
        desc: l10n.onboardingRewardMovieDesc,
        icon: RemixIcons.movie_line,
      ),
      _RewardOption(
        value: 'Nghỉ ngơi 30 phút',
        name: l10n.onboardingRewardRest,
        desc: l10n.onboardingRewardRestDesc,
        icon: RemixIcons.zzz_line,
      ),
      _RewardOption(
        value: 'Mạng xã hội 20 phút',
        name: l10n.onboardingRewardSocial,
        desc: l10n.onboardingRewardSocialDesc,
        icon: RemixIcons.smartphone_line,
      ),
      _RewardOption(
        value: 'Ăn món yêu thích',
        name: l10n.onboardingRewardFood,
        desc: l10n.onboardingRewardFoodDesc,
        icon: RemixIcons.restaurant_line,
      ),
      _RewardOption(
        value: 'Tự tạo reward',
        name: l10n.onboardingRewardCustom,
        desc: l10n.onboardingRewardCustomDesc,
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
