import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/learning_roadmap_model.dart';

class TodayLearningPlanCard extends StatelessWidget {
  final LearningRoadmapStepModel? currentLesson;
  final int suggestedMinutesToday;

  // Frontend local counters — reset each time the roadmap page opens.
  // TODO: Backend should persist daily study time and completed count.
  final int completedTodayCount;
  final int studyMinutesToday;

  final VoidCallback? onStartLearning;
  final VoidCallback? onStudyMore;

  const TodayLearningPlanCard({
    super.key,
    this.currentLesson,
    this.suggestedMinutesToday = 25,
    this.completedTodayCount = 0,
    this.studyMinutesToday = 0,
    this.onStartLearning,
    this.onStudyMore,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDoneForToday = currentLesson == null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        gradient: AppColor.todayLearningPlanGradient,
        border: Border.all(
          color: AppColor.secondarySoftBorder,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                RemixIcons.calendar_line,
                size: 16,
                color: AppColor.violet,
              ),
              const SizedBox(width: AppSpacing.s8),
              Text(
                l10n.lrTodayPlanTitle,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: AppColor.violet,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s12),

          if (isDoneForToday) ...[
            // Done for today state
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColor.successDim,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    RemixIcons.check_line,
                    size: 18,
                    color: AppColor.success,
                  ),
                ),
                const SizedBox(width: AppSpacing.s10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.lrTodayPlanDone,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.success,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s2),
                      Text(
                        l10n.lrTodayPlanStats(completedTodayCount, studyMinutesToday),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.fgSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onStudyMore,
                    icon: const Icon(RemixIcons.add_line, size: 14),
                    label: Text(l10n.lrTodayPlanStudyMore),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.violet,
                      side: BorderSide(color: AppColor.secondaryStrongBorder),
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Current lesson info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Active indicator
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColor.cyanDim,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryBorder,
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    RemixIcons.play_circle_fill,
                    size: 18,
                    color: AppColor.cyan,
                  ),
                ),
                const SizedBox(width: AppSpacing.s10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentLesson!.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.fg,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s2),
                      Text(
                        l10n.lrTodayPlanNextLesson(currentLesson!.estimatedMinutes),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.fgSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.s10),

            // Stats row
            Row(
              children: [
                _StatChip(
                  icon: RemixIcons.time_line,
                  label: l10n.lrTodayPlanMinutesToday(suggestedMinutesToday),
                ),
                const SizedBox(width: AppSpacing.s8),
                _StatChip(
                  icon: RemixIcons.check_line,
                  label: l10n.lrTodayPlanCompletedCount(completedTodayCount),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.s12),

            // Primary CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onStartLearning,
                icon: const Icon(RemixIcons.play_fill, size: 16),
                label: Text(l10n.lrTodayPlanStartLearning),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.cyan,
                  foregroundColor: AppColor.bgDeep,
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
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColor.surfaceHover,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColor.fgMuted),
          const SizedBox(width: AppSpacing.s4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColor.fgSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
