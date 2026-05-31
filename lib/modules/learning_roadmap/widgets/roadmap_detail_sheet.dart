import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/learning_roadmap_model.dart';
import '../../../widgets/app_progress_bar/app_progress_bar.dart';
import '../constants/learning_roadmap_constants.dart';
import 'roadmap_step_tile.dart';

class RoadmapDetailSheet {
  static Future<void> show(
    BuildContext context, {
    required LearningRoadmapModel roadmap,
    required Future<void> Function(LearningRoadmapStepModel step, bool completed)
        onToggleStep,
  }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _RoadmapDetailContent(
        roadmap: roadmap,
        onToggleStep: onToggleStep,
      ),
    );
  }
}

class _RoadmapDetailContent extends StatelessWidget {
  final LearningRoadmapModel roadmap;
  final Future<void> Function(LearningRoadmapStepModel step, bool completed)
      onToggleStep;

  const _RoadmapDetailContent({
    required this.roadmap,
    required this.onToggleStep,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.75;
    final progressPercent = (roadmap.computedProgress * 100).round();

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: AppColor.bgRaised,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.fgMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        roadmap.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColor.fg,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        RemixIcons.close_line,
                        size: 20,
                        color: AppColor.fgMuted,
                      ),
                    ),
                  ],
                ),
                if (roadmap.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    roadmap.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColor.fgSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.s12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${LearningRoadmapConstants.detailProgressLabel}: ${roadmap.completedSteps}/${roadmap.totalSteps} bước',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.fgMuted,
                      ),
                    ),
                    Text(
                      '$progressPercent%',
                      style: const TextStyle(
                        fontFamily: 'Exo2',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColor.violet,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s6),
                AppProgressBar(
                  progress: roadmap.computedProgress,
                  height: 6,
                  progressColor: AppColor.violet,
                ),
                const SizedBox(height: AppSpacing.s12),
                const Divider(color: AppColor.border, height: 1),
              ],
            ),
          ),

          // Step list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              itemCount: roadmap.steps.length,
              itemBuilder: (context, index) {
                final step = roadmap.steps[index];
                return RoadmapStepTile(
                  step: step,
                  onChanged: (completed) async {
                    await onToggleStep(step, completed);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
