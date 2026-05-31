import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/daily_review_model.dart';
import '../../models/log_entry_model.dart';
import '../../models/enums/log_enums.dart';
import '../../models/enums/quest_enums.dart';
import '../../services/daily_review_service.dart';
import '../../services/log_service.dart';
import '../../services/quest_service.dart';
import '../../services/service_providers.dart';

class DailyReviewPageState extends BasePageState {
  final AppLoadState loadState;
  final DailyReviewModel? todayReview;

  final int completedQuestCount;
  final int skippedQuestCount;
  final int earnedExp;
  final double completionRate;

  final String? difficulty;
  final List<String> helpfulQuests;
  final List<String> annoyingQuests;
  final LogMood? mood;
  final int? energyLevel;
  final int? satisfactionLevel;
  final List<String> tomorrowAdjustments;
  final String note;

  final String? errorMessage;
  final bool hasSubmitted;

  DailyReviewPageState({
    this.loadState = AppLoadState.idle,
    this.todayReview,
    this.completedQuestCount = 0,
    this.skippedQuestCount = 0,
    this.earnedExp = 0,
    this.completionRate = 0,
    this.difficulty,
    this.helpfulQuests = const [],
    this.annoyingQuests = const [],
    this.mood,
    this.energyLevel,
    this.satisfactionLevel,
    this.tomorrowAdjustments = const [],
    this.note = '',
    this.errorMessage,
    this.hasSubmitted = false,
    super.isLockedPage,
  });

