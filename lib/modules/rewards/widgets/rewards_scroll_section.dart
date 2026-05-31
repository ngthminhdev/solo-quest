import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/reward_model.dart';
import '../../../models/enums/reward_enums.dart';

class RewardsScrollSection extends StatelessWidget {
  final List<RewardModel> rewards;
  final int availablePoints;
  final ValueChanged<RewardModel> onClaim;

  const RewardsScrollSection({
    super.key,
    required this.rewards,
    required this.availablePoints,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            0,
            AppSpacing.s16,
            AppSpacing.s8,
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColor.expGold,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.s6),
              const Text(
                'PHẦN THƯỞNG',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: AppColor.fgMuted,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            itemCount: rewards.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s10),
            itemBuilder: (context, index) {
              final reward = rewards[index];
              final canAfford = availablePoints >= reward.costPoints;
              final isAvailable = reward.status == RewardStatus.available;

              return _RewardCard(
                reward: reward,
                canAfford: canAfford,
                isAvailable: isAvailable,
                onClaim: () => onClaim(reward),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  final RewardModel reward;
  final bool canAfford;
  final bool isAvailable;
  final VoidCallback onClaim;

  const _RewardCard({
    required this.reward,
    required this.canAfford,
    required this.isAvailable,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final canRedeem = isAvailable && canAfford;

    return Container(
      width: 155,
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _iconBg,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Center(
              child: Text(
                reward.iconText,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s10),

          // Name
          Text(
            reward.title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColor.fg,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),

          // Cost
          Text(
            '${reward.costPoints} pts',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColor.expGold,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),

          // Button
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: canRedeem ? onClaim : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: canRedeem
                      ? AppColor.expGold
                      : AppColor.surfaceActive,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  _buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: canRedeem
                        ? AppColor.bgDeep
                        : AppColor.fgMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color get _iconBg {
    if (reward.type == RewardType.rest) return AppColor.successDim;
    if (reward.type == RewardType.entertainment) return AppColor.infoDim;
    if (reward.type == RewardType.food) return AppColor.warnDim;
    if (reward.type == RewardType.shopping) return AppColor.dangerDim;
    return AppColor.violetDim;
  }

  String get _buttonText {
    if (reward.status == RewardStatus.claimed) return 'Đã đổi';
    if (!isAvailable) return 'Khóa';
    if (!canAfford) return 'Chưa đủ';
    return 'Đổi';
  }
}
