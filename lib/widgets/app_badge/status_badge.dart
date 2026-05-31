import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../models/enums/quest_enums.dart';

class StatusBadge extends StatelessWidget {
  final QuestStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _dotColor,
            boxShadow: status == QuestStatus.active
                ? [BoxShadow(color: AppColor.cyanGlow, blurRadius: 8)]
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          _label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
      ],
    );
  }

  String get _label {
    switch (status) {
      case QuestStatus.pending:
        return 'Chờ';
      case QuestStatus.active:
        return 'Đang làm';
      case QuestStatus.completed:
        return 'Xong';
      case QuestStatus.skipped:
        return 'Bỏ qua';
      case QuestStatus.snoozed:
        return 'Hoãn';
      case QuestStatus.expired:
        return 'Hết hạn';
    }
  }

  Color get _dotColor {
    switch (status) {
      case QuestStatus.pending:
        return AppColor.fgMuted;
      case QuestStatus.active:
        return AppColor.cyan;
      case QuestStatus.completed:
        return AppColor.success;
      case QuestStatus.skipped:
        return AppColor.fgMuted;
      case QuestStatus.snoozed:
        return AppColor.warn;
      case QuestStatus.expired:
        return AppColor.fgMuted;
    }
  }

  Color get _textColor {
    switch (status) {
      case QuestStatus.pending:
        return AppColor.fgMuted;
      case QuestStatus.active:
        return AppColor.cyan;
      case QuestStatus.completed:
        return AppColor.success;
      case QuestStatus.skipped:
        return AppColor.fgMuted;
      case QuestStatus.snoozed:
        return AppColor.warn;
      case QuestStatus.expired:
        return AppColor.fgMuted;
    }
  }
}
