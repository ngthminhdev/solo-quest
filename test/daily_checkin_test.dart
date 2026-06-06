import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/daily_checkin_dto.dart';
import 'package:solo_quest/core/api/services/daily_checkin_api_service.dart';
import 'package:solo_quest/core/api/requests/api_requests.dart';
import 'package:solo_quest/core/network/api_exception.dart';
import 'package:solo_quest/models/enums/user_enums.dart';
import 'package:solo_quest/services/daily_checkin_service.dart';

class MockDailyCheckinApiService implements DailyCheckinApiService {
  DailyCheckinStatusDto? mockStatus;
  DailyCheckinDto? mockSaveResult;
  ApiException? throwError;

  @override
  Future<DailyCheckinStatusDto> getToday() async {
    if (throwError != null) throw throwError!;
    return mockStatus ?? DailyCheckinStatusDto(
      hasCheckedIn: false,
      date: DateTime.now(),
    );
  }

  @override
  Future<DailyCheckinStatusDto> getByDate(String date) async {
    throw UnimplementedError();
  }

  @override
  Future<DailyCheckinDto> save(SaveDailyCheckinRequest request) async {
    if (throwError != null) throw throwError!;
    return mockSaveResult ?? DailyCheckinDto(
      id: 'test-id',
      date: DateTime.now(),
      mood: request.mood,
      energyLevel: request.energyLevel,
      availability: request.availability,
      priority: request.priority,
      availableTimeBlocks: [],
      createdAt: DateTime.now(),
    );
  }
}

void main() {
  group('DailyCheckinService', () {
    late MockDailyCheckinApiService mockApi;
    late DailyCheckinService service;

    setUp(() {
      mockApi = MockDailyCheckinApiService();
      service = DailyCheckinService(apiService: mockApi);
    });

    group('getTodayCheckin', () {
      test('returns null when no check-in exists (hasCheckedIn=false)', () async {
        mockApi.mockStatus = DailyCheckinStatusDto(
          hasCheckedIn: false,
          item: null,
          date: DateTime.now(),
        );

        final result = await service.getTodayCheckin();
        expect(result, isNull);
      });

      test('returns check-in model when check-in exists', () async {
        final now = DateTime.now();
        mockApi.mockStatus = DailyCheckinStatusDto(
          hasCheckedIn: true,
          item: DailyCheckinDto(
            id: 'checkin-1',
            date: now,
            mood: CheckinMood.good,
            energyLevel: EnergyLevel.high,
            availability: Availability.normal,
            priority: CheckinPriority.learning,
            availableTimeBlocks: [],
            createdAt: now,
          ),
          date: now,
        );

        final result = await service.getTodayCheckin();
        expect(result, isNotNull);
        expect(result!.id, 'checkin-1');
        expect(result.mood, CheckinMood.good);
        expect(result.energyLevel, EnergyLevel.high);
        expect(result.availability, Availability.normal);
        expect(result.priority, CheckinPriority.learning);
      });

      test('returns null on 404 error (no check-in today)', () async {
        mockApi.throwError = ApiException(
          error: 'not_found',
          message: 'Not found',
          statusCode: 404,
        );

        final result = await service.getTodayCheckin();
        expect(result, isNull);
      });

      test('returns null on network error', () async {
        mockApi.throwError = ApiException(
          error: 'server_error',
          message: 'Network error',
          statusCode: 500,
        );

        final result = await service.getTodayCheckin();
        expect(result, isNull);
      });
    });

    group('hasCheckedInToday', () {
      test('returns true when check-in exists', () async {
        mockApi.mockStatus = DailyCheckinStatusDto(
          hasCheckedIn: true,
          date: DateTime.now(),
        );

        final result = await service.hasCheckedInToday();
        expect(result, isTrue);
      });

      test('returns false when no check-in exists', () async {
        mockApi.mockStatus = DailyCheckinStatusDto(
          hasCheckedIn: false,
          date: DateTime.now(),
        );

        final result = await service.hasCheckedInToday();
        expect(result, isFalse);
      });

      test('returns false on 404 error', () async {
        mockApi.throwError = ApiException(
          error: 'not_found',
          message: 'Not found',
          statusCode: 404,
        );

        final result = await service.hasCheckedInToday();
        expect(result, isFalse);
      });

      test('returns false on network error', () async {
        mockApi.throwError = ApiException(
          error: 'server_error',
          message: 'Network error',
          statusCode: 500,
        );

        final result = await service.hasCheckedInToday();
        expect(result, isFalse);
      });
    });
  });

  group('DailyCheckinDto parsing', () {
    test('parses simplified fields correctly', () {
      final json = {
        'id': 'test-id',
        'date': '2026-06-02',
        'mood': 'good',
        'energy_level': 'high',
        'availability': 'normal',
        'priority': 'learning',
        'created_at': '2026-06-02T10:00:00Z',
      };

      final dto = DailyCheckinDto.fromJson(json);
      expect(dto.mood, CheckinMood.good);
      expect(dto.energyLevel, EnergyLevel.high);
      expect(dto.availability, Availability.normal);
      expect(dto.priority, CheckinPriority.learning);
    });

    test('parses all mood variants', () {
      final testCases = {
        'very_bad': CheckinMood.veryBad,
        'bad': CheckinMood.bad,
        'normal': CheckinMood.normal,
        'good': CheckinMood.good,
        'very_good': CheckinMood.veryGood,
      };

      for (final entry in testCases.entries) {
        final json = {
          'id': 'test',
          'date': '2026-06-02',
          'mood': entry.key,
          'energy_level': 'medium',
          'availability': 'normal',
          'priority': 'learning',
          'created_at': '2026-06-02T10:00:00Z',
        };

        final dto = DailyCheckinDto.fromJson(json);
        expect(dto.mood, entry.value, reason: 'Failed for ${entry.key}');
      }
    });

    test('handles legacy Vietnamese mood labels', () {
      final json = {
        'id': 'test-id',
        'date': '2026-06-02',
        'mood': 'Rất tệ',
        'energy_level': 'medium',
        'availability': 'normal',
        'priority': 'learning',
        'created_at': '2026-06-02T10:00:00Z',
      };

      final dto = DailyCheckinDto.fromJson(json);
      expect(dto.mood, CheckinMood.veryBad);
    });

    test('handles legacy enum names for mood', () {
      final json = {
        'id': 'test-id',
        'date': '2026-06-02',
        'mood': 'veryHigh',
        'energy_level': 'medium',
        'availability': 'normal',
        'priority': 'learning',
        'created_at': '2026-06-02T10:00:00Z',
      };

      final dto = DailyCheckinDto.fromJson(json);
      expect(dto.mood, CheckinMood.veryGood);
    });

    test('handles missing optional fields with defaults', () {
      final json = {
        'id': 'test-id',
        'date': '2026-06-02',
        'energy_level': 'medium',
        'created_at': '2026-06-02T10:00:00Z',
      };

      final dto = DailyCheckinDto.fromJson(json);
      expect(dto.mood, CheckinMood.normal);
      expect(dto.availability, Availability.normal);
      expect(dto.priority, CheckinPriority.learning);
    });
  });
}