  @override
  DailyReviewPageState updateState({
    AppLoadState? loadState,
    DailyReviewModel? todayReview,
    int? completedQuestCount,
    int? skippedQuestCount,
    int? earnedExp,
    double? completionRate,
    String? difficulty,
    List<String>? helpfulQuests,
    List<String>? annoyingQuests,
    LogMood? mood,
    int? energyLevel,
    int? satisfactionLevel,
    List<String>? tomorrowAdjustments,
    String? note,
    String? errorMessage,
    bool? hasSubmitted,
    bool? isLockedPage,
  }) {
    return DailyReviewPageState(
      loadState: loadState ?? this.loadState,
      todayReview: todayReview ?? this.todayReview,
      completedQuestCount: completedQuestCount ?? this.completedQuestCount,
      skippedQuestCount: skippedQuestCount ?? this.skippedQuestCount,
      earnedExp: earnedExp ?? this.earnedExp,
      completionRate: completionRate ?? this.completionRate,
      difficulty: difficulty ?? this.difficulty,
      helpfulQuests: helpfulQuests ?? this.helpfulQuests,
      annoyingQuests: annoyingQuests ?? this.annoyingQuests,
      mood: mood ?? this.mood,
      energyLevel: energyLevel ?? this.energyLevel,
      satisfactionLevel: satisfactionLevel ?? this.satisfactionLevel,
      tomorrowAdjustments: tomorrowAdjustments ?? this.tomorrowAdjustments,
      note: note ?? this.note,
      errorMessage: errorMessage ?? this.errorMessage,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  bool get canSubmit => mood != null;

  bool get hasReviewedToday => todayReview != null || hasSubmitted;

  int get totalQuestCount => completedQuestCount + skippedQuestCount;
}

class DailyReviewPageModel extends BasePageModel<DailyReviewPageState> {
  DailyReviewPageModel({
    required this.dailyReviewService,
    required this.questService,
    required this.logService,
  }) : super(DailyReviewPageState());

  final DailyReviewService dailyReviewService;
  final QuestService questService;
  final LogService logService;

  Future<void> loadDailyReview() async {
    state = state.updateState(loadState: AppLoadState.loading);

    try {
      final review = await dailyReviewService.getTodayReview();
      final quests = await questService.getTodayQuests();

      final completed = quests.where((q) => q.isCompleted).toList();
      final skipped = quests.where((q) => q.status == QuestStatus.skipped).toList();
      final totalExp = completed.fold<int>(0, (sum, q) => sum + q.exp);
      final total = quests.length;
      final rate = total > 0 ? completed.length / total : 0.0;

      if (review != null) {
        state = state.updateState(
          loadState: AppLoadState.ready,
          todayReview: review,
          completedQuestCount: completed.length,
          skippedQuestCount: skipped.length,
          earnedExp: totalExp,
          completionRate: rate,
          mood: review.mood,
          note: review.improvementTomorrow ?? '',
          hasSubmitted: true,
        );
      } else {
        state = state.updateState(
          loadState: AppLoadState.ready,
          completedQuestCount: completed.length,
          skippedQuestCount: skipped.length,
          earnedExp: totalExp,
          completionRate: rate,
        );
      }
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: 'Không thể tải dữ liệu: ${e.toString()}',
      );
    }
  }

  void setDifficulty(String value) {
    state = state.updateState(difficulty: value);
  }

  void toggleHelpfulQuest(String value) {
    final current = List<String>.from(state.helpfulQuests);
    if (current.contains(value)) {
      current.remove(value);
    } else {
      current.add(value);
    }
    state = state.updateState(helpfulQuests: current);
  }

  void toggleAnnoyingQuest(String value) {
    final current = List<String>.from(state.annoyingQuests);
    if (current.contains(value)) {
      current.remove(value);
    } else {
      current.add(value);
    }
    state = state.updateState(annoyingQuests: current);
  }

  void setMood(LogMood value) {
    state = state.updateState(mood: value);
  }

  void setEnergyLevel(int value) {
    state = state.updateState(energyLevel: value);
  }

  void setSatisfactionLevel(int value) {
    state = state.updateState(satisfactionLevel: value);
  }

  void toggleTomorrowAdjustment(String value) {
    final current = List<String>.from(state.tomorrowAdjustments);
    if (current.contains(value)) {
      current.remove(value);
    } else {
      current.add(value);
    }
    state = state.updateState(tomorrowAdjustments: current);
  }

  void setNote(String value) {
    state = state.updateState(note: value);
  }

  Future<bool> submitReview() async {
    if (!state.canSubmit) return false;
    if (state.isLockedPage) return false;

    state = state.updateState(isLockedPage: true);

    try {
      final now = DateTime.now();
      final review = DailyReviewModel(
        id: 'review_${now.millisecondsSinceEpoch}',
        date: now,
        completedQuestCount: state.completedQuestCount,
        skippedQuestCount: state.skippedQuestCount,
        earnedExp: state.earnedExp,
        mood: state.mood!,
        bestMoment: state.helpfulQuests.isEmpty
            ? null
            : state.helpfulQuests.join(', '),
        challenge: state.annoyingQuests.isEmpty
            ? null
            : state.annoyingQuests.join(', '),
        improvementTomorrow: state.tomorrowAdjustments.isEmpty
            ? (state.note.isEmpty ? null : state.note)
            : state.tomorrowAdjustments.join(', '),
        createdAt: now,
      );

      final saved = await dailyReviewService.saveReview(review);

      await logService.addLog(LogEntryModel(
        id: 'log_review_${now.millisecondsSinceEpoch}',
        type: LogEntryType.dailyReview,
        title: 'Đánh giá cuối ngày',
        description:
            'Hoàn thành ${state.completedQuestCount} quest, mood: ${state.mood!.label}',
        createdAt: now,
        mood: state.mood,
        metadata: {
          'completedQuestCount': state.completedQuestCount,
          'skippedQuestCount': state.skippedQuestCount,
          'earnedExp': state.earnedExp,
          'completionRate': state.completionRate,
          'difficulty': state.difficulty,
          'helpfulQuests': state.helpfulQuests,
          'annoyingQuests': state.annoyingQuests,
          'energyLevel': state.energyLevel,
          'satisfactionLevel': state.satisfactionLevel,
          'tomorrowAdjustments': state.tomorrowAdjustments,
          'note': state.note,
        },
      ));

      state = state.updateState(
        isLockedPage: false,
        hasSubmitted: true,
        todayReview: saved,
      );
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: 'Không thể lưu đánh giá: ${e.toString()}',
      );
      return false;
    }
  }
}

final dailyReviewPageProvider =
    StateNotifierProvider<DailyReviewPageModel, DailyReviewPageState>((ref) {
  return DailyReviewPageModel(
    dailyReviewService: ref.read(dailyReviewServiceProvider),
    questService: ref.read(questServiceProvider),
    logService: ref.read(logServiceProvider),
  );
});
