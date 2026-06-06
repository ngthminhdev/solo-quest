import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/learning_roadmap_model.dart';

enum TopicStatus { completed, selected, notStarted }

class ModuleLessonItem extends StatelessWidget {
  final LearningRoadmapStepModel step;
  final TopicStatus status;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onCompletedChanged;

  const ModuleLessonItem({
    super.key,
    required this.step,
    required this.status,
    this.onTap,
    this.onCompletedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == TopicStatus.completed;
    final isSelected = status == TopicStatus.selected;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColor.border, width: 1)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? AppColor.successBackground
                      : isSelected
                      ? AppColor.primarySoft
                      : AppColor.bgRaised,
                  border: Border.all(
                    color: isCompleted
                        ? AppColor.success
                        : isSelected
                        ? AppColor.primary
                        : AppColor.border,
                  ),
                ),
                child: Center(
                  child: Icon(
                    isCompleted
                        ? RemixIcons.check_line
                        : isSelected
                        ? RemixIcons.checkbox_blank_circle_fill
                        : RemixIcons.checkbox_blank_circle_line,
                    size: 15,
                    color: isCompleted
                        ? AppColor.success
                        : isSelected
                        ? AppColor.primary
                        : AppColor.textMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isCompleted
                          ? AppColor.textSecondary
                          : AppColor.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (step.description.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      step.description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColor.textSecondary,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s10),
            _TopicStatusChip(status: status),
          ],
        ),
      ),
    );
  }
}

class _TopicStatusChip extends StatelessWidget {
  final TopicStatus status;

  const _TopicStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String label;
    Color color;
    Color background;

    switch (status) {
      case TopicStatus.completed:
        label = l10n.lrModuleLessonDone;
        color = AppColor.success;
        background = AppColor.successBackground;
        break;
      case TopicStatus.selected:
        label = l10n.lrModuleLessonSelected;
        color = AppColor.primary;
        background = AppColor.primarySoft;
        break;
      case TopicStatus.notStarted:
        label = l10n.lrModuleLessonNotStarted;
        color = AppColor.textSecondary;
        background = AppColor.surfaceHover;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
