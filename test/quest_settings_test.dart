import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/quest_settings_dto.dart';
import 'package:solo_quest/core/api/services/quest_settings_api_service.dart';
import 'package:solo_quest/core/network/api_exception.dart';
import 'package:solo_quest/models/enums/quest_enums.dart';
import 'package:solo_quest/services/quest_rule_service.dart';

class FakeQuestSettingsApiService implements QuestSettingsApiService {
  QuestSettingsDto? mockResult;
  Object? throwError;

  @override
  Future<QuestSettingsDto> getSettings() async {
    if (throwError != null) throw throwError!;
    return mockResult!;
  }

  @override
  Future<QuestSettingsDto> updateSettings(Map<String, dynamic> body) async {
    if (throwError != null) throw throwError!;
    return mockResult!;
  }

  @override
  Future<QuestSettingsDto> resetSettings() async {
    if (throwError != null) throw throwError!;
    return mockResult!;
  }
}

void main() {
  group('QuestSettingsDto', () {
    test('parses full backend response', () {
      final json = {
        'daily_quest_count': 6,
        'difficulty': 'normal',
        'auto_adjust_enabled': true,
        'enabled_categories': ['water', 'learning', 'breakTime'],
        'preferred_duration': 'short',
        'rest_day_enabled': false,
        'rules': [
          {
            'id': 'rule_water',
            'type': 'water',
            'title': 'Uống nước',
            'description': 'Nhắc uống nước',
            'enabled': true,
            'difficulty': 'easy',
            'min_interval_minutes': 90,
            'max_per_day': 8,
            'active_time_range': {'start': '08:00', 'end': '22:00'},
            'active_weekdays': [1, 2, 3, 4, 5, 6, 7],
            'priority': 5,
            'adapt_to_energy': true,
            'adapt_to_stress': true,
            'adapt_to_schedule': true,
          },
          {
            'id': 'rule_learning',
            'type': 'learning',
            'title': 'Học tập',
            'description': '',
            'enabled': true,
            'difficulty': 'medium',
            'min_interval_minutes': 240,
            'max_per_day': 2,
            'active_time_range': {'start': '19:00', 'end': '22:00'},
            'active_weekdays': [1, 2, 3, 4, 5],
            'priority': 4,
            'adapt_to_energy': true,
            'adapt_to_stress': true,
            'adapt_to_schedule': false,
          },
        ],
      };

      final dto = QuestSettingsDto.fromJson(json);

      expect(dto.dailyQuestCount, 6);
      expect(dto.difficulty, 'medium');
      expect(dto.autoAdjustEnabled, true);
      expect(dto.enabledCategories, ['water', 'learning', 'breakTime']);
      expect(dto.preferredDuration, 'short');
      expect(dto.restDayEnabled, false);

      expect(dto.rules, hasLength(2));
      expect(dto.rules[0].id, 'rule_water');
      expect(dto.rules[0].type, 'water');
      expect(dto.rules[0].difficulty, QuestDifficulty.easy);
      expect(dto.rules[0].minIntervalMinutes, 90);
      expect(dto.rules[0].maxPerDay, 8);
      expect(dto.rules[0].activeTimeRange!.start, '08:00');
      expect(dto.rules[0].activeTimeRange!.end, '22:00');
      expect(dto.rules[0].activeWeekdays, [1, 2, 3, 4, 5, 6, 7]);
      expect(dto.rules[0].priority, 5);

      expect(dto.rules[1].id, 'rule_learning');
      expect(dto.rules[1].difficulty, QuestDifficulty.medium);
      expect(dto.rules[1].adaptToSchedule, false);
    });

    test('maps "easy" → "easy" and "hard" → "hard" directly', () {
      final json = {
        'difficulty': 'easy',
      };
      var dto = QuestSettingsDto.fromJson(json);
      expect(dto.difficulty, 'easy');

      json['difficulty'] = 'hard';
      dto = QuestSettingsDto.fromJson(json);
      expect(dto.difficulty, 'hard');
    });

    test('maps "normal" → "medium"', () {
      final json = {'difficulty': 'normal'};
      final dto = QuestSettingsDto.fromJson(json);
      expect(dto.difficulty, 'medium');
    });

    test('handles empty rules and categories', () {
      final json = <String, dynamic>{
        'daily_quest_count': 8,
        'rules': <Map<String, dynamic>>[],
        'enabled_categories': <String>[],
      };

      final dto = QuestSettingsDto.fromJson(json);
      expect(dto.rules, isEmpty);
      expect(dto.enabledCategories, isEmpty);
      expect(dto.dailyQuestCount, 8);
    });

    test('toPutBody excludes null values', () {
      final dto = QuestSettingsDto(
        dailyQuestCount: 10,
        difficulty: 'medium',
      );
      final body = dto.toPutBody();
      expect(body['daily_quest_count'], 10);
      expect(body['difficulty'], 'normal');
      expect(body['rules'], isNotNull);
    });

    test('rule DTO parses unknown difficulty gracefully', () {
      final json = {
        'id': 'test',
        'type': 'water',
        'difficulty': 'unknown_value',
      };
      final dto = QuestSettingsRuleDto.fromJson(json);
      expect(dto.difficulty, QuestDifficulty.easy);
    });
  });

  group('QuestSettingsApiService', () {
    test('isEndpointUnavailable returns true for 404', () {
      expect(
        QuestSettingsApiService.isEndpointUnavailable(
          ApiException(statusCode: 404, error: 'not_found', message: ''),
        ),
        true,
      );
    });

    test('isEndpointUnavailable returns true for network error', () {
      expect(
        QuestSettingsApiService.isEndpointUnavailable(
          Exception('Connection refused'),
        ),
        true,
      );
    });

    test('isEndpointUnavailable returns false for 500 server error', () {
      expect(
        QuestSettingsApiService.isEndpointUnavailable(
          ApiException(statusCode: 500, error: 'server_error', message: ''),
        ),
        false,
      );
    });
  });

  group('QuestRuleService', () {
    late FakeQuestSettingsApiService fakeApi;
    late QuestRuleService service;

    setUp(() {
      fakeApi = FakeQuestSettingsApiService();
    });

    test('loadSettings returns API data when API succeeds', () async {
      fakeApi.mockResult = QuestSettingsDto(
        dailyQuestCount: 6,
        difficulty: 'medium',
        autoAdjustEnabled: true,
        enabledCategories: ['water', 'learning'],
        preferredDuration: 'short',
        restDayEnabled: false,
        rules: [
          QuestSettingsRuleDto(
            id: 'rule_water',
            type: 'water',
            title: 'Uống nước',
            difficulty: QuestDifficulty.easy,
            minIntervalMinutes: 90,
            maxPerDay: 8,
            activeWeekdays: [1, 2, 3, 4, 5],
            priority: 5,
          ),
        ],
      );

      service = QuestRuleService(apiService: fakeApi);
      final data = await service.loadSettings();

      expect(data.dailyQuestCount, 6);
      expect(data.difficulty, 'medium');
      expect(data.autoAdjustEnabled, true);
      expect(data.enabledCategories, ['water', 'learning']);
      expect(data.preferredDuration, 'short');
      expect(data.restDayEnabled, false);
      expect(data.rules, hasLength(1));

      final rule = data.rules[0];
      expect(rule.id, 'rule_water');
      expect(rule.type, QuestType.water);
      expect(rule.enabled, true);
      expect(rule.difficulty, QuestDifficulty.easy);
      expect(rule.minIntervalMinutes, 90);
      expect(rule.maxPerDay, 8);
      expect(rule.priority, 5);
    });

    test('updateSettings sends rule update to API', () async {
      fakeApi.mockResult = QuestSettingsDto(
        dailyQuestCount: 10,
        difficulty: 'medium',
        autoAdjustEnabled: true,
        rules: [
          QuestSettingsRuleDto(
            id: 'rule_water',
            type: 'water',
            title: 'Updated',
            difficulty: QuestDifficulty.hard,
            maxPerDay: 5,
            priority: 3,
          ),
        ],
      );

      service = QuestRuleService(apiService: fakeApi);
      final data = await service.updateSettings(
        QuestSettingsDataUpdate(dailyQuestCount: 10),
      );

      expect(data.dailyQuestCount, 10);
    });

    test('resetToDefaultSettings returns defaults via API', () async {
      fakeApi.mockResult = QuestSettingsDto(
        dailyQuestCount: 8,
        difficulty: 'medium',
        rules: [],
      );

      service = QuestRuleService(apiService: fakeApi);
      final data = await service.resetToDefaultSettings();

      expect(data.dailyQuestCount, 8);
      expect(data.rules, isEmpty);
    });

    test('loadSettings falls back to defaults when API unavailable', () async {
      fakeApi.throwError =
          ApiException(statusCode: 404, error: 'not_found', message: '');
      service = QuestRuleService(apiService: fakeApi);

      final data = await service.loadSettings();

      expect(data.dailyQuestCount, 8);
      expect(data.rules, hasLength(6));
      expect(data.difficulty, 'medium');
      expect(data.autoAdjustEnabled, true);
      expect(data.enabledCategories, isNotEmpty);
    });

    test(
        'updateSettings falls back to local when API unavailable',
        () async {
      fakeApi.throwError = Exception('Connection refused');
      service = QuestRuleService(apiService: fakeApi);

      // Load defaults first to populate cache
      await service.loadSettings();

      final data = await service.updateSettings(
        QuestSettingsDataUpdate(dailyQuestCount: 5),
      );

      expect(data.dailyQuestCount, 5);
    });

    test('works without API service (pure local)', () async {
      service = QuestRuleService();

      final data = await service.loadSettings();
      expect(data.dailyQuestCount, 8);
      expect(data.rules, hasLength(6));
      expect(data.autoAdjustEnabled, true);
      expect(data.restDayEnabled, false);
    });

    test('updateDailyQuestLimit backward compat', () async {
      service = QuestRuleService();
      await service.updateDailyQuestLimit(3);

      final limit = await service.getDailyQuestLimit();
      expect(limit, 3);
    });

    test('loadSettings maps QuestType from rule type string', () async {
      fakeApi.mockResult = QuestSettingsDto(
        dailyQuestCount: 8,
        difficulty: 'medium',
        rules: [
          QuestSettingsRuleDto(
            id: 'rule_break_time',
            type: 'breakTime',
            title: 'Break',
            difficulty: QuestDifficulty.easy,
            maxPerDay: 6,
            priority: 5,
          ),
          QuestSettingsRuleDto(
            id: 'rule_unknown',
            type: 'unknown_type',
            title: 'Unknown',
            difficulty: QuestDifficulty.easy,
            maxPerDay: 1,
            priority: 1,
          ),
        ],
      );

      service = QuestRuleService(apiService: fakeApi);
      final data = await service.loadSettings();

      expect(data.rules[0].type, QuestType.breakTime);
      expect(data.rules[1].type, QuestType.custom);
    });
  });
}
