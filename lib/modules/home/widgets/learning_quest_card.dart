import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/learning_quest_model.dart';
import '../../../widgets/app_progress_bar/app_progress_bar.dart';

class LearningQuestCard extends StatelessWidget {
  final LearningQuestModel quest;
  final ValueChanged<LearningQuestChecklistItem> onToggleItem;
  final VoidCallback onChooseMoreTopics;

  const LearningQuestCard({
    super.key,
    required this.quest,
    required this.onToggleItem,
    required this.onChooseMoreTopics,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
      ).copyWith(bottom: AppSpacing.s14),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        gradient: AppColor.questCyanGradient,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.borderGlowCyan),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColor.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColor.primaryBorder),
                ),
                child: Icon(
                  RemixIcons.book_open_line,
                  size: 20,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.isCompleted
                          ? l10n.lqCompletedToday
                          : quest.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      quest.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _ProgressPill(
                completedCount: quest.completedCount,
                totalCount: quest.totalCount,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s14),
          AppProgressBar(
            progress: quest.progress,
            height: 6,
            progressColor: quest.isCompleted
                ? AppColor.success
                : AppColor.primary,
          ),
          const SizedBox(height: AppSpacing.s12),
          ...quest.checklistItems.map(
            (item) =>
                _ChecklistRow(item: item, onTap: () => onToggleItem(item)),
          ),
          const SizedBox(height: AppSpacing.s12),
          OutlinedButton.icon(
            onPressed: onChooseMoreTopics,
            icon: const Icon(RemixIcons.add_line, size: 16),
            label: Text(l10n.lqChooseMoreTopics),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColor.primary,
              side: BorderSide(color: AppColor.borderGlowCyan),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s12,
                vertical: AppSpacing.s10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressPill extends StatelessWidget {
  final int completedCount;
  final int totalCount;

  const _ProgressPill({required this.completedCount, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColor.surfaceHover,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        l10n.lqTopicsCount(completedCount, totalCount),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColor.textSecondary,
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final LearningQuestChecklistItem item;
  final VoidCallback onTap;

  const _ChecklistRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.s8),
        padding: const EdgeInsets.all(AppSpacing.s10),
        decoration: BoxDecoration(
          color: item.completed
              ? AppColor.successBackground
              : AppColor.bgRaised,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: item.completed ? AppColor.successBorder : AppColor.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              item.completed
                  ? RemixIcons.checkbox_circle_fill
                  : RemixIcons.checkbox_blank_circle_line,
              size: 18,
              color: item.completed ? AppColor.success : AppColor.primary,
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.sourceTitle} — ${item.title}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: item.completed
                          ? AppColor.textSecondary
                          : AppColor.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
