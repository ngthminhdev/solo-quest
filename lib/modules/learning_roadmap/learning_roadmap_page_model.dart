import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/learning_roadmap_model.dart';
import '../../models/learning_quest_model.dart';
import '../../models/log_entry_model.dart';
import '../../models/enums/log_enums.dart';
import '../../services/learning_service.dart';
import '../../services/learning_quest_service.dart';
import '../../services/log_service.dart';
import '../../services/service_providers.dart';
import 'widgets/roadmap_suggestion_card.dart';
import 'widgets/roadmap_preference_sheet.dart';

class LearningRoadmapPageState extends BasePageState {
  final AppLoadState loadState;
  final List<LearningRoadmapModel> roadmaps;
  final String? errorMessage;
  final Set<String> selectedTopicIds;
  final bool showPreferenceSheet;
  final bool showSuggestionSheet;
  final bool isLoadingSuggestions;
  final List<RoadmapSuggestion> suggestions;
  final RoadmapPreferences? userPreferences;

  LearningRoadmapPageState({
    this.loadState = AppLoadState.idle,
    this.roadmaps = const [],
    this.errorMessage,
    this.selectedTopicIds = const {},
    this.showPreferenceSheet = false,
    this.showSuggestionSheet = false,
    this.isLoadingSuggestions = false,
    this.suggestions = const [],
    this.userPreferences,
    super.isLockedPage,
  });

