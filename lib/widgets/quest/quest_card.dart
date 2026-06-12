import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import '../../models/enums/quest_enums.dart';
import '../../models/quest_model.dart';
import '../app_badge/quest_type_chip.dart';
import '../app_badge/exp_badge.dart';

class QuestCard extends StatelessWidget {
  final QuestModel quest;
  final bool highlighted;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final VoidCallback? onComplete;
  final VoidCallback? onSnooze;
  final VoidCallback? onSkip;
  final VoidCallback? onViewReason;
  final bool isActionPending;

  const QuestCard({
    super.key,
    required this.quest,
    this.highlighted = false,
    this.onTap,
    this.onStart,
    this.onComplete,
    this.onSnooze,
    this.onSkip,
    this.onViewReason,
    this.isActionPending = false,
  });

  @override
  Widget build(BuildContext context) {
    if (highlighted) return _buildActiveCard();
    return _buildCompactCard();
  }

  String _getPriorityLabel() {
    if (quest.isImportant) return 'Ưu tiên cao';
    switch (quest.difficulty) {
      case QuestDifficulty.hard:
        return 'Ưu tiên cao';
      case QuestDifficulty.medium:
        return 'Ưu tiên vừa';
      case QuestDifficulty.easy:
        return 'Ưu tiên thấp';
    }
  }

  Color _getPriorityColor() {
    if (quest.isImportant || quest.difficulty == QuestDifficulty.hard) {
      return AppColor.cyan;
    }
    if (quest.difficulty == QuestDifficulty.medium) {
      return AppColor.warn;
    }
    return AppColor.textSecondary;
  }

  Color _getPriorityBgColor() {
    if (quest.isImportant || quest.difficulty == QuestDifficulty.hard) {
      return AppColor.cyanDim;
    }
    if (quest.difficulty == QuestDifficulty.medium) {
      return AppColor.warnDim;
    }
    return AppColor.surfaceHover;
  }

  Widget _buildActiveCard() {
    final isQuestActive = quest.isActive;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColor.activeQuestReadableGradient,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColor.borderGlowCyan),
          boxShadow: [
            BoxShadow(
              color: AppColor.primarySubtleOverlay,
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _getPriorityBgColor(),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(RemixIcons.star_fill, size: 10, color: _getPriorityColor()),
                      const SizedBox(width: 4),
                      Text(
                        _getPriorityLabel(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _getPriorityColor(),
                          letterSpacing: 0.04,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (quest.displayTime != null) ...[
              Text(
                quest.displayTime!,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColor.cyan,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              quest.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.fg,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              quest.description,
              style: TextStyle(
                fontSize: 14,
                color: AppColor.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                QuestTypeChip(type: quest.type),
                const SizedBox(width: 12),
                if (quest.estimatedMinutes > 0) ...[
                  Icon(RemixIcons.time_line, size: 16, color: AppColor.textSecondary),
                  const SizedBox(width: 5),
                  Text(
                    '${quest.estimatedMinutes} phút',
                    style: TextStyle(fontSize: 13, color: AppColor.textSecondary),
                  ),
                ],
                const Spacer(),
                ExpBadge(exp: quest.exp),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _actionButton(
                    label: isQuestActive ? 'Hoàn Thành' : 'Bắt Đầu',
                    color: AppColor.cyan,
                    textColor: AppColor.bgDeep,
                    onTap: isQuestActive ? onComplete : onStart,
                    isLoading: isActionPending,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _actionButton(
                    label: 'Hoãn',
                    color: AppColor.warningBackground,
                    textColor: AppColor.warn,
                    border: Border.all(color: AppColor.warnGlow),
                    onTap: isActionPending ? null : onSnooze,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _actionButton(
                    label: 'Bỏ Qua',
                    color: AppColor.surface.withValues(alpha: 0.75),
                    textColor: AppColor.textSecondary,
                    border: Border.all(color: AppColor.borderGlowCyan),
                    onTap: isActionPending ? null : onSkip,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard() {
    final isCompleted = quest.isCompleted;
    final isSnoozed = quest.isSnoozed;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isCompleted ? 0.55 : 1.0,
        child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSnoozed
                ? AppColor.warnDim
                : AppColor.border,
          ),
        ),
        child: Row(
          children: [
            if (quest.displayTime != null) ...[
              if (!isCompleted) ...[
                Text(
                  quest.displayTime!,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fg,
                  ),
                ),
              ] else ...[
                Text(
                  quest.displayTime!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fgSecondary,
                  ),
                ),
              ],
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? AppColor.fgSecondary : AppColor.fg,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    quest.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isCompleted ? AppColor.fgMuted : AppColor.fgSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isCompleted) ...[
              Icon(RemixIcons.checkbox_circle_line, size: 16, color: AppColor.success),
              if (quest.displayTime != null) ...[
                const SizedBox(width: 4),
                Text(
                  quest.displayTime!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColor.success,
                  ),
                ),
              ],
              const SizedBox(width: 6),
              ExpBadge(exp: quest.exp),
            ] else if (isSnoozed) ...[
              Icon(RemixIcons.time_line, size: 16, color: AppColor.warn),
              const SizedBox(width: 4),
              Text(
                'Đã hoãn',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColor.warn,
                ),
              ),
            ] else ...[
              ExpBadge(exp: quest.exp),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: isActionPending ? null : onComplete,
                child: Opacity(
                  opacity: isActionPending ? 0.6 : 1.0,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: AppColor.borderGlowCyan),
                      color: AppColor.bgRaised,
                    ),
                    child: Center(
                      child: isActionPending
                          ? SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.cyan),
                              ),
                            )
                          : Icon(RemixIcons.check_line, size: 16, color: AppColor.cyan),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required Color textColor,
    Border? border,
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Opacity(
        opacity: isLoading ? 0.6 : 1.0,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: border,
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
