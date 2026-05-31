import 'enums/quest_enums.dart';

class WeeklySummaryModel {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int completedQuestCount;
  final int skippedQuestCount;
  final int earnedExp;
  final double completionRate;
  final List<String> insights;
  final List<String> suggestedAdjustments;
  final Map<QuestType, int> completedByType;

  const WeeklySummaryModel({
    required this.weekStart,
    required this.weekEnd,
    this.completedQuestCount = 0,
    this.skippedQuestCount = 0,
    this.earnedExp = 0,
    this.completionRate = 0.0,
    this.insights = const [],
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
    List<String>? insights,
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
      insights: insights ?? this.insights,
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
      insights: (json['insights'] as List<dynamic>?)?.cast<String>() ?? [],
      suggestedAdjustments: (json['suggested_adjustments'] as List<dynamic>?)?.cast<String>() ?? [],
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
      'insights': insights,
      'suggested_adjustments': suggestedAdjustments,
      'completed_by_type': completedByType.map((k, v) => MapEntry(k.name, v)),
    };
  }
}
