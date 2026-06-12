import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../widgets/app_progress_bar/app_progress_bar.dart';

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
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        gradient: AppColor.roadmapOverviewGradient,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.borderGlowViolet),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.lrSummaryTitle,
            style: TextStyle(
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
                label: l10n.lrSummaryTotalRoadmaps,
                color: AppColor.cyan,
              ),
              _StatItem(
                value: '$completedRoadmaps',
                label: l10n.lrSummaryCompleted,
                color: AppColor.success,
              ),
              _StatItem(
                value: '$completedSteps/$totalSteps',
                label: l10n.lrSummarySteps,
                color: AppColor.violet,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.lrSummaryAvgProgress,
                style: TextStyle(fontSize: 11, color: AppColor.fgMuted),
              ),
              Text(
                '${(averageProgress * 100).round()}%',
                style: TextStyle(
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
          const SizedBox(height: AppSpacing.s8),
          Text(
            l10n.lrLocalProgressHint,
            style: TextStyle(
              fontSize: 11,
              color: AppColor.fgMuted,
              height: 1.35,
            ),
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
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
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