  @override
  LearningRoadmapPageState updateState({
    AppLoadState? loadState,
    List<LearningRoadmapModel>? roadmaps,
    String? errorMessage,
    bool? isLockedPage,
    Set<String>? selectedTopicIds,
    bool? showPreferenceSheet,
    bool? showSuggestionSheet,
    bool? isLoadingSuggestions,
    List<RoadmapSuggestion>? suggestions,
    RoadmapPreferences? userPreferences,
  }) {
    return LearningRoadmapPageState(
      loadState: loadState ?? this.loadState,
      roadmaps: roadmaps ?? this.roadmaps,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
      selectedTopicIds: selectedTopicIds ?? this.selectedTopicIds,
      showPreferenceSheet: showPreferenceSheet ?? this.showPreferenceSheet,
      showSuggestionSheet: showSuggestionSheet ?? this.showSuggestionSheet,
      isLoadingSuggestions: isLoadingSuggestions ?? this.isLoadingSuggestions,
      suggestions: suggestions ?? this.suggestions,
      userPreferences: userPreferences ?? this.userPreferences,
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

class LearningRoadmapPageModel extends BasePageModel<LearningRoadmapPageState> {
  LearningRoadmapPageModel({
    required this.learningService,
    required this.learningQuestService,
    required this.logService,
  }) : super(LearningRoadmapPageState());

  final LearningService learningService;
  final LearningQuestService learningQuestService;
  final LogService logService;

  Future<void> loadRoadmaps() async {
    try {
      state = state.updateState(loadState: AppLoadState.loading);

      final roadmaps = await learningService.getRoadmaps();

      roadmaps.sort((a, b) {
        final aDone = a.computedProgress >= 1.0;
        final bDone = b.computedProgress >= 1.0;
        if (aDone != bDone) return aDone ? 1 : -1;
        return b.computedProgress.compareTo(a.computedProgress);
      });

      state = state.updateState(
        loadState: AppLoadState.ready,
        roadmaps: roadmaps,
        errorMessage: null,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: 'Không thể tải lộ trình học. Vui lòng thử lại.',
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
        errorMessage: 'Không thể làm mới lộ trình học. Vui lòng thử lại.',
      );
    }
  }

  void toggleTopicSelection(String topicId) {
    final selected = Set<String>.from(state.selectedTopicIds);
    if (selected.contains(topicId)) {
      selected.remove(topicId);
    } else {
      selected.add(topicId);
    }
    state = state.updateState(selectedTopicIds: selected);
  }

  void clearTopicSelection() {
    state = state.updateState(selectedTopicIds: <String>{});
  }

  Future<bool> toggleStep({
    required String roadmapId,
    required String stepId,
    required bool completed,
  }) async {
    try {
      // Check if user is following the roadmap
      final roadmap = state.roadmaps.firstWhere((r) => r.id == roadmapId);

      // If not following (status is empty or not tracking/completed), follow first
      if (!roadmap.isFollowing) {
        try {
          await learningService.followRoadmap(roadmapId);
        } catch (followError) {
          // If follow fails, stop here
          state = state.updateState(
            errorMessage: 'Không thể theo dõi lộ trình. Vui lòng thử lại.',
          );
          return false;
        }
      }

      // Now toggle the step
      final updatedRoadmap = await learningService.toggleRoadmapStep(
        roadmapId: roadmapId,
        stepId: stepId,
        completed: completed,
      );

      final roadmaps = state.roadmaps
          .map((roadmap) => roadmap.id == roadmapId ? updatedRoadmap : roadmap)
          .toList();
      _sortRoadmaps(roadmaps);
      state = state.updateState(
        loadState: AppLoadState.ready,
        roadmaps: roadmaps,
        errorMessage: null,
      );
      return true;
    } catch (e) {
      // User-friendly error messages
      String errorMessage = 'Không thể cập nhật tiến độ. Vui lòng thử lại.';

      if (e.toString().contains('not found')) {
        errorMessage = 'Không tìm thấy lộ trình hoặc bước học.';
      } else if (e.toString().contains('not following')) {
        errorMessage = 'Bạn chưa theo dõi lộ trình này.';
      }

      state = state.updateState(errorMessage: errorMessage);
      return false;
    }
  }

  Future<bool> addSelectedTopicsToTodayQuest() async {
    if (state.selectedTopicIds.isEmpty) return false;

    try {
      state = state.updateState(isLockedPage: true);

      final selections = <LearningTopicSelection>[];
      for (final roadmap in state.roadmaps) {
        selections.addAll(
          roadmap.steps
              .where((step) => state.selectedTopicIds.contains(step.id))
              .map(
                (step) => LearningTopicSelection(
                  topicId: step.id,
                  title: step.title,
                  sourceTitle: roadmap.title,
                ),
              ),
        );
      }

      await learningQuestService.addTopicsToTodayQuest(selections);
      await logService.addLog(
        LogEntryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
          type: LogEntryType.questCreated,
          title: 'Thêm chủ đề học vào quest hôm nay',
          description: '${selections.length} chủ đề từ lộ trình học',
          metadata: {
            'topic_count': selections.length,
            'source_count': selections
                .map((selection) => selection.sourceTitle)
                .toSet()
                .length,
          },
        ),
      );

      state = state.updateState(
        isLockedPage: false,
        selectedTopicIds: <String>{},
      );
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  // ── Template-based Roadmap Discovery ──
  // TODO: In future, add AI-powered roadmap generation here

  Future<void> loadSuggestions(RoadmapPreferences preferences) async {
    state = state.updateState(
      isLoadingSuggestions: true,
      userPreferences: preferences,
    );

    try {
      // Call backend API to get template suggestions
      final suggestionDtos = await learningService.suggestRoadmaps(
        learningGoal: preferences.learningGoal ?? '',
        category: preferences.category,
        difficulty: _mapPreferredDifficultyToString(preferences.difficulty),
        maxDuration: preferences.maxDuration,
      );

      // Convert DTOs to UI models
      final suggestions = suggestionDtos.map((dto) {
        return RoadmapSuggestion(
          id: dto.id,
          title: dto.title,
          description: dto.description,
          category: dto.category,
          difficulty: _mapStringToDifficulty(dto.difficulty),
          estimatedMinutes: dto.estimatedMinutes,
          totalSteps: dto.totalSteps,
        );
      }).toList();

      state = state.updateState(
        isLoadingSuggestions: false,
        suggestions: suggestions,
        showSuggestionSheet: true,
      );
    } catch (e) {
      state = state.updateState(
        isLoadingSuggestions: false,
        suggestions: [],
        showSuggestionSheet: true,
        errorMessage: 'Không thể tải gợi ý lộ trình. Vui lòng thử lại.',
      );
    }
  }

  String? _mapPreferredDifficultyToString(PreferredDifficulty preferred) {
    switch (preferred) {
      case PreferredDifficulty.beginner:
        return 'beginner';
      case PreferredDifficulty.intermediate:
        return 'intermediate';
      case PreferredDifficulty.advanced:
        return 'advanced';
      case PreferredDifficulty.any:
        return null; // Don't filter by difficulty
    }
  }

  RoadmapDifficulty _mapStringToDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return RoadmapDifficulty.beginner;
      case 'advanced':
        return RoadmapDifficulty.advanced;
      case 'intermediate':
      default:
        return RoadmapDifficulty.intermediate;
    }
  }


  Future<void> createRoadmapFromSuggestion(String suggestionId) async {
    try {
      state = state.updateState(isLockedPage: true);

      // Call backend API to create roadmap from template
      await learningService.createRoadmapFromTemplate(
        templateId: suggestionId,
        learningGoal: state.userPreferences?.learningGoal ?? '',
        category: state.userPreferences?.category,
        difficulty: _mapPreferredDifficultyToString(
          state.userPreferences?.difficulty ?? PreferredDifficulty.any,
        ),
        maxDuration: state.userPreferences?.maxDuration,
      );

      // Reload roadmaps to show the new one
      await loadRoadmaps();

      state = state.updateState(
        isLockedPage: false,
        showPreferenceSheet: false,
        showSuggestionSheet: false,
        suggestions: [],
        userPreferences: null,
        errorMessage: null,
      );

      // Success - roadmap created and list refreshed
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: 'Không thể tạo lộ trình. Vui lòng thử lại.',
      );
    }
  }

  void showPreferenceSheet() {
    state = state.updateState(showPreferenceSheet: true);
  }

  void hideAllSheets() {
    state = state.updateState(
      showPreferenceSheet: false,
      showSuggestionSheet: false,
      suggestions: [],
      userPreferences: null,
    );
  }

  void onPreferencesSubmitted(RoadmapPreferences preferences) {
    // Close preference sheet
    state = state.updateState(showPreferenceSheet: false);

    // Load template suggestions with preferences
    loadSuggestions(preferences);
  }
}

final learningRoadmapPageProvider =
    StateNotifierProvider<LearningRoadmapPageModel, LearningRoadmapPageState>((
      ref,
    ) {
      return LearningRoadmapPageModel(
        learningService: ref.read(learningServiceProvider),
        learningQuestService: ref.read(learningQuestServiceProvider),
        logService: ref.read(logServiceProvider),
      );
    });

void _sortRoadmaps(List<LearningRoadmapModel> roadmaps) {
  roadmaps.sort((a, b) {
    final aDone = a.computedProgress >= 1.0;
    final bDone = b.computedProgress >= 1.0;
    if (aDone != bDone) return aDone ? 1 : -1;
    return a.computedProgress.compareTo(b.computedProgress);
  });
}
