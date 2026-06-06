import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../widgets/app_progress_bar/app_progress_bar.dart';

class LearningGoalSummaryCard extends StatelessWidget {
  final int totalGoals;
  final int activeGoals;
  final int completedGoals;
  final double averageProgress;

  const LearningGoalSummaryCard({
    super.key,
    required this.totalGoals,
    required this.activeGoals,
    required this.completedGoals,
    required this.averageProgress,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _StatItem(
                icon: RemixIcons.target_line,
                label: l10n.lgSummaryTotal,
                value: totalGoals.toString(),
              ),
              const SizedBox(width: AppSpacing.s12),
              _StatItem(
                icon: RemixIcons.play_circle_line,
                label: l10n.lgSummaryActive,
                value: activeGoals.toString(),
              ),
              const SizedBox(width: AppSpacing.s12),
              _StatItem(
                icon: RemixIcons.checkbox_circle_line,
                label: l10n.lgSummaryCompleted,
                value: completedGoals.toString(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.lgSummaryAvgProgress,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.fgMuted,
                    ),
                  ),
                  Text(
                    '${(averageProgress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColor.cyan,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s6),
              AppProgressBar(
                progress: averageProgress,
                height: 6,
              ),
            ],
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
            size: 18,
            color: AppColor.cyan,
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
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
