import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';

class ProfileStatsGrid extends StatelessWidget {
  final int totalCompletedQuests;
  final int streakDays;
  final int currentLevelExp;
  final int level;

  const ProfileStatsGrid({
    super.key,
    required this.totalCompletedQuests,
    required this.streakDays,
    required this.currentLevelExp,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: RemixIcons.checkbox_circle_line,
              label: 'Quest hoàn thành',
              value: totalCompletedQuests.toString(),
              color: AppColor.success,
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: _StatCard(
              icon: RemixIcons.fire_line,
              label: 'Streak',
              value: '$streakDays ngày',
              color: AppColor.warn,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColor.fgMuted,
            ),
          ),
        ],
      ),
    );
  }
}
