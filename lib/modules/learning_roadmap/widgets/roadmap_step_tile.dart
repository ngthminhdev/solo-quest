import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/learning_roadmap_model.dart';

class RoadmapStepTile extends StatelessWidget {
  final LearningRoadmapStepModel step;
  final ValueChanged<bool> onChanged;
  final bool isPending;

  const RoadmapStepTile({
    super.key,
    required this.step,
    required this.onChanged,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actionLabel = step.completed
        ? l10n.lrStepUnmarkLabel
        : l10n.lrStepCompletedLabel;

    return Semantics(
      button: true,
      label: '${step.title}. $actionLabel',
      child: Tooltip(
        message: actionLabel,
        child: GestureDetector(
          onTap: isPending ? null : () => onChanged(!step.completed),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColor.border, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                _buildStatusIcon(),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: step.completed
                              ? AppColor.fgMuted
                              : AppColor.fg,
                          decoration: step.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (step.description.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          step.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: step.completed
                                ? AppColor.mutedStrongOverlay
                                : AppColor.fgSecondary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                if (isPending)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.cyan,
                    ),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        RemixIcons.time_line,
                        size: 12,
                        color: AppColor.fgMuted,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        l10n.lrStepEstimated(step.estimatedMinutes),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColor.fgMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (step.completed) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColor.successDim,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          RemixIcons.checkbox_circle_line,
          size: 16,
          color: AppColor.success,
        ),
      );
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColor.surfaceHover,
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.primaryBorder),
      ),
      child: const Icon(
        RemixIcons.circle_line,
        size: 16,
        color: AppColor.fgMuted,
      ),
    );
  }
}
