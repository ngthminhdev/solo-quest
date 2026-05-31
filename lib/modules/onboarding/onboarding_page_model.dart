import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../constants/app_constant.dart';
import '../../models/log_entry_model.dart';
import '../../models/enums/log_enums.dart';
import '../../services/local_storage_service.dart';
import '../../services/profile_service.dart';
import '../../services/log_service.dart';
import '../../services/quest_rule_service.dart';
import '../../services/service_providers.dart';
import 'constants/onboarding_constants.dart';
import 'models/onboarding_data.dart';

class OnboardingPageState extends BasePageState {
  final AppLoadState loadState;
  final int currentStep;
  final int totalSteps;
  final OnboardingData data;
  final String? errorMessage;

  OnboardingPageState({
    this.loadState = AppLoadState.idle,
    this.currentStep = 0,
    this.totalSteps = OnboardingConstants.totalSteps,
    this.data = const OnboardingData(),
    this.errorMessage,
    super.isLockedPage,
  });

  @override
  OnboardingPageState updateState({
    AppLoadState? loadState,
    int? currentStep,
    int? totalSteps,
    OnboardingData? data,
    String? errorMessage,
    bool? isLockedPage,
  }) {
    return OnboardingPageState(
      loadState: loadState ?? this.loadState,
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  bool get isFirstStep => currentStep == 0;

  bool get isLastStep => currentStep == totalSteps - 1;

  double get progress {
    if (totalSteps <= 0) return 0;
    return ((currentStep + 1) / totalSteps).clamp(0.0, 1.0);
  }

  bool get canContinue {
    switch (currentStep) {
      case 0:
        return true;
      case 1:
        return data.displayName.trim().isNotEmpty && data.age != null;
      case 2:
        return data.mainActivity.trim().isNotEmpty &&
            data.workStartTime.trim().isNotEmpty &&
            data.workEndTime.trim().isNotEmpty;
      case 3:
        return data.activityLevel.trim().isNotEmpty &&
            data.lastWorkout.trim().isNotEmpty;
      case 4:
        return data.mainGoals.isNotEmpty;
      case 5:
        return data.wakeUpTime.trim().isNotEmpty &&
            data.targetSleepTime.trim().isNotEmpty &&
            data.freeTimeStart.trim().isNotEmpty &&
            data.freeTimeEnd.trim().isNotEmpty;
      case 6:
        return data.breakReminderInterval > 0 &&
            data.waterReminderMode.trim().isNotEmpty &&
            data.quietAfterTime.trim().isNotEmpty;
      case 7:
        return data.preferredRewards.isNotEmpty;
      case 8:
        return true;
      default:
        return true;
    }
  }
}

class OnboardingPageModel extends BasePageModel<OnboardingPageState> {
  OnboardingPageModel({
    required this.profileService,
    required this.localStorageService,
    required this.questRuleService,
    required this.logService,
  }) : super(OnboardingPageState());

  final ProfileService profileService;
  final LocalStorageService localStorageService;
  final QuestRuleService questRuleService;
  final LogService logService;

  void nextStep() {
    if (!state.canContinue) return;
    if (!state.isLastStep) {
      state = state.updateState(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (!state.isFirstStep) {
      state = state.updateState(currentStep: state.currentStep - 1);
    }
  }

  // Step 1 - Basic Info
  void updateDisplayName(String value) {
    state = state.updateState(data: state.data.copyWith(displayName: value));
  }

  void updateAge(String value) {
    final parsed = int.tryParse(value);
    state = state.updateState(data: state.data.copyWith(age: parsed));
  }

  void updateGender(String value) {
    state = state.updateState(data: state.data.copyWith(gender: value));
  }

  void updateHeight(String value) {
    final parsed = double.tryParse(value);
    state = state.updateState(data: state.data.copyWith(heightCm: parsed));
  }

  void updateWeight(String value) {
    final parsed = double.tryParse(value);
    state = state.updateState(data: state.data.copyWith(weightKg: parsed));
  }

  // Step 2 - Work & Study
  void updateMainActivity(String value) {
    state = state.updateState(data: state.data.copyWith(mainActivity: value));
  }

  void updateWorkScheduleType(String value) {
    state =
        state.updateState(data: state.data.copyWith(workScheduleType: value));
  }

  void updateWorkStartTime(String value) {
    state = state.updateState(data: state.data.copyWith(workStartTime: value));
  }

  void updateWorkEndTime(String value) {
    state = state.updateState(data: state.data.copyWith(workEndTime: value));
  }

  void updateFreeTimePreference(String value) {
    state = state.updateState(
        data: state.data.copyWith(freeTimePreference: value));
  }

  // Step 3 - Health & Activity
  void updateActivityLevel(String value) {
    state = state.updateState(data: state.data.copyWith(activityLevel: value));
  }

  void updateLastWorkout(String value) {
    state = state.updateState(data: state.data.copyWith(lastWorkout: value));
  }

  void toggleHealthLimitation(String value) {
    final list = List<String>.from(state.data.healthLimitations);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    state =
        state.updateState(data: state.data.copyWith(healthLimitations: list));
  }

  // Step 4 - Goals
  void toggleMainGoal(String value) {
    final list = List<String>.from(state.data.mainGoals);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    state = state.updateState(data: state.data.copyWith(mainGoals: list));
  }

  // Step 5 - Schedule
  void updateWakeUpTime(String value) {
    state = state.updateState(data: state.data.copyWith(wakeUpTime: value));
  }

  void updateTargetSleepTime(String value) {
    state =
        state.updateState(data: state.data.copyWith(targetSleepTime: value));
  }

  void updateFreeTimeStart(String value) {
    state = state.updateState(data: state.data.copyWith(freeTimeStart: value));
  }

  void updateFreeTimeEnd(String value) {
    state = state.updateState(data: state.data.copyWith(freeTimeEnd: value));
  }

  void updateLearningTimePreference(String value) {
    state = state.updateState(
        data: state.data.copyWith(learningTimePreference: value));
  }

  void updateMovementTimePreference(String value) {
    state = state.updateState(
        data: state.data.copyWith(movementTimePreference: value));
  }

  // Step 6 - Reminders
  void updateBreakReminderInterval(int value) {
    state = state.updateState(
        data: state.data.copyWith(breakReminderInterval: value));
  }

  void updateBreakDuration(String value) {
    state =
        state.updateState(data: state.data.copyWith(breakDuration: value));
  }

  void updateWaterReminderMode(String value) {
    state =
        state.updateState(data: state.data.copyWith(waterReminderMode: value));
  }

  void updateQuietAfterTime(String value) {
    state =
        state.updateState(data: state.data.copyWith(quietAfterTime: value));
  }

  // Step 7 - Rewards
  void togglePreferredReward(String value) {
    final list = List<String>.from(state.data.preferredRewards);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    state =
        state.updateState(data: state.data.copyWith(preferredRewards: list));
  }

  Future<bool> completeOnboarding() async {
    if (!state.canContinue) return false;

    try {
      state = state.updateState(isLockedPage: true);

      await profileService.createOrUpdateProfile(
        name: state.data.displayName,
        mainGoals: state.data.mainGoals,
      );

      await questRuleService.updateDailyQuestLimit(6);

      await localStorageService.setBool(
        AppStorageKey.hasCompletedOnboarding,
        true,
      );

      await logService.addLog(
        LogEntryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
          type: LogEntryType.profileUpdated,
          title: 'Hoàn tất onboarding',
          description:
              'Đã thiết lập hồ sơ SoloQuest: ${state.data.displayName}',
        ),
      );

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

final onboardingPageProvider =
    StateNotifierProvider<OnboardingPageModel, OnboardingPageState>((ref) {
  return OnboardingPageModel(
    profileService: ref.read(profileServiceProvider),
    localStorageService: ref.read(localStorageServiceProvider),
    questRuleService: ref.read(questRuleServiceProvider),
    logService: ref.read(logServiceProvider),
  );
});
