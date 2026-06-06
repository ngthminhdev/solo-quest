import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../models/enums/quest_enums.dart';

/// UI-only extension for QuestType — colors, icons, and emoji fallbacks.
/// Separated from domain enum file to avoid circular imports with AppColor.
extension QuestTypeUiX on QuestType {
  IconData get icon {
    switch (this) {
      case QuestType.water:
        return RemixIcons.drop_line;
      case QuestType.breakTime:
        return RemixIcons.eye_line;
      case QuestType.movement:
        return RemixIcons.walk_line;
      case QuestType.learning:
        return RemixIcons.book_open_line;
      case QuestType.sleep:
        return RemixIcons.moon_line;
      case QuestType.fitness:
        return RemixIcons.heart_pulse_line;
      case QuestType.mindfulness:
        return RemixIcons.mental_health_line;
      case QuestType.review:
        return RemixIcons.file_list_3_line;
      case QuestType.custom:
        return RemixIcons.star_line;
    }
  }

  String get iconText {
    switch (this) {
      case QuestType.water:
        return '💧';
      case QuestType.breakTime:
        return '☕';
      case QuestType.movement:
        return '🚶';
      case QuestType.learning:
        return '📚';
      case QuestType.sleep:
        return '😴';
      case QuestType.fitness:
        return '💪';
      case QuestType.mindfulness:
        return '🧘';
      case QuestType.review:
        return '📝';
      case QuestType.custom:
        return '⭐';
    }
  }

  Color get chipBackgroundColor {
    switch (this) {
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

  Color get chipTextColor {
    switch (this) {
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

/// UI-only extension for QuestStatus — canonical status colors.
/// Widgets that need different visual styles should pass explicit params instead of
/// duplicating switch logic.
extension QuestStatusUiX on QuestStatus {
  Color get color {
    switch (this) {
      case QuestStatus.completed:
        return AppColor.success;
      case QuestStatus.active:
        return AppColor.cyan;
      case QuestStatus.snoozed:
        return AppColor.warn;
      case QuestStatus.skipped:
        return AppColor.fgMuted;
      case QuestStatus.pending:
        return AppColor.fgMuted;
      case QuestStatus.expired:
        return AppColor.fgMuted;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case QuestStatus.completed:
        return AppColor.successDim;
      case QuestStatus.active:
        return AppColor.cyanDim;
      case QuestStatus.snoozed:
        return AppColor.warnDim;
      case QuestStatus.skipped:
        return AppColor.surface;
      case QuestStatus.pending:
        return AppColor.cyanDim;
      case QuestStatus.expired:
        return AppColor.surface;
    }
  }
}

/// UI-only extension for QuestDifficulty — canonical difficulty colors.
extension QuestDifficultyUiX on QuestDifficulty {
  Color get color {
    switch (this) {
      case QuestDifficulty.easy:
        return AppColor.success;
      case QuestDifficulty.medium:
        return AppColor.warn;
      case QuestDifficulty.hard:
        return AppColor.danger;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case QuestDifficulty.easy:
        return AppColor.successDim;
      case QuestDifficulty.medium:
        return AppColor.warnDim;
      case QuestDifficulty.hard:
        return AppColor.dangerDim;
    }
  }
}
