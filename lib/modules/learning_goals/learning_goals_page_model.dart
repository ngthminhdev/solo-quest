import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/learning_goal_model.dart';
import '../../models/log_entry_model.dart';
import '../../models/enums/log_enums.dart';
import '../../services/learning_service.dart';
import '../../services/log_service.dart';
import '../../services/service_providers.dart';

class LearningGoalsPageState extends BasePageState {
  final AppLoadState loadState;
  final List<LearningGoalModel> goals;
  final String? selectedCategory;
  final String? errorMessage;
  final bool showAiSuggestions;
  final bool isLoadingAiSuggestions;
  final Set<String> selectedSuggestionIds;

  LearningGoalsPageState({
    this.loadState = AppLoadState.idle,
    this.goals = const [],
    this.selectedCategory,
    this.errorMessage,
    this.showAiSuggestions = false,
    this.isLoadingAiSuggestions = false,
    this.selectedSuggestionIds = const {},
    super.isLockedPage,
  });

  @override
  LearningGoalsPageState updateState({
    AppLoadState? loadState,
    List<LearningGoalModel>? goals,
    String? selectedCategory,
    bool clearSelectedCategory = false,
    String? errorMessage,
    bool? isLockedPage,
    bool? showAiSuggestions,
    bool? isLoadingAiSuggestions,
    Set<String>? selectedSuggestionIds,
  }) {
    return LearningGoalsPageState(
      loadState: loadState ?? this.loadState,
      goals: goals ?? this.goals,
      selectedCategory: clearSelectedCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
      showAiSuggestions: showAiSuggestions ?? this.showAiSuggestions,
      isLoadingAiSuggestions: isLoadingAiSuggestions ?? this.isLoadingAiSuggestions,
      selectedSuggestionIds: selectedSuggestionIds ?? this.selectedSuggestionIds,
    );
  }

  List<LearningGoalModel> get filteredGoals {
    if (selectedCategory == null || selectedCategory!.isEmpty) {
      return goals;
    }
    return goals.where((goal) => goal.category == selectedCategory).toList();
  }

  List<String> get categories {
    final values = goals
        .map((goal) => goal.category)
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    values.sort();
    return values;
  }

  int get totalGoals => goals.length;

  int get activeGoals => goals.where((goal) => goal.isActive).length;

  int get completedGoals => goals.where((goal) => goal.progress >= 1.0).length;

  double get averageProgress {
    if (goals.isEmpty) return 0;
    final total = goals.fold<double>(0, (sum, goal) => sum + goal.progress);
    return (total / goals.length).clamp(0.0, 1.0);
  }

  bool get hasGoals => goals.isNotEmpty;
}

class LearningGoalsPageModel extends BasePageModel<LearningGoalsPageState> {
  LearningGoalsPageModel({
    required this.learningService,
    required this.logService,
  }) : super(LearningGoalsPageState());

  final LearningService learningService;
  final LogService logService;

  Future<void> loadGoals() async {
    try {
      state = state.updateState(loadState: AppLoadState.loading);

      final goals = await learningService.getLearningGoals();

      // Sort: active first, then by progress (incomplete first), then by deadline
      goals.sort((a, b) {
        if (a.isActive != b.isActive) {
          return a.isActive ? -1 : 1;
        }
        if (a.progress >= 1.0 && b.progress < 1.0) return 1;
        if (a.progress < 1.0 && b.progress >= 1.0) return -1;
        if (a.deadline != null && b.deadline != null) {
          return a.deadline!.compareTo(b.deadline!);
        }
        if (a.deadline != null) return -1;
        if (b.deadline != null) return 1;
        return 0;
      });

      state = state.updateState(
        loadState: AppLoadState.ready,
        goals: goals,
        errorMessage: null,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshGoals() async {
    try {
      final goals = await learningService.getLearningGoals();

      goals.sort((a, b) {
        if (a.isActive != b.isActive) {
          return a.isActive ? -1 : 1;
        }
        if (a.progress >= 1.0 && b.progress < 1.0) return 1;
        if (a.progress < 1.0 && b.progress >= 1.0) return -1;
        if (a.deadline != null && b.deadline != null) {
          return a.deadline!.compareTo(b.deadline!);
        }
        if (a.deadline != null) return -1;
        if (b.deadline != null) return 1;
        return 0;
      });

      state = state.updateState(
        loadState: AppLoadState.ready,
        goals: goals,
        errorMessage: null,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> addGoal(LearningGoalModel goal) async {
    try {
      state = state.updateState(isLockedPage: true);

      await learningService.addLearningGoal(goal);

      // Add log entry
      await logService.addLog(
        LogEntryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
          type: LogEntryType.profileUpdated,
          title: 'Thêm mục tiêu học tập',
          description: goal.title,
        ),
      );

      await loadGoals();

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

  Future<bool> updateGoal(LearningGoalModel goal) async {
    try {
      state = state.updateState(isLockedPage: true);

      await learningService.updateLearningGoal(goal);

      await loadGoals();

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

  Future<bool> deleteGoal(String goalId) async {
    try {
      state = state.updateState(isLockedPage: true);

      await learningService.deleteLearningGoal(goalId);

      await loadGoals();

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

  Future<bool> updateGoalProgress(String goalId, double progress) async {
    try {
      state = state.updateState(isLockedPage: true);

      final clampedProgress = progress.clamp(0.0, 1.0);
      await learningService.updateGoalProgress(goalId, clampedProgress);

      await loadGoals();

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

  void selectCategory(String? category) {
    state = state.updateState(
      selectedCategory: category,
      clearSelectedCategory: category == null,
    );
  }

  void clearCategoryFilter() {
    state = state.updateState(clearSelectedCategory: true);
  }

  Future<void> showAiSuggestions() async {
    // Simulate loading AI suggestions
    state = state.updateState(isLoadingAiSuggestions: true);

    // TODO: Backend integration - Replace with real API call to fetch AI suggestions
    await Future.delayed(const Duration(milliseconds: 800));

    state = state.updateState(
      isLoadingAiSuggestions: false,
      showAiSuggestions: true,
    );
  }

  void toggleSuggestionSelection(String suggestionId) {
    final currentSelections = Set<String>.from(state.selectedSuggestionIds);

    if (currentSelections.contains(suggestionId)) {
      currentSelections.remove(suggestionId);
    } else {
      currentSelections.add(suggestionId);
    }

    state = state.updateState(selectedSuggestionIds: currentSelections);
  }

  bool isSuggestionSelected(String suggestionId) {
    return state.selectedSuggestionIds.contains(suggestionId);
  }

  void hideAiSuggestions() {
    state = state.updateState(showAiSuggestions: false);
  }
}

final learningGoalsPageProvider =
    StateNotifierProvider<LearningGoalsPageModel, LearningGoalsPageState>(
        (ref) {
  return LearningGoalsPageModel(
    learningService: ref.read(learningServiceProvider),
    logService: ref.read(logServiceProvider),
  );
});
