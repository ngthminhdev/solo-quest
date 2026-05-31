import 'enums/quest_enums.dart';

class ProgressModel {
  final int level;

  /// EXP hiện tại trong level hiện tại. Dùng cho progress bar lên level.
  final int currentLevelExp;

  /// EXP cần để lên level tiếp theo.
  final int nextLevelExp;

  /// Tổng EXP tích lũy cả đời. Không bao giờ bị trừ.
  final int totalExp;

  /// Currency dùng để đổi thưởng. Có thể bị trừ khi claim reward.
  final int rewardPoints;

  final int streakDays;
  final int totalCompletedQuests;
  final int totalSkippedQuests;
  final double weeklyCompletionRate;
  final Map<QuestType, int> completedByType;

  /// Streak safety fields
  final int streakShields;
  final int lightDaysUsed;
  final int bestStreak;

  /// Weekly daily completion data (7 days: Mon-Sun)
  final List<DailyCompletion> weeklyDailyData;

  const ProgressModel({
    this.level = 1,
    this.currentLevelExp = 0,
    this.nextLevelExp = 100,
    this.totalExp = 0,
    this.rewardPoints = 0,
    this.streakDays = 0,
    this.totalCompletedQuests = 0,
    this.totalSkippedQuests = 0,
    this.weeklyCompletionRate = 0.0,
    this.completedByType = const {},
    this.streakShields = 2,
    this.lightDaysUsed = 0,
    this.bestStreak = 0,
    this.weeklyDailyData = const [],
  });

  double get levelProgress {
    if (nextLevelExp <= 0) return 0;
    return (currentLevelExp / nextLevelExp).clamp(0.0, 1.0);
  }

  int get expToNextLevel {
    final remaining = nextLevelExp - currentLevelExp;
    return remaining < 0 ? 0 : remaining;
  }

  int get weeklyTotalCompleted =>
      weeklyDailyData.fold(0, (sum, d) => sum + d.completed);

  int get weeklyTotalPlanned =>
      weeklyDailyData.fold(0, (sum, d) => sum + d.planned);

  ProgressModel copyWith({
    int? level,
    int? currentLevelExp,
    int? nextLevelExp,
    int? totalExp,
    int? rewardPoints,
    int? streakDays,
    int? totalCompletedQuests,
    int? totalSkippedQuests,
    double? weeklyCompletionRate,
    Map<QuestType, int>? completedByType,
    int? streakShields,
    int? lightDaysUsed,
    int? bestStreak,
    List<DailyCompletion>? weeklyDailyData,
  }) {
    return ProgressModel(
      level: level ?? this.level,
      currentLevelExp: currentLevelExp ?? this.currentLevelExp,
      nextLevelExp: nextLevelExp ?? this.nextLevelExp,
      totalExp: totalExp ?? this.totalExp,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      streakDays: streakDays ?? this.streakDays,
      totalCompletedQuests: totalCompletedQuests ?? this.totalCompletedQuests,
      totalSkippedQuests: totalSkippedQuests ?? this.totalSkippedQuests,
      weeklyCompletionRate: weeklyCompletionRate ?? this.weeklyCompletionRate,
      completedByType: completedByType ?? this.completedByType,
      streakShields: streakShields ?? this.streakShields,
      lightDaysUsed: lightDaysUsed ?? this.lightDaysUsed,
      bestStreak: bestStreak ?? this.bestStreak,
      weeklyDailyData: weeklyDailyData ?? this.weeklyDailyData,
    );
  }

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    final byType = <QuestType, int>{};
    if (json['completed_by_type'] != null) {
      (json['completed_by_type'] as Map<String, dynamic>).forEach((key, value) {
        byType[QuestType.values.byName(key)] = value as int;
      });
    }

    final dailyData = <DailyCompletion>[];
    if (json['weekly_daily_data'] != null) {
      for (final item in json['weekly_daily_data'] as List<dynamic>) {
        dailyData.add(DailyCompletion.fromJson(item as Map<String, dynamic>));
      }
    }

    return ProgressModel(
      level: json['level'] as int? ?? 1,
      currentLevelExp: json['current_level_exp'] as int? ??
          json['current_exp'] as int? ??
          0,
      nextLevelExp: json['next_level_exp'] as int? ?? 100,
      totalExp: json['total_exp'] as int? ??
          json['total_earned_exp'] as int? ??
          0,
      rewardPoints: json['reward_points'] as int? ?? 0,
      streakDays: json['streak_days'] as int? ?? 0,
      totalCompletedQuests: json['total_completed_quests'] as int? ?? 0,
      totalSkippedQuests: json['total_skipped_quests'] as int? ?? 0,
      weeklyCompletionRate:
          (json['weekly_completion_rate'] as num?)?.toDouble() ?? 0.0,
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

class DailyCompletion {
  final String dayLabel;
  final int completed;
  final int planned;

  const DailyCompletion({
    required this.dayLabel,
    required this.completed,
    required this.planned,
  });

  double get rate => planned == 0 ? 0.0 : (completed / planned).clamp(0.0, 1.0);

  factory DailyCompletion.fromJson(Map<String, dynamic> json) {
    return DailyCompletion(
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
