import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../constants/rewards_constants.dart';

class RewardHistoryList extends StatelessWidget {
  const RewardHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s20,
            AppSpacing.s16,
            AppSpacing.s8,
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColor.fgMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.s6),
              const Text(
                'LỊCH SỬ',
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
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          decoration: BoxDecoration(
            color: AppColor.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColor.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: RewardsHistoryData.items.map((item) {
              final isLast = item == RewardsHistoryData.items.last;
              return _HistoryItem(item: item, isLast: isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final RewardHistoryItem item;
  final bool isLast;

  const _HistoryItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColor.borderSubtle, width: 1),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(item.icon, size: 16, color: AppColor.fg),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fg,
                  ),
                ),
                Text(
                  item.desc,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColor.fgMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${item.isMinus ? '-' : '+'}${item.points}',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: item.isMinus ? AppColor.fgMuted : AppColor.success,
            ),
          ),
        ],
      ),
    );
  }
}
