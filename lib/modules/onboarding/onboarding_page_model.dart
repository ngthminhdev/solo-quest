import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import '../../services/quest_service.dart';
import '../../services/service_providers.dart';
import '../../core/api/services/user_api_service.dart';
import '../../core/api/services/ai_api_service.dart';
import '../../helpers/time_helper.dart';
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
    this.totalSteps = 7,
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
    UserApiService? userApiService,
  }) : _userApiService = userApiService ?? UserApiService(),
       super(OnboardingPageState());

  final ProfileService profileService;
  final LocalStorageService localStorageService;
  final QuestRuleService questRuleService;
  final LogService logService;
  final UserApiService _userApiService;

  static const Map<String, String> _mainGoalApiValues = {
    'Uống Nước': 'water',
    'Vận Động': 'movement',
    'Học Tập': 'learning',
    'Chánh Niệm': 'mindfulness',
    'Ngủ Tốt Hơn': 'sleep',
    'Tập Trung Tốt Hơn': 'focus',
    'Giảm Cân': 'weight',
    'Kỷ Luật Hơn': 'discipline',
    'water': 'water',
    'movement': 'movement',
    'learning': 'learning',
    'mindfulness': 'mindfulness',
    'sleep': 'sleep',
    'focus': 'focus',
    'weight': 'weight',
    'discipline': 'discipline',
  };

  static const Map<String, String> _genderApiValues = {
    'male': 'male',
    'female': 'female',
    'other': 'other',
    'Nam': 'male',
    'Nữ': 'female',
    'Khác': 'other',
    'Male': 'male',
    'Female': 'female',
    'Other': 'other',
  };

  static const Map<String, String> _workScheduleTypeApiValues = {
    'weekdays': 'weekdays',
    'full_week': 'full_week',
    'flexible': 'flexible',
    'night_shift': 'night_shift',
    'Mon-Fri': 'weekdays',
    'Mon–Fri': 'weekdays',
    'Mon-Sat': 'full_week',
    'Mon–Sat': 'full_week',
    'Flexible': 'flexible',
    'Night Shift': 'night_shift',
    'Thứ 2-6': 'weekdays',
    'Thứ 2–6': 'weekdays',
    'Thứ 2 - Thứ 6': 'weekdays',
    'Thứ 2 – Thứ 6': 'weekdays',
    'Thứ 2-7': 'full_week',
    'Thứ 2–7': 'full_week',
    'Linh hoạt': 'flexible',
    'Ca đêm': 'night_shift',
  };

  static const Map<String, String> _activityLevelApiValues = {
    'very_little': 'very_little',
    'occasional': 'occasional',
    'regular': 'regular',
    'Rất ít': 'very_little',
    'Thỉnh thoảng': 'occasional',
    'Đều đặn': 'regular',
  };

  static const Map<String, String> _lastWorkoutApiValues = {
    'today': 'today',
    'this_week': 'this_week',
    'longer_ago': 'longer_ago',
    'Hôm nay': 'today',
    'Tuần này': 'this_week',
    '1 tháng trước': 'longer_ago',
    'Lâu hơn': 'longer_ago',
  };

  static const Map<String, String> _healthLimitationApiValues = {
    'back_pain': 'back_pain',
    'eye_strain': 'eye_strain',
    'low_energy': 'low_energy',
    'busy': 'busy',
    'none': 'none',
    'Đau lưng': 'back_pain',
    'Mỏi mắt': 'eye_strain',
    'Ít năng lượng': 'low_energy',
    'Bận rộn': 'busy',
    'Không có': 'none',
  };

  static const Map<String, String> _mainActivityApiValues = {
    'software_engineer': 'software_engineer',
    'student': 'student',
    'office_worker': 'office_worker',
    'freelancer': 'freelancer',
    'other': 'other',
    'Software Engineer': 'software_engineer',
    'Sinh Viên': 'student',
    'Nhân Viên Văn Phòng': 'office_worker',
    'Freelancer': 'freelancer',
    'Khác': 'other',
  };

  static const Map<String, String> _preferredFreeTimeApiValues = {
    'early_morning': 'early_morning',
    'lunch': 'lunch',
    'after_work': 'after_work',
    'evening': 'evening',
    'Early Morning': 'early_morning',
    'Early Morning (5-7 AM)': 'early_morning',
    'Early Morning (5–7 AM)': 'early_morning',
    'Lunch Break': 'lunch',
    'After Work': 'after_work',
    'Evening': 'evening',
    'Evening (8-11 PM)': 'evening',
    'Evening (8–11 PM)': 'evening',
    'Sáng sớm': 'early_morning',
    'Sáng sớm (5-7h)': 'early_morning',
    'Sáng sớm (5–7h)': 'early_morning',
    'Nghỉ trưa': 'lunch',
    'Sau giờ làm': 'after_work',
    'Tối': 'evening',
    'Tối (20-23h)': 'evening',
    'Tối (20–23h)': 'evening',
  };

  static const Map<String, String> _timePreferenceApiValues = {
    'morning': 'morning',
    'lunch': 'lunch',
    'evening': 'evening',
    'early_morning': 'morning',
    'after_work': 'evening',
    'before_sleep': 'evening',
    'Sáng': 'morning',
    'Sáng sớm': 'morning',
    'Nghỉ trưa': 'lunch',
    'Sau giờ làm': 'evening',
    'Tối': 'evening',
    'Tối (20-22h)': 'evening',
    'Tối (20–22h)': 'evening',
    'Trước khi ngủ': 'evening',
    'Morning': 'morning',
    'Early Morning': 'morning',
    'Lunch Break': 'lunch',
    'After Work': 'evening',
    'Evening': 'evening',
    'Before Sleep': 'evening',
  };

  static const Map<String, String> _waterReminderModeApiValues = {
    'fixed': 'fixed',
    'random': 'random',
    'optimal': 'optimal',
    'Cố định': 'fixed',
    'Ngẫu nhiên': 'random',
    'Tối ưu': 'optimal',
    'Fixed': 'fixed',
    'Random': 'random',
    'Optimal': 'optimal',
  };

  void nextStep() {
    if (!state.canContinue) return;
    if (!state.isLastStep) {
      state = state.updateState(currentStep: state.currentStep + 1);
    }
  }

  Future<void> prefillFromProfile() async {
    try {
      final profile = await _userApiService.getMe();
      if (profile.name.isNotEmpty) {
        state = state.updateState(
          data: state.data.copyWith(displayName: profile.name),
        );
        if (kDebugMode) {
          debugPrint(
            '[ONBOARDING] prefilled displayName from /me: ${profile.name}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ONBOARDING] prefillFromProfile skipped: $e');
      }
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
    state = state.updateState(
      data: state.data.copyWith(workScheduleType: value),
    );
  }

  void updateWorkStartTime(String value) {
    state = state.updateState(data: state.data.copyWith(workStartTime: value));
  }

  void updateWorkEndTime(String value) {
    state = state.updateState(data: state.data.copyWith(workEndTime: value));
  }

  void updateFreeTimePreference(String value) {
    state = state.updateState(
      data: state.data.copyWith(freeTimePreference: value),
    );
  }

  void togglePreferredFreeTime(String value) {
    final list = List<String>.from(state.data.preferredFreeTimes);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    state = state.updateState(
      data: state.data.copyWith(
        preferredFreeTimes: list,
        freeTimePreference: list.isNotEmpty ? list.join(',') : '',
      ),
    );
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
    state = state.updateState(
      data: state.data.copyWith(healthLimitations: list),
    );
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
    state = state.updateState(
      data: state.data.copyWith(targetSleepTime: value),
    );
  }

  void updateFreeTimeStart(String value) {
    state = state.updateState(data: state.data.copyWith(freeTimeStart: value));
  }

  void updateFreeTimeEnd(String value) {
    state = state.updateState(data: state.data.copyWith(freeTimeEnd: value));
  }

  void toggleLearningTimePreference(String value) {
    final normalized = _normalizeRequiredValue(
      value,
      values: _timePreferenceApiValues,
      fallback: 'evening',
    );
    final list = List<String>.from(state.data.learningTimePreferences);
    if (list.contains(normalized)) {
      list.remove(normalized);
    } else {
      list.add(normalized);
    }
    final selected = list.isNotEmpty ? list : const ['evening'];
    state = state.updateState(
      data: state.data.copyWith(
        learningTimePreferences: selected,
        learningTimePreference: selected.first,
      ),
    );
  }

  void toggleMovementTimePreference(String value) {
    final normalized = _normalizeRequiredValue(
      value,
      values: _timePreferenceApiValues,
      fallback: 'evening',
    );
    final list = List<String>.from(state.data.movementTimePreferences);
    if (list.contains(normalized)) {
      list.remove(normalized);
    } else {
      list.add(normalized);
    }
    final selected = list.isNotEmpty ? list : const ['evening'];
    state = state.updateState(
      data: state.data.copyWith(
        movementTimePreferences: selected,
        movementTimePreference: selected.join(','),
      ),
    );
  }

  void updateLearningTimePreference(String value) =>
      toggleLearningTimePreference(value);

  void updateMovementTimePreference(String value) =>
      toggleMovementTimePreference(value);

  // Step 6 - Reminders
  void updateBreakReminderInterval(int value) {
    state = state.updateState(
      data: state.data.copyWith(breakReminderInterval: value),
    );
  }

  void updateBreakDuration(String value) {
    state = state.updateState(data: state.data.copyWith(breakDuration: value));
  }

  void updateWaterReminderMode(String value) {
    state = state.updateState(
      data: state.data.copyWith(waterReminderMode: value),
    );
  }

  void updateQuietAfterTime(String value) {
    state = state.updateState(data: state.data.copyWith(quietAfterTime: value));
  }

  // Step 7 - Rewards
  void togglePreferredReward(String value) {
    final list = List<String>.from(state.data.preferredRewards);
    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }
    state = state.updateState(
      data: state.data.copyWith(preferredRewards: list),
    );
  }

  Future<bool> completeOnboarding() async {
    if (!state.canContinue) return false;

    final payload = _buildOnboardingPayload();

    try {
      state = state.updateState(isLockedPage: true);

      await profileService.createOrUpdateProfile(
        name: state.data.displayName,
        mainGoals: state.data.mainGoals,
      );

      await questRuleService.updateDailyQuestLimit(6);

      if (kDebugMode) {
        debugPrint(
          '[ONBOARDING] POST /api/onboarding '
          'work_schedule_type=${payload['work_schedule_type']} '
          'preferred_free_times=${payload['preferred_free_times']} '
          'activity_level=${payload['activity_level']} '
          'last_workout=${payload['last_workout']}',
        );
      }

      await _userApiService.saveOnboarding(payload);

      if (kDebugMode) {
        debugPrint('[ONBOARDING] saveOnboarding succeeded');
      }

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
      if (kDebugMode) {
        debugPrint('[ONBOARDING] saveOnboarding failed: $e');
      }
      state = state.updateState(
        isLockedPage: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Map<String, dynamic> _buildOnboardingPayload() {
    final preferredFreeTimes = _normalizePreferredFreeTimes(
      state.data.preferredFreeTimes,
      fallbackPreference: state.data.freeTimePreference,
    );

    final normalizedHealthLimitations = state.data.healthLimitations
        .map((v) => _healthLimitationApiValues[v.trim()] ?? v.trim())
        .where((v) => v.isNotEmpty)
        .toSet()
        .toList();

    final learningTimePreferences = _normalizeTimePreferences(
      state.data.learningTimePreferences,
      fallbackPreference: state.data.learningTimePreference,
    );
    final movementTimePreferences = _normalizeTimePreferences(
      state.data.movementTimePreferences,
      fallbackPreference: state.data.movementTimePreference,
    );

    final normalizedMainGoals = state.data.mainGoals
        .map((goal) => _mainGoalApiValues[goal.trim()] ?? goal.trim())
        .where((goal) => goal.isNotEmpty)
        .toSet()
        .toList();

    return {
      'display_name': state.data.displayName,
      'age': state.data.age,
      'gender': _normalizeRequiredValue(
        state.data.gender,
        values: _genderApiValues,
        fallback: 'male',
      ),
      'height_cm': state.data.heightCm,
      'weight_kg': state.data.weightKg,
      'main_activity': _normalizeRequiredValue(
        state.data.mainActivity,
        values: _mainActivityApiValues,
        fallback: 'software_engineer',
      ),
      'work_schedule_type': _normalizeRequiredValue(
        state.data.workScheduleType,
        values: _workScheduleTypeApiValues,
        fallback: 'weekdays',
      ),
      'work_start_time': state.data.workStartTime,
      'work_end_time': state.data.workEndTime,
      'free_time_preference': preferredFreeTimes.join(','),
      'preferred_free_times': preferredFreeTimes,
      'activity_level': _normalizeRequiredValue(
        state.data.activityLevel,
        values: _activityLevelApiValues,
        fallback: 'very_little',
      ),
      'last_workout': _normalizeRequiredValue(
        state.data.lastWorkout,
        values: _lastWorkoutApiValues,
        fallback: 'longer_ago',
      ),
      'health_limitations': normalizedHealthLimitations,
      'main_goals': normalizedMainGoals,
      'wake_up_time': state.data.wakeUpTime,
      'target_sleep_time': state.data.targetSleepTime,
      'free_time_start': state.data.freeTimeStart,
      'free_time_end': state.data.freeTimeEnd,
      'learning_time_preference': learningTimePreferences.first,
      'learning_time_preferences': learningTimePreferences,
      'movement_time_preference': movementTimePreferences.join(','),
      'movement_time_preferences': movementTimePreferences,
      // Note: Omitted from active onboarding UI (reminders step is skipped),
      // these use default state values.
      'break_reminder_interval': state.data.breakReminderInterval,
      'break_duration': state.data.breakDuration,
      'water_reminder_mode': _normalizeRequiredValue(
        state.data.waterReminderMode,
        values: _waterReminderModeApiValues,
        fallback: 'optimal',
      ),
      'quiet_after_time': state.data.quietAfterTime.trim().isNotEmpty
          ? state.data.quietAfterTime.trim()
          : '22:00',
      'preferred_rewards': <String>[],
      'preferred_review_time': _calculatePreferredReviewTime(
        targetSleepTime: state.data.targetSleepTime,
        quietAfterTime: state.data.quietAfterTime,
      ),
      'completed': true,
    };
  }

  static String _calculatePreferredReviewTime({
    required String targetSleepTime,
    required String? quietAfterTime,
  }) {
    final sleepTod = TimeHelper.parseTimeOfDay(targetSleepTime) ?? const TimeOfDay(hour: 23, minute: 0);
    int reviewHour = sleepTod.hour - 1;
    if (reviewHour < 0) {
      reviewHour = 23;
    }
    final reviewTod = TimeOfDay(hour: reviewHour, minute: sleepTod.minute);
    String reviewTimeStr = TimeHelper.formatTimeOfDay(reviewTod);

    if (quietAfterTime != null && quietAfterTime.trim().isNotEmpty) {
      final quietStr = quietAfterTime.trim();
      if (TimeHelper.compareTime(reviewTimeStr, quietStr) > 0) {
        reviewTimeStr = quietStr;
      }
    }
    return reviewTimeStr;
  }

  static String _normalizeRequiredValue(
    String value, {
    required Map<String, String> values,
    required String fallback,
  }) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return fallback;
    return values[trimmed] ?? trimmed;
  }

  static List<String> _normalizePreferredFreeTimes(
    List<String> values, {
    required String fallbackPreference,
  }) {
    final sourceValues = values.isNotEmpty
        ? values
        : fallbackPreference
              .split(',')
              .map((value) => value.trim())
              .where((value) => value.isNotEmpty);

    return sourceValues
        .map((value) {
          final trimmed = value.trim();
          return _preferredFreeTimeApiValues[trimmed] ?? trimmed;
        })
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList();
  }

  static List<String> _normalizeTimePreferences(
    List<String> values, {
    required String fallbackPreference,
  }) {
    final sourceValues = values.isNotEmpty
        ? values
        : fallbackPreference
              .split(',')
              .map((value) => value.trim())
              .where((value) => value.isNotEmpty);

    final normalized = sourceValues
        .map((value) {
          final trimmed = value.trim();
          return _timePreferenceApiValues[trimmed] ?? trimmed;
        })
        .where((value) => value.isNotEmpty)
        .where(
          (value) =>
              value == 'morning' || value == 'lunch' || value == 'evening',
        )
        .toSet()
        .toList();

    if (normalized.isEmpty) return const ['evening'];

    const order = ['morning', 'lunch', 'evening'];
    normalized.sort((a, b) => order.indexOf(a).compareTo(order.indexOf(b)));
    return normalized;
  }
}

final onboardingPageProvider =
    StateNotifierProvider<OnboardingPageModel, OnboardingPageState>((ref) {
      return OnboardingPageModel(
        profileService: ref.read(profileServiceProvider),
        localStorageService: ref.read(localStorageServiceProvider),
        questRuleService: ref.read(questRuleServiceProvider),
        logService: ref.read(logServiceProvider),
        userApiService: ref.read(userApiServiceProvider),
      );
    });
