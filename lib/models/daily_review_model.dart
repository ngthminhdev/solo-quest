import 'enums/log_enums.dart';

class DailyReviewModel {
  final String id;
  final DateTime date;
  final int completedQuestCount;
  final int skippedQuestCount;
  final int earnedExp;
  final LogMood mood;
  final String? bestMoment;
  final String? challenge;
  final String? improvementTomorrow;
  final DateTime createdAt;

  const DailyReviewModel({
    required this.id,
    required this.date,
    this.completedQuestCount = 0,
    this.skippedQuestCount = 0,
    this.earnedExp = 0,
    this.mood = LogMood.neutral,
    this.bestMoment,
    this.challenge,
    this.improvementTomorrow,
    required this.createdAt,
  });

  DailyReviewModel copyWith({
    String? id,
    DateTime? date,
    int? completedQuestCount,
    int? skippedQuestCount,
    int? earnedExp,
    LogMood? mood,
    String? bestMoment,
    String? challenge,
    String? improvementTomorrow,
    DateTime? createdAt,
  }) {
    return DailyReviewModel(
      id: id ?? this.id,
      date: date ?? this.date,
      completedQuestCount: completedQuestCount ?? this.completedQuestCount,
      skippedQuestCount: skippedQuestCount ?? this.skippedQuestCount,
      earnedExp: earnedExp ?? this.earnedExp,
      mood: mood ?? this.mood,
      bestMoment: bestMoment ?? this.bestMoment,
      challenge: challenge ?? this.challenge,
      improvementTomorrow: improvementTomorrow ?? this.improvementTomorrow,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory DailyReviewModel.fromJson(Map<String, dynamic> json) {
    return DailyReviewModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      completedQuestCount: json['completed_quest_count'] as int? ?? 0,
      skippedQuestCount: json['skipped_quest_count'] as int? ?? 0,
      earnedExp: json['earned_exp'] as int? ?? 0,
      mood: LogMood.values.byName(json['mood'] as String? ?? 'neutral'),
      bestMoment: json['best_moment'] as String?,
      challenge: json['challenge'] as String?,
      improvementTomorrow: json['improvement_tomorrow'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'completed_quest_count': completedQuestCount,
      'skipped_quest_count': skippedQuestCount,
      'earned_exp': earnedExp,
      'mood': mood.name,
      'best_moment': bestMoment,
      'challenge': challenge,
      'improvement_tomorrow': improvementTomorrow,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
