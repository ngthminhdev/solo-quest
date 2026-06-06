import '../core/api/dto/progress_dto.dart';
import '../core/api/services/progress_api_service.dart';
import '../models/progress_model.dart';
import '../models/xp_transaction_model.dart';

class ProgressService {
  final ProgressApiService _apiService;

  ProgressService({ProgressApiService? apiService})
      : _apiService = apiService ?? ProgressApiService();

  /// Convert ProgressDto to ProgressModel
  ProgressModel _dtoToModel(ProgressDto dto) {
    // Convert DailyCompletionDto to DailyCompletion
    final weeklyData = dto.weeklyDailyData.map((d) {
      return DailyCompletion(
        dayLabel: d.dayLabel,
        completed: d.completed,
        planned: d.planned,
      );
    }).toList();

    return ProgressModel(
      level: dto.level,
      currentLevelExp: dto.currentLevelExp,
      nextLevelExp: dto.nextLevelExp,
      totalExp: dto.totalExp,
      rewardPoints: dto.rewardPoints,
      streakDays: dto.streakDays,
      totalCompletedQuests: dto.totalCompletedQuests,
      totalSkippedQuests: dto.totalSkippedQuests,
      weeklyCompletionRate: dto.weeklyCompletionRate,
      completedByType: dto.completedByType,
      streakShields: dto.streakShields,
      lightDaysUsed: dto.lightDaysUsed,
      bestStreak: dto.bestStreak,
      weeklyDailyData: weeklyData,
    );
  }

  Future<ProgressModel> getProgress() async {
    final dto = await _apiService.getProgress();
    return _dtoToModel(dto);
  }

  /// Get XP history with optional pagination
  Future<XPHistoryModel> getXPHistory({
    String? currency,
    int? limit,
    int? offset,
  }) async {
    final dto = await _apiService.getXPHistory(
      currency: currency,
      limit: limit,
      offset: offset,
    );
    return _xpHistoryDtoToModel(dto);
  }

  /// Convert XPHistoryDto to XPHistoryModel
  XPHistoryModel _xpHistoryDtoToModel(XPHistoryDto dto) {
    final transactions = dto.transactions.map((t) {
      return XPTransactionModel(
        id: t.id,
        type: t.type,
        amount: t.amount,
        questId: t.questId,
        questTitle: t.questTitle,
        description: t.description,
        createdAt: t.createdAt,
      );
    }).toList();

    return XPHistoryModel(
      transactions: transactions,
      total: dto.total,
      limit: dto.limit,
      offset: dto.offset,
    );
  }

  /// These methods are kept for local state management
  /// Backend handles the actual updates when quests are completed/rewards claimed
  /// These are now deprecated - backend is source of truth
  @Deprecated('Backend handles quest rewards automatically')
  Future<ProgressModel> addQuestReward({
    required int exp,
    required int points,
  }) async {
    // Just refresh from backend
    return getProgress();
  }

  @Deprecated('Backend handles reward spending automatically')
  Future<ProgressModel> spendRewardPoints(int points) async {
    // Just refresh from backend
    return getProgress();
  }

  @Deprecated('Backend handles streak updates automatically')
  Future<ProgressModel> updateStreak() async {
    // Just refresh from backend
    return getProgress();
  }
}
