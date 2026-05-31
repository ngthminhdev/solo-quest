import '../../models/progress_model.dart';
import '../../models/enums/quest_enums.dart';

class MockProgressData {
  static final ProgressModel currentProgress = ProgressModel(
    level: 5,
    currentLevelExp: 1250,
    nextLevelExp: 1500,
    totalExp: 4800,
    rewardPoints: 320,
    streakDays: 5,
    totalCompletedQuests: 45,
    totalSkippedQuests: 3,
    weeklyCompletionRate: 0.70,
    completedByType: {
      QuestType.water: 20,
      QuestType.breakTime: 8,
      QuestType.movement: 5,
      QuestType.learning: 4,
      QuestType.fitness: 5,
      QuestType.review: 3,
    },
    streakShields: 2,
    lightDaysUsed: 0,
    bestStreak: 5,
    weeklyDailyData: const [
      DailyCompletion(dayLabel: 'T2', completed: 8, planned: 9),
      DailyCompletion(dayLabel: 'T3', completed: 6, planned: 8),
      DailyCompletion(dayLabel: 'T4', completed: 4, planned: 9),
      DailyCompletion(dayLabel: 'T5', completed: 7, planned: 9),
      DailyCompletion(dayLabel: 'T6', completed: 6, planned: 8),
      DailyCompletion(dayLabel: 'T7', completed: 5, planned: 7),
      DailyCompletion(dayLabel: 'CN', completed: 3, planned: 5),
    ],
  );
}
