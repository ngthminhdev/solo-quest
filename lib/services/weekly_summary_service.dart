import 'package:flutter/foundation.dart';
import '../core/api/dto/weekly_summary_dto.dart';
import '../core/api/services/weekly_summary_api_service.dart';
import '../core/network/api_exception.dart';
import '../models/weekly_summary_model.dart';
import '../models/enums/quest_enums.dart';

class WeeklySummaryService {
  final WeeklySummaryApiService _apiService;

  WeeklySummaryService({WeeklySummaryApiService? apiService})
      : _apiService = apiService ?? WeeklySummaryApiService();

  WeeklySummaryModel _dtoToModel(WeeklySummaryDto dto) {
    final dailyBreakdown = dto.dailyBreakdown
        .map((d) => WeeklyDailyBreakdown(
              date: d.date,
              completed: d.completed,
              skipped: d.skipped,
              total: d.total,
              rate: d.rate,
            ))
        .toList();

    final categoryBreakdown = dto.categoryBreakdown
        .map((c) => WeeklyCategoryBreakdown(
              category: c.category,
              completed: c.completed,
              total: c.total,
              rate: c.rate,
            ))
        .toList();

    final suggestions = dto.suggestions
        .map((s) => WeeklySuggestion(
              id: s.id,
              title: s.title,
              description: s.description,
              type: s.type,
              actionable: s.actionable,
            ))
        .toList();

    // Build completedByType from categoryBreakdown for legacy widget compatibility
    final completedByType = <QuestType, int>{};
    for (final c in dto.categoryBreakdown) {
      try {
        final type = QuestType.values.byName(c.category);
        completedByType[type] = c.completed;
      } catch (_) {
        // Skip unknown categories
      }
    }

    return WeeklySummaryModel(
      weekStart: dto.weekStart,
      weekEnd: dto.weekEnd,
      completedQuestCount: dto.completedQuestCount,
      skippedQuestCount: dto.skippedQuestCount,
      earnedExp: dto.earnedExp,
      completionRate: dto.completionRate,
      streakDays: dto.streakDays,
      reviewedDays: dto.reviewedDays,
      totalDays: dto.totalDays,
      bestCategory: dto.bestCategory,
      weakestCategory: dto.weakestCategory,
      dailyBreakdown: dailyBreakdown,
      categoryBreakdown: categoryBreakdown,
      insights: dto.insights,
      suggestions: suggestions,
      aiSummary: dto.aiSummary,
      nextWeekFocus: dto.nextWeekFocus,
      suggestedAdjustments: dto.suggestions.map((s) => s.title).toList(),
      completedByType: completedByType,
    );
  }

