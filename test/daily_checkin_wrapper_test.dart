import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/daily_checkin_dto.dart';
import 'package:solo_quest/models/enums/user_enums.dart';
import 'package:solo_quest/services/daily_checkin_service.dart';
import 'package:solo_quest/core/api/services/daily_checkin_api_service.dart';
import 'package:solo_quest/core/network/api_exception.dart';

class MockDailyCheckinApiService implements DailyCheckinApiService {
  final DailyCheckinStatusDto? statusToReturn;
  final ApiException? exceptionToThrow;

  MockDailyCheckinApiService({this.statusToReturn, this.exceptionToThrow});

  @override
  Future<DailyCheckinStatusDto> getToday() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return statusToReturn!;
  }

  @override
  Future<DailyCheckinStatusDto> getByDate(String date) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return statusToReturn!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('DailyCheckinService - wrapper response parsing', () {
    test('hasCheckedInToday returns true when has_checked_in=true and item exists', () async {
      final status = DailyCheckinStatusDto(
        hasCheckedIn: true,
        item: DailyCheckinDto(
          id: 'test-id',
          date: DateTime.parse('2026-06-02'),
          mood: CheckinMood.normal,
          energyLevel: EnergyLevel.medium,
          availability: Availability.normal,
          priority: CheckinPriority.learning,
          availableTimeBlocks: [],
          createdAt: DateTime.parse('2026-06-02T02:46:51.404118Z'),
        ),
        date: DateTime.parse('2026-06-02'),
      );

      final service = DailyCheckinService(
        apiService: MockDailyCheckinApiService(statusToReturn: status),
      );

      final result = await service.hasCheckedInToday();
      expect(result, true);
    });

    test('hasCheckedInToday returns false when has_checked_in=false and item is null', () async {
      final status = DailyCheckinStatusDto(
        hasCheckedIn: false,
        item: null,
        date: DateTime.parse('2026-06-02'),
      );

      final service = DailyCheckinService(
        apiService: MockDailyCheckinApiService(statusToReturn: status),
      );

      final result = await service.hasCheckedInToday();
      expect(result, false);
    });

    test('hasCheckedInToday returns false on 404', () async {
      final service = DailyCheckinService(
        apiService: MockDailyCheckinApiService(
          exceptionToThrow: ApiException(
            statusCode: 404,
            error: 'not_found',
            message: 'Not found',
          ),
        ),
      );

      final result = await service.hasCheckedInToday();
      expect(result, false);
    });

    test('getTodayCheckin returns non-null when item exists', () async {
      final status = DailyCheckinStatusDto(
        hasCheckedIn: true,
        item: DailyCheckinDto(
          id: 'test-id-123',
          date: DateTime.parse('2026-06-02'),
          mood: CheckinMood.good,
          energyLevel: EnergyLevel.high,
          availability: Availability.free,
          priority: CheckinPriority.work,
          availableTimeBlocks: [],
          createdAt: DateTime.parse('2026-06-02T02:46:51.404118Z'),
        ),
        date: DateTime.parse('2026-06-02'),
      );

      final service = DailyCheckinService(
        apiService: MockDailyCheckinApiService(statusToReturn: status),
      );

      final result = await service.getTodayCheckin();
      expect(result, isNotNull);
      expect(result!.id, 'test-id-123');
      expect(result.mood, CheckinMood.good);
      expect(result.energyLevel, EnergyLevel.high);
      expect(result.availability, Availability.free);
      expect(result.priority, CheckinPriority.work);
    });

    test('getTodayCheckin returns null when item is null', () async {
      final status = DailyCheckinStatusDto(
        hasCheckedIn: false,
        item: null,
        date: DateTime.parse('2026-06-02'),
      );

      final service = DailyCheckinService(
        apiService: MockDailyCheckinApiService(statusToReturn: status),
      );

      final result = await service.getTodayCheckin();
      expect(result, isNull);
    });

    test('getTodayCheckin returns null on 404', () async {
      final service = DailyCheckinService(
        apiService: MockDailyCheckinApiService(
          exceptionToThrow: ApiException(
            statusCode: 404,
            error: 'not_found',
            message: 'Not found',
          ),
        ),
      );

      final result = await service.getTodayCheckin();
      expect(result, isNull);
    });
  });

  group('DailyCheckinStatusDto - fromJson parsing', () {
    test('parses wrapper response with has_checked_in=true and item', () {
      final json = {
        'item': {
          'id': 'a11eaade-8e8b-457f-ad87-c30dcfbf6921',
          'user_id': '00000000-0000-0000-0000-000000000001',
          'date': '2026-06-02',
          'mood': 'good',
          'energy_level': 'medium',
          'availability': 'normal',
          'priority': 'learning',
          'created_at': '2026-06-02T02:46:51.404118Z',
          'updated_at': '2026-06-02T13:14:56.881887+07:00',
        },
        'has_checked_in': true,
        'date': '2026-06-02',
      };

      final dto = DailyCheckinStatusDto.fromJson(json);
      expect(dto.hasCheckedIn, true);
      expect(dto.item, isNotNull);
      expect(dto.item!.id, 'a11eaade-8e8b-457f-ad87-c30dcfbf6921');
    });

    test('parses wrapper response with has_checked_in=false and null item', () {
      final json = {
        'item': null,
        'has_checked_in': false,
        'date': '2026-06-02',
      };

      final dto = DailyCheckinStatusDto.fromJson(json);
      expect(dto.hasCheckedIn, false);
      expect(dto.item, isNull);
    });

    test('defaults has_checked_in to false when missing', () {
      final json = {
        'item': null,
        'date': '2026-06-02',
      };

      final dto = DailyCheckinStatusDto.fromJson(json);
      expect(dto.hasCheckedIn, false);
    });
  });
}
