import '../models/progress_model.dart';
import 'mock/mock_progress_data.dart';

class ProgressService {
  late ProgressModel _progress;

  ProgressService() {
    _progress = MockProgressData.currentProgress;
  }

  Future<ProgressModel> getProgress() async {
    return _progress;
  }

  /// Hoàn thành quest: tăng level EXP, total EXP và rewardPoints.
  /// Không bao giờ trừ totalExp khi đổi thưởng.
  Future<ProgressModel> addQuestReward({
    required int exp,
    required int points,
  }) async {
    var newLevel = _progress.level;
    var newCurrentLevelExp = _progress.currentLevelExp + exp;
    var newNextLevelExp = _progress.nextLevelExp;

    while (newCurrentLevelExp >= newNextLevelExp) {
      newCurrentLevelExp -= newNextLevelExp;
      newLevel += 1;
      newNextLevelExp = _expRequiredForLevel(newLevel);
    }

    _progress = _progress.copyWith(
      level: newLevel,
      currentLevelExp: newCurrentLevelExp,
      nextLevelExp: newNextLevelExp,
      totalExp: _progress.totalExp + exp,
      rewardPoints: _progress.rewardPoints + points,
      totalCompletedQuests: _progress.totalCompletedQuests + 1,
    );
    return _progress;
  }

  /// Chỉ tiêu rewardPoints khi đổi thưởng.
  /// Tuyệt đối không trừ totalExp / currentLevelExp / level.
  Future<ProgressModel> spendRewardPoints(int points) async {
    if (points <= 0) return _progress;
    if (_progress.rewardPoints < points) {
      throw Exception('Not enough reward points');
    }
    _progress = _progress.copyWith(
      rewardPoints: _progress.rewardPoints - points,
    );
    return _progress;
  }

  Future<ProgressModel> updateStreak() async {
    _progress = _progress.copyWith(
      streakDays: _progress.streakDays + 1,
    );
    return _progress;
  }

  int _expRequiredForLevel(int level) {
    return 100 + ((level - 1) * 50);
  }
}
