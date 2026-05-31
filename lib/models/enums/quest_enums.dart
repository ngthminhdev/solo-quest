import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

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
}
