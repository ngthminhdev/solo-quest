import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/weekly_summary_model.dart';

class WeeklyScoreCard extends StatelessWidget {
  final WeeklySummaryModel summary;

  const WeeklyScoreCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final rate = (summary.completionRate * 100).round();
    final total = summary.completedQuestCount + summary.skippedQuestCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColor.surface,
          border: Border.all(color: AppColor.borderGlowCyan),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColor.cyan.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Big percentage
            Text(
              '$rate%',
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: AppColor.cyan,
                height: 1,
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              '${summary.completedQuestCount} / $total nhiệm vụ',
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.fgSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),

            // Sub stats row
            Row(
              children: [
                _MiniStat(
                  label: 'EXP',
                  value: '+${summary.earnedExp}',
                  color: AppColor.expGold,
                ),
                Container(width: 1, height: 28, color: AppColor.border),
                _MiniStat(
                  label: 'Bỏ qua',
                  value: '${summary.skippedQuestCount}',
                  color: AppColor.danger,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColor.fgMuted,
            ),
          ),
        ],
      ),
    );
  }
}
