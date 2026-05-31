import '../models/reward_model.dart';
import '../models/enums/reward_enums.dart';
import 'mock/mock_reward_data.dart';

class RewardService {
  late List<RewardModel> _rewards;

  RewardService() {
    _rewards = MockRewardData.rewards.map((r) => r).toList();
  }

  Future<List<RewardModel>> getRewards() async {
    return List.from(_rewards);
  }

  Future<List<RewardModel>> getAvailableRewards() async {
    return _rewards.where((r) => r.status == RewardStatus.available).toList();
  }

  Future<RewardModel> claimReward(String rewardId) async {
    final index = _rewards.indexWhere((r) => r.id == rewardId);
    if (index == -1) throw Exception('Reward not found');

    final reward = _rewards[index];
    if (reward.status == RewardStatus.claimed) {
      throw Exception('Reward already claimed');
    }
    if (reward.status == RewardStatus.locked) {
      throw Exception('Reward is locked');
    }

    _rewards[index] = reward.copyWith(
      status: RewardStatus.claimed,
      claimedAt: DateTime.now(),
    );
    return _rewards[index];
  }
}
