import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/daily_checkin_model.dart';
import '../../models/log_entry_model.dart';
import '../../models/enums/user_enums.dart';
import '../../models/enums/log_enums.dart';
import '../../services/daily_checkin_service.dart';
import '../../services/log_service.dart';
import '../../services/quest_service.dart';
import '../../services/service_providers.dart';

class MorningCheckinPageState extends BasePageState {
  final AppLoadState loadState;
  final DailyCheckinModel? todayCheckin;

  final EnergyLevel? energyLevel;
  final StressLevel? stressLevel;
  final FocusLevel? focusLevel;
  final DayIntensity? dayIntensity;
  final String mainFocusToday;
  final String note;
  final List<String> availableTimeBlocks;

  final String? errorMessage;
  final bool hasSubmitted;

  MorningCheckinPageState({
    this.loadState = AppLoadState.idle,
    this.todayCheckin,
    this.energyLevel,
    this.stressLevel,
    this.focusLevel,
    this.dayIntensity,
    this.mainFocusToday = '',
    this.note = '',
    this.availableTimeBlocks = const [],
    this.errorMessage,
    this.hasSubmitted = false,
    super.isLockedPage,
  });

  @override
  MorningCheckinPageState updateState({
    AppLoadState? loadState,
    DailyCheckinModel? todayCheckin,
    EnergyLevel? energyLevel,
    StressLevel? stressLevel,
    FocusLevel? focusLevel,
    DayIntensity? dayIntensity,
    String? mainFocusToday,
    String? note,
    List<String>? availableTimeBlocks,
    String? errorMessage,
    bool? hasSubmitted,
    bool? isLockedPage,
  }) {
    return MorningCheckinPageState(
      loadState: loadState ?? this.loadState,
      todayCheckin: todayCheckin ?? this.todayCheckin,
      energyLevel: energyLevel ?? this.energyLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      focusLevel: focusLevel ?? this.focusLevel,
      dayIntensity: dayIntensity ?? this.dayIntensity,
      mainFocusToday: mainFocusToday ?? this.mainFocusToday,
      note: note ?? this.note,
      availableTimeBlocks: availableTimeBlocks ?? this.availableTimeBlocks,
      errorMessage: errorMessage ?? this.errorMessage,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  bool get canSubmit {
    return energyLevel != null &&
        stressLevel != null &&
        focusLevel != null &&
        dayIntensity != null;
  }

  bool get hasCheckedInToday => todayCheckin != null || hasSubmitted;

  int get completedRequiredFieldCount {
    int count = 0;
    if (energyLevel != null) count++;
    if (stressLevel != null) count++;
    if (focusLevel != null) count++;
    if (dayIntensity != null) count++;
    return count;
  }

  double get requiredProgress => completedRequiredFieldCount / 4.0;
}

class MorningCheckinPageModel
    extends BasePageModel<MorningCheckinPageState> {
  MorningCheckinPageModel({
    required this.dailyCheckinService,
    required this.logService,
    required this.questService,
  }) : super(MorningCheckinPageState());

  final DailyCheckinService dailyCheckinService;
  final LogService logService;
  final QuestService questService;

  Future<void> loadTodayCheckin() async {
    state = state.updateState(loadState: AppLoadState.loading);

    try {
      final checkin = await dailyCheckinService.getTodayCheckin();

      if (checkin != null) {
        state = state.updateState(
          loadState: AppLoadState.ready,
          todayCheckin: checkin,
          energyLevel: checkin.energyLevel,
          stressLevel: checkin.stressLevel,
          focusLevel: checkin.focusLevel,
          dayIntensity: checkin.dayIntensity,
          mainFocusToday: checkin.mainFocusToday ?? '',
          note: checkin.note ?? '',
          availableTimeBlocks: List.from(checkin.availableTimeBlocks),
        );
      } else {
        state = state.updateState(loadState: AppLoadState.ready);
      }
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: 'Không thể tải check-in: ${e.toString()}',
      );
    }
  }

  void setEnergyLevel(EnergyLevel value) {
    state = state.updateState(energyLevel: value);
  }

  void setStressLevel(StressLevel value) {
    state = state.updateState(stressLevel: value);
  }

  void setFocusLevel(FocusLevel value) {
    state = state.updateState(focusLevel: value);
  }

  void setDayIntensity(DayIntensity value) {
    state = state.updateState(dayIntensity: value);
  }

  void setMainFocusToday(String value) {
    state = state.updateState(mainFocusToday: value);
  }

  void setNote(String value) {
    state = state.updateState(note: value);
  }

  void toggleAvailableTimeBlock(String value) {
    final current = List<String>.from(state.availableTimeBlocks);
    if (current.contains(value)) {
      current.remove(value);
    } else {
      current.add(value);
    }
    state = state.updateState(availableTimeBlocks: current);
  }

  Future<bool> submitCheckin() async {
    if (!state.canSubmit) return false;
    if (state.isLockedPage) return false;

    state = state.updateState(isLockedPage: true);

    try {
      final now = DateTime.now();
      final checkin = DailyCheckinModel(
        id: 'checkin_${now.millisecondsSinceEpoch}',
        date: now,
        energyLevel: state.energyLevel!,
        stressLevel: state.stressLevel!,
        focusLevel: state.focusLevel!,
        dayIntensity: state.dayIntensity!,
        mainFocusToday: state.mainFocusToday.isEmpty ? null : state.mainFocusToday,
        note: state.note.isEmpty ? null : state.note,
        availableTimeBlocks: state.availableTimeBlocks,
        createdAt: now,
      );

      final saved = await dailyCheckinService.saveCheckin(checkin);

      await logService.addLog(LogEntryModel(
        id: 'log_checkin_${now.millisecondsSinceEpoch}',
        type: LogEntryType.morningCheckin,
        title: 'Check-in buổi sáng',
        description:
            'Năng lượng: ${state.energyLevel!.label}, '
            'Stress: ${state.stressLevel!.label}, '
            'Focus: ${state.focusLevel!.label}',
        createdAt: now,
        metadata: {
          'energyLevel': state.energyLevel!.name,
          'stressLevel': state.stressLevel!.name,
          'focusLevel': state.focusLevel!.name,
          'dayIntensity': state.dayIntensity!.name,
          'mainFocusToday': state.mainFocusToday,
          'availableTimeBlocks': state.availableTimeBlocks,
        },
      ));

      state = state.updateState(
        isLockedPage: false,
        hasSubmitted: true,
        todayCheckin: saved,
      );
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: 'Không thể lưu check-in: ${e.toString()}',
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
    logService: ref.read(logServiceProvider),
    questService: ref.read(questServiceProvider),
  );
});
