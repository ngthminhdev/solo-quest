import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/daily_review_dto.dart';
import 'package:solo_quest/core/api/services/daily_review_api_service.dart';
import 'package:solo_quest/core/api/requests/api_requests.dart';
import 'package:solo_quest/core/network/api_exception.dart';
import 'package:solo_quest/core/utils/enum_mapper.dart';
import 'package:solo_quest/models/enums/user_enums.dart';
import 'package:solo_quest/services/daily_review_service.dart';

class MockDailyReviewApiService implements DailyReviewApiService {
  DailyReviewStatusDto? mockStatus;
  DailyReviewDto? mockSaveResult;
  ApiException? throwError;

  @override
  Future<DailyReviewStatusDto> getToday() async {
    if (throwError != null) throw throwError!;
    return mockStatus ?? DailyReviewStatusDto(
      hasReviewed: false,
      date: DateTime.now(),
    );
  }

  @override
  Future<DailyReviewStatusDto> getByDate(String date) async {
    throw UnimplementedError();
  }

  @override
  Future<DailyReviewSummaryDto> getSummary({String? date}) async {
    throw UnimplementedError();
  }

  @override
  Future<DailyReviewDto> save(SaveDailyReviewRequest request) async {
    if (throwError != null) throw throwError!;
    return mockSaveResult ?? DailyReviewDto(
      id: 'test-id',
      date: DateTime.now(),
      mood: parseCheckinMood(request.mood),
      energyLevel: parseEnergyLevel(request.energyLevel),
      satisfaction: request.satisfaction,
      reflection: request.reflection,
      tomorrowPriority: parseCheckinPriority(request.tomorrowPriority),
      createdAt: DateTime.now(),
    );
  }
}

void main() {
  group('DailyReviewService', () {
    late MockDailyReviewApiService mockApi;
    late DailyReviewService service;

    setUp(() {
      mockApi = MockDailyReviewApiService();
      service = DailyReviewService(apiService: mockApi);
    });

    group('getTodayReview', () {
      test('returns null when no review exists (hasReviewed=false)', () async {
        mockApi.mockStatus = DailyReviewStatusDto(
          hasReviewed: false,
          item: null,
          date: DateTime.now(),
        );

        final result = await service.getTodayReview();
        expect(result, isNull);
      });

      test('returns review model when review exists', () async {
        final now = DateTime.now();
        mockApi.mockStatus = DailyReviewStatusDto(
          hasReviewed: true,
          item: DailyReviewDto(
            id: 'review-1',
            date: now,
            mood: CheckinMood.good,
            energyLevel: EnergyLevel.high,
            satisfaction: 4,
            reflection: 'Hôm nay học tốt',
            tomorrowPriority: CheckinPriority.learning,
            createdAt: now,
          ),
          date: now,
        );

        final result = await service.getTodayReview();
        expect(result, isNotNull);
        expect(result!.id, 'review-1');
        expect(result.mood, CheckinMood.good);
        expect(result.energyLevel, EnergyLevel.high);
        expect(result.satisfaction, 4);
        expect(result.reflection, 'Hôm nay học tốt');
        expect(result.tomorrowPriority, CheckinPriority.learning);
      });

      test('returns null on 404 error (no review today)', () async {
        mockApi.throwError = ApiException(
          error: 'not_found',
          message: 'Not found',
          statusCode: 404,
        );

        final result = await service.getTodayReview();
        expect(result, isNull);
      });

      test('returns null on network error', () async {
        mockApi.throwError = ApiException(
          error: 'server_error',
          message: 'Network error',
          statusCode: 500,
        );

        final result = await service.getTodayReview();
        expect(result, isNull);
      });
    });

    group('hasReviewedToday', () {
      test('returns true when review exists', () async {
        mockApi.mockStatus = DailyReviewStatusDto(
          hasReviewed: true,
          date: DateTime.now(),
        );

        final result = await service.hasReviewedToday();
        expect(result, isTrue);
      });

      test('returns false when no review exists', () async {
        mockApi.mockStatus = DailyReviewStatusDto(
          hasReviewed: false,
          date: DateTime.now(),
        );

        final result = await service.hasReviewedToday();
        expect(result, isFalse);
      });

      test('returns false on 404 error', () async {
        mockApi.throwError = ApiException(
          error: 'not_found',
          message: 'Not found',
          statusCode: 404,
        );

        final result = await service.hasReviewedToday();
        expect(result, isFalse);
      });

      test('returns false on network error', () async {
        mockApi.throwError = ApiException(
          error: 'server_error',
          message: 'Network error',
          statusCode: 500,
        );

        final result = await service.hasReviewedToday();
        expect(result, isFalse);
      });
    });
  });

  group('DailyReviewDto parsing', () {
    test('parses simplified fields correctly', () {
      final json = {
        'id': 'test-id',
        'date': '2026-06-02',
        'mood': 'good',
        'energy_level': 'high',
        'satisfaction': 4,
        'reflection': 'Hôm nay học tốt',
        'tomorrow_priority': 'learning',
        'created_at': '2026-06-02T10:00:00Z',
      };

      final dto = DailyReviewDto.fromJson(json);
      expect(dto.mood, CheckinMood.good);
      expect(dto.energyLevel, EnergyLevel.high);
      expect(dto.satisfaction, 4);
      expect(dto.reflection, 'Hôm nay học tốt');
      expect(dto.tomorrowPriority, CheckinPriority.learning);
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
          'satisfaction': 3,
          'tomorrow_priority': 'learning',
          'created_at': '2026-06-02T10:00:00Z',
        };

        final dto = DailyReviewDto.fromJson(json);
        expect(dto.mood, entry.value, reason: 'Failed for ${entry.key}');
      }
    });

    test('handles optional fields', () {
      final json = {
        'id': 'test-id',
        'date': '2026-06-02',
        'mood': 'normal',
        'energy_level': 'medium',
        'satisfaction': 3,
        'tomorrow_priority': 'learning',
        'created_at': '2026-06-02T10:00:00Z',
      };

      final dto = DailyReviewDto.fromJson(json);
      expect(dto.reflection, isNull);
      expect(dto.aiSummary, isNull);
    });

    test('parses ai_summary when present', () {
      final json = {
        'id': 'test-id',
        'date': '2026-06-02',
        'mood': 'good',
        'energy_level': 'high',
        'satisfaction': 4,
        'tomorrow_priority': 'learning',
        'ai_summary': 'Bạn có một ngày tốt!',
        'created_at': '2026-06-02T10:00:00Z',
      };

      final dto = DailyReviewDto.fromJson(json);
      expect(dto.aiSummary, 'Bạn có một ngày tốt!');
    });
  });
}
