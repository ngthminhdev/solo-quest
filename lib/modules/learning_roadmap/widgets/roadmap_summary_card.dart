import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../widgets/app_progress_bar/app_progress_bar.dart';
import '../constants/learning_roadmap_constants.dart';

class RoadmapSummaryCard extends StatelessWidget {
  final int totalRoadmaps;
  final int completedRoadmaps;
  final int totalSteps;
  final int completedSteps;
  final double averageProgress;

  const RoadmapSummaryCard({
    super.key,
    required this.totalRoadmaps,
    required this.completedRoadmaps,
    required this.totalSteps,
    required this.completedSteps,
    required this.averageProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.violet.withOpacity(0.08),
            AppColor.cyan.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.borderGlowViolet),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LearningRoadmapConstants.summaryTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColor.fg,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Row(
            children: [
              _StatItem(
                value: '$totalRoadmaps',
                label: LearningRoadmapConstants.summaryTotalRoadmaps,
                color: AppColor.cyan,
              ),
              _StatItem(
                value: '$completedRoadmaps',
                label: LearningRoadmapConstants.summaryCompleted,
                color: AppColor.success,
              ),
              _StatItem(
                value: '$completedSteps/$totalSteps',
                label: LearningRoadmapConstants.summarySteps,
                color: AppColor.violet,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LearningRoadmapConstants.summaryAvgProgress,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColor.fgMuted,
                ),
              ),
              Text(
                '${(averageProgress * 100).round()}%',
                style: const TextStyle(
                  fontFamily: 'Exo2',
                  fontSize: 11,
                  color: AppColor.violet,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s6),
          AppProgressBar(
            progress: averageProgress,
            height: 6,
            progressColor: AppColor.violet,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
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
              fontFamily: 'Exo2',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColor.fgMuted,
              letterSpacing: 0.04,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
