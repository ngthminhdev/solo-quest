import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../core/utils/app_time_formatter.dart';
import '../../models/daily_review_model.dart';
import '../../models/enums/quest_enums.dart';
import '../../models/enums/user_enums.dart';
import '../../services/daily_review_service.dart';
import '../../services/quest_service.dart';
import '../../services/service_providers.dart';

class DailyReviewPageState extends BasePageState {
  final AppLoadState loadState;
  final DailyReviewModel? todayReview;

  // Quest summary stats
  final int completedQuestCount;
  final int skippedQuestCount;
  final int earnedExp;
  final double completionRate;

  // Simplified user input fields
  final CheckinMood? mood;
  final EnergyLevel? energyLevel;
  final int? satisfaction;
  final String reflection;
  final CheckinPriority? tomorrowPriority;

  final String? errorMessage;
  final bool hasSubmitted;

  DailyReviewPageState({
    this.loadState = AppLoadState.idle,
    this.todayReview,
    this.completedQuestCount = 0,
    this.skippedQuestCount = 0,
    this.earnedExp = 0,
    this.completionRate = 0,
    this.mood,
    this.energyLevel,
    this.satisfaction,
    this.reflection = '',
    this.tomorrowPriority,
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
    CheckinMood? mood,
    EnergyLevel? energyLevel,
    int? satisfaction,
    String? reflection,
    CheckinPriority? tomorrowPriority,
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
      mood: mood ?? this.mood,
      energyLevel: energyLevel ?? this.energyLevel,
      satisfaction: satisfaction ?? this.satisfaction,
      reflection: reflection ?? this.reflection,
      tomorrowPriority: tomorrowPriority ?? this.tomorrowPriority,
      errorMessage: errorMessage ?? this.errorMessage,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  bool get canSubmit {
    return mood != null &&
        energyLevel != null &&
        satisfaction != null &&
        tomorrowPriority != null;
  }

  bool get hasReviewedToday => todayReview != null || hasSubmitted;

  int get totalQuestCount => completedQuestCount + skippedQuestCount;
}

class DailyReviewPageModel extends BasePageModel<DailyReviewPageState> {
  DailyReviewPageModel({
    required this.dailyReviewService,
    required this.questService,
  }) : super(DailyReviewPageState());

  final DailyReviewService dailyReviewService;
  final QuestService questService;

  Future<void> loadDailyReview() async {
    if (kDebugMode) {
      developer.log('[REVIEW] Loading today review');
    }
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
        if (kDebugMode) {
          developer.log('[REVIEW] Today review found: id=${review.id}, date=${review.date}');
        }
        state = state.updateState(
          loadState: AppLoadState.ready,
          todayReview: review,
          completedQuestCount: completed.length,
          skippedQuestCount: skipped.length,
          earnedExp: totalExp,
          completionRate: rate,
          mood: review.mood,
          energyLevel: review.energyLevel,
          satisfaction: review.satisfaction,
          reflection: review.reflection ?? '',
          tomorrowPriority: review.tomorrowPriority,
          hasSubmitted: true,
        );
      } else {
        if (kDebugMode) {
          developer.log('[REVIEW] No review today');
        }
        state = state.updateState(
          loadState: AppLoadState.ready,
          completedQuestCount: completed.length,
          skippedQuestCount: skipped.length,
          earnedExp: totalExp,
          completionRate: rate,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('[REVIEW] Failed to load today review: $e');
      }
      state = state.updateState(
        loadState: AppLoadState.error,
      );
    }
  }

  void setMood(CheckinMood value) {
    state = state.updateState(mood: value);
  }

  void setEnergyLevel(EnergyLevel value) {
    state = state.updateState(energyLevel: value);
  }

  void setSatisfaction(int value) {
    state = state.updateState(satisfaction: value);
  }

  void setReflection(String value) {
    state = state.updateState(reflection: value);
  }

  void setTomorrowPriority(CheckinPriority value) {
    state = state.updateState(tomorrowPriority: value);
  }

  Future<bool> submitReview() async {
    if (!state.canSubmit) return false;
    if (state.isLockedPage) return false;

    if (kDebugMode) {
      final localDate = AppTimeFormatter.todayLocalDateQuery();
      developer.log('[REVIEW] Submit tapped — local date: $localDate');
    }

    state = state.updateState(isLockedPage: true);

    try {
      final now = DateTime.now();
      final review = DailyReviewModel(
        id: 'review_${now.millisecondsSinceEpoch}',
        date: now,
        mood: state.mood!,
        energyLevel: state.energyLevel!,
        satisfaction: state.satisfaction!,
        reflection: state.reflection.isEmpty ? null : state.reflection,
        tomorrowPriority: state.tomorrowPriority!,
        completedQuestCount: state.completedQuestCount,
        skippedQuestCount: state.skippedQuestCount,
        earnedExp: state.earnedExp,
        createdAt: now,
      );

      final saved = await dailyReviewService.saveReview(review);

      if (kDebugMode) {
        developer.log('[REVIEW] Save success: id=${saved.id}, date=${saved.date}');
      }

      state = state.updateState(
        isLockedPage: false,
        hasSubmitted: true,
        todayReview: saved,
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[REVIEW] Save failed: $e');
      }
      state = state.updateState(
        isLockedPage: false,
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
  );
});
