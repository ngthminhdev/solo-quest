import '../../../models/enums/quest_enums.dart';
import '../../utils/date_time_parser.dart';
import '../../utils/enum_mapper.dart';

/// Progress data from /api/progress
class ProgressDto {
  final int level;
  final int currentLevelExp;
  final int nextLevelExp;
  final int totalExp;
  final int rewardPoints;
  final int streakDays;
  final int totalCompletedQuests;
  final int totalSkippedQuests;
  final double weeklyCompletionRate;
  final Map<QuestType, int> completedByType;
  final int streakShields;
  final int lightDaysUsed;
  final int bestStreak;
  final List<DailyCompletionDto> weeklyDailyData;

  ProgressDto({
    required this.level,
    required this.currentLevelExp,
    required this.nextLevelExp,
    required this.totalExp,
    required this.rewardPoints,
    required this.streakDays,
    required this.totalCompletedQuests,
    required this.totalSkippedQuests,
    required this.weeklyCompletionRate,
    required this.completedByType,
    required this.streakShields,
    required this.lightDaysUsed,
    required this.bestStreak,
    required this.weeklyDailyData,
  });

  factory ProgressDto.fromJson(Map<String, dynamic> json) {
    final byType = <QuestType, int>{};
    if (json['completed_by_type'] != null) {
      (json['completed_by_type'] as Map<String, dynamic>).forEach((key, value) {
        final questType = parseQuestType(key);
        byType[questType] = value as int;
      });
    }

    final dailyData = <DailyCompletionDto>[];
    if (json['weekly_daily_data'] != null) {
      for (final item in json['weekly_daily_data'] as List<dynamic>) {
        dailyData.add(DailyCompletionDto.fromJson(item as Map<String, dynamic>));
      }
    }

    return ProgressDto(
      level: json['level'] as int? ?? 1,
      currentLevelExp: json['current_level_exp'] as int? ?? 0,
      nextLevelExp: json['next_level_exp'] as int? ?? 100,
      totalExp: json['total_exp'] as int? ?? 0,
      rewardPoints: json['reward_points'] as int? ?? 0,
      streakDays: json['streak_days'] as int? ?? 0,
      totalCompletedQuests: json['total_completed_quests'] as int? ?? 0,
      totalSkippedQuests: json['total_skipped_quests'] as int? ?? 0,
      weeklyCompletionRate: (json['weekly_completion_rate'] as num?)?.toDouble() ?? 0.0,
      completedByType: byType,
      streakShields: json['streak_shields'] as int? ?? 2,
      lightDaysUsed: json['light_days_used'] as int? ?? 0,
      bestStreak: json['best_streak'] as int? ?? 0,
      weeklyDailyData: dailyData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'current_level_exp': currentLevelExp,
      'next_level_exp': nextLevelExp,
      'total_exp': totalExp,
      'reward_points': rewardPoints,
      'streak_days': streakDays,
      'total_completed_quests': totalCompletedQuests,
      'total_skipped_quests': totalSkippedQuests,
      'weekly_completion_rate': weeklyCompletionRate,
      'completed_by_type': completedByType.map((k, v) => MapEntry(k.name, v)),
      'streak_shields': streakShields,
      'light_days_used': lightDaysUsed,
      'best_streak': bestStreak,
      'weekly_daily_data': weeklyDailyData.map((d) => d.toJson()).toList(),
    };
  }
}

/// Daily completion data
class DailyCompletionDto {
  final String dayLabel;
  final int completed;
  final int planned;

  DailyCompletionDto({
    required this.dayLabel,
    required this.completed,
    required this.planned,
  });

  factory DailyCompletionDto.fromJson(Map<String, dynamic> json) {
    return DailyCompletionDto(
      dayLabel: json['day_label'] as String,
      completed: json['completed'] as int? ?? 0,
      planned: json['planned'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_label': dayLabel,
      'completed': completed,
      'planned': planned,
    };
  }
}

/// Weekly chart data from /api/progress/weekly-chart
class WeeklyChartDto {
  final List<DailyCompletionDto> days;
  final int totalCompleted;
  final int totalPlanned;
  final double completionRate;

  WeeklyChartDto({
    required this.days,
    required this.totalCompleted,
    required this.totalPlanned,
    required this.completionRate,
  });

  factory WeeklyChartDto.fromJson(Map<String, dynamic> json) {
    final days = <DailyCompletionDto>[];
    if (json['days'] != null) {
      for (final item in json['days'] as List<dynamic>) {
        days.add(DailyCompletionDto.fromJson(item as Map<String, dynamic>));
      }
    }

    return WeeklyChartDto(
      days: days,
      totalCompleted: json['total_completed'] as int? ?? 0,
      totalPlanned: json['total_planned'] as int? ?? 0,
      completionRate: (json['completion_rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days.map((d) => d.toJson()).toList(),
      'total_completed': totalCompleted,
      'total_planned': totalPlanned,
      'completion_rate': completionRate,
    };
  }
}

/// XP history from /api/progress/xp-history
class XPHistoryDto {
  final List<XPTransactionDto> transactions;
  final int total;
  final int limit;
  final int offset;

  XPHistoryDto({
    required this.transactions,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory XPHistoryDto.fromJson(Map<String, dynamic> json) {
    final transactions = <XPTransactionDto>[];
    if (json['transactions'] != null) {
      for (final item in json['transactions'] as List<dynamic>) {
        transactions.add(XPTransactionDto.fromJson(item as Map<String, dynamic>));
      }
    }

    return XPHistoryDto(
      transactions: transactions,
      total: json['total'] as int? ?? 0,
      limit: json['limit'] as int? ?? 20,
      offset: json['offset'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'total': total,
      'limit': limit,
      'offset': offset,
    };
  }
}

/// XP transaction
class XPTransactionDto {
  final String id;
  final String type;
  final int amount;
  final String? questId;
  final String? questTitle;
  final String description;
  final DateTime createdAt;

  XPTransactionDto({
    required this.id,
    required this.type,
    required this.amount,
    this.questId,
    this.questTitle,
    required this.description,
    required this.createdAt,
  });

  factory XPTransactionDto.fromJson(Map<String, dynamic> json) {
    return XPTransactionDto(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: json['amount'] as int? ?? 0,
      questId: json['quest_id'] as String?,
      questTitle: json['quest_title'] as String?,
      description: json['description'] as String? ?? '',
      createdAt: parseUtcDateTime(json['created_at'] as String?) ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'quest_id': questId,
      'quest_title': questTitle,
      'description': description,
      'created_at': formatUtcDateTime(createdAt),
    };
  }
}
