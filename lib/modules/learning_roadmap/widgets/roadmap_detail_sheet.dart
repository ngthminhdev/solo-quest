import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/learning_roadmap_model.dart';
import '../../../widgets/app_progress_bar/app_progress_bar.dart';
import '../../../widgets/app_toast/app_toast_service.dart';
import 'roadmap_step_tile.dart';

class RoadmapDetailSheet {
  static Future<void> show(
    BuildContext context, {
    required LearningRoadmapModel roadmap,
    required Future<bool> Function(
      LearningRoadmapStepModel step,
      bool completed,
    )
    onToggleStep,
  }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.transparent,
      isScrollControlled: true,
      builder: (ctx) =>
          _RoadmapDetailContent(roadmap: roadmap, onToggleStep: onToggleStep),
    );
  }
}

class _RoadmapDetailContent extends StatefulWidget {
  final LearningRoadmapModel roadmap;
  final Future<bool> Function(LearningRoadmapStepModel step, bool completed)
  onToggleStep;

  const _RoadmapDetailContent({
    required this.roadmap,
    required this.onToggleStep,
  });

  @override
  State<_RoadmapDetailContent> createState() => _RoadmapDetailContentState();
}

class _RoadmapDetailContentState extends State<_RoadmapDetailContent> {
  late LearningRoadmapModel _roadmap;
  final Set<String> _pendingStepIds = {};

  @override
  void initState() {
    super.initState();
    _roadmap = widget.roadmap;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.75;
    final progressPercent = (_roadmap.computedProgress * 100).round();

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
                        _roadmap.title,
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
                if (_roadmap.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _roadmap.description,
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
                      '${l10n.lrDetailProgressLabel}: ${_roadmap.completedSteps}/${_roadmap.totalSteps} ${l10n.lrDetailSteps}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.fgMuted,
                      ),
                    ),
                    Text(
                      '$progressPercent%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColor.violet,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s6),
                AppProgressBar(
                  progress: _roadmap.computedProgress,
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
              itemCount: _roadmap.steps.length,
              itemBuilder: (context, index) {
                final step = _roadmap.steps[index];
                return RoadmapStepTile(
                  step: step,
                  isPending: _pendingStepIds.contains(step.id),
                  onChanged: (completed) async {
                    setState(() {
                      _pendingStepIds.add(step.id);
                      _roadmap = _replaceStepAt(index, completed);
                    });

                    final updated = await widget.onToggleStep(step, completed);
                    if (!mounted || !context.mounted) return;

                    if (updated) {
                      setState(() {
                        _pendingStepIds.remove(step.id);
                      });
                      // Show success feedback
                      AppToastService.success(
                        context,
                        completed ? l10n.lrToastStepCompleted : l10n.lrToastStepUpdated,
                      );
                      return;
                    }

                    setState(() {
                      _pendingStepIds.remove(step.id);
                      _roadmap = _replaceStepAt(index, step.completed);
                    });
                    AppToastService.error(context, l10n.lrToastToggleError);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  LearningRoadmapModel _replaceStepAt(int index, bool completed) {
    final steps = List<LearningRoadmapStepModel>.from(_roadmap.steps);
    steps[index] = steps[index].copyWith(completed: completed);
    return _roadmap.copyWith(steps: steps);
  }
}
