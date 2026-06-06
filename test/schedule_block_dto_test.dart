import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/schedule_block_dto.dart';
import 'package:solo_quest/models/schedule_model.dart';

void main() {
  group('ScheduleBlockDto.fromJson', () {
    test('parses full backend object correctly', () {
      final json = {
        'id': 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        'title': 'Math Class',
        'type': 'school',
        'days_of_week': [1, 3, 5],
        'start_time': '08:00',
        'end_time': '09:30',
        'is_busy': true,
        'is_flexible': false,
        'enabled': true,
        'location': 'Room 101',
        'note': 'Bring textbook',
        'created_at': '2026-06-03T10:00:00Z',
        'updated_at': '2026-06-03T12:00:00Z',
      };

      final dto = ScheduleBlockDto.fromJson(json);

      expect(dto.id, 'a1b2c3d4-e5f6-7890-abcd-ef1234567890');
      expect(dto.title, 'Math Class');
      expect(dto.type, 'school');
      expect(dto.daysOfWeek, [1, 3, 5]);
      expect(dto.startTime, '08:00');
      expect(dto.endTime, '09:30');
      expect(dto.isBusy, true);
      expect(dto.isFlexible, false);
      expect(dto.enabled, true);
      expect(dto.location, 'Room 101');
      expect(dto.note, 'Bring textbook');
      expect(dto.createdAt, isNotNull);
      expect(dto.updatedAt, isNotNull);
    });

    test('handles null optional fields gracefully', () {
      final json = {
        'id': 'uuid-1',
        'title': 'Work',
        'type': 'work',
        'days_of_week': [1, 2, 3, 4, 5],
        'start_time': '09:00',
        'end_time': '17:00',
      };

      final dto = ScheduleBlockDto.fromJson(json);

      expect(dto.id, 'uuid-1');
      expect(dto.isBusy, false);
      expect(dto.isFlexible, false);
      expect(dto.enabled, true);
      expect(dto.location, isNull);
      expect(dto.note, isNull);
      expect(dto.createdAt, isNull);
      expect(dto.updatedAt, isNull);
    });

    test('handles null days_of_week gracefully', () {
      final json = {
        'id': 'uuid-2',
        'title': 'Sleep',
        'type': 'sleep',
        'days_of_week': null,
        'start_time': '23:00',
        'end_time': '07:00',
      };

      final dto = ScheduleBlockDto.fromJson(json);

      expect(dto.daysOfWeek, isEmpty);
    });

    test('handles null location and note without crashing', () {
      final json = {
        'id': 'uuid-3',
        'title': 'Commute',
        'type': 'commute',
        'days_of_week': [1, 2, 3, 4, 5],
        'start_time': '07:30',
        'end_time': '08:30',
        'location': null,
        'note': null,
      };

      final dto = ScheduleBlockDto.fromJson(json);

      expect(dto.location, isNull);
      expect(dto.note, isNull);
    });
  });

  group('ScheduleBlockDto.toCreateJson', () {
    test('produces correct snake_case keys without id/timestamps', () {
      const dto = ScheduleBlockDto(
        id: 'should-be-ignored',
        title: 'Study Session',
        type: 'study',
        daysOfWeek: [2, 4],
        startTime: '19:00',
        endTime: '21:00',
        isBusy: false,
        isFlexible: true,
        location: 'Library',
        note: '',
      );

      final json = dto.toCreateJson();

      expect(json['title'], 'Study Session');
      expect(json['type'], 'study');
      expect(json['days_of_week'], [2, 4]);
      expect(json['start_time'], '19:00');
      expect(json['end_time'], '21:00');
      expect(json['is_busy'], false);
      expect(json['is_flexible'], true);
      expect(json['location'], 'Library');
      expect(json['note'], '');
      // Should NOT contain id, created_at, updated_at
      expect(json.containsKey('id'), false);
      expect(json.containsKey('created_at'), false);
      expect(json.containsKey('updated_at'), false);
      expect(json.containsKey('enabled'), false);
    });

    test('omits null location and note', () {
      const dto = ScheduleBlockDto(
        id: 'uuid',
        title: 'Work',
        type: 'work',
        daysOfWeek: [1, 2, 3, 4, 5],
        startTime: '09:00',
        endTime: '17:00',
      );

      final json = dto.toCreateJson();

      expect(json.containsKey('location'), false);
      expect(json.containsKey('note'), false);
    });
  });

  group('ScheduleBlockDto.toUpdateJson', () {
    test('includes enabled field but omits id/timestamps', () {
      const dto = ScheduleBlockDto(
        id: 'uuid-to-ignore',
        title: 'Updated Title',
        type: 'personal',
        daysOfWeek: [6, 7],
        startTime: '10:00',
        endTime: '12:00',
        isBusy: true,
        isFlexible: false,
        enabled: true,
      );

      final json = dto.toUpdateJson();

      expect(json['title'], 'Updated Title');
      expect(json['enabled'], true);
      expect(json.containsKey('id'), false);
      expect(json.containsKey('created_at'), false);
      expect(json.containsKey('updated_at'), false);
    });
  });

  group('ScheduleBlockModel.fromDto', () {
    test('maps DTO fields to model correctly', () {
      const dto = ScheduleBlockDto(
        id: 'uuid-1',
        title: 'Gym',
        type: 'personal',
        daysOfWeek: [2, 4, 6],
        startTime: '18:00',
        endTime: '19:00',
        isBusy: false,
        isFlexible: true,
        enabled: true,
        location: 'Fitness Center',
        note: 'Leg day',
      );

      final model = ScheduleBlockModel.fromDto(dto);

      expect(model.id, 'uuid-1');
      expect(model.title, 'Gym');
      expect(model.type, 'personal');
      expect(model.weekdays, [2, 4, 6]);
      expect(model.timeRange.start, '18:00');
      expect(model.timeRange.end, '19:00');
      expect(model.isBusy, false);
      expect(model.isFlexible, true);
      expect(model.enabled, true);
      expect(model.location, 'Fitness Center');
      expect(model.note, 'Leg day');
    });
  });

  group('ScheduleBlockModel.toDto', () {
    test('converts model back to DTO correctly', () {
      const model = ScheduleBlockModel(
        id: 'uuid-2',
        title: 'Lunch',
        timeRange: TimeRangeModel(start: '12:00', end: '13:00'),
        weekdays: [1, 2, 3, 4, 5],
        type: 'meal',
        isFlexible: false,
        isBusy: true,
        enabled: true,
      );

      final dto = model.toDto();

      expect(dto.id, 'uuid-2');
      expect(dto.title, 'Lunch');
      expect(dto.type, 'meal');
      expect(dto.daysOfWeek, [1, 2, 3, 4, 5]);
      expect(dto.startTime, '12:00');
      expect(dto.endTime, '13:00');
      expect(dto.isBusy, true);
      expect(dto.isFlexible, false);
      expect(dto.enabled, true);
    });
  });

  group('ScheduleBlockDto backend response parsing', () {
    test('parses GET envelope data list into DTO list', () {
      // Simulates what ApiResponseParser.extractList would produce
      final dataList = [
        {
          'id': 'uuid-1',
          'title': 'School',
          'type': 'school',
          'days_of_week': [1, 3, 5],
          'start_time': '08:00',
          'end_time': '09:30',
          'is_busy': true,
          'is_flexible': false,
          'enabled': true,
          'location': null,
          'note': null,
          'created_at': '2026-06-03T10:00:00Z',
          'updated_at': '2026-06-03T10:00:00Z',
        },
        {
          'id': 'uuid-2',
          'title': 'Free Time',
          'type': 'free',
          'days_of_week': [6, 7],
          'start_time': '14:00',
          'end_time': '18:00',
          'is_busy': false,
          'is_flexible': true,
          'enabled': true,
          'location': null,
          'note': 'Relax',
          'created_at': '2026-06-03T10:00:00Z',
          'updated_at': '2026-06-03T10:00:00Z',
        },
      ];

      final dtos = dataList
          .map((item) =>
              ScheduleBlockDto.fromJson(item as Map<String, dynamic>))
          .toList();

      expect(dtos.length, 2);
      expect(dtos[0].title, 'School');
      expect(dtos[0].type, 'school');
      expect(dtos[0].isBusy, true);
      expect(dtos[1].title, 'Free Time');
      expect(dtos[1].type, 'free');
      expect(dtos[1].isBusy, false);
      expect(dtos[1].note, 'Relax');
    });

    test('parses empty data list as empty DTO list', () {
      final List<dynamic> dataList = [];

      final dtos = dataList
          .map((item) =>
              ScheduleBlockDto.fromJson(item as Map<String, dynamic>))
          .toList();

      expect(dtos, isEmpty);
    });

    test('parses all valid backend type values', () {
      final validTypes = [
        'school',
        'work',
        'commute',
        'meal',
        'sleep',
        'study',
        'personal',
        'busy',
        'free',
        'other',
      ];

      for (final type in validTypes) {
        final json = {
          'id': 'uuid-$type',
          'title': 'Test $type',
          'type': type,
          'days_of_week': [1],
          'start_time': '10:00',
          'end_time': '11:00',
        };

        final dto = ScheduleBlockDto.fromJson(json);
        expect(dto.type, type, reason: 'Failed to parse type: $type');
      }
    });
  });
}
