import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import '../../models/enums/quest_enums.dart';

class QuestTypeChip extends StatelessWidget {
  final QuestType type;

  const QuestTypeChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        type.label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.04,
          color: _textColor,
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (type) {
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
      case QuestType.mindfulness:
        return AppColor.violetDim;
      case QuestType.review:
        return AppColor.violetDim;
      case QuestType.custom:
        return AppColor.cyanDim;
    }
  }

  Color get _textColor {
    switch (type) {
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
      case QuestType.mindfulness:
        return AppColor.violet;
      case QuestType.review:
        return AppColor.violet;
      case QuestType.custom:
        return AppColor.cyan;
    }
  }
}
