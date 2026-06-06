import 'package:flutter/foundation.dart';

import '../core/api/dto/quest_settings_dto.dart';
import '../core/api/services/quest_settings_api_service.dart';
import '../models/enums/quest_enums.dart';
import '../models/quest_rule_model.dart';
import '../models/schedule_model.dart';

class QuestRuleService {
  final QuestSettingsApiService? _apiService;

  QuestSettingsDto? _cachedSettings;
  bool _usingFallback = false;

  QuestRuleService({QuestSettingsApiService? apiService})
      : _apiService = apiService;

  Future<QuestSettingsData> loadSettings() async {
    if (_apiService != null) {
      try {
        final dto = await _apiService.getSettings();
        _cachedSettings = dto;
        if (_usingFallback) {
          _usingFallback = false;
          if (kDebugMode) {
            debugPrint(
                '[QuestSettings] Backend API available, loaded from API.');
          }
        }
        if (kDebugMode) {
          debugPrint(
              '[QuestSettings] API GET success — '
              '${dto.rules.length} rules, daily=${dto.dailyQuestCount}');
        }
      } catch (e) {
        if (QuestSettingsApiService.isEndpointUnavailable(e)) {
          if (!_usingFallback) {
            _usingFallback = true;
            if (kDebugMode) {
              debugPrint(
                  '[QuestSettings] API unavailable, using local fallback. ($e)');
            }
          }
          _cachedSettings = null;
        } else {
          rethrow;
        }
      }
    }

    final settings = _cachedSettings ?? _defaultSettingsDto();
    return QuestSettingsData(
      dailyQuestCount: settings.dailyQuestCount,
      difficulty: settings.difficulty,
      autoAdjustEnabled: settings.autoAdjustEnabled,
      enabledCategories: settings.enabledCategories,
      preferredDuration: settings.preferredDuration,
      restDayEnabled: settings.restDayEnabled,
      rules: settings.rules.map(_dtoToModel).toList(),
    );
  }

  Future<QuestSettingsData> updateSettings(
      QuestSettingsDataUpdate update) async {
    final current = _cachedSettings ?? _defaultSettingsDto();

    final body = _buildUpdateBody(update, current);

    if (_apiService != null) {
      try {
        final dto = await _apiService.updateSettings(body);
        _cachedSettings = dto;
        if (kDebugMode) {
          debugPrint('[QuestSettings] API PUT success');
        }
      } catch (e) {
        if (QuestSettingsApiService.isEndpointUnavailable(e)) {
          _applyUpdateLocally(update);
          if (kDebugMode) {
            debugPrint(
                '[QuestSettings] API PUT unavailable, using local update.');
          }
        } else {
          rethrow;
        }
      }
    } else {
      _applyUpdateLocally(update);
    }

    final settings = _cachedSettings ?? _defaultSettingsDto();
    return QuestSettingsData(
      dailyQuestCount: settings.dailyQuestCount,
      difficulty: settings.difficulty,
      autoAdjustEnabled: settings.autoAdjustEnabled,
      enabledCategories: settings.enabledCategories,
      preferredDuration: settings.preferredDuration,
      restDayEnabled: settings.restDayEnabled,
      rules: settings.rules.map(_dtoToModel).toList(),
    );
  }

  Future<QuestSettingsData> resetToDefaultSettings() async {
    if (_apiService != null) {
      try {
        final dto = await _apiService.resetSettings();
        _cachedSettings = dto;
        if (kDebugMode) {
          debugPrint('[QuestSettings] API POST /reset success');
        }
      } catch (e) {
        if (QuestSettingsApiService.isEndpointUnavailable(e)) {
          _cachedSettings = _defaultSettingsDto();
          if (kDebugMode) {
            debugPrint(
                '[QuestSettings] API reset unavailable, using local defaults.');
          }
        } else {
          rethrow;
        }
      }
    } else {
      _cachedSettings = _defaultSettingsDto();
    }

    final settings = _cachedSettings ?? _defaultSettingsDto();
    return QuestSettingsData(
      dailyQuestCount: settings.dailyQuestCount,
      difficulty: settings.difficulty,
      autoAdjustEnabled: settings.autoAdjustEnabled,
      enabledCategories: settings.enabledCategories,
      preferredDuration: settings.preferredDuration,
      restDayEnabled: settings.restDayEnabled,
      rules: settings.rules.map(_dtoToModel).toList(),
    );
  }

