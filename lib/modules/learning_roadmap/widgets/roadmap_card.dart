import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/learning_roadmap_model.dart';
import '../../../widgets/app_progress_bar/app_progress_bar.dart';
import '../constants/learning_roadmap_constants.dart';

class RoadmapCard extends StatelessWidget {
  final LearningRoadmapModel roadmap;
  final VoidCallback? onTap;

  const RoadmapCard({
    super.key,
    required this.roadmap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = roadmap.computedProgress >= 1.0;
    final progressPercent = (roadmap.computedProgress * 100).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? AppColor.success.withOpacity(0.3)
                : AppColor.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    roadmap.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColor.fg,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                _StatusBadge(isCompleted: isCompleted),
              ],
            ),
            if (roadmap.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s6),
              Text(
                roadmap.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColor.fgSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppSpacing.s12),
            Row(
              children: [
                const Icon(
                  RemixIcons.checkbox_circle_line,
                  size: 14,
                  color: AppColor.fgMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '${roadmap.completedSteps}/${roadmap.totalSteps} bước',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.fgMuted,
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                const Icon(
                  RemixIcons.time_line,
                  size: 14,
                  color: AppColor.fgMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '${roadmap.totalEstimatedMinutes} phút',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.fgMuted,
                  ),
                ),
                const Spacer(),
                Text(
                  '$progressPercent%',
                  style: TextStyle(
                    fontFamily: 'Exo2',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isCompleted ? AppColor.success : AppColor.cyan,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            AppProgressBar(
              progress: roadmap.computedProgress,
              height: 5,
              progressColor: isCompleted ? AppColor.success : AppColor.cyan,
            ),
            const SizedBox(height: AppSpacing.s12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  LearningRoadmapConstants.viewRoadmapButton,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? AppColor.success : AppColor.cyan,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  RemixIcons.arrow_right_s_line,
                  size: 16,
                  color: isCompleted ? AppColor.success : AppColor.cyan,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isCompleted;

  const _StatusBadge({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isCompleted ? AppColor.successDim : AppColor.cyanDim,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isCompleted
            ? LearningRoadmapConstants.statusCompleted
            : LearningRoadmapConstants.statusLearning,
        style: TextStyle(
          fontFamily: 'Exo2',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isCompleted ? AppColor.success : AppColor.cyan,
        ),
      ),
    );
  }
}
