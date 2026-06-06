import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../extensions/localization_extension.dart';

class DailyReviewSummaryCard extends StatelessWidget {
  final int completedCount;
  final int skippedCount;
  final int earnedExp;
  final double completionRate;

  const DailyReviewSummaryCard({
    super.key,
    required this.completedCount,
    required this.skippedCount,
    required this.earnedExp,
    required this.completionRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColor.border)),
      ),
      child: Row(
        children: [
          _StatCell(
            value: '$completedCount',
            label: context.l10n.dailyReviewSummaryCompleted,
            color: AppColor.cyan,
            icon: RemixIcons.checkbox_circle_line,
          ),
          _StatCell(
            value: '+$earnedExp',
            label: 'EXP',
            color: AppColor.expGold,
            icon: RemixIcons.flashlight_line,
          ),
          _StatCell(
            value: '${(completionRate * 100).round()}%',
            label: context.l10n.dailyReviewSummaryRate,
            color: AppColor.success,
            icon: RemixIcons.pie_chart_line,
          ),
          _StatCell(
            value: '$skippedCount',
            label: context.l10n.dailyReviewSummarySkipped,
            color: AppColor.warn,
            icon: RemixIcons.skip_forward_line,
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final IconData icon;

  const _StatCell({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s10,
          horizontal: AppSpacing.s4,
        ),
        decoration: BoxDecoration(
          color: AppColor.surface,
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
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
      ),
    );
  }
}
