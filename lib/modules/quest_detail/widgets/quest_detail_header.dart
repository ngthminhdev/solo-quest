import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/quest_model.dart';
import '../../../models/enums/quest_enums.dart';

class QuestDetailHeader extends StatelessWidget {
  final QuestModel quest;

  const QuestDetailHeader({
    super.key,
    required this.quest,
  });

  Color get _typeColor {
    switch (quest.type) {
      case QuestType.water:
        return AppColor.chipWaterText;
      case QuestType.breakTime:
        return AppColor.chipBreakText;
      case QuestType.movement:
        return AppColor.chipMovementText;
      case QuestType.learning:
        return AppColor.chipLearningText;
      case QuestType.sleep:
        return AppColor.chipSleepText;
      case QuestType.fitness:
        return AppColor.chipFitnessText;
      default:
        return AppColor.cyan;
    }
  }

  Color get _typeBgColor {
    switch (quest.type) {
      case QuestType.water:
        return AppColor.chipWaterBg;
      case QuestType.breakTime:
        return AppColor.chipBreakBg;
      case QuestType.movement:
        return AppColor.chipMovementBg;
      case QuestType.learning:
        return AppColor.chipLearningBg;
      case QuestType.sleep:
        return AppColor.chipSleepBg;
      case QuestType.fitness:
        return AppColor.chipFitnessBg;
      default:
        return AppColor.cyanDim;
    }
  }

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
                color: _typeBgColor,
                border: Border.all(color: _typeColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: _typeColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  quest.type.iconText,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
        
            // Title
            Text(
              quest.title,
              style: const TextStyle(
                fontFamily: 'Exo2',
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
              style: const TextStyle(
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
    if (quest.scheduledAt == null) return '';
    final hour = quest.scheduledAt!.hour;
    String period;
    if (hour < 12) {
      period = 'Buổi sáng';
    } else if (hour < 18) {
      period = 'Buổi chiều';
    } else {
      period = 'Buổi tối';
    }
    return '$period · ${quest.displayTime}';
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;
    String text;

    switch (quest.status) {
      case QuestStatus.pending:
        bgColor = AppColor.cyanDim;
        textColor = AppColor.cyan;
        text = '● Cần làm';
      case QuestStatus.active:
        bgColor = AppColor.cyanDim;
        textColor = AppColor.cyan;
        text = '● Đang làm';
      case QuestStatus.completed:
        bgColor = AppColor.successDim;
        textColor = AppColor.success;
        text = '✓ Đã xong';
      case QuestStatus.skipped:
        bgColor = AppColor.surface;
        textColor = AppColor.fgMuted;
        text = '— Đã bỏ qua';
      case QuestStatus.snoozed:
        bgColor = AppColor.warnDim;
        textColor = AppColor.warn;
        text = '◷ Đã hoãn';
      case QuestStatus.expired:
        bgColor = AppColor.surface;
        textColor = AppColor.fgMuted;
        text = '○ Hết hạn';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s4 + 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
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
}
