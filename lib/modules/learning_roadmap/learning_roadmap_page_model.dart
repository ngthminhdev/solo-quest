import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/learning_roadmap_model.dart';
import '../../models/log_entry_model.dart';
import '../../models/enums/log_enums.dart';
import '../../services/learning_service.dart';
import '../../services/log_service.dart';
import '../../services/service_providers.dart';

class LearningRoadmapPageState extends BasePageState {
  final AppLoadState loadState;
  final List<LearningRoadmapModel> roadmaps;
  final String? errorMessage;

  LearningRoadmapPageState({
    this.loadState = AppLoadState.idle,
    this.roadmaps = const [],
    this.errorMessage,
    super.isLockedPage,
  });

  @override
  LearningRoadmapPageState updateState({
    AppLoadState? loadState,
    List<LearningRoadmapModel>? roadmaps,
    String? errorMessage,
    bool? isLockedPage,
  }) {
    return LearningRoadmapPageState(
      loadState: loadState ?? this.loadState,
      roadmaps: roadmaps ?? this.roadmaps,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  bool get hasRoadmaps => roadmaps.isNotEmpty;

  int get totalRoadmaps => roadmaps.length;

  int get completedRoadmaps =>
      roadmaps.where((r) => r.computedProgress >= 1.0).length;

  int get totalSteps =>
      roadmaps.fold<int>(0, (sum, roadmap) => sum + roadmap.totalSteps);

  int get completedSteps =>
      roadmaps.fold<int>(0, (sum, roadmap) => sum + roadmap.completedSteps);

  double get averageProgress {
    if (roadmaps.isEmpty) return 0;
    final total = roadmaps.fold<double>(
      0,
      (sum, roadmap) => sum + roadmap.computedProgress,
    );
    return (total / roadmaps.length).clamp(0.0, 1.0);
  }
}

class LearningRoadmapPageModel
    extends BasePageModel<LearningRoadmapPageState> {
  LearningRoadmapPageModel({
    required this.learningService,
    required this.logService,
  }) : super(LearningRoadmapPageState());

  final LearningService learningService;
  final LogService logService;

  Future<void> loadRoadmaps() async {
    try {
      state = state.updateState(loadState: AppLoadState.loading);

      final roadmaps = await learningService.getRoadmaps();

      roadmaps.sort((a, b) {
        final aDone = a.computedProgress >= 1.0;
        final bDone = b.computedProgress >= 1.0;
        if (aDone != bDone) return aDone ? 1 : -1;
        return a.computedProgress.compareTo(b.computedProgress);
      });

      state = state.updateState(
        loadState: AppLoadState.ready,
        roadmaps: roadmaps,
        errorMessage: null,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshRoadmaps() async {
    try {
      final roadmaps = await learningService.getRoadmaps();

      roadmaps.sort((a, b) {
        final aDone = a.computedProgress >= 1.0;
        final bDone = b.computedProgress >= 1.0;
        if (aDone != bDone) return aDone ? 1 : -1;
        return a.computedProgress.compareTo(b.computedProgress);
      });

      state = state.updateState(
        loadState: AppLoadState.ready,
        roadmaps: roadmaps,
        errorMessage: null,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> toggleStep({
    required String roadmapId,
    required String stepId,
    required bool completed,
  }) async {
    try {
      state = state.updateState(isLockedPage: true);

      await learningService.toggleRoadmapStep(
        roadmapId: roadmapId,
        stepId: stepId,
        completed: completed,
      );

      if (completed) {
        await logService.addLog(
          LogEntryModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            createdAt: DateTime.now(),
            type: LogEntryType.profileUpdated,
            title: 'Hoàn thành bước học tập',
            description: 'Bước $stepId trong roadmap $roadmapId',
            metadata: {
              'roadmap_id': roadmapId,
              'step_id': stepId,
            },
          ),
        );
      }

      await loadRoadmaps();

      state = state.updateState(isLockedPage: false);
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final learningRoadmapPageProvider = StateNotifierProvider<
    LearningRoadmapPageModel, LearningRoadmapPageState>((ref) {
  return LearningRoadmapPageModel(
    learningService: ref.read(learningServiceProvider),
    logService: ref.read(logServiceProvider),
  );
});
