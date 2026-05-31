import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/weekly_summary_model.dart';

class WeeklyStatsGrid extends StatelessWidget {
  final WeeklySummaryModel summary;

  const WeeklyStatsGrid({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppSpacing.s8,
        crossAxisSpacing: AppSpacing.s8,
        childAspectRatio: 1.0,
        children: [
          _StatCard(
            label: 'Hoàn thành',
            value: '${summary.completedQuestCount}',
            color: AppColor.cyan,
            icon: RemixIcons.checkbox_circle_line,
            highlight: true,
          ),
          _StatCard(
            label: 'EXP tuần',
            value: '+${summary.earnedExp}',
            color: AppColor.expGold,
            icon: RemixIcons.flashlight_line,
          ),
          _StatCard(
            label: 'Streak',
            value: '5',
            color: AppColor.success,
            icon: RemixIcons.fire_line,
            sub: 'ngày liên tiếp',
          ),
          _StatCard(
            label: 'Đã hoãn',
            value: '12',
            color: AppColor.warn,
            icon: RemixIcons.time_line,
            sub: 'lần trong tuần',
          ),
          _StatCard(
            label: 'Bỏ qua',
            value: '${summary.skippedQuestCount}',
            color: AppColor.danger,
            icon: RemixIcons.skip_forward_line,
            sub: 'quest',
          ),
          _StatCard(
            label: 'Daily Review',
            value: '4/7',
            color: AppColor.violet,
            icon: RemixIcons.file_list_3_line,
            sub: 'ngày hoàn thành',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool highlight;
  final String? sub;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.highlight = false,
    this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s10),
      decoration: BoxDecoration(
        color: AppColor.surface,
        border: Border.all(
          color: highlight ? AppColor.borderGlowCyan : AppColor.border,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: highlight
            ? [
                BoxShadow(
                  color: AppColor.cyan.withAlpha(20),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1.1,
            ),
          ),
          if (sub != null) ...[
            const SizedBox(height: 2),
            Text(
              sub!,
              style: const TextStyle(
                fontSize: 9,
                color: AppColor.fgMuted,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColor.fgSecondary,
              letterSpacing: 0.04,
            ),
          ),
        ],
      ),
    );
  }
}
