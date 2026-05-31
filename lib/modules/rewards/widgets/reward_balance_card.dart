import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../widgets/app_card/app_glow_card.dart';

class RewardBalanceCard extends StatelessWidget {
  final int availablePoints;
  final int availableRewardCount;
  final int claimedRewardCount;

  const RewardBalanceCard({
    super.key,
    required this.availablePoints,
    required this.availableRewardCount,
    required this.claimedRewardCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlowCard(
      glowColor: AppColor.cyan,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16)
          .copyWith(bottom: AppSpacing.s12),
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColor.cyanDim,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    RemixIcons.gift_line,
                    size: 22,
                    color: AppColor.cyan,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Điểm thưởng hiện có',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.fgMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$availablePoints',
                      style: const TextStyle(
                        fontFamily: 'Exo2',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColor.cyan,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  label: 'Có thể đổi',
                  value: '$availableRewardCount',
                  color: AppColor.cyan,
                ),
              ),
              Container(
                width: 1,
                height: 28,
                color: AppColor.border,
              ),
              Expanded(
                child: _SummaryItem(
                  label: 'Đã đổi',
                  value: '$claimedRewardCount',
                  color: AppColor.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Exo2',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColor.fgMuted,
          ),
        ),
      ],
    );
  }
}
