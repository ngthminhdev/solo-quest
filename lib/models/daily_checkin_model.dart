import 'enums/user_enums.dart';

class DailyCheckinModel {
  final String id;
  final DateTime date;
  final EnergyLevel energyLevel;
  final StressLevel stressLevel;
  final FocusLevel focusLevel;
  final DayIntensity dayIntensity;
  final String? mainFocusToday;
  final String? note;
  final List<String> availableTimeBlocks;
  final DateTime createdAt;

  const DailyCheckinModel({
    required this.id,
    required this.date,
    this.energyLevel = EnergyLevel.medium,
    this.stressLevel = StressLevel.medium,
    this.focusLevel = FocusLevel.medium,
    this.dayIntensity = DayIntensity.normal,
    this.mainFocusToday,
    this.note,
    this.availableTimeBlocks = const [],
    required this.createdAt,
  });

  DailyCheckinModel copyWith({
    String? id,
    DateTime? date,
    EnergyLevel? energyLevel,
    StressLevel? stressLevel,
    FocusLevel? focusLevel,
    DayIntensity? dayIntensity,
    String? mainFocusToday,
    String? note,
    List<String>? availableTimeBlocks,
    DateTime? createdAt,
  }) {
    return DailyCheckinModel(
      id: id ?? this.id,
      date: date ?? this.date,
      energyLevel: energyLevel ?? this.energyLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      focusLevel: focusLevel ?? this.focusLevel,
      dayIntensity: dayIntensity ?? this.dayIntensity,
      mainFocusToday: mainFocusToday ?? this.mainFocusToday,
      note: note ?? this.note,
      availableTimeBlocks: availableTimeBlocks ?? this.availableTimeBlocks,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory DailyCheckinModel.fromJson(Map<String, dynamic> json) {
    return DailyCheckinModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      energyLevel: EnergyLevel.values.byName(json['energy_level'] as String? ?? 'medium'),
      stressLevel: StressLevel.values.byName(json['stress_level'] as String? ?? 'medium'),
      focusLevel: FocusLevel.values.byName(json['focus_level'] as String? ?? 'medium'),
      dayIntensity: DayIntensity.values.byName(json['day_intensity'] as String? ?? 'normal'),
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
      'energy_level': energyLevel.name,
      'stress_level': stressLevel.name,
      'focus_level': focusLevel.name,
      'day_intensity': dayIntensity.name,
      'main_focus_today': mainFocusToday,
      'note': note,
      'available_time_blocks': availableTimeBlocks,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
