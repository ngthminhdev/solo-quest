import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/learning_goal_model.dart';
import '../../../widgets/app_progress_bar/app_progress_bar.dart';

class ActiveGoalCard extends StatelessWidget {
  final LearningGoalModel goal;
  final VoidCallback? onViewRoadmap;
  final VoidCallback? onSync;
  final VoidCallback? onPause;

  // TODO: Backend integration - These mock values should come from backend
  final int currentWeek;
  final int completedLessons;
  final int totalLessons;
  final bool isSynced;
  final String timeSlot;

  // Frontend fallback: true if this goal is the first active goal (treated as main)
  final bool isMainGoal;

  const ActiveGoalCard({
    super.key,
    required this.goal,
    this.onViewRoadmap,
    this.onSync,
    this.onPause,
    this.currentWeek = 1,
    this.completedLessons = 2,
    this.totalLessons = 12,
    this.isSynced = true,
    this.timeSlot = 'tối',
    this.isMainGoal = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final weekProgress = totalLessons > 0 ? completedLessons / totalLessons : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        border: Border.all(
          color: AppColor.secondaryBorder,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColor.secondaryShadow,
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with name and week badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Goal name
              Expanded(
                child: Text(
                  goal.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fg,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.s10),
              // Main goal badge
              if (isMainGoal)
                Container(
                  margin: const EdgeInsets.only(right: AppSpacing.s6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s6,
                    vertical: AppSpacing.s2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.expGoldDim,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColor.accentBorder),
                  ),
                  child: Text(
                    l10n.lgActiveMainBadge,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColor.expGold,
                    ),
                  ),
                ),
              // Week badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s2,
                ),
                decoration: BoxDecoration(
                  color: AppColor.violetDim,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  l10n.lgActiveWeek(currentWeek),
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColor.violet,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s6),

          // Meta info (time and lessons)
          Row(
            children: [
              const Icon(
                RemixIcons.time_line,
                size: 14,
                color: AppColor.fgMuted,
              ),
              const SizedBox(width: AppSpacing.s4),
              Text(
                '${goal.targetMinutesPerDay} phút mỗi $timeSlot · Bài $completedLessons / $totalLessons',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColor.fgSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s10),

          // Sync status
          if (isSynced)
            Row(
              children: [
                const Icon(
                  RemixIcons.check_line,
                  size: 14,
                  color: AppColor.success,
                ),
                const SizedBox(width: AppSpacing.s6),
                Text(
                  l10n.lgActiveSynced,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColor.success,
                  ),
                ),
              ],
            ),

          const SizedBox(height: AppSpacing.s10),

          // Progress section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.lgActiveWeeklyProgress,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColor.fgMuted,
                    ),
                  ),
                  Text(
                    '$completedLessons / $totalLessons bài',
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColor.violet,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s6),
              AppProgressBar(
                progress: weekProgress,
                height: 6,
                progressColor: AppColor.violet,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s12),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: RemixIcons.route_line,
                  label: l10n.lgActiveViewRoadmap,
                  onTap: onViewRoadmap,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: _ActionButton(
                  icon: RemixIcons.refresh_line,
                  label: l10n.lgActiveSync,
                  onTap: onSync,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              _ActionButton(
                icon: RemixIcons.pause_circle_line,
                label: l10n.lgActivePause,
                onTap: onPause,
                isGhost: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isGhost;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isGhost = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s8,
          vertical: AppSpacing.s6,
        ),
        decoration: BoxDecoration(
          color: isGhost ? AppColor.transparent : AppColor.bgRaised,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: isGhost ? AppColor.transparent : AppColor.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: AppColor.fgMuted,
            ),
            const SizedBox(width: AppSpacing.s4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColor.fgSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