  Future<WeeklySummaryModel> getCurrentWeekSummary() async {
    try {
      final dto = await _apiService.getCurrentWeekSummary();
      if (kDebugMode) {
        debugPrint('[WEEKLY SUMMARY SERVICE] using real API data');
      }
      return _dtoToModel(dto);
    } on ApiException catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[WEEKLY SUMMARY SERVICE] using mock fallback because: ApiException - ${e.message}');
      }
      return _getMockSummary();
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[WEEKLY SUMMARY SERVICE] using mock fallback because: $e');
      }
      return _getMockSummary();
    }
  }

  Future<WeeklySummaryModel> getWeekSummary({required String weekStart}) async {
    try {
      final dto = await _apiService.getWeekSummary(weekStart: weekStart);
      if (kDebugMode) {
        debugPrint('[WEEKLY SUMMARY SERVICE] using real API data');
      }
      return _dtoToModel(dto);
    } on ApiException catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[WEEKLY SUMMARY SERVICE] using mock fallback because: ApiException - ${e.message}');
      }
      return _getMockSummary();
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[WEEKLY SUMMARY SERVICE] using mock fallback because: $e');
      }
      return _getMockSummary();
    }
  }

  // Mock fallback kept for dev convenience; always logged in debug mode.
  WeeklySummaryModel _getMockSummary() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return WeeklySummaryModel(
      weekStart: DateTime(weekStart.year, weekStart.month, weekStart.day),
      weekEnd: DateTime(weekEnd.year, weekEnd.month, weekEnd.day),
      completedQuestCount: 42,
      skippedQuestCount: 6,
      earnedExp: 1250,
      completionRate: 0.70,
      streakDays: 5,
      reviewedDays: 4,
      totalDays: 7,
      bestCategory: 'learning',
      weakestCategory: 'movement',
      dailyBreakdown: [
        WeeklyDailyBreakdown(
          date: DateTime(now.year, now.month, now.day - 6),
          completed: 6,
          skipped: 1,
          total: 7,
          rate: 0.85,
        ),
        WeeklyDailyBreakdown(
          date: DateTime(now.year, now.month, now.day - 5),
          completed: 4,
          skipped: 2,
          total: 6,
          rate: 0.60,
        ),
        WeeklyDailyBreakdown(
          date: DateTime(now.year, now.month, now.day - 4),
          completed: 6,
          skipped: 1,
          total: 8,
          rate: 0.75,
        ),
        WeeklyDailyBreakdown(
          date: DateTime(now.year, now.month, now.day - 3),
          completed: 7,
          skipped: 1,
          total: 8,
          rate: 0.90,
        ),
        WeeklyDailyBreakdown(
          date: DateTime(now.year, now.month, now.day - 2),
          completed: 4,
          skipped: 2,
          total: 6,
          rate: 0.55,
        ),
        WeeklyDailyBreakdown(
          date: DateTime(now.year, now.month, now.day - 1),
          completed: 5,
          skipped: 1,
          total: 7,
          rate: 0.70,
        ),
        WeeklyDailyBreakdown(
          date: DateTime(now.year, now.month, now.day),
          completed: 5,
          skipped: 2,
          total: 7,
          rate: 0.65,
        ),
      ],
      categoryBreakdown: [
        const WeeklyCategoryBreakdown(
            category: 'water', completed: 15, total: 18, rate: 0.83),
        const WeeklyCategoryBreakdown(
            category: 'learning', completed: 8, total: 10, rate: 0.80),
        const WeeklyCategoryBreakdown(
            category: 'breakTime', completed: 7, total: 10, rate: 0.70),
        const WeeklyCategoryBreakdown(
            category: 'movement', completed: 4, total: 9, rate: 0.44),
        const WeeklyCategoryBreakdown(
            category: 'sleep', completed: 5, total: 7, rate: 0.71),
        const WeeklyCategoryBreakdown(
            category: 'fitness', completed: 3, total: 5, rate: 0.60),
      ],
      insights: const [
        'Water Quest ổn định 5/7 ngày. Hệ thống sẽ giữ nguyên tần suất.',
        'Learning Quest tốt nhất sau 20:00. Khung giờ 20:00–21:30 phù hợp nhất.',
        'Break Quest hay bị hoãn buổi sáng. Có thể đổi thời điểm nhắc.',
        'Movement Quest bị bỏ qua 4 lần. Có thể giảm tần suất hoặc đổi loại.',
        'Daily Review 4/7 ngày. Dữ liệu này giúp hệ thống hiểu bạn hơn.',
      ],
      suggestions: [
        const WeeklySuggestion(
          id: 'suggestion-1',
          title: 'Chuyển Learning Quest sang 20:00–21:30',
          description:
              'Tuần này bạn hoàn thành tốt hơn vào buổi tối.',
          type: 'schedule',
          actionable: true,
        ),
        const WeeklySuggestion(
          id: 'suggestion-2',
          title: 'Giảm Movement Quest còn 3 lần/tuần',
          description: 'Quest này bị bỏ qua 4 lần trong tuần.',
          type: 'frequency',
          actionable: true,
        ),
        const WeeklySuggestion(
          id: 'suggestion-3',
          title: 'Đổi Break Quest buổi sáng: mỗi 90 phút → 120 phút',
          description: 'Bạn thường hoãn Break Quest vào buổi sáng.',
          type: 'schedule',
          actionable: true,
        ),
        const WeeklySuggestion(
          id: 'suggestion-4',
          title: 'Tăng Learning Quest từ 15 phút lên 25 phút',
          description:
              'Tỷ lệ hoàn thành học tập đang tốt, nhưng vẫn có 2 ngày mệt.',
          type: 'duration',
          actionable: true,
        ),
      ],
      aiSummary:
          'Tuần này bạn duy trì học tập tốt, nhưng vận động cần cải thiện.',
      nextWeekFocus: 'movement',
      suggestedAdjustments: const [
        'Chuyển Learning Quest sang 20:00–21:30',
        'Giảm Movement Quest còn 3 lần/tuần',
        'Đổi Break Quest buổi sáng: mỗi 90 phút → 120 phút',
      ],
      completedByType: const {
        QuestType.water: 15,
        QuestType.learning: 8,
        QuestType.breakTime: 7,
        QuestType.movement: 4,
        QuestType.sleep: 5,
        QuestType.fitness: 3,
      },
    );
  }
}