  void _applyUpdateLocally(QuestSettingsDataUpdate update) {
    var current = _cachedSettings ?? _defaultSettingsDto();
    final rules = current.rules.toList();

    if (update.dailyQuestCount != null) {
      current = QuestSettingsDto(
        dailyQuestCount: update.dailyQuestCount!,
        difficulty: current.difficulty,
        autoAdjustEnabled: current.autoAdjustEnabled,
        enabledCategories: current.enabledCategories,
        preferredDuration: current.preferredDuration,
        restDayEnabled: current.restDayEnabled,
        rules: rules,
      );
    }
    if (update.difficulty != null) {
      current = QuestSettingsDto(
        dailyQuestCount: current.dailyQuestCount,
        difficulty: update.difficulty!,
        autoAdjustEnabled: current.autoAdjustEnabled,
        enabledCategories: current.enabledCategories,
        preferredDuration: current.preferredDuration,
        restDayEnabled: current.restDayEnabled,
        rules: rules,
      );
    }
    if (update.autoAdjustEnabled != null) {
      current = QuestSettingsDto(
        dailyQuestCount: current.dailyQuestCount,
        difficulty: current.difficulty,
        autoAdjustEnabled: update.autoAdjustEnabled!,
        enabledCategories: current.enabledCategories,
        preferredDuration: current.preferredDuration,
        restDayEnabled: current.restDayEnabled,
        rules: rules,
      );
    }
    if (update.enabledCategories != null) {
      current = QuestSettingsDto(
        dailyQuestCount: current.dailyQuestCount,
        difficulty: current.difficulty,
        autoAdjustEnabled: current.autoAdjustEnabled,
        enabledCategories: update.enabledCategories!,
        preferredDuration: current.preferredDuration,
        restDayEnabled: current.restDayEnabled,
        rules: rules,
      );
    }
    if (update.preferredDuration != null) {
      current = QuestSettingsDto(
        dailyQuestCount: current.dailyQuestCount,
        difficulty: current.difficulty,
        autoAdjustEnabled: current.autoAdjustEnabled,
        enabledCategories: current.enabledCategories,
        preferredDuration: update.preferredDuration!,
        restDayEnabled: current.restDayEnabled,
        rules: rules,
      );
    }
    if (update.restDayEnabled != null) {
      current = QuestSettingsDto(
        dailyQuestCount: current.dailyQuestCount,
        difficulty: current.difficulty,
        autoAdjustEnabled: current.autoAdjustEnabled,
        enabledCategories: current.enabledCategories,
        preferredDuration: current.preferredDuration,
        restDayEnabled: update.restDayEnabled!,
        rules: rules,
      );
    }
    if (update.ruleUpdate != null) {
      final ruleDto = update.ruleUpdate!;
      final idx = rules.indexWhere((r) => r.id == ruleDto.id);
      if (idx != -1) {
        rules[idx] = _modelToDto(ruleDto);
      }
      current = QuestSettingsDto(
        dailyQuestCount: current.dailyQuestCount,
        difficulty: current.difficulty,
        autoAdjustEnabled: current.autoAdjustEnabled,
        enabledCategories: current.enabledCategories,
        preferredDuration: current.preferredDuration,
        restDayEnabled: current.restDayEnabled,
        rules: rules,
      );
    }

    _cachedSettings = current;
  }

  // ─── Legacy backward-compat methods (used by onboarding) ─────────────

