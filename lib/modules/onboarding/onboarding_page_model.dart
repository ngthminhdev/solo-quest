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
  final bool isGeneratingQuests;
  final String? postOnboardingFallbackMessage;

  OnboardingPageState({
    this.loadState = AppLoadState.idle,
    this.currentStep = 0,
    this.totalSteps = 7,
    this.data = const OnboardingData(),
    this.errorMessage,
    this.isGeneratingQuests = false,
    this.postOnboardingFallbackMessage,
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
    bool? isGeneratingQuests,
    String? postOnboardingFallbackMessage,
  }) {
    return OnboardingPageState(
      loadState: loadState ?? this.loadState,
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
      isGeneratingQuests: isGeneratingQuests ?? this.isGeneratingQuests,
      postOnboardingFallbackMessage:
          postOnboardingFallbackMessage ?? this.postOnboardingFallbackMessage,
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
    required this.questService,
    UserApiService? userApiService,
    AiApiService? aiApiService,
  }) : _userApiService = userApiService ?? UserApiService(),
       _aiApiService = aiApiService ?? AiApiService(),
       super(OnboardingPageState());

  final ProfileService profileService;
  final LocalStorageService localStorageService;
  final QuestRuleService questRuleService;
  final LogService logService;
  final QuestService questService;
  final UserApiService _userApiService;
  final AiApiService _aiApiService;

  /// Whether generate-today has already been attempted (prevents double calls).
  bool _generateTodayAttempted = false;

  static const Map<String, String> _mainGoalApiValues = {
    'Uống Nước': 'health',
    'Vận Động': 'movement',
    'Học Tập': 'learning',
    'Chánh Niệm': 'mindfulness',
    'Ngủ Tốt Hơn': 'sleep',
    'Tập Trung Tốt Hơn': 'productivity',
    'Giảm Cân': 'weight_loss',
    'Kỷ Luật Hơn': 'productivity',
    'water': 'health',
    'movement': 'movement',
    'learning': 'learning',
    'mindfulness': 'mindfulness',
    'sleep': 'sleep',
    'focus': 'productivity',
    'productivity': 'productivity',
    'weight': 'weight_loss',
    'weight_loss': 'weight_loss',
    'health': 'health',
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
    'monday_to_saturday': 'monday_to_saturday',
    'full_week': 'full_week',
    'flexible': 'flexible',
    'night_shift': 'night_shift',
    'custom': 'custom',
    'Mon-Fri': 'weekdays',
    'Mon–Fri': 'weekdays',
    'Mon-Sat': 'monday_to_saturday',
    'Mon–Sat': 'monday_to_saturday',
    'Flexible': 'flexible',
    'Night Shift': 'night_shift',
    'Thứ 2-6': 'weekdays',
    'Thứ 2–6': 'weekdays',
    'Thứ 2 - Thứ 6': 'weekdays',
    'Thứ 2 – Thứ 6': 'weekdays',
    'Thứ 2-7': 'monday_to_saturday',
    'Thứ 2–7': 'monday_to_saturday',
    'Linh hoạt': 'flexible',
    'Ca đêm': 'night_shift',
  };

  static const Map<String, String> _activityLevelApiValues = {
    'sedentary': 'sedentary',
    'light': 'light',
    'moderate': 'moderate',
    'active': 'active',
    'very_little': 'sedentary',
    'occasional': 'light',
    'regular': 'active',
    'Rất ít': 'sedentary',
    'Thỉnh thoảng': 'light',
    'Đều đặn': 'active',
  };

  static const Map<String, String> _lastWorkoutApiValues = {
    'recently': 'recently',
    'this_week': 'this_week',
    'long_ago': 'long_ago',
    'today': 'recently',
    'longer_ago': 'long_ago',
    'this_month': 'this_month',
    'never': 'never',
    'Hôm nay': 'recently',
    'Tuần này': 'this_week',
    '1 tháng trước': 'this_month',
    'Lâu hơn': 'long_ago',
  };

  static const Map<String, String> _healthLimitationApiValues = {
    'none': 'none',
    'back_pain': 'back_pain',
    'knee_pain': 'knee_pain',
    'low_energy': 'low_energy',
    'limited_mobility': 'limited_mobility',
    'injury_recovery': 'injury_recovery',
    'other': 'other',
    'eye_strain': 'other',
    'busy': 'other',
    'Đau lưng': 'back_pain',
    'Mỏi mắt': 'other',
    'Ít năng lượng': 'low_energy',
    'Bận rộn': 'other',
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
    'early_morning': 'early_morning',
    'lunch': 'lunch',
    'after_work': 'after_work',
    'evening': 'evening',
    'morning': 'early_morning',
    'before_sleep': 'evening',
    'Sáng': 'early_morning',
    'Sáng sớm': 'early_morning',
    'Nghỉ trưa': 'lunch',
    'Sau giờ làm': 'after_work',
    'Tối': 'evening',
    'Tối (20-22h)': 'evening',
    'Tối (20–22h)': 'evening',
    'Trước khi ngủ': 'evening',
    'Morning': 'early_morning',
    'Early Morning': 'early_morning',
    'Lunch Break': 'lunch',
    'After Work': 'after_work',
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
        freeTimePreference: list.isNotEmpty ? list.first : '',
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

  void updateLearningTopic(String value) {
    state = state.updateState(
      data: state.data.copyWith(
        learningTopic: value.trim().isEmpty ? null : value.trim(),
      ),
    );
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
        movementTimePreference: selected.first,
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
    if (_generateTodayAttempted) return false;

    final payload = _buildOnboardingPayload();

    try {
      state = state.updateState(isLockedPage: true);

      await profileService.createOrUpdateProfile(
        name: state.data.displayName,
        mainGoals: state.data.mainGoals,
      );

      await questRuleService.updateDailyQuestLimit(6);

      if (kDebugMode) {
        debugPrint('[ONBOARDING] Submitting payload:');
        debugPrint('  work_schedule_type: ${payload['work_schedule_type']}');
        debugPrint('  work_weekdays: ${payload['work_weekdays']}');
        debugPrint('  work_start_time: ${payload['work_start_time']}');
        debugPrint('  work_end_time: ${payload['work_end_time']}');
        debugPrint('  preferred_free_times: ${payload['preferred_free_times']}');
        debugPrint('  main_goals: ${payload['main_goals']}');
        debugPrint('  health_limitations: ${payload['health_limitations']}');
        debugPrint('  learning_topic: ${payload['learning_topic']}');
        debugPrint('  learning_time_preference: ${payload['learning_time_preference']}');
        debugPrint('  learning_time_preferences: ${payload['learning_time_preferences']}');
        debugPrint('  movement_time_preference: ${payload['movement_time_preference']}');
        debugPrint('  movement_time_preferences: ${payload['movement_time_preferences']}');
        debugPrint('  sleep_time_preference: ${payload['sleep_time_preference']}');
        debugPrint('  nutrition_time_preference: ${payload['nutrition_time_preference']}');
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

      // ── Post-onboarding: AI generate today's quests ──
      _generateTodayAttempted = true;
      state = state.updateState(
        isLockedPage: false,
        isGeneratingQuests: true,
      );

      final genSuccess = await _performPostOnboardingGeneration();

      if (!genSuccess) {
        state = state.updateState(
          isGeneratingQuests: false,
          postOnboardingFallbackMessage: 'generate_failed',
        );
      } else {
        state = state.updateState(isGeneratingQuests: false);
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ONBOARDING] saveOnboarding failed: $e');
      }
      state = state.updateState(
        isLockedPage: false,
        isGeneratingQuests: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Calls the AI generate-today endpoint and refreshes today's quests.
  /// Returns true on success, false if generation failed.
  Future<bool> _performPostOnboardingGeneration() async {
    try {
      final result = await _aiApiService.generateTodayQuests();
      if (result != null) {
        // Refresh quests so Home has data immediately
        await questService.getTodayQuests();
        return true;
      }
      return false;
    } catch (_) {
      if (kDebugMode) {
        debugPrint('[ONBOARDING] generateTodayQuests threw, proceeding');
      }
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

    final workScheduleTypeNormalized = _normalizeRequiredValue(
      state.data.workScheduleType,
      values: _workScheduleTypeApiValues,
      fallback: 'weekdays',
    );

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
      'work_schedule_type': workScheduleTypeNormalized,
      'work_weekdays': _calculateWorkWeekdays(workScheduleTypeNormalized),
      'work_start_time': state.data.workStartTime,
      'work_end_time': state.data.workEndTime,
      'free_time_preference': preferredFreeTimes.isNotEmpty ? preferredFreeTimes.first : 'evening',
      'preferred_free_times': preferredFreeTimes,
      'activity_level': _normalizeRequiredValue(
        state.data.activityLevel,
        values: _activityLevelApiValues,
        fallback: 'sedentary',
      ),
      'last_workout': _normalizeRequiredValue(
        state.data.lastWorkout,
        values: _lastWorkoutApiValues,
        fallback: 'long_ago',
      ),
      'health_limitations': normalizedHealthLimitations,
      'main_goals': normalizedMainGoals,
      'learning_topic': null,
      'wake_up_time': state.data.wakeUpTime,
      'target_sleep_time': state.data.targetSleepTime,
      'free_time_start': state.data.freeTimeStart,
      'free_time_end': state.data.freeTimeEnd,
      'learning_time_preference': learningTimePreferences.first,
      'learning_time_preferences': learningTimePreferences,
      'movement_time_preference': movementTimePreferences.first,
      'movement_time_preferences': movementTimePreferences,
      'sleep_time_preference': 'evening',
      'nutrition_time_preference': 'flexible',
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

  static List<int> _calculateWorkWeekdays(String type) {
    switch (type) {
      case 'weekdays':
        return const [1, 2, 3, 4, 5];
      case 'monday_to_saturday':
        return const [1, 2, 3, 4, 5, 6];
      case 'full_week':
        return const [1, 2, 3, 4, 5, 6, 7];
      case 'flexible':
        return const [];
      case 'night_shift':
        return const [1, 2, 3, 4, 5];
      case 'custom':
      default:
        return const [];
    }
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

    final normalized = sourceValues
        .map((value) {
          final trimmed = value.trim();
          return _preferredFreeTimeApiValues[trimmed] ?? trimmed;
        })
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList();

    if (normalized.isEmpty) return const ['evening'];
    return normalized;
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
              value == 'early_morning' ||
              value == 'lunch' ||
              value == 'after_work' ||
              value == 'evening',
        )
        .toSet()
        .toList();

    if (normalized.isEmpty) return const ['evening'];

    const order = ['early_morning', 'lunch', 'after_work', 'evening'];
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
        questService: ref.read(questServiceProvider),
        userApiService: ref.read(userApiServiceProvider),
      );
    });
