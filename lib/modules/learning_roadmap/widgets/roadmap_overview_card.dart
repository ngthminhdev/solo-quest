import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/learning_roadmap_model.dart';
import '../../../widgets/app_progress_bar/app_progress_bar.dart';

class RoadmapOverviewCard extends StatelessWidget {
  final LearningRoadmapModel roadmap;

  const RoadmapOverviewCard({super.key, required this.roadmap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final totalTopics = roadmap.totalSteps;
    final completedTopics = roadmap.completedSteps;
    final remainingTopics = totalTopics - completedTopics;
    final progress = roadmap.computedProgress;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        gradient: AppColor.roadmapOverviewGradient,
        border: Border.all(color: AppColor.secondaryBorder),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            roadmap.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColor.fg,
            ),
          ),

          const SizedBox(height: AppSpacing.s12),

          // Stats grid
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  value: totalTopics.toString(),
                  label: l10n.lrOverviewTopics,
                ),
              ),
              Expanded(
                child: _StatItem(
                  value: completedTopics.toString(),
                  label: l10n.lrOverviewDone,
                ),
              ),
              Expanded(
                child: _StatItem(
                  value: remainingTopics.toString(),
                  label: l10n.lrOverviewRemaining,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s12),

          // Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.lrOverviewTotalProgress,
                    style: TextStyle(fontSize: 11, color: AppColor.fgMuted),
                  ),
                  Text(
                    l10n.lrOverviewProgressCount(completedTopics, totalTopics),
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: AppColor.violet,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s6),
              AppProgressBar(
                progress: progress,
                height: 6,
                progressColor: AppColor.violet,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColor.cyan,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColor.fgMuted,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
