import 'enums/quest_enums.dart';

class WeeklyDailyBreakdown {
  final DateTime date;
  final int completed;
  final int skipped;
  final int total;
  final double rate;

  const WeeklyDailyBreakdown({
    required this.date,
    required this.completed,
    this.skipped = 0,
    required this.total,
    required this.rate,
  });
}

class WeeklyCategoryBreakdown {
  final String category;
  final int completed;
  final int total;
  final double rate;

  const WeeklyCategoryBreakdown({
    required this.category,
    required this.completed,
    required this.total,
    required this.rate,
  });

  String get displayLabel {
    try {
      final type = QuestType.values.byName(category);
      return type.label;
    } catch (_) {
      return _fallbackCategoryLabel(category);
    }
  }
}

class WeeklySuggestion {
  final String id;
  final String title;
  final String description;
  final String type;
  final bool actionable;

  const WeeklySuggestion({
    required this.id,
    required this.title,
    required this.description,
    this.type = 'general',
    this.actionable = true,
  });
}

class WeeklySummaryModel {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int completedQuestCount;
  final int skippedQuestCount;
  final int earnedExp;
  final double completionRate;
  final int streakDays;
  final int reviewedDays;
  final int totalDays;
  final String? bestCategory;
  final String? weakestCategory;
  final List<WeeklyDailyBreakdown> dailyBreakdown;
  final List<WeeklyCategoryBreakdown> categoryBreakdown;
  final List<String> insights;
  final List<WeeklySuggestion> suggestions;
  final String? aiSummary;
  final String? nextWeekFocus;

  // Legacy fields kept for backward compatibility with existing widgets
  final List<String> suggestedAdjustments;
  final Map<QuestType, int> completedByType;

  const WeeklySummaryModel({
    required this.weekStart,
    required this.weekEnd,
    this.completedQuestCount = 0,
    this.skippedQuestCount = 0,
    this.earnedExp = 0,
    this.completionRate = 0.0,
    this.streakDays = 0,
    this.reviewedDays = 0,
    this.totalDays = 7,
    this.bestCategory,
    this.weakestCategory,
    this.dailyBreakdown = const [],
    this.categoryBreakdown = const [],
    this.insights = const [],
    this.suggestions = const [],
    this.aiSummary,
    this.nextWeekFocus,
    this.suggestedAdjustments = const [],
    this.completedByType = const {},
  });

  WeeklySummaryModel copyWith({
    DateTime? weekStart,
    DateTime? weekEnd,
    int? completedQuestCount,
    int? skippedQuestCount,
    int? earnedExp,
    double? completionRate,
    int? streakDays,
    int? reviewedDays,
    int? totalDays,
    String? bestCategory,
    String? weakestCategory,
    List<WeeklyDailyBreakdown>? dailyBreakdown,
    List<WeeklyCategoryBreakdown>? categoryBreakdown,
    List<String>? insights,
    List<WeeklySuggestion>? suggestions,
    String? aiSummary,
    String? nextWeekFocus,
    List<String>? suggestedAdjustments,
    Map<QuestType, int>? completedByType,
  }) {
    return WeeklySummaryModel(
      weekStart: weekStart ?? this.weekStart,
      weekEnd: weekEnd ?? this.weekEnd,
      completedQuestCount: completedQuestCount ?? this.completedQuestCount,
      skippedQuestCount: skippedQuestCount ?? this.skippedQuestCount,
      earnedExp: earnedExp ?? this.earnedExp,
      completionRate: completionRate ?? this.completionRate,
      streakDays: streakDays ?? this.streakDays,
      reviewedDays: reviewedDays ?? this.reviewedDays,
      totalDays: totalDays ?? this.totalDays,
      bestCategory: bestCategory ?? this.bestCategory,
      weakestCategory: weakestCategory ?? this.weakestCategory,
      dailyBreakdown: dailyBreakdown ?? this.dailyBreakdown,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      insights: insights ?? this.insights,
      suggestions: suggestions ?? this.suggestions,
      aiSummary: aiSummary ?? this.aiSummary,
      nextWeekFocus: nextWeekFocus ?? this.nextWeekFocus,
      suggestedAdjustments: suggestedAdjustments ?? this.suggestedAdjustments,
      completedByType: completedByType ?? this.completedByType,
    );
  }

  factory WeeklySummaryModel.fromJson(Map<String, dynamic> json) {
    final byType = <QuestType, int>{};
    if (json['completed_by_type'] != null) {
      (json['completed_by_type'] as Map<String, dynamic>).forEach((key, value) {
        byType[QuestType.values.byName(key)] = value as int;
      });
    }
    return WeeklySummaryModel(
      weekStart: DateTime.parse(json['week_start'] as String),
      weekEnd: DateTime.parse(json['week_end'] as String),
      completedQuestCount: json['completed_quest_count'] as int? ?? 0,
      skippedQuestCount: json['skipped_quest_count'] as int? ?? 0,
      earnedExp: json['earned_exp'] as int? ?? 0,
      completionRate: (json['completion_rate'] as num?)?.toDouble() ?? 0.0,
      streakDays: json['streak_days'] as int? ?? 0,
      reviewedDays: json['reviewed_days'] as int? ?? 0,
      totalDays: json['total_days'] as int? ?? 7,
      bestCategory: json['best_category'] as String?,
      weakestCategory: json['weakest_category'] as String?,
      insights: (json['insights'] as List<dynamic>?)?.cast<String>() ?? [],
      suggestedAdjustments:
          (json['suggested_adjustments'] as List<dynamic>?)?.cast<String>() ??
              [],
      completedByType: byType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week_start': weekStart.toIso8601String(),
      'week_end': weekEnd.toIso8601String(),
      'completed_quest_count': completedQuestCount,
      'skipped_quest_count': skippedQuestCount,
      'earned_exp': earnedExp,
      'completion_rate': completionRate,
      'streak_days': streakDays,
      'reviewed_days': reviewedDays,
      'total_days': totalDays,
      'best_category': bestCategory,
      'weakest_category': weakestCategory,
      'insights': insights,
      'suggested_adjustments': suggestedAdjustments,
      'completed_by_type': completedByType.map((k, v) => MapEntry(k.name, v)),
    };
  }
}

String _fallbackCategoryLabel(String category) {
  switch (category) {
    case 'main':
      return 'Chính';
    case 'side':
      return 'Phụ';
    case 'daily':
      return 'Hằng ngày';
    case 'weekly':
      return 'Hằng tuần';
    default:
      return category;
  }
}
