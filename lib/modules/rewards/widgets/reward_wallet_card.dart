import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';

class RewardWalletCard extends StatelessWidget {
  final int availablePoints;
  final int weeklyEarned;
  final int claimedCount;
  final int badgeCount;
  final int exp;
  final int nextLevelExp;

  const RewardWalletCard({
    super.key,
    required this.availablePoints,
    required this.weeklyEarned,
    required this.claimedCount,
    required this.badgeCount,
    required this.exp,
    required this.nextLevelExp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.s16),
      padding: const EdgeInsets.all(AppSpacing.s20),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColor.borderGlowViolet),
        boxShadow: [
          BoxShadow(
            color: AppColor.violet.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top: icon + points + exchange info
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColor.expGoldDim,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: const Center(
                  child: Icon(
                    RemixIcons.vip_diamond_fill,
                    color: AppColor.expGold,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'REWARD POINTS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColor.fgMuted,
                        letterSpacing: 0.06,
                      ),
                    ),
                    Text(
                      '$availablePoints',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColor.expGold,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColor.fgMuted,
                      ),
                      children: [
                        const TextSpan(text: 'Quy đổi: '),
                        TextSpan(
                          text: '≈ ${availablePoints ~/ 150} phần thưởng nhỏ',
                          style: const TextStyle(
                            color: AppColor.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'EXP: $exp / $nextLevelExp',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColor.fgMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s16),

          // Stats grid
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColor.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                Expanded(
                  child: _WalletStat(
                    value: '+$weeklyEarned',
                    label: 'Tuần này',
                    valueColor: AppColor.cyan,
                  ),
                ),
                Container(width: 1, height: 28, color: AppColor.border),
                Expanded(
                  child: _WalletStat(
                    value: '$claimedCount',
                    label: 'Đã đổi',
                    valueColor: AppColor.success,
                  ),
                ),
                Container(width: 1, height: 28, color: AppColor.border),
                Expanded(
                  child: _WalletStat(
                    value: '$badgeCount',
                    label: 'Badge',
                    valueColor: AppColor.violet,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletStat extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _WalletStat({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.bgRaised,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s10,
        horizontal: AppSpacing.s8,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: valueColor,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColor.fgMuted,
              letterSpacing: 0.04,
            ),
          ),
        ],
      ),
    );
  }
}
