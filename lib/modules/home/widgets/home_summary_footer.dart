import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';

class HomeSummaryFooter extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final int earnedExp;
  final int streakDays;

  const HomeSummaryFooter({
    super.key,
    required this.completedCount,
    required this.totalCount,
    required this.earnedExp,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      decoration: BoxDecoration(
        color: AppColor.bgRaised,
        border: Border.all(color: AppColor.borderGlowCyan),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SummaryItem(
            label: 'Quest',
            value: '$completedCount/$totalCount',
            valueColor: AppColor.cyan,
          ),
          _SummaryItem(
            label: 'EXP Hôm Nay',
            value: '+$earnedExp',
            valueColor: AppColor.expGold,
          ),
          _SummaryItem(
            label: 'Chuỗi',
            value: '$streakDays ngày',
            valueColor: AppColor.warn,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColor.fgMuted,
            letterSpacing: 0.04,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'GoogleSansCode',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
