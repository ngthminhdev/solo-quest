class WeeklyDailyBreakdownDto {
  final DateTime date;
  final int completed;
  final int skipped;
  final int total;
  final double rate;

  const WeeklyDailyBreakdownDto({
    required this.date,
    required this.completed,
    required this.skipped,
    required this.total,
    required this.rate,
  });

  factory WeeklyDailyBreakdownDto.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date'] as String?;
    final date = _parseDateOnly(dateStr);

    return WeeklyDailyBreakdownDto(
      date: date,
      completed: json['completed'] as int? ?? 0,
      skipped: json['skipped'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date':
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'completed': completed,
      'skipped': skipped,
      'total': total,
      'rate': rate,
    };
  }
}

class WeeklyCategoryBreakdownDto {
  final String category;
  final int completed;
  final int total;
  final double rate;

  const WeeklyCategoryBreakdownDto({
    required this.category,
    required this.completed,
    required this.total,
    required this.rate,
  });

  factory WeeklyCategoryBreakdownDto.fromJson(Map<String, dynamic> json) {
    return WeeklyCategoryBreakdownDto(
      category: json['category'] as String? ?? 'unknown',
      completed: json['completed'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'completed': completed,
      'total': total,
      'rate': rate,
    };
  }
}

class WeeklySuggestionDto {
  final String id;
  final String title;
  final String description;
  final String type;
  final bool actionable;

  const WeeklySuggestionDto({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.actionable = true,
  });

  factory WeeklySuggestionDto.fromJson(Map<String, dynamic> json) {
    return WeeklySuggestionDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'general',
      actionable: json['actionable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'actionable': actionable,
    };
  }
}

class WeeklySummaryDto {
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
  final List<WeeklyDailyBreakdownDto> dailyBreakdown;
  final List<WeeklyCategoryBreakdownDto> categoryBreakdown;
  final List<String> insights;
  final List<WeeklySuggestionDto> suggestions;
  final String? aiSummary;
  final String? nextWeekFocus;

  const WeeklySummaryDto({
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
  });

  factory WeeklySummaryDto.fromJson(Map<String, dynamic> json) {
    final weekStart = _parseDateOnly(json['week_start'] as String?);
    final weekEnd = _parseDateOnly(json['week_end'] as String?);

    return WeeklySummaryDto(
      weekStart: weekStart,
      weekEnd: weekEnd,
      completedQuestCount: json['completed_quest_count'] as int? ?? 0,
      skippedQuestCount: json['skipped_quest_count'] as int? ?? 0,
      earnedExp: json['earned_exp'] as int? ?? 0,
      completionRate: (json['completion_rate'] as num?)?.toDouble() ?? 0.0,
      streakDays: json['streak_days'] as int? ?? 0,
      reviewedDays: json['reviewed_days'] as int? ?? 0,
      totalDays: json['total_days'] as int? ?? 7,
      bestCategory: json['best_category'] as String?,
      weakestCategory: json['weakest_category'] as String?,
      dailyBreakdown: (json['daily_breakdown'] as List<dynamic>?)
              ?.map((e) =>
                  WeeklyDailyBreakdownDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categoryBreakdown: (json['category_breakdown'] as List<dynamic>?)
              ?.map((e) => WeeklyCategoryBreakdownDto.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
      insights: (json['insights'] as List<dynamic>?)?.cast<String>() ?? [],
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) =>
                  WeeklySuggestionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      aiSummary: json['ai_summary'] as String?,
      nextWeekFocus: json['next_week_focus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week_start':
          '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}',
      'week_end':
          '${weekEnd.year}-${weekEnd.month.toString().padLeft(2, '0')}-${weekEnd.day.toString().padLeft(2, '0')}',
      'completed_quest_count': completedQuestCount,
      'skipped_quest_count': skippedQuestCount,
      'earned_exp': earnedExp,
      'completion_rate': completionRate,
      'streak_days': streakDays,
      'reviewed_days': reviewedDays,
      'total_days': totalDays,
      'best_category': bestCategory,
      'weakest_category': weakestCategory,
      'daily_breakdown': dailyBreakdown.map((e) => e.toJson()).toList(),
      'category_breakdown': categoryBreakdown.map((e) => e.toJson()).toList(),
      'insights': insights,
      'suggestions': suggestions.map((e) => e.toJson()).toList(),
      'ai_summary': aiSummary,
      'next_week_focus': nextWeekFocus,
    };
  }
}

DateTime _parseDateOnly(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) {
    return DateTime.now();
  }
  try {
    return DateTime.parse('${dateStr}T00:00:00');
  } catch (_) {
    return DateTime.now();
  }
}
