import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/learning_roadmap_model.dart';

class RoadmapStepTile extends StatefulWidget {
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
  State<RoadmapStepTile> createState() => _RoadmapStepTileState();
}

class _RoadmapStepTileState extends State<RoadmapStepTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actionLabel = widget.step.completed
        ? l10n.lrStepUnmarkLabel
        : l10n.lrStepCompletedLabel;

    return Semantics(
      button: true,
      label: '${widget.step.title}. $actionLabel',
      child: Tooltip(
        message: actionLabel,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColor.border, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: widget.isPending ? null : () => widget.onChanged(!widget.step.completed),
                child: _buildStatusIcon(),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: GestureDetector(
                  onTap: widget.step.description.isNotEmpty
                      ? () => setState(() => _isExpanded = !_isExpanded)
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.step.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: widget.step.completed
                              ? AppColor.fgMuted
                              : AppColor.fg,
                          decoration: widget.step.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.step.description.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.step.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.step.completed
                                ? AppColor.mutedStrongOverlay
                                : AppColor.fgSecondary,
                            height: 1.3,
                          ),
                          maxLines: _isExpanded ? null : 2,
                          overflow: _isExpanded ? null : TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              if (widget.isPending)
                SizedBox(
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
                      l10n.lrStepEstimated(widget.step.estimatedMinutes),
                      style: TextStyle(
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
    );
  }

  Widget _buildStatusIcon() {
    if (widget.step.completed) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColor.successDim,
          shape: BoxShape.circle,
        ),
        child: Icon(
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
      child: Icon(
        RemixIcons.circle_line,
        size: 16,
        color: AppColor.fgMuted,
      ),
    );
  }
}
