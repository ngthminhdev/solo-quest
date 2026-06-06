import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';

enum LessonCompletionAction {
  nextLesson,
  stopHere,
  studyMore,
}

class LessonCompletionSheet extends StatelessWidget {
  final String lessonTitle;
  final String? nextLessonTitle;
  final int todayCompletedCount;
  final int todayStudyMinutes;

  const LessonCompletionSheet({
    super.key,
    required this.lessonTitle,
    this.nextLessonTitle,
    this.todayCompletedCount = 0,
    this.todayStudyMinutes = 0,
  });

  static Future<LessonCompletionAction?> show(
    BuildContext context, {
    required String lessonTitle,
    String? nextLessonTitle,
    int todayCompletedCount = 0,
    int todayStudyMinutes = 0,
  }) {
    return showModalBottomSheet<LessonCompletionAction>(
      context: context,
      backgroundColor: AppColor.transparent,
      isScrollControlled: true,
      builder: (context) => LessonCompletionSheet(
        lessonTitle: lessonTitle,
        nextLessonTitle: nextLessonTitle,
        todayCompletedCount: todayCompletedCount,
        todayStudyMinutes: todayStudyMinutes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
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

          const SizedBox(height: AppSpacing.s20),

          // Success icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColor.successDim,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.successBorder,
                width: 2,
              ),
            ),
            child: const Icon(
              RemixIcons.checkbox_circle_line,
              size: 30,
              color: AppColor.success,
            ),
          ),

          const SizedBox(height: AppSpacing.s14),

          // Title
          Text(
            l10n.lsCompleteTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor.fg,
            ),
          ),

          const SizedBox(height: AppSpacing.s4),

          Text(
            '"$lessonTitle"',
            style: const TextStyle(
              fontSize: 13,
              color: AppColor.fgSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.s8),

          // Today stats
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s8,
            ),
            decoration: BoxDecoration(
              color: AppColor.surfaceHover,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(RemixIcons.time_line, size: 12, color: AppColor.fgMuted),
                const SizedBox(width: AppSpacing.s4),
                Text(
                  l10n.lsCompleteStats(todayCompletedCount, todayStudyMinutes),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.fgSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.s16),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
            child: Column(
              children: [
                // Next lesson
                if (nextLessonTitle != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(
                        context,
                        LessonCompletionAction.nextLesson,
                      ),
                      icon: const Icon(RemixIcons.arrow_right_s_line, size: 16),
                      label: Text(l10n.lsCompleteNextLesson),
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

                if (nextLessonTitle != null)
                  const SizedBox(height: AppSpacing.s8),

                // Stop here
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(
                      context,
                      LessonCompletionAction.stopHere,
                    ),
                    icon: const Icon(RemixIcons.stop_line, size: 14),
                    label: Text(l10n.lsCompleteStop),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.fgSecondary,
                      side: const BorderSide(color: AppColor.border),
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.s8),

                // Study more
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(
                    context,
                    LessonCompletionAction.studyMore,
                  ),
                  icon: const Icon(RemixIcons.add_line, size: 14),
                  label: Text(l10n.lsCompleteExtra),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.violet,
                    side: BorderSide(color: AppColor.secondaryStrongBorder),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s16,
                      vertical: AppSpacing.s8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.s20),
        ],
      ),
    );
  }
}
