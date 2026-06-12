import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../core/utils/app_time_formatter.dart';
import '../../../models/quest_model.dart';
import '../../../models/enums/quest_enums.dart';
import '../../quests/ui/quest_ui_extensions.dart';

class QuestDetailHeader extends StatelessWidget {
  final QuestModel quest;

  const QuestDetailHeader({
    super.key,
    required this.quest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Quest icon with glow
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: quest.type.chipBackgroundColor,
                border: Border.all(color: quest.type.chipTextColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: quest.type.chipTextColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Center(
                child: Icon(quest.type.icon, size: 22, color: quest.type.chipTextColor),
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
        
            // Title
            Text(
              quest.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.fg,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s4),
        
            // Subtitle (time)
            Text(
              _getTimeOfDay(),
              style: TextStyle(
                fontSize: 13,
                color: AppColor.fgSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
        
            // Status badge
            _buildStatusBadge(),
          ],
        ),
      ),
    );
  }

  String _getTimeOfDay() {
    // Use reminderTime if available, otherwise no time context
    final timeToCheck = quest.reminderTime;
    if (timeToCheck == null) return '';

    final local = AppTimeFormatter.toLocalDisplay(timeToCheck);
    if (local == null) return '';

    final hour = local.hour;
    String period;
    if (hour < 12) {
      period = 'Buổi sáng';
    } else if (hour < 18) {
      period = 'Buổi chiều';
    } else {
      period = 'Buổi tối';
    }
    final time = quest.displayTime;
    if (time == null) return period;
    return '$period · $time';
  }

  Widget _buildStatusBadge() {
    final bgColor = quest.status.backgroundColor;
    final textColor = quest.status.color;
    final text = _statusText(quest.status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s4 + 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _statusText(QuestStatus status) {
    switch (status) {
      case QuestStatus.pending:
        return '● Cần làm';
      case QuestStatus.active:
        return '● Đang làm';
      case QuestStatus.completed:
        return '✓ Đã xong';
      case QuestStatus.skipped:
        return '— Đã bỏ qua';
      case QuestStatus.snoozed:
        return '◷ Đã hoãn';
      case QuestStatus.expired:
        return '○ Hết hạn';
    }
  }
}
