import '../core/utils/enum_mapper.dart';
import 'enums/user_enums.dart';

class DailyReviewModel {
  final String id;
  final DateTime date;

  // Simplified review fields
  final CheckinMood mood;
  final EnergyLevel energyLevel;
  final int satisfaction;
  final String? reflection;
  final CheckinPriority tomorrowPriority;

  // Summary stats (from quest data, not user input)
  final int completedQuestCount;
  final int skippedQuestCount;
  final int earnedExp;

  final DateTime createdAt;

  const DailyReviewModel({
    required this.id,
    required this.date,
    this.mood = CheckinMood.normal,
    this.energyLevel = EnergyLevel.medium,
    this.satisfaction = 3,
    this.reflection,
    this.tomorrowPriority = CheckinPriority.learning,
    this.completedQuestCount = 0,
    this.skippedQuestCount = 0,
    this.earnedExp = 0,
    required this.createdAt,
  });

  DailyReviewModel copyWith({
    String? id,
    DateTime? date,
    CheckinMood? mood,
    EnergyLevel? energyLevel,
    int? satisfaction,
    String? reflection,
    CheckinPriority? tomorrowPriority,
    int? completedQuestCount,
    int? skippedQuestCount,
    int? earnedExp,
    DateTime? createdAt,
  }) {
    return DailyReviewModel(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      energyLevel: energyLevel ?? this.energyLevel,
      satisfaction: satisfaction ?? this.satisfaction,
      reflection: reflection ?? this.reflection,
      tomorrowPriority: tomorrowPriority ?? this.tomorrowPriority,
      completedQuestCount: completedQuestCount ?? this.completedQuestCount,
      skippedQuestCount: skippedQuestCount ?? this.skippedQuestCount,
      earnedExp: earnedExp ?? this.earnedExp,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory DailyReviewModel.fromJson(Map<String, dynamic> json) {
    return DailyReviewModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      mood: parseCheckinMood(json['mood'] as String?),
      energyLevel: parseEnergyLevel(json['energy_level'] as String?),
      satisfaction: json['satisfaction'] as int? ?? 3,
      reflection: json['reflection'] as String?,
      tomorrowPriority: parseCheckinPriority(json['tomorrow_priority'] as String?),
      completedQuestCount: json['completed_quest_count'] as int? ?? 0,
      skippedQuestCount: json['skipped_quest_count'] as int? ?? 0,
      earnedExp: json['earned_exp'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mood': mood.name,
      'energy_level': energyLevel.name,
      'satisfaction': satisfaction,
      'reflection': reflection,
      'tomorrow_priority': tomorrowPriority.name,
      'completed_quest_count': completedQuestCount,
      'skipped_quest_count': skippedQuestCount,
      'earned_exp': earnedExp,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
