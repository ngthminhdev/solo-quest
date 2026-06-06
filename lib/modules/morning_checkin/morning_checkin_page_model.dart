import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../core/utils/app_time_formatter.dart';
import '../../models/daily_checkin_model.dart';
import '../../models/enums/user_enums.dart';
import '../../services/daily_checkin_service.dart';
import '../../services/service_providers.dart';

class MorningCheckinPageState extends BasePageState {
  final AppLoadState loadState;
  final DailyCheckinModel? todayCheckin;

  final CheckinMood? mood;
  final EnergyLevel? energyLevel;
  final Availability? availability;
  final CheckinPriority? priority;

  final String? errorMessage;
  final bool hasSubmitted;

  MorningCheckinPageState({
    this.loadState = AppLoadState.idle,
    this.todayCheckin,
    this.mood = CheckinMood.normal,
    this.energyLevel = EnergyLevel.medium,
    this.availability = Availability.normal,
    this.priority,
    this.errorMessage,
    this.hasSubmitted = false,
    super.isLockedPage,
  });

  @override
  MorningCheckinPageState updateState({
    AppLoadState? loadState,
    DailyCheckinModel? todayCheckin,
    CheckinMood? mood,
    EnergyLevel? energyLevel,
    Availability? availability,
    CheckinPriority? priority,
    String? errorMessage,
    bool? hasSubmitted,
    bool? isLockedPage,
  }) {
    return MorningCheckinPageState(
      loadState: loadState ?? this.loadState,
      todayCheckin: todayCheckin ?? this.todayCheckin,
      mood: mood ?? this.mood,
      energyLevel: energyLevel ?? this.energyLevel,
      availability: availability ?? this.availability,
      priority: priority ?? this.priority,
      errorMessage: errorMessage ?? this.errorMessage,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  bool get canSubmit {
    return mood != null &&
        energyLevel != null &&
        availability != null &&
        priority != null;
  }

  bool get hasCheckedInToday => todayCheckin != null || hasSubmitted;

  int get completedRequiredFieldCount {
    int count = 0;
    if (mood != null) count++;
    if (energyLevel != null) count++;
    if (availability != null) count++;
    if (priority != null) count++;
    return count;
  }

  double get requiredProgress => completedRequiredFieldCount / 4.0;
}

class MorningCheckinPageModel
    extends BasePageModel<MorningCheckinPageState> {
  MorningCheckinPageModel({
    required this.dailyCheckinService,
  }) : super(MorningCheckinPageState());

  final DailyCheckinService dailyCheckinService;

  Future<void> loadTodayCheckin() async {
    if (kDebugMode) {
      developer.log('[CHECKIN] Loading today check-in');
    }
    state = state.updateState(loadState: AppLoadState.loading);

    try {
      final checkin = await dailyCheckinService.getTodayCheckin();

      if (checkin != null) {
        if (kDebugMode) {
          developer.log('[CHECKIN] Today check-in found: id=${checkin.id}, date=${checkin.date}');
        }
        state = state.updateState(
          loadState: AppLoadState.ready,
          todayCheckin: checkin,
          mood: checkin.mood,
          energyLevel: checkin.energyLevel,
          availability: checkin.availability,
          priority: checkin.priority,
          hasSubmitted: true,
        );
      } else {
        if (kDebugMode) {
          developer.log('[CHECKIN] No check-in today');
        }
        state = state.updateState(loadState: AppLoadState.ready);
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('[CHECKIN] Failed to load today check-in: $e');
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

  void setAvailability(Availability value) {
    state = state.updateState(availability: value);
  }

  void setPriority(CheckinPriority value) {
    state = state.updateState(priority: value);
  }

  Future<bool> submitCheckin() async {
    if (!state.canSubmit) return false;
    if (state.isLockedPage) return false;

    if (kDebugMode) {
      final localDate = AppTimeFormatter.todayLocalDateQuery();
      developer.log('[CHECKIN] Submit tapped — local date: $localDate');
    }

    state = state.updateState(isLockedPage: true);

    try {
      final now = DateTime.now();
      final checkin = DailyCheckinModel(
        id: 'checkin_${now.millisecondsSinceEpoch}',
        date: now,
        mood: state.mood!,
        energyLevel: state.energyLevel!,
        availability: state.availability!,
        priority: state.priority!,
        createdAt: now,
      );

      final saved = await dailyCheckinService.saveCheckin(checkin);

      if (kDebugMode) {
        developer.log('[CHECKIN] Save success: id=${saved.id}, date=${saved.date}');
      }

      state = state.updateState(
        isLockedPage: false,
        hasSubmitted: true,
        todayCheckin: saved,
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[CHECKIN] Save failed: $e');
      }
      state = state.updateState(
        isLockedPage: false,
      );
      return false;
    }
  }
}

final morningCheckinPageProvider =
    StateNotifierProvider<MorningCheckinPageModel, MorningCheckinPageState>(
        (ref) {
  return MorningCheckinPageModel(
    dailyCheckinService: ref.read(dailyCheckinServiceProvider),
  );
});
