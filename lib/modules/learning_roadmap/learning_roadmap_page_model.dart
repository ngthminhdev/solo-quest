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
import '../../core/api/dto/roadmap_suggestion_dto.dart';
import '../../config/app_session.dart';
import '../../widgets/app_toast/app_toast_service.dart';
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
  final bool isGeneratingRoadmap;
  final String? generationStatusMessage;
  final String? generationError;
  final String? activeGenerationJobId;

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
    this.isGeneratingRoadmap = false,
    this.generationStatusMessage,
    this.generationError,
    this.activeGenerationJobId,
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
    bool? isGeneratingRoadmap,
    String? generationStatusMessage,
    String? generationError,
    String? activeGenerationJobId,
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
      isGeneratingRoadmap: isGeneratingRoadmap ?? this.isGeneratingRoadmap,
      generationStatusMessage: generationStatusMessage,
      generationError: generationError,
      activeGenerationJobId: activeGenerationJobId,
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

  int _generationSequenceId = 0;

  bool _isGenerationCancelled(int sequenceId) {
    return sequenceId != _generationSequenceId;
  }

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

  Future<bool> deleteRoadmap(String roadmapId) async {
    try {
      state = state.updateState(isLockedPage: true);
      await learningService.deleteRoadmap(roadmapId);

      // Remove from list and update state
      final updatedRoadmaps = state.roadmaps.where((r) => r.id != roadmapId).toList();
      state = state.updateState(
        isLockedPage: false,
        roadmaps: updatedRoadmaps,
        errorMessage: null,
      );

      final context = AppSession.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        AppToastService.success(context, 'Xoá lộ trình thành công!');
      }

      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: 'Không thể xoá lộ trình. Vui lòng thử lại.',
      );
      final context = AppSession.navigatorKey.currentContext;
      if (context != null && context.mounted) {
        AppToastService.error(context, 'Không thể xoá lộ trình.');
      }
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

  /// Generate roadmap with AI
  Future<void> generateRoadmapWithAI(RoadmapPreferences preferences) async {
    // Validate learning goal
    if (preferences.learningGoal == null || preferences.learningGoal!.trim().isEmpty) {
      state = state.updateState(
        generationError: 'Vui lòng nhập mục tiêu học.',
      );
      return;
    }

    // Prevent double submit
    if (state.isGeneratingRoadmap) {
      return;
    }

    // Increment sequence to cancel any previous polling
    _generationSequenceId++;
    final currentSequenceId = _generationSequenceId;

    try {
      // Clear previous error and start generation
      state = state.updateState(
        isGeneratingRoadmap: true,
        generationStatusMessage: 'Đang tạo lộ trình học...',
        generationError: null,
        activeGenerationJobId: null,
      );

      final result = await learningService.generateRoadmap(
        learningGoal: preferences.learningGoal!,
        category: preferences.category,
        difficulty: _mapPreferredDifficultyToString(preferences.difficulty),
        maxDuration: preferences.maxDuration,
      );

      // Check if cancelled
      if (_isGenerationCancelled(currentSequenceId)) {
        return;
      }

      // Handle sync completion
      if (result.status == GenerateStatus.completed) {
        if (result.roadmapItem != null) {
          // Refresh roadmap list to include the new one
          await refreshRoadmaps();

          if (_isGenerationCancelled(currentSequenceId)) {
            return;
          }

          state = state.updateState(
            isGeneratingRoadmap: false,
            generationStatusMessage: null,
            showPreferenceSheet: false,
            userPreferences: null,
          );

          final context = AppSession.navigatorKey.currentContext;
          if (context != null && context.mounted) {
            AppToastService.success(context, 'Tạo lộ trình học thành công!');
          }
          return;
        }
      }

      // Handle async start
      if (result.status == GenerateStatus.started && result.jobId != null) {
        state = state.updateState(
          generationStatusMessage: 'SoloQuest đang tạo lộ trình học...',
          activeGenerationJobId: result.jobId,
        );

        // Poll for completion with cancellation guard
        final generatedRoadmap = await learningService.pollRoadmapGeneration(
          jobId: result.jobId!,
          isCancelled: () => _isGenerationCancelled(currentSequenceId),
        );

        if (_isGenerationCancelled(currentSequenceId)) {
          return;
        }

        if (generatedRoadmap != null) {
          // Success - refresh list
          await refreshRoadmaps();

          if (_isGenerationCancelled(currentSequenceId)) {
            return;
          }

          state = state.updateState(
            isGeneratingRoadmap: false,
            generationStatusMessage: null,
            activeGenerationJobId: null,
            showPreferenceSheet: false,
            userPreferences: null,
          );

          final context = AppSession.navigatorKey.currentContext;
          if (context != null && context.mounted) {
            AppToastService.success(context, 'Tạo lộ trình học thành công!');
          }
        } else {
          // Timeout
          state = state.updateState(
            isGeneratingRoadmap: false,
            generationStatusMessage: null,
            activeGenerationJobId: null,
            generationError: 'Tạo lộ trình đang lâu hơn dự kiến. Bạn có thể thử lại sau hoặc kéo để làm mới.',
          );
        }
        return;
      }

      // Handle failed
      if (result.status == GenerateStatus.failed) {
        state = state.updateState(
          isGeneratingRoadmap: false,
          generationStatusMessage: null,
          activeGenerationJobId: null,
          generationError: result.errorMessage ?? 'Không thể tạo lộ trình. Vui lòng thử lại.',
        );
        return;
      }
    } catch (e) {
      // Check if cancelled before updating state
      if (_isGenerationCancelled(currentSequenceId)) {
        return;
      }

      // Map error messages
      String errorMessage = 'Không thể tạo lộ trình. Vui lòng thử lại.';

      if (e.toString().contains('400') || e.toString().contains('validation')) {
        errorMessage = 'Vui lòng nhập mục tiêu học rõ hơn.';
      } else if (e.toString().contains('503') && e.toString().contains('AI')) {
        errorMessage = 'Tính năng tạo lộ trình bằng AI đang tạm tắt.';
      } else if (e.toString().contains('502') || e.toString().contains('503')) {
        errorMessage = 'AI đang bận, thử lại sau.';
      }

      state = state.updateState(
        isGeneratingRoadmap: false,
        generationStatusMessage: null,
        activeGenerationJobId: null,
        generationError: errorMessage,
      );
    }
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
