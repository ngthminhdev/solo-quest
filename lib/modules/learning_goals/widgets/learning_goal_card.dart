import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/learning_goal_model.dart';
import '../../../widgets/app_progress_bar/app_progress_bar.dart';
import '../constants/learning_goals_constants.dart';

class LearningGoalCard extends StatelessWidget {
  final LearningGoalModel goal;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdateProgress;

  const LearningGoalCard({
    super.key,
    required this.goal,
    this.onEdit,
    this.onDelete,
    this.onUpdateProgress,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = goal.progress >= 1.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isCompleted ? AppColor.success.withOpacity(0.3) : AppColor.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Category chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s4,
                ),
                decoration: BoxDecoration(
                  color: AppColor.cyanDim,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  border: Border.all(color: AppColor.cyan.withOpacity(0.3)),
                ),
                child: Text(
                  goal.category,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColor.cyan,
                  ),
                ),
              ),
              const Spacer(),
              // Status badge
              _StatusBadge(goal: goal),
            ],
          ),

          const SizedBox(height: AppSpacing.s10),

          // Title
          Text(
            goal.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColor.fg,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          if (goal.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s6),
            Text(
              goal.description,
              style: TextStyle(
                fontSize: 13,
                color: AppColor.fgMuted,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: AppSpacing.s10),

          // Target minutes
          Row(
            children: [
              Icon(
                RemixIcons.time_line,
                size: 14,
                color: AppColor.fgMuted,
              ),
              const SizedBox(width: AppSpacing.s4),
              Text(
                '${goal.targetMinutesPerDay} phút/ngày',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.fgSecondary,
                ),
              ),
              if (goal.deadline != null) ...[
                const SizedBox(width: AppSpacing.s12),
                Icon(
                  RemixIcons.calendar_2_line,
                  size: 14,
                  color: AppColor.fgMuted,
                ),
                const SizedBox(width: AppSpacing.s4),
                Text(
                  DateFormat('dd/MM/yyyy').format(goal.deadline!),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.fgSecondary,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: AppSpacing.s10),

          // Progress
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tiến độ',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColor.fgMuted,
                          ),
                        ),
                        Text(
                          '${(goal.progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.cyan,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    AppProgressBar(
                      progress: goal.progress,
                      height: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s10),

          // Actions
          Row(
            children: [
              _ActionButton(
                icon: RemixIcons.line_chart_line,
                label: 'Tiến độ',
                onTap: onUpdateProgress,
              ),
              const SizedBox(width: AppSpacing.s8),
              _ActionButton(
                icon: RemixIcons.edit_2_line,
                label: 'Sửa',
                onTap: onEdit,
              ),
              const SizedBox(width: AppSpacing.s8),
              _ActionButton(
                icon: RemixIcons.delete_bin_6_line,
                label: 'Xóa',
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final LearningGoalModel goal;

  const _StatusBadge({required this.goal});

  @override
  Widget build(BuildContext context) {
    final isCompleted = goal.progress >= 1.0;
    final isActive = goal.isActive;

    String label;
    Color color;
    Color bgColor;

    if (isCompleted) {
      label = LearningGoalsConstants.statusCompleted;
      color = AppColor.success;
      bgColor = AppColor.successDim;
    } else if (isActive) {
      label = LearningGoalsConstants.statusActive;
      color = AppColor.cyan;
      bgColor = AppColor.cyanDim;
    } else {
      label = LearningGoalsConstants.statusInactive;
      color = AppColor.fgMuted;
      bgColor = AppColor.bgRaised;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s6,
        vertical: AppSpacing.s2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
          decoration: BoxDecoration(
            color: AppColor.bgRaised,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColor.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: AppColor.fgMuted,
              ),
              const SizedBox(width: AppSpacing.s4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColor.fgSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
