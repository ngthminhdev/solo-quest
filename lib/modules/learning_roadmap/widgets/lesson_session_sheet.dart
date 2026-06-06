import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../models/learning_roadmap_model.dart';

enum LessonSessionAction {
  start,
  continueSession,
  markComplete,
  skipForNow,
}

class LessonSessionSheet extends StatelessWidget {
  final LearningRoadmapStepModel lesson;
  final String moduleTitle;
  final int weekNumber;
  final bool isCompleted;
  final bool isLocked;
  final bool hasCompletedTodayGoal;

  final Function(LessonSessionAction)? onAction;

  const LessonSessionSheet({
    super.key,
    required this.lesson,
    this.moduleTitle = '',
    this.weekNumber = 1,
    this.isCompleted = false,
    this.isLocked = false,
    this.hasCompletedTodayGoal = false,
    this.onAction,
  });

  static Future<LessonSessionAction?> show(
    BuildContext context, {
    required LearningRoadmapStepModel lesson,
    String moduleTitle = '',
    int weekNumber = 1,
    bool isCompleted = false,
    bool isLocked = false,
    bool hasCompletedTodayGoal = false,
  }) {
    return showModalBottomSheet<LessonSessionAction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      builder: (context) => LessonSessionSheet(
        lesson: lesson,
        moduleTitle: moduleTitle,
        weekNumber: weekNumber,
        isCompleted: isCompleted,
        isLocked: isLocked,
        hasCompletedTodayGoal: hasCompletedTodayGoal,
        onAction: (action) => Navigator.pop(context, action),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: AppColor.bgRaised,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
        border: Border(
          top: BorderSide(color: AppColor.border),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.s10),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.mutedOverlay,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: AppSpacing.s16),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Module badge
                if (moduleTitle.isNotEmpty || weekNumber > 0)
                  Row(
                    children: [
                      if (weekNumber > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s8,
                            vertical: AppSpacing.s2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.cyanDim,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            l10n.lsWeek(weekNumber),
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColor.cyan,
                            ),
                          ),
                        ),
                      if (moduleTitle.isNotEmpty) ...[
                        const SizedBox(width: AppSpacing.s8),
                        Text(
                          moduleTitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.fgSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),

                const SizedBox(height: AppSpacing.s12),

                // Lesson title
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fg,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: AppSpacing.s10),

                // Meta info
                Row(
                  children: [
                    _MetaChip(
                      icon: RemixIcons.time_line,
                      label: l10n.lsMinutes(lesson.estimatedMinutes),
                    ),
                    if (isCompleted) ...[
                      const SizedBox(width: AppSpacing.s8),
                      _MetaChip(
                        icon: RemixIcons.check_line,
                        label: l10n.lsCompleted,
                        color: AppColor.success,
                      ),
                    ],
                    if (isLocked) ...[
                      const SizedBox(width: AppSpacing.s8),
                      _MetaChip(
                        icon: RemixIcons.lock_line,
                        label: l10n.lsLocked,
                        color: AppColor.fgMuted,
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: AppSpacing.s14),

                // Description
                if (lesson.description.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.s12),
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: Text(
                      lesson.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColor.fgSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),

                const SizedBox(height: AppSpacing.s16),

                // State-specific info
                if (isLocked)
                  _buildLockedInfo(l10n)
                else if (isCompleted)
                  _buildCompletedInfo(l10n)
                else if (hasCompletedTodayGoal)
                  _buildExtraStudyInfo(l10n)
                else
                  _buildActiveInfo(l10n),

                const SizedBox(height: AppSpacing.s16),

                // Actions
                _buildActions(context, l10n),

                const SizedBox(height: AppSpacing.s20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedInfo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s10),
      decoration: BoxDecoration(
        color: AppColor.warnDim,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          const Icon(RemixIcons.lock_line, size: 14, color: AppColor.warn),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(
              l10n.lsLockedInfo,
              style: const TextStyle(
                fontSize: 12,
                color: AppColor.warn,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedInfo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s10),
      decoration: BoxDecoration(
        color: AppColor.successDim,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          const Icon(RemixIcons.check_line, size: 14, color: AppColor.success),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(
              l10n.lsCompletedInfo,
              style: const TextStyle(
                fontSize: 12,
                color: AppColor.fgSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtraStudyInfo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s10),
      decoration: BoxDecoration(
        color: AppColor.violetDim,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          const Icon(RemixIcons.star_line, size: 14, color: AppColor.violet),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(
              l10n.lsExtraInfo,
              style: const TextStyle(
                fontSize: 12,
                color: AppColor.fgSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveInfo(AppLocalizations l10n) {
    return Row(
      children: [
        const Icon(RemixIcons.play_circle_fill, size: 14, color: AppColor.cyan),
        const SizedBox(width: AppSpacing.s8),
        Flexible(
          child: Text(
            l10n.lsReadyInfo,
            style: const TextStyle(
              fontSize: 12,
              color: AppColor.fgSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, AppLocalizations l10n) {
    if (isLocked) {
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.border),
          ),
          child: Text(
            l10n.lsClose,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.fgSecondary,
            ),
          ),
        ),
      );
    }

    if (isCompleted) {
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.border),
          ),
          child: Text(
            l10n.lsClose,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.fgSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Start / Continue
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              if (hasCompletedTodayGoal) {
                onAction?.call(LessonSessionAction.continueSession);
              } else {
                onAction?.call(LessonSessionAction.start);
              }
            },
            icon: const Icon(RemixIcons.play_fill, size: 16),
            label: Text(hasCompletedTodayGoal ? l10n.lsStudyMore : l10n.lsStart),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.cyan,
              foregroundColor: AppColor.bgDeep,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.s8),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => onAction?.call(LessonSessionAction.markComplete),
                icon: const Icon(RemixIcons.check_line, size: 14),
                label: Text(l10n.lsMarkDone),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.success,
                  side: BorderSide(color: AppColor.successStrongBorder),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => onAction?.call(LessonSessionAction.skipForNow),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.fgSecondary,
                  side: const BorderSide(color: AppColor.border),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(l10n.lsLater),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _MetaChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColor.fgMuted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: chipColor),
        const SizedBox(width: AppSpacing.s4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: chipColor,
          ),
        ),
      ],
    );
  }
}
