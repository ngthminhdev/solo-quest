import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/learning_roadmap_model.dart';

class RoadmapStepTile extends StatelessWidget {
  final LearningRoadmapStepModel step;
  final ValueChanged<bool> onChanged;

  const RoadmapStepTile({
    super.key,
    required this.step,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!step.completed),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColor.border,
              width: 0.5,
            ),
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
                            ? AppColor.fgMuted.withOpacity(0.6)
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
                  '${step.estimatedMinutes}p',
                  style: const TextStyle(
                    fontFamily: 'Exo2',
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
        border: Border.all(
          color: AppColor.cyan.withOpacity(0.3),
        ),
      ),
      child: const Icon(
        RemixIcons.circle_line,
        size: 16,
        color: AppColor.fgMuted,
      ),
    );
  }
}
