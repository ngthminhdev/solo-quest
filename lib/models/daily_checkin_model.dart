import '../core/utils/enum_mapper.dart';
import 'enums/user_enums.dart';

class DailyCheckinModel {
  final String id;
  final DateTime date;

  // Simplified check-in fields
  final CheckinMood mood;
  final EnergyLevel energyLevel;
  final Availability availability;
  final CheckinPriority priority;

  // Legacy fields (kept for backward compatibility with BE responses, not used by UI)
  @Deprecated('Removed from check-in UI. Kept only for BE backward compat.')
  final StressLevel stressLevel;
  @Deprecated('Removed from check-in UI. Kept only for BE backward compat.')
  final FocusLevel focusLevel;
  @Deprecated('Removed from check-in UI. Kept only for BE backward compat.')
  final SleepQuality sleepQuality;
  @Deprecated('Removed from check-in UI. Kept only for BE backward compat.')
  final DayIntensity dayIntensity;
  @Deprecated('Removed from check-in UI. Kept only for BE backward compat.')
  final String? mainFocusToday;
  @Deprecated('Removed from check-in UI. Kept only for BE backward compat.')
  final String? note;
  @Deprecated('Removed from check-in UI. Kept only for BE backward compat.')
  final List<String> availableTimeBlocks;

  final DateTime createdAt;

  const DailyCheckinModel({
    required this.id,
    required this.date,
    this.mood = CheckinMood.normal,
    this.energyLevel = EnergyLevel.medium,
    this.availability = Availability.normal,
    this.priority = CheckinPriority.learning,
    // Legacy defaults
    this.stressLevel = StressLevel.medium,
    this.focusLevel = FocusLevel.medium,
    this.sleepQuality = SleepQuality.medium,
    this.dayIntensity = DayIntensity.normal,
    this.mainFocusToday,
    this.note,
    this.availableTimeBlocks = const [],
    required this.createdAt,
  });

  DailyCheckinModel copyWith({
    String? id,
    DateTime? date,
    CheckinMood? mood,
    EnergyLevel? energyLevel,
    Availability? availability,
    CheckinPriority? priority,
    DateTime? createdAt,
  }) {
    return DailyCheckinModel(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      energyLevel: energyLevel ?? this.energyLevel,
      availability: availability ?? this.availability,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory DailyCheckinModel.fromJson(Map<String, dynamic> json) {
    return DailyCheckinModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      mood: parseCheckinMood(json['mood'] as String?),
      energyLevel: parseEnergyLevel(json['energy_level'] as String?),
      availability: parseAvailability(json['availability'] as String?),
      priority: parseCheckinPriority(json['priority'] as String?),
      // Legacy fields for backward compat
      stressLevel: parseStressLevel(json['stress_level'] as String?),
      focusLevel: parseFocusLevel(json['focus_level'] as String?),
      sleepQuality: parseSleepQuality(json['sleep_quality'] as String?),
      dayIntensity: parseDayIntensity(json['day_intensity'] as String?),
      mainFocusToday: json['main_focus_today'] as String?,
      note: json['note'] as String?,
      availableTimeBlocks: (json['available_time_blocks'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mood': mood.name,
      'energy_level': energyLevel.name,
      'availability': availability.name,
      'priority': priority.name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
