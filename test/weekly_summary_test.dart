import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/weekly_summary_dto.dart';
import 'package:solo_quest/core/api/services/weekly_summary_api_service.dart';
import 'package:solo_quest/core/network/api_exception.dart';
import 'package:solo_quest/models/weekly_summary_model.dart';
import 'package:solo_quest/models/enums/quest_enums.dart';
import 'package:solo_quest/services/weekly_summary_service.dart';

class MockWeeklySummaryApiService implements WeeklySummaryApiService {
  WeeklySummaryDto? mockResult;
  Object? throwError;

  @override
  Future<WeeklySummaryDto> getCurrentWeekSummary() async {
    if (throwError != null) throw throwError!;
    return mockResult!;
  }

  @override
  Future<WeeklySummaryDto> getWeekSummary({required String weekStart}) async {
    if (throwError != null) throw throwError!;
    return mockResult!;
  }
}

void main() {
  group('WeeklySummaryDto', () {
    test('parses full response with all fields', () {
      final json = {
        'week_start': '2026-06-01',
        'week_end': '2026-06-07',
        'completed_quest_count': 42,
        'skipped_quest_count': 6,
        'earned_exp': 1250,
        'completion_rate': 0.70,
        'streak_days': 5,
        'reviewed_days': 4,
        'total_days': 7,
        'best_category': 'learning',
        'weakest_category': 'health',
        'daily_breakdown': [
          {
            'date': '2026-06-01',
            'completed': 6,
            'skipped': 1,
            'total': 7,
            'rate': 0.85,
          },
          {
            'date': '2026-06-02',
            'completed': 4,
            'skipped': 2,
            'total': 6,
            'rate': 0.60,
          },
        ],
        'category_breakdown': [
          {
            'category': 'learning',
            'completed': 10,
            'total': 12,
            'rate': 0.83,
          },
          {
            'category': 'water',
            'completed': 15,
            'total': 18,
            'rate': 0.83,
          },
        ],
        'insights': [
          'Bạn hoàn thành tốt các quest học tập trong tuần này.',
        ],
        'suggestions': [
          {
            'id': 'suggestion-1',
            'title': 'Giảm quest buổi sáng',
            'description':
                'Bạn thường bỏ qua quest vào buổi sáng. Hãy chuyển sang buổi tối.',
            'type': 'schedule',
            'actionable': true,
          },
        ],
        'ai_summary': 'Tuần này bạn duy trì học tập tốt.',
        'next_week_focus': 'health',
      };

      final dto = WeeklySummaryDto.fromJson(json);

      expect(dto.weekStart, DateTime(2026, 6, 1));
      expect(dto.weekEnd, DateTime(2026, 6, 7));
      expect(dto.completedQuestCount, 42);
      expect(dto.skippedQuestCount, 6);
      expect(dto.earnedExp, 1250);
      expect(dto.completionRate, 0.70);
      expect(dto.streakDays, 5);
      expect(dto.reviewedDays, 4);
      expect(dto.totalDays, 7);
      expect(dto.bestCategory, 'learning');
      expect(dto.weakestCategory, 'health');
      expect(dto.dailyBreakdown.length, 2);
      expect(dto.dailyBreakdown[0].completed, 6);
      expect(dto.dailyBreakdown[0].skipped, 1);
      expect(dto.dailyBreakdown[0].rate, 0.85);
      expect(dto.categoryBreakdown.length, 2);
      expect(dto.categoryBreakdown[0].category, 'learning');
      expect(dto.categoryBreakdown[0].rate, 0.83);
      expect(dto.insights.length, 1);
      expect(dto.suggestions.length, 1);
      expect(dto.suggestions[0].id, 'suggestion-1');
      expect(dto.suggestions[0].title, 'Giảm quest buổi sáng');
      expect(dto.suggestions[0].type, 'schedule');
      expect(dto.aiSummary, 'Tuần này bạn duy trì học tập tốt.');
      expect(dto.nextWeekFocus, 'health');
    });

    test('parses response with missing optional fields', () {
      final json = {
        'week_start': '2026-06-01',
        'week_end': '2026-06-07',
        'completed_quest_count': 10,
      };

      final dto = WeeklySummaryDto.fromJson(json);

      expect(dto.completedQuestCount, 10);
      expect(dto.skippedQuestCount, 0);
      expect(dto.earnedExp, 0);
      expect(dto.completionRate, 0.0);
      expect(dto.streakDays, 0);
      expect(dto.reviewedDays, 0);
      expect(dto.totalDays, 7);
      expect(dto.bestCategory, isNull);
      expect(dto.weakestCategory, isNull);
      expect(dto.dailyBreakdown, isEmpty);
      expect(dto.categoryBreakdown, isEmpty);
      expect(dto.insights, isEmpty);
      expect(dto.suggestions, isEmpty);
      expect(dto.aiSummary, isNull);
      expect(dto.nextWeekFocus, isNull);
    });

    test('parses empty suggestions list', () {
      final json = {
        'week_start': '2026-06-01',
        'week_end': '2026-06-07',
        'suggestions': <Map<String, dynamic>>[],
      };

      final dto = WeeklySummaryDto.fromJson(json);
      expect(dto.suggestions, isEmpty);
    });

    test('toJson and fromJson roundtrip', () {
      final original = WeeklySummaryDto(
        weekStart: DateTime(2026, 6, 1),
        weekEnd: DateTime(2026, 6, 7),
        completedQuestCount: 42,
        skippedQuestCount: 6,
        earnedExp: 1250,
        completionRate: 0.70,
        streakDays: 5,
        reviewedDays: 4,
        totalDays: 7,
        bestCategory: 'learning',
        weakestCategory: 'health',
        dailyBreakdown: [
          WeeklyDailyBreakdownDto(
            date: DateTime(2026, 6, 1),
            completed: 6,
            skipped: 1,
            total: 7,
            rate: 0.85,
          ),
        ],
        categoryBreakdown: [
          WeeklyCategoryBreakdownDto(
            category: 'learning',
            completed: 10,
            total: 12,
            rate: 0.83,
          ),
        ],
        insights: ['Test insight'],
        suggestions: [
          WeeklySuggestionDto(
            id: 's1',
            title: 'Test',
            description: 'Desc',
            type: 'schedule',
          ),
        ],
        aiSummary: 'AI summary',
        nextWeekFocus: 'health',
      );

      final json = original.toJson();
      final restored = WeeklySummaryDto.fromJson(json);

      expect(restored.completedQuestCount, 42);
      expect(restored.streakDays, 5);
      expect(restored.dailyBreakdown.length, 1);
      expect(restored.categoryBreakdown.length, 1);
      expect(restored.suggestions[0].id, 's1');
      expect(restored.aiSummary, 'AI summary');
    });
  });

  group('WeeklySummaryNestedDtos', () {
    test('WeeklyDailyBreakdownDto parses correctly', () {
      final json = {
        'date': '2026-06-01',
        'completed': 6,
        'skipped': 1,
        'total': 7,
        'rate': 0.85,
      };

      final dto = WeeklyDailyBreakdownDto.fromJson(json);
      expect(dto.date, DateTime(2026, 6, 1));
      expect(dto.completed, 6);
      expect(dto.skipped, 1);
      expect(dto.total, 7);
      expect(dto.rate, 0.85);
    });

    test('WeeklyCategoryBreakdownDto parses correctly', () {
      final json = {
        'category': 'learning',
        'completed': 10,
        'total': 12,
        'rate': 0.83,
      };

      final dto = WeeklyCategoryBreakdownDto.fromJson(json);
      expect(dto.category, 'learning');
      expect(dto.completed, 10);
      expect(dto.total, 12);
      expect(dto.rate, 0.83);
    });

    test('WeeklySuggestionDto parses correctly', () {
      final json = {
        'id': 'suggestion-1',
        'title': 'Giảm quest buổi sáng',
        'description': 'Bạn thường bỏ qua quest vào buổi sáng.',
        'type': 'schedule',
        'actionable': true,
      };

      final dto = WeeklySuggestionDto.fromJson(json);
      expect(dto.id, 'suggestion-1');
      expect(dto.title, 'Giảm quest buổi sáng');
      expect(dto.type, 'schedule');
      expect(dto.actionable, true);
    });

    test('WeeklySuggestionDto handles missing optional fields', () {
      final json = <String, dynamic>{};

      final dto = WeeklySuggestionDto.fromJson(json);
      expect(dto.id, '');
      expect(dto.title, '');
      expect(dto.description, '');
      expect(dto.type, 'general');
      expect(dto.actionable, true);
    });
  });

  group('WeeklySummaryModel', () {
    test('has all new fields with defaults', () {
      final now = DateTime.now();
      final model = WeeklySummaryModel(
        weekStart: now,
        weekEnd: now.add(const Duration(days: 6)),
      );

      expect(model.completedQuestCount, 0);
      expect(model.skippedQuestCount, 0);
      expect(model.earnedExp, 0);
      expect(model.completionRate, 0.0);
      expect(model.streakDays, 0);
      expect(model.reviewedDays, 0);
      expect(model.totalDays, 7);
      expect(model.bestCategory, isNull);
      expect(model.weakestCategory, isNull);
      expect(model.dailyBreakdown, isEmpty);
      expect(model.categoryBreakdown, isEmpty);
      expect(model.insights, isEmpty);
      expect(model.suggestions, isEmpty);
      expect(model.aiSummary, isNull);
      expect(model.nextWeekFocus, isNull);
      expect(model.suggestedAdjustments, isEmpty);
      expect(model.completedByType, isEmpty);
    });

    test('WeeklyCategoryBreakdown.displayLabel maps known types', () {
      const breakdown = WeeklyCategoryBreakdown(
        category: 'water',
        completed: 10,
        total: 12,
        rate: 0.83,
      );
      expect(breakdown.displayLabel, 'Uống nước');
    });

    test('WeeklyCategoryBreakdown.displayLabel falls back for unknown', () {
      const breakdown = WeeklyCategoryBreakdown(
        category: 'unknown_category',
        completed: 5,
        total: 10,
        rate: 0.5,
      );
      expect(breakdown.displayLabel, 'unknown_category');
    });

    test('WeeklyCategoryBreakdown.displayLabel falls back for main', () {
      const breakdown = WeeklyCategoryBreakdown(
        category: 'main',
        completed: 5,
        total: 10,
        rate: 0.5,
      );
      expect(breakdown.displayLabel, 'Chính');
    });

    test('WeeklyCategoryBreakdown.displayLabel falls back for side', () {
      const breakdown = WeeklyCategoryBreakdown(
        category: 'side',
        completed: 5,
        total: 10,
        rate: 0.5,
      );
      expect(breakdown.displayLabel, 'Phụ');
    });

    test('WeeklyCategoryBreakdown.displayLabel falls back for daily', () {
      const breakdown = WeeklyCategoryBreakdown(
        category: 'daily',
        completed: 5,
        total: 10,
        rate: 0.5,
      );
      expect(breakdown.displayLabel, 'Hằng ngày');
    });

    test('WeeklyCategoryBreakdown.displayLabel falls back for weekly', () {
      const breakdown = WeeklyCategoryBreakdown(
        category: 'weekly',
        completed: 5,
        total: 10,
        rate: 0.5,
      );
      expect(breakdown.displayLabel, 'Hằng tuần');
    });
  });

  group('WeeklySummaryService', () {
    late MockWeeklySummaryApiService mockApi;
    late WeeklySummaryService service;

    setUp(() {
      mockApi = MockWeeklySummaryApiService();
      service = WeeklySummaryService(apiService: mockApi);
    });

    test('returns API data when API succeeds', () async {
      mockApi.mockResult = WeeklySummaryDto(
        weekStart: DateTime(2026, 6, 1),
        weekEnd: DateTime(2026, 6, 7),
        completedQuestCount: 42,
        skippedQuestCount: 6,
        earnedExp: 1250,
        completionRate: 0.70,
        streakDays: 5,
        reviewedDays: 4,
        totalDays: 7,
        bestCategory: 'learning',
        weakestCategory: 'health',
        dailyBreakdown: [
          WeeklyDailyBreakdownDto(
            date: DateTime(2026, 6, 1),
            completed: 6,
            skipped: 1,
            total: 7,
            rate: 0.85,
          ),
        ],
        categoryBreakdown: [
          WeeklyCategoryBreakdownDto(
            category: 'learning',
            completed: 10,
            total: 12,
            rate: 0.83,
          ),
          WeeklyCategoryBreakdownDto(
            category: 'water',
            completed: 15,
            total: 18,
            rate: 0.83,
          ),
        ],
        insights: ['Test insight'],
        suggestions: [
          WeeklySuggestionDto(
            id: 's1',
            title: 'Test suggestion',
            description: 'Description',
            type: 'schedule',
          ),
        ],
        aiSummary: 'AI summary',
        nextWeekFocus: 'health',
      );

      final result = await service.getCurrentWeekSummary();

      expect(result.completedQuestCount, 42);
      expect(result.streakDays, 5);
      expect(result.reviewedDays, 4);
      expect(result.totalDays, 7);
      expect(result.bestCategory, 'learning');
      expect(result.dailyBreakdown.length, 1);
      expect(result.categoryBreakdown.length, 2);
      expect(result.suggestions.length, 1);
      expect(result.suggestions[0].id, 's1');
      expect(result.aiSummary, 'AI summary');
      // Legacy fields should be populated
      expect(result.suggestedAdjustments, ['Test suggestion']);
      expect(result.completedByType[QuestType.learning], 10);
      expect(result.completedByType[QuestType.water], 15);
    });

    test('falls back to mock when API throws ApiException', () async {
      mockApi.throwError = ApiException(
        error: 'server_error',
        message: 'Endpoint not found',
        statusCode: 404,
      );

      final result = await service.getCurrentWeekSummary();

      // Should return mock data
      expect(result.completedQuestCount, 42);
      expect(result.streakDays, 5);
      expect(result.insights, isNotEmpty);
      expect(result.suggestions, isNotEmpty);
    });

    test('falls back to mock when API throws generic exception', () async {
      mockApi.throwError = Exception('Connection refused');

      final result = await service.getCurrentWeekSummary();

      expect(result.completedQuestCount, 42);
      expect(result.insights, isNotEmpty);
    });

    test('getWeekSummary falls back to mock on API failure', () async {
      mockApi.throwError = ApiException(
        error: 'server_error',
        message: 'Not found',
        statusCode: 404,
      );

      final result = await service.getWeekSummary(weekStart: '2026-06-01');

      expect(result.completedQuestCount, 42);
      expect(result.insights, isNotEmpty);
    });

    test('mock fallback has all required fields', () async {
      mockApi.throwError = ApiException(
        error: 'server_error',
        message: 'fail',
        statusCode: 500,
      );

      final result = await service.getCurrentWeekSummary();

      expect(result.weekStart, isNotNull);
      expect(result.weekEnd, isNotNull);
      expect(result.completedQuestCount, isNonNegative);
      expect(result.skippedQuestCount, isNonNegative);
      expect(result.earnedExp, isNonNegative);
      expect(result.completionRate, inInclusiveRange(0.0, 1.0));
      expect(result.streakDays, isNonNegative);
      expect(result.reviewedDays, isNonNegative);
      expect(result.totalDays, 7);
      expect(result.dailyBreakdown.length, 7);
      expect(result.categoryBreakdown, isNotEmpty);
      expect(result.insights, isNotEmpty);
      expect(result.suggestions, isNotEmpty);
    });
  });
}
