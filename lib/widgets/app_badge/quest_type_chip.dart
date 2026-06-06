import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../models/enums/quest_enums.dart';
import '../../modules/quests/ui/quest_ui_extensions.dart';

class QuestTypeChip extends StatelessWidget {
  final QuestType type;

  const QuestTypeChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: type.chipBackgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        type.label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.04,
          color: type.chipTextColor,
        ),
      ),
    );
  }
}
