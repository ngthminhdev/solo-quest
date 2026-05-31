import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/reward_model.dart';
import '../../models/progress_model.dart';
import '../../models/log_entry_model.dart';
import '../../models/enums/reward_enums.dart';
import '../../models/enums/log_enums.dart';
import '../../services/reward_service.dart';
import '../../services/progress_service.dart';
import '../../services/log_service.dart';
import '../../services/service_providers.dart';

class RewardsPageState extends BasePageState {
  final AppLoadState loadState;
  final List<RewardModel> rewards;
  final List<RewardModel> filteredRewards;
  final ProgressModel? progress;
  final RewardType? selectedType;
  final String? errorMessage;

  RewardsPageState({
    this.loadState = AppLoadState.idle,
    this.rewards = const [],
    this.filteredRewards = const [],
    this.progress,
    this.selectedType,
    this.errorMessage,
    super.isLockedPage,
  });

  @override
  RewardsPageState updateState({
    AppLoadState? loadState,
    List<RewardModel>? rewards,
    List<RewardModel>? filteredRewards,
    ProgressModel? progress,
    RewardType? selectedType,
    bool clearSelectedType = false,
    String? errorMessage,
    bool? isLockedPage,
  }) {
    return RewardsPageState(
      loadState: loadState ?? this.loadState,
      rewards: rewards ?? this.rewards,
      filteredRewards: filteredRewards ?? this.filteredRewards,
      progress: progress ?? this.progress,
      selectedType:
          clearSelectedType ? null : selectedType ?? this.selectedType,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  int get availablePoints => progress?.rewardPoints ?? 0;

  int get availableRewardCount => rewards
      .where((r) =>
          r.status == RewardStatus.available && r.costPoints <= availablePoints)
      .length;

  int get claimedRewardCount =>
      rewards.where((r) => r.status == RewardStatus.claimed).length;

  bool canClaim(RewardModel reward) {
    return reward.status == RewardStatus.available &&
        availablePoints >= reward.costPoints;
  }

  bool get hasRewards => filteredRewards.isNotEmpty;
}

class RewardsPageModel extends BasePageModel<RewardsPageState> {
  RewardsPageModel({
    required this.rewardService,
    required this.progressService,
    required this.logService,
  }) : super(RewardsPageState());

  final RewardService rewardService;
  final ProgressService progressService;
  final LogService logService;

  Future<void> loadRewards() async {
    state = state.updateState(loadState: AppLoadState.loading);

    try {
      final results = await Future.wait([
        rewardService.getRewards(),
        progressService.getProgress(),
      ]);

      final rewards = results[0] as List<RewardModel>;
      final progress = results[1] as ProgressModel;

      state = state.updateState(
        loadState: AppLoadState.ready,
        rewards: rewards,
        progress: progress,
      );
      _applyFilters();
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: 'Không thể tải phần thưởng: ${e.toString()}',
      );
    }
  }

  Future<void> refreshRewards() async {
    try {
      final results = await Future.wait([
        rewardService.getRewards(),
        progressService.getProgress(),
      ]);

      final rewards = results[0] as List<RewardModel>;
      final progress = results[1] as ProgressModel;

      state = state.updateState(
        rewards: rewards,
        progress: progress,
      );
      _applyFilters();
    } catch (_) {}
  }

  Future<bool> claimReward(String rewardId) async {
    if (state.isLockedPage) return false;

    final reward = state.rewards.where((r) => r.id == rewardId).firstOrNull;
    if (reward == null) return false;
    if (state.progress == null) return false;
    if (!state.canClaim(reward)) return false;

    state = state.updateState(isLockedPage: true);

    try {
      await progressService.spendRewardPoints(reward.costPoints);
      final claimed = await rewardService.claimReward(rewardId);

      await logService.addLog(LogEntryModel(
        id: 'log_reward_${claimed.id}_${DateTime.now().millisecondsSinceEpoch}',
        type: LogEntryType.rewardClaimed,
        title: 'Đã đổi phần thưởng',
        description: claimed.title,
        createdAt: DateTime.now(),
        pointsChanged: -claimed.costPoints,
        metadata: {
          'rewardId': claimed.id,
          'rewardTitle': claimed.title,
        },
      ));

      await refreshRewards();
      state = state.updateState(isLockedPage: false);
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: 'Không thể đổi phần thưởng: ${e.toString()}',
      );
      return false;
    }
  }

  void selectType(RewardType? type) {
    state = state.updateState(
      selectedType: type,
      clearSelectedType: type == null,
    );
    _applyFilters();
  }

  void clearFilter() {
    state = state.updateState(clearSelectedType: true);
    _applyFilters();
  }

  void _applyFilters() {
    final selectedType = state.selectedType;

    var filtered = state.rewards.where((reward) {
      if (selectedType != null && reward.type != selectedType) return false;
      return true;
    }).toList();

    filtered.sort((a, b) {
      final statusOrder = {
        RewardStatus.available: 0,
        RewardStatus.locked: 1,
        RewardStatus.claimed: 2,
      };
      final aOrder = statusOrder[a.status] ?? 3;
      final bOrder = statusOrder[b.status] ?? 3;
      if (aOrder != bOrder) return aOrder.compareTo(bOrder);
      return a.costPoints.compareTo(b.costPoints);
    });

    state = state.updateState(filteredRewards: filtered);
  }
}

final rewardsPageProvider =
    StateNotifierProvider<RewardsPageModel, RewardsPageState>((ref) {
  return RewardsPageModel(
    rewardService: ref.read(rewardServiceProvider),
    progressService: ref.read(progressServiceProvider),
    logService: ref.read(logServiceProvider),
  );
});
