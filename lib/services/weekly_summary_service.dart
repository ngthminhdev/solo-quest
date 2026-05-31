import '../models/weekly_summary_model.dart';
import '../models/enums/quest_enums.dart';

class WeeklySummaryService {
  Future<WeeklySummaryModel> getCurrentWeekSummary() async {
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
      insights: const [
        'Water Quest ổn định 5/7 ngày. Hệ thống sẽ giữ nguyên tần suất.',
        'Learning Quest tốt nhất sau 20:00. Khung giờ 20:00–21:30 phù hợp nhất.',
        'Break Quest hay bị hoãn buổi sáng. Có thể đổi thời điểm nhắc.',
        'Movement Quest bị bỏ qua 4 lần. Có thể giảm tần suất hoặc đổi loại.',
        'Daily Review 4/7 ngày. Dữ liệu này giúp hệ thống hiểu bạn hơn.',
      ],
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
