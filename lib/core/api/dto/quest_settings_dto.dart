import '../../../models/enums/quest_enums.dart';
import '../../../models/schedule_model.dart';

class QuestSettingsRuleDto {
  final String id;
  final String type;
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

  const QuestSettingsRuleDto({
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

  factory QuestSettingsRuleDto.fromJson(Map<String, dynamic> json) {
    return QuestSettingsRuleDto(
      id: json['id'] as String,
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
      difficulty: _parseRuleDifficulty(json['difficulty'] as String?),
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
      'type': type,
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

  static QuestDifficulty _parseRuleDifficulty(String? value) {
    if (value == null) return QuestDifficulty.easy;
    try {
      return QuestDifficulty.values.byName(value);
    } catch (_) {
      return QuestDifficulty.easy;
    }
  }
}

class QuestSettingsDto {
  final int dailyQuestCount;
  final String difficulty;
  final bool autoAdjustEnabled;
  final List<String> enabledCategories;
  final String preferredDuration;
  final bool restDayEnabled;
  final List<QuestSettingsRuleDto> rules;

  const QuestSettingsDto({
    this.dailyQuestCount = 8,
    this.difficulty = 'medium',
    this.autoAdjustEnabled = true,
    this.enabledCategories = const [],
    this.preferredDuration = 'medium',
    this.restDayEnabled = false,
    this.rules = const [],
  });

  factory QuestSettingsDto.fromJson(Map<String, dynamic> json) {
    return QuestSettingsDto(
      dailyQuestCount: json['daily_quest_count'] as int? ?? 8,
      difficulty: _mapGlobalDifficulty(json['difficulty'] as String?),
      autoAdjustEnabled: json['auto_adjust_enabled'] as bool? ?? true,
      enabledCategories:
          (json['enabled_categories'] as List<dynamic>?)?.cast<String>() ?? [],
      preferredDuration: json['preferred_duration'] as String? ?? 'medium',
      restDayEnabled: json['rest_day_enabled'] as bool? ?? false,
      rules: (json['rules'] as List<dynamic>?)
              ?.map(
                  (e) => QuestSettingsRuleDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily_quest_count': dailyQuestCount,
      'difficulty': _unmapGlobalDifficulty(difficulty),
      'auto_adjust_enabled': autoAdjustEnabled,
      'enabled_categories': enabledCategories,
      'preferred_duration': preferredDuration,
      'rest_day_enabled': restDayEnabled,
      'rules': rules.map((r) => r.toJson()).toList(),
    };
  }

  Map<String, dynamic> toPutBody() {
    final body = <String, dynamic>{
      'daily_quest_count': dailyQuestCount,
      'difficulty': _unmapGlobalDifficulty(difficulty),
      'auto_adjust_enabled': autoAdjustEnabled,
      'enabled_categories': enabledCategories,
      'preferred_duration': preferredDuration,
      'rest_day_enabled': restDayEnabled,
      'rules': rules.map((r) => r.toJson()).toList(),
    };
    body.removeWhere((_, v) => v == null);
    return body;
  }

  static String _mapGlobalDifficulty(String? beValue) {
    switch (beValue) {
      case 'easy':
        return 'easy';
      case 'hard':
        return 'hard';
      case 'normal':
      default:
        return 'medium';
    }
  }

  static String _unmapGlobalDifficulty(String feValue) {
    switch (feValue) {
      case 'easy':
        return 'easy';
      case 'hard':
        return 'hard';
      case 'medium':
      default:
        return 'normal';
    }
  }
}
