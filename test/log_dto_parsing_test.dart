import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/log_dto.dart';
import 'package:solo_quest/models/enums/log_enums.dart';

void main() {
  group('LogEntryDto', () {
    test('parses known type correctly', () {
      final json = {
        'id': '1',
        'type': 'quest_completed',
        'title': 'Test Quest',
        'description': 'Test description',
        'created_at': '2026-06-04T10:00:00Z',
      };

      final dto = LogEntryDto.fromJson(json);
      expect(dto.id, '1');
      expect(dto.type, LogEntryType.questCompleted);
      expect(dto.title, 'Test Quest');
      expect(dto.description, 'Test description');
    });

    test('parses learning roadmap types correctly', () {
      final json = {
        'id': '2',
        'type': 'learning_roadmap_created',
        'title': 'Created Roadmap',
        'description': 'New roadmap created',
        'created_at': '2026-06-04T10:00:00Z',
      };

      final dto = LogEntryDto.fromJson(json);
      expect(dto.type, LogEntryType.learningRoadmapCreated);
    });

    test('parses learning roadmap step completed correctly', () {
      final json = {
        'id': '3',
        'type': 'learning_roadmap_step_completed',
        'title': 'Step Completed',
        'description': 'Step completed',
        'created_at': '2026-06-04T10:00:00Z',
      };

      final dto = LogEntryDto.fromJson(json);
      expect(dto.type, LogEntryType.learningRoadmapStepCompleted);
    });

    test('parses level up and lowercase system types correctly', () {
      final levelUp = LogEntryDto.fromJson({
        'id': 'level-1',
        'type': 'level_up',
        'title': 'Level 5',
        'description': '',
        'created_at': '2026-06-04T10:00:00Z',
      });
      final system = LogEntryDto.fromJson({
        'id': 'system-1',
        'type': 'system',
        'title': 'System log',
        'description': '',
        'created_at': '2026-06-04T10:01:00Z',
      });

      expect(levelUp.type, LogEntryType.levelUp);
      expect(system.type, LogEntryType.system);
      expect(levelUp.description, '');
    });

    test('handles roadmap log with null quest id and quest type', () {
      final json = {
        'id': 'roadmap-1',
        'type': 'learning_roadmap_step_completed',
        'title': 'Completed a roadmap step',
        'description': '',
        'created_at': '2026-06-04T10:00:00Z',
        'quest_id': null,
        'quest_type': null,
      };

      final dto = LogEntryDto.fromJson(json);
      expect(dto.type, LogEntryType.learningRoadmapStepCompleted);
      expect(dto.questId, isNull);
      expect(dto.questType, isNull);
      expect(dto.description, '');
    });

    test('handles unknown type safely', () {
      final json = {
        'id': '4',
        'type': 'unknown_future_type',
        'title': 'Future Activity',
        'description': 'Some future activity',
        'created_at': '2026-06-04T10:00:00Z',
      };

      final dto = LogEntryDto.fromJson(json);
      expect(dto.type, LogEntryType.unknown);
      expect(dto.title, 'Future Activity');
      expect(dto.description, 'Some future activity');
    });

    test('handles null type safely', () {
      final json = {
        'id': '5',
        'type': null,
        'title': 'Null Type Activity',
        'description': 'Activity with null type',
        'created_at': '2026-06-04T10:00:00Z',
      };

      final dto = LogEntryDto.fromJson(json);
      expect(dto.type, LogEntryType.unknown);
    });

    test('handles missing type safely with fallback', () {
      final json = {
        'id': '6',
        'title': 'Missing Type Activity',
        'description': 'Activity with missing type',
        'created_at': '2026-06-04T10:00:00Z',
      };

      // When type is missing, the DTO should use the unknown fallback
      final dto = LogEntryDto.fromJson(json);
      expect(dto.type, LogEntryType.unknown);
      expect(dto.title, 'Missing Type Activity');
    });

    test('parses all optional fields correctly', () {
      final json = {
        'id': '7',
        'type': 'quest_completed',
        'title': 'Complete Quest',
        'description': 'Quest completed',
        'created_at': '2026-06-04T10:00:00Z',
        'quest_id': 'quest-123',
        'quest_type': 'learning',
        'exp_changed': 50,
        'points_changed': 10,
        'mood': 'good',
        'metadata': {'key': 'value'},
      };

      final dto = LogEntryDto.fromJson(json);
      expect(dto.questId, 'quest-123');
      expect(dto.questType, isNotNull);
      expect(dto.expChanged, 50);
      expect(dto.pointsChanged, 10);
      expect(dto.mood, isNotNull);
      expect(dto.metadata, {'key': 'value'});
    });

    test('handles missing optional fields gracefully', () {
      final json = {
        'id': '8',
        'type': 'quest_completed',
        'title': 'Minimal Quest',
        'created_at': '2026-06-04T10:00:00Z',
      };

      final dto = LogEntryDto.fromJson(json);
      expect(dto.description, '');
      expect(dto.questId, isNull);
      expect(dto.questType, isNull);
      expect(dto.expChanged, isNull);
      expect(dto.pointsChanged, isNull);
      expect(dto.mood, isNull);
      expect(dto.metadata, isEmpty);
    });

    test('parses timestamp correctly', () {
      final json = {
        'id': '9',
        'type': 'quest_completed',
        'title': 'Timestamp Test',
        'created_at': '2026-06-04T10:30:45Z',
      };

      final dto = LogEntryDto.fromJson(json);
      expect(dto.createdAt, isNotNull);
      expect(dto.createdAt.year, 2026);
      expect(dto.createdAt.month, 6);
      expect(dto.createdAt.day, 4);
      expect(dto.createdAt.hour, 10);
      expect(dto.createdAt.minute, 30);
      expect(dto.createdAt.second, 45);
    });

    test('handles invalid timestamp gracefully', () {
      final json = {
        'id': '10',
        'type': 'quest_completed',
        'title': 'Invalid Timestamp',
        'created_at': 'invalid-date',
      };

      // Should fallback to now
      final dto = LogEntryDto.fromJson(json);
      expect(dto.createdAt, isNotNull);
    });
  });

  group('LogListDto', () {
    test('parses list of logs correctly', () {
      final json = {
        'logs': [
          {
            'id': '1',
            'type': 'quest_completed',
            'title': 'Quest 1',
            'created_at': '2026-06-04T10:00:00Z',
          },
          {
            'id': '2',
            'type': 'learning_roadmap_created',
            'title': 'Roadmap Created',
            'created_at': '2026-06-04T11:00:00Z',
          },
        ],
        'total': 2,
        'limit': 20,
        'offset': 0,
      };

      final dto = LogListDto.fromJson(json);
      expect(dto.logs.length, 2);
      expect(dto.total, 2);
      expect(dto.limit, 20);
      expect(dto.offset, 0);
    });

    test('parses backend success data items response without total', () {
      final json = {
        'items': [
          {
            'id': '1',
            'type': 'questCompleted',
            'title': 'Quest completed',
            'description': 'Legacy camel case',
            'created_at': '2026-06-04T10:00:00Z',
          },
          {
            'id': '2',
            'type': 'learning_roadmap_completed',
            'title': 'Roadmap completed',
            'description': '',
            'created_at': '2026-06-04T11:00:00Z',
            'quest_id': null,
            'quest_type': null,
          },
          {
            'id': '3',
            'type': 'system',
            'title': 'System event',
            'description': '',
            'created_at': '2026-06-04T12:00:00Z',
          },
        ],
        'limit': 20,
        'offset': 0,
      };

      final dto = LogListDto.fromJson(json);
      expect(dto.logs.length, 3);
      expect(dto.total, 3);
      expect(dto.limit, 20);
      expect(dto.offset, 0);
      expect(dto.logs[0].type, LogEntryType.questCompleted);
      expect(dto.logs[1].type, LogEntryType.learningRoadmapCompleted);
      expect(dto.logs[1].questId, isNull);
      expect(dto.logs[1].questType, isNull);
      expect(dto.logs[2].type, LogEntryType.system);
    });

    test('handles empty logs list', () {
      final json = {
        'logs': [],
        'total': 0,
        'limit': 20,
        'offset': 0,
      };

      final dto = LogListDto.fromJson(json);
      expect(dto.logs, isEmpty);
      expect(dto.total, 0);
    });

    test('handles missing logs key', () {
      final json = {
        'total': 0,
        'limit': 20,
        'offset': 0,
      };

      final dto = LogListDto.fromJson(json);
      expect(dto.logs, isEmpty);
    });

    test('handles missing pagination fields', () {
      final json = {
        'logs': [],
      };

      final dto = LogListDto.fromJson(json);
      expect(dto.total, 0);
      expect(dto.limit, 20);
      expect(dto.offset, 0);
    });
  });
}
