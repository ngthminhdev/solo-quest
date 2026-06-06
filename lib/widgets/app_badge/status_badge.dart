import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../models/enums/quest_enums.dart';
import '../../modules/quests/ui/quest_ui_extensions.dart';

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
            color: status.color,
            boxShadow: status == QuestStatus.active
                ? [BoxShadow(color: AppColor.cyanGlow, blurRadius: 8)]
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          status.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: status.color,
          ),
        ),
      ],
    );
  }
}
