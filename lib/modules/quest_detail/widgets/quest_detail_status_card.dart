import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../core/utils/app_time_formatter.dart';
import '../../../models/quest_model.dart';

class QuestDetailStatusCard extends StatelessWidget {
  final QuestModel quest;

  const QuestDetailStatusCard({
    super.key,
    required this.quest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuickStat(
                icon: RemixIcons.time_line,
                value: '${quest.estimatedMinutes} phút',
              ),
              const SizedBox(width: AppSpacing.s16),
              _buildQuickStat(
                icon: RemixIcons.star_fill,
                value: '+${quest.exp} EXP',
                isExp: true,
              ),
            ],
          ),
          // Time info row (due date, snoozed until, completed at)
          if (_getTimeInfo() != null) ...[
            const SizedBox(height: AppSpacing.s12),
            Container(
              padding: const EdgeInsets.only(top: AppSpacing.s12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColor.border.withValues(alpha: 0.5)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getTimeIcon(),
                    size: 14,
                    color: _getTimeColor(),
                  ),
                  const SizedBox(width: AppSpacing.s6),
                  Text(
                    _getTimeInfo()!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _getTimeColor(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getTimeIcon() {
    if (quest.completedAt != null) return RemixIcons.checkbox_circle_line;
    if (quest.snoozedUntil != null) return RemixIcons.time_line;
    if (quest.reminderTime != null) return RemixIcons.notification_3_line;
    if (quest.dueDate != null) return RemixIcons.calendar_line;
    return RemixIcons.time_line;
  }

  Color _getTimeColor() {
    if (quest.completedAt != null) return AppColor.success;
    if (quest.snoozedUntil != null) return AppColor.warn;
    return AppColor.fgSecondary;
  }

  String? _getTimeInfo() {
    // Priority: completedAt > snoozedUntil > reminderTime > dueDate
    if (quest.completedAt != null) {
      return AppTimeFormatter.formatCompletedAt(quest.completedAt);
    }
    if (quest.snoozedUntil != null) {
      return AppTimeFormatter.formatSnoozedUntil(quest.snoozedUntil);
    }
    if (quest.reminderTime != null) {
      return AppTimeFormatter.formatReminderTime(quest.reminderTime);
    }
    if (quest.dueDate != null) {
      return 'Hạn ${AppTimeFormatter.formatLocalDate(quest.dueDate)}';
    }
    return null;
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String value,
    bool isExp = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: isExp ? AppColor.expGold : AppColor.fgMuted,
        ),
        const SizedBox(width: AppSpacing.s6),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isExp ? AppColor.expGold : AppColor.fg,
          ),
        ),
      ],
    );
  }
}
