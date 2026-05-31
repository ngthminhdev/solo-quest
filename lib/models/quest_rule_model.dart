import 'enums/quest_enums.dart';
import 'schedule_model.dart';

class QuestRuleModel {
  final String id;
  final QuestType type;
  final String title;
  final String description;
  final bool enabled;
  final QuestDifficulty difficulty;
  final int? minIntervalMinutes;
  final int? maxPerDay;
  final TimeRangeModel? activeTimeRange;
  final List<int> activeWeekdays;
  final int priority;
  final bool adaptToEnergy;
  final bool adaptToStress;
  final bool adaptToSchedule;

  const QuestRuleModel({
    required this.id,
    required this.type,
    required this.title,
    this.description = '',
    this.enabled = true,
    this.difficulty = QuestDifficulty.easy,
    this.minIntervalMinutes,
    this.maxPerDay,
    this.activeTimeRange,
    this.activeWeekdays = const [1, 2, 3, 4, 5, 6, 7],
    this.priority = 1,
    this.adaptToEnergy = true,
    this.adaptToStress = true,
    this.adaptToSchedule = true,
  });

  QuestRuleModel copyWith({
    String? id,
    QuestType? type,
    String? title,
    String? description,
    bool? enabled,
    QuestDifficulty? difficulty,
    int? minIntervalMinutes,
    int? maxPerDay,
    TimeRangeModel? activeTimeRange,
    List<int>? activeWeekdays,
    int? priority,
    bool? adaptToEnergy,
    bool? adaptToStress,
    bool? adaptToSchedule,
  }) {
    return QuestRuleModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      enabled: enabled ?? this.enabled,
      difficulty: difficulty ?? this.difficulty,
      minIntervalMinutes: minIntervalMinutes ?? this.minIntervalMinutes,
      maxPerDay: maxPerDay ?? this.maxPerDay,
      activeTimeRange: activeTimeRange ?? this.activeTimeRange,
      activeWeekdays: activeWeekdays ?? this.activeWeekdays,
      priority: priority ?? this.priority,
      adaptToEnergy: adaptToEnergy ?? this.adaptToEnergy,
      adaptToStress: adaptToStress ?? this.adaptToStress,
      adaptToSchedule: adaptToSchedule ?? this.adaptToSchedule,
    );
  }

  factory QuestRuleModel.fromJson(Map<String, dynamic> json) {
    return QuestRuleModel(
      id: json['id'] as String,
      type: QuestType.values.byName(json['type'] as String),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
      difficulty: QuestDifficulty.values.byName(
        json['difficulty'] as String? ?? QuestDifficulty.easy.name,
      ),
      minIntervalMinutes: json['min_interval_minutes'] as int?,
      maxPerDay: json['max_per_day'] as int?,
      activeTimeRange: json['active_time_range'] != null
          ? TimeRangeModel.fromJson(
              json['active_time_range'] as Map<String, dynamic>,
            )
          : null,
      activeWeekdays:
          (json['active_weekdays'] as List<dynamic>?)?.cast<int>() ??
          [1, 2, 3, 4, 5, 6, 7],
      priority: json['priority'] as int? ?? 1,
      adaptToEnergy: json['adapt_to_energy'] as bool? ?? true,
      adaptToStress: json['adapt_to_stress'] as bool? ?? true,
      adaptToSchedule: json['adapt_to_schedule'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'enabled': enabled,
      'difficulty': difficulty.name,
      'min_interval_minutes': minIntervalMinutes,
      'max_per_day': maxPerDay,
      'active_time_range': activeTimeRange?.toJson(),
      'active_weekdays': activeWeekdays,
      'priority': priority,
      'adapt_to_energy': adaptToEnergy,
      'adapt_to_stress': adaptToStress,
      'adapt_to_schedule': adaptToSchedule,
    };
  }
}