  Future<int> getDailyQuestLimit() async {
    final settings = _cachedSettings ?? _defaultSettingsDto();
    return settings.dailyQuestCount;
  }

  Future<void> updateDailyQuestLimit(int limit) async {
    await updateSettings(QuestSettingsDataUpdate(
      dailyQuestCount: limit,
    ));
  }

  // ─── DTO ↔ Model mappers ────────────────────────────────────────────

  QuestRuleModel _dtoToModel(QuestSettingsRuleDto dto) {
    QuestType type;
    try {
      type = QuestType.values.byName(dto.type);
    } catch (_) {
      type = QuestType.custom;
    }

    return QuestRuleModel(
      id: dto.id,
      type: type,
      title: dto.title,
      description: dto.description,
      enabled: dto.enabled,
      difficulty: dto.difficulty,
      minIntervalMinutes: dto.minIntervalMinutes,
      maxPerDay: dto.maxPerDay,
      activeTimeRange: dto.activeTimeRange,
      activeWeekdays: dto.activeWeekdays,
      priority: dto.priority,
      adaptToEnergy: dto.adaptToEnergy,
      adaptToStress: dto.adaptToStress,
      adaptToSchedule: dto.adaptToSchedule,
    );
  }

  QuestSettingsRuleDto _modelToDto(QuestRuleModel model) {
    return QuestSettingsRuleDto(
      id: model.id,
      type: model.type.name,
      title: model.title,
      description: model.description,
      enabled: model.enabled,
      difficulty: model.difficulty,
      minIntervalMinutes: model.minIntervalMinutes,
      maxPerDay: model.maxPerDay,
      activeTimeRange: model.activeTimeRange,
      activeWeekdays: model.activeWeekdays,
      priority: model.priority,
      adaptToEnergy: model.adaptToEnergy,
      adaptToStress: model.adaptToStress,
      adaptToSchedule: model.adaptToSchedule,
    );
  }

  Map<String, dynamic> _modelToDtoJson(QuestRuleModel model) {
    return _modelToDto(model).toJson();
  }

  Map<String, dynamic> _buildUpdateBody(
      QuestSettingsDataUpdate update, QuestSettingsDto current) {
    final body = <String, dynamic>{};
    if (update.dailyQuestCount != null) {
      body['daily_quest_count'] = update.dailyQuestCount;
    }
    if (update.difficulty != null) {
      body['difficulty'] = _toBeDifficulty(update.difficulty!);
    }
    if (update.autoAdjustEnabled != null) {
      body['auto_adjust_enabled'] = update.autoAdjustEnabled;
    }
    if (update.enabledCategories != null) {
      body['enabled_categories'] = update.enabledCategories;
    }
    if (update.preferredDuration != null) {
      body['preferred_duration'] = update.preferredDuration;
    }
    if (update.restDayEnabled != null) {
      body['rest_day_enabled'] = update.restDayEnabled;
    }
    if (update.ruleUpdate != null) {
      body['rules'] = [
        _modelToDtoJson(update.ruleUpdate!),
      ];
    }
    return body;
  }

  static String _toBeDifficulty(String feDifficulty) {
    switch (feDifficulty) {
      case 'easy':
        return 'easy';
      case 'hard':
        return 'hard';
      case 'medium':
      default:
        return 'normal';
    }
  }

  // ─── Defaults ───────────────────────────────────────────────────────

  static QuestSettingsDto _defaultSettingsDto() {
    return QuestSettingsDto(
      dailyQuestCount: 8,
      difficulty: 'medium',
      autoAdjustEnabled: true,
      enabledCategories: [
        'water',
        'breakTime',
        'movement',
        'learning',
        'sleep',
        'review',
      ],
      preferredDuration: 'medium',
      restDayEnabled: false,
      rules: _defaultRuleDtos(),
    );
  }

