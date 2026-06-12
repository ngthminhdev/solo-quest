import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/progress_model.dart';

class DailyProgressCard extends StatelessWidget {
  final ProgressModel? progress;
  final int completedToday;
  final int totalToday;
  final double completionRate;

  const DailyProgressCard({
    super.key,
    this.progress,
    this.completedToday = 0,
    this.totalToday = 0,
    this.completionRate = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final p = progress;

    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.s16, AppSpacing.s16, AppSpacing.s16, AppSpacing.s14),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.borderGlowCyan),
      ),
      child: Column(
        children: [
          // Stats grid
          Row(
            children: [
              _statCell(
                value: '${p?.level ?? 1}',
                label: 'Cấp',
                color: AppColor.cyan,
                icon: RemixIcons.medal_line,
              ),
              SizedBox(width: 12),
              _statCell(
                value: '${p?.totalExp ?? 0}',
                label: 'EXP',
                color: AppColor.expGold,
                icon: RemixIcons.flashlight_line,
              ),
              SizedBox(width: 12),
              _statCell(
                value: '${p?.streakDays ?? 0}',
                label: 'Chuỗi',
                color: AppColor.warn,
                icon: RemixIcons.fire_line,
              ),
              SizedBox(width: 12),
              _statCell(
                value: '${(completionRate * 100).toInt()}%',
                label: 'Hoàn Thành',
                color: AppColor.success,
                icon: RemixIcons.checkbox_circle_line,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCell({
    required String value,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColor.border),
        ),
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
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
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
