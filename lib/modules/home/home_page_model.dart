import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/quest_model.dart';
import '../../models/progress_model.dart';
import '../../services/quest_service.dart';
import '../../services/progress_service.dart';
import '../../services/log_service.dart';
import '../../services/service_providers.dart';

class HomePageState extends BasePageState {
  final AppLoadState loadState;
  final List<QuestModel> activeQuests;
  final List<QuestModel> upcomingQuests;
  final List<QuestModel> completedQuests;
  final ProgressModel? progress;
  final String? errorMessage;
  final String? todayInsight;

  HomePageState({
    this.loadState = AppLoadState.idle,
    this.activeQuests = const [],
    this.upcomingQuests = const [],
    this.completedQuests = const [],
    this.progress,
    this.errorMessage,
    this.todayInsight,
    super.isLockedPage,
  });

  int get totalTodayQuestCount =>
      activeQuests.length + upcomingQuests.length + completedQuests.length;

  int get completedTodayQuestCount => completedQuests.length;

  double get todayCompletionRate {
    if (totalTodayQuestCount == 0) return 0.0;
    return completedTodayQuestCount / totalTodayQuestCount;
  }

  bool get hasAnyQuest =>
      activeQuests.isNotEmpty || upcomingQuests.isNotEmpty || completedQuests.isNotEmpty;

  @override
  HomePageState updateState({
    AppLoadState? loadState,
    List<QuestModel>? activeQuests,
    List<QuestModel>? upcomingQuests,
    List<QuestModel>? completedQuests,
    ProgressModel? progress,
    String? errorMessage,
    String? todayInsight,
    bool? isLockedPage,
  }) {
    return HomePageState(
      loadState: loadState ?? this.loadState,
      activeQuests: activeQuests ?? this.activeQuests,
      upcomingQuests: upcomingQuests ?? this.upcomingQuests,
      completedQuests: completedQuests ?? this.completedQuests,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      todayInsight: todayInsight ?? this.todayInsight,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }
}

class HomePageModel extends BasePageModel<HomePageState> {
  HomePageModel({
    required this.questService,
    required this.progressService,
    required this.logService,
  }) : super(HomePageState());

  final QuestService questService;
  final ProgressService progressService;
  final LogService logService;

  Future<void> loadHomeData() async {
    state = state.updateState(loadState: AppLoadState.loading);

    try {
      final allQuests = await questService.getTodayQuests();
      final active = allQuests.where((q) => q.isActive).toList();
      final upcoming = allQuests.where((q) => q.isPending).toList();
      final completed = allQuests.where((q) => q.isCompleted).toList();
      final progress = await progressService.getProgress();

      state = state.updateState(
        loadState: AppLoadState.ready,
        activeQuests: active,
        upcomingQuests: upcoming,
        completedQuests: completed,
        progress: progress,
        todayInsight: 'Dựa trên check-in sáng nay: năng lượng 3/5, stress thấp. '
            'Hệ thống đề xuất lịch nhẹ — ưu tiên học tập ngắn, nghỉ mắt và uống nước đều đặn.',
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: 'Không thể tải dữ liệu: ${e.toString()}',
      );
    }
  }

  Future<void> startQuest(String questId) async {
    state = state.updateState(isLockedPage: true);
    try {
      await questService.startQuest(questId);
      await loadHomeData();
    } catch (e) {
      state = state.updateState(
        errorMessage: 'Không thể bắt đầu nhiệm vụ',
      );
    } finally {
      state = state.updateState(isLockedPage: false);
    }
  }

  Future<void> completeQuest(String questId, {String? note, String? mood}) async {
    state = state.updateState(isLockedPage: true);
    try {
      final quest = await questService.completeQuest(questId, note: note, mood: mood);
      if (quest.exp > 0) {
        await progressService.addQuestReward(
          exp: quest.exp,
          points: quest.exp,
        );
      }
      await loadHomeData();
    } catch (e) {
      state = state.updateState(
        errorMessage: 'Không thể hoàn thành nhiệm vụ',
      );
    } finally {
      state = state.updateState(isLockedPage: false);
    }
  }

  Future<void> snoozeQuest(String questId, {required int minutes}) async {
    state = state.updateState(isLockedPage: true);
    try {
      await questService.snoozeQuest(questId, minutes: minutes);
      await loadHomeData();
    } catch (e) {
      state = state.updateState(
        errorMessage: 'Không thể hoãn nhiệm vụ',
      );
    } finally {
      state = state.updateState(isLockedPage: false);
    }
  }

  Future<void> skipQuest(String questId, {required String reason}) async {
    state = state.updateState(isLockedPage: true);
    try {
      await questService.skipQuest(questId, reason: reason);
      await loadHomeData();
    } catch (e) {
      state = state.updateState(
        errorMessage: 'Không thể bỏ qua nhiệm vụ',
      );
    } finally {
      state = state.updateState(isLockedPage: false);
    }
  }
}

final homePageProvider = StateNotifierProvider<HomePageModel, HomePageState>((ref) {
  return HomePageModel(
    questService: ref.read(questServiceProvider),
    progressService: ref.read(progressServiceProvider),
    logService: ref.read(logServiceProvider),
  );
});