  static List<QuestSettingsRuleDto> _defaultRuleDtos() {
    return const [
      QuestSettingsRuleDto(
        id: 'rule_water',
        type: 'water',
        title: 'Uống nước',
        description:
            'Nhắc uống nước đều trong ngày để giữ năng lượng ổn định.',
        difficulty: QuestDifficulty.easy,
        minIntervalMinutes: 90,
        maxPerDay: 8,
        activeTimeRange: TimeRangeModel(start: '08:00', end: '22:00'),
        priority: 5,
      ),
      QuestSettingsRuleDto(
        id: 'rule_break_time',
        type: 'breakTime',
        title: 'Nghỉ mắt',
        description: 'Tạo nhịp nghỉ ngắn để giảm mỏi mắt và căng thẳng.',
        difficulty: QuestDifficulty.easy,
        minIntervalMinutes: 90,
        maxPerDay: 6,
        activeTimeRange: TimeRangeModel(start: '09:00', end: '18:00'),
        priority: 5,
      ),
      QuestSettingsRuleDto(
        id: 'rule_movement',
        type: 'movement',
        title: 'Vận động',
        description:
            'Gợi ý đứng dậy, đi bộ hoặc giãn cơ trong ngày làm việc.',
        difficulty: QuestDifficulty.medium,
        minIntervalMinutes: 180,
        maxPerDay: 3,
        activeTimeRange: TimeRangeModel(start: '10:00', end: '20:00'),
        priority: 4,
      ),
      QuestSettingsRuleDto(
        id: 'rule_learning',
        type: 'learning',
        title: 'Học tập',
        description:
            'Ưu tiên phiên học tập ngắn vào khung giờ dễ tập trung.',
        difficulty: QuestDifficulty.medium,
        minIntervalMinutes: 240,
        maxPerDay: 2,
        activeTimeRange: TimeRangeModel(start: '19:00', end: '22:00'),
        priority: 4,
      ),
      QuestSettingsRuleDto(
        id: 'rule_sleep',
        type: 'sleep',
        title: 'Ngủ nghỉ',
        description: 'Giữ nhịp thư giãn cuối ngày và chuẩn bị ngủ đúng giờ.',
        difficulty: QuestDifficulty.easy,
        maxPerDay: 1,
        activeTimeRange: TimeRangeModel(start: '22:00', end: '23:30'),
        priority: 3,
      ),
      QuestSettingsRuleDto(
        id: 'rule_review',
        type: 'review',
        title: 'Daily Review',
        description:
            'Nhắc tổng kết ngày, ghi nhận tiến trình và điều chỉnh mục tiêu.',
        difficulty: QuestDifficulty.easy,
        maxPerDay: 1,
        activeTimeRange: TimeRangeModel(start: '21:00', end: '23:00'),
        priority: 3,
      ),
    ];
  }
}

class QuestSettingsData {
  final int dailyQuestCount;
  final String difficulty;
  final bool autoAdjustEnabled;
  final List<String> enabledCategories;
  final String preferredDuration;
  final bool restDayEnabled;
  final List<QuestRuleModel> rules;

  const QuestSettingsData({
    this.dailyQuestCount = 8,
    this.difficulty = 'medium',
    this.autoAdjustEnabled = true,
    this.enabledCategories = const [],
    this.preferredDuration = 'medium',
    this.restDayEnabled = false,
    this.rules = const [],
  });
}

class QuestSettingsDataUpdate {
  final int? dailyQuestCount;
  final String? difficulty;
  final bool? autoAdjustEnabled;
  final List<String>? enabledCategories;
  final String? preferredDuration;
  final bool? restDayEnabled;
  final QuestRuleModel? ruleUpdate;

  const QuestSettingsDataUpdate({
    this.dailyQuestCount,
    this.difficulty,
    this.autoAdjustEnabled,
    this.enabledCategories,
    this.preferredDuration,
    this.restDayEnabled,
    this.ruleUpdate,
  });
}
