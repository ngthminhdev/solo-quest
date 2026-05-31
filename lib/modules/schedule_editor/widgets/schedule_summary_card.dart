import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';

class ScheduleSummaryCard extends StatelessWidget {
  final int totalBlocks;
  final int fixedBlockCount;
  final int flexibleBlockCount;

  const ScheduleSummaryCard({
    super.key,
    required this.totalBlocks,
    required this.fixedBlockCount,
    required this.flexibleBlockCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          _StatItem(
            icon: RemixIcons.time_line,
            label: 'Tổng block',
            value: totalBlocks.toString(),
          ),
          const SizedBox(width: AppSpacing.s16),
          _StatItem(
            icon: RemixIcons.lock_line,
            label: 'Cố định',
            value: fixedBlockCount.toString(),
          ),
          const SizedBox(width: AppSpacing.s16),
          _StatItem(
            icon: RemixIcons.shuffle_line,
            label: 'Linh hoạt',
            value: flexibleBlockCount.toString(),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColor.cyan,
          ),
          const SizedBox(height: AppSpacing.s6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.fg,
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColor.fgMuted,
            ),
          ),
        ],
      ),
    );
  }
}
