import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/enums/quest_enums.dart';
import '../../../widgets/app_form/app_option_card.dart';

class QuestDifficultySelector extends StatelessWidget {
  final QuestDifficulty value;
  final ValueChanged<QuestDifficulty> onChanged;

  const QuestDifficultySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: QuestDifficulty.values.map((difficulty) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s8),
          child: AppOptionCard(
            title: difficulty.label,
            subtitle: difficulty.description,
            selected: value == difficulty,
            leading: Icon(
              _iconFor(difficulty),
              size: 18,
              color: value == difficulty ? AppColor.cyan : AppColor.fgMuted,
            ),
            onTap: () => onChanged(difficulty),
          ),
        );
      }).toList(),
    );
  }

  IconData _iconFor(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return RemixIcons.leaf_line;
      case QuestDifficulty.medium:
        return RemixIcons.flashlight_line;
      case QuestDifficulty.hard:
        return RemixIcons.fire_line;
    }
  }
}
