import '../../generated/l10n/app_localizations.dart';

enum QuestType {
  water,
  breakTime,
  movement,
  learning,
  sleep,
  fitness,
  mindfulness,
  review,
  custom,
}

enum QuestStatus { pending, active, completed, skipped, snoozed, expired }

enum QuestDifficulty { easy, medium, hard }

enum QuestSource {
  dailyPlan,
  morningCheckin,
  scheduleRule,
  learningGoal,
  manual,
  systemSuggestion,
}

enum QuestActionType { start, complete, snooze, skip, viewReason }

enum QuestPriority { highest, high, medium, low, lowest }

extension QuestTypeX on QuestType {
  String get label {
    switch (this) {
      case QuestType.water:
        return 'Uống nước';
      case QuestType.breakTime:
        return 'Nghỉ giải lao';
      case QuestType.movement:
        return 'Vận động';
      case QuestType.learning:
        return 'Học tập';
      case QuestType.sleep:
        return 'Ngủ nghỉ';
      case QuestType.fitness:
        return 'Thể chất';
      case QuestType.mindfulness:
        return 'Tĩnh tâm';
      case QuestType.review:
        return 'Tổng kết';
      case QuestType.custom:
        return 'Tùy chỉnh';
    }
  }

  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case QuestType.water:
        return l10n.questTypeWater;
      case QuestType.breakTime:
        return l10n.questTypeBreak;
      case QuestType.movement:
        return l10n.questTypeMovement;
      case QuestType.learning:
        return l10n.questTypeLearning;
      case QuestType.sleep:
        return l10n.questTypeSleep;
      case QuestType.fitness:
        return l10n.questTypeFitness;
      case QuestType.mindfulness:
        return l10n.questTypeMindfulness;
      case QuestType.review:
        return l10n.questTypeReview;
      case QuestType.custom:
        return l10n.questTypeCustom;
    }
  }
}

extension QuestStatusX on QuestStatus {
  String get label {
    switch (this) {
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

  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case QuestStatus.pending:
        return l10n.statusPending;
      case QuestStatus.active:
        return l10n.statusActive;
      case QuestStatus.completed:
        return l10n.statusCompleted;
      case QuestStatus.skipped:
        return l10n.statusSkipped;
      case QuestStatus.snoozed:
        return l10n.statusSnoozed;
      case QuestStatus.expired:
        return l10n.statusExpired;
    }
  }
}

extension QuestDifficultyX on QuestDifficulty {
  String get label {
    switch (this) {
      case QuestDifficulty.easy:
        return 'Dễ';
      case QuestDifficulty.medium:
        return 'Vừa';
      case QuestDifficulty.hard:
        return 'Khó';
    }
  }

  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case QuestDifficulty.easy:
        return l10n.difficultyEasy;
      case QuestDifficulty.medium:
        return l10n.difficultyMedium;
      case QuestDifficulty.hard:
        return l10n.difficultyHard;
    }
  }

  String get description {
    switch (this) {
      case QuestDifficulty.easy:
        return 'Quest nhỏ, dễ hoàn thành.';
      case QuestDifficulty.medium:
        return 'Cần tập trung hoặc vận động nhẹ.';
      case QuestDifficulty.hard:
        return 'Cần nhiều năng lượng/thời gian hơn.';
    }
  }

  String getLocalizedDescription(AppLocalizations l10n) {
    switch (this) {
      case QuestDifficulty.easy:
        return l10n.difficultyEasyDesc;
      case QuestDifficulty.medium:
        return l10n.difficultyMediumDesc;
      case QuestDifficulty.hard:
        return l10n.difficultyHardDesc;
    }
  }
}

extension QuestPriorityX on QuestPriority {
  String get label {
    switch (this) {
      case QuestPriority.highest:
        return 'Cao nhất';
      case QuestPriority.high:
        return 'Cao';
      case QuestPriority.medium:
        return 'Vừa';
      case QuestPriority.low:
        return 'Thấp';
      case QuestPriority.lowest:
        return 'Thấp nhất';
    }
  }

  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case QuestPriority.highest:
        return l10n.priorityHighest;
      case QuestPriority.high:
        return l10n.priorityHigh;
      case QuestPriority.medium:
        return l10n.priorityMedium;
      case QuestPriority.low:
        return l10n.priorityLow;
      case QuestPriority.lowest:
        return l10n.priorityLowest;
    }
  }

  int get value {
    switch (this) {
      case QuestPriority.highest:
        return 5;
      case QuestPriority.high:
        return 4;
      case QuestPriority.medium:
        return 3;
      case QuestPriority.low:
        return 2;
      case QuestPriority.lowest:
        return 1;
    }
  }

  static QuestPriority fromValue(int value) {
    switch (value) {
      case 5:
        return QuestPriority.highest;
      case 4:
        return QuestPriority.high;
      case 3:
        return QuestPriority.medium;
      case 2:
        return QuestPriority.low;
      case 1:
      default:
        return QuestPriority.lowest;
    }
  }
}
