class OnboardingData {
  // Step 1 - Basic Info
  final String displayName;
  final int? age;
  final String gender;
  final double? heightCm;
  final double? weightKg;

  // Step 2 - Work & Study
  final String mainActivity;
  final String workScheduleType;
  final String workStartTime;
  final String workEndTime;
  final String freeTimePreference;
  final List<String> preferredFreeTimes;

  // Step 3 - Health & Activity
  final String activityLevel;
  final String lastWorkout;
  final List<String> healthLimitations;

  // Step 4 - Goals
  final List<String> mainGoals;

  // Step 5 - Schedule
  final String wakeUpTime;
  final String targetSleepTime;
  final String freeTimeStart;
  final String freeTimeEnd;
  final String learningTimePreference;
  final List<String> learningTimePreferences;
  final String movementTimePreference;
  final List<String> movementTimePreferences;

  // Step 6 - Reminders
  final int breakReminderInterval;
  final String breakDuration;
  final String waterReminderMode;
  final String quietAfterTime;

  // Step 7 - Rewards
  final List<String> preferredRewards;

  const OnboardingData({
    this.displayName = '',
    this.age,
    this.gender = 'male',
    this.heightCm,
    this.weightKg,
    this.mainActivity = 'software_engineer',
    this.workScheduleType = 'weekdays',
    this.workStartTime = '08:30',
    this.workEndTime = '17:30',
    this.freeTimePreference = '',
    this.preferredFreeTimes = const [],
    this.activityLevel = 'very_little',
    this.lastWorkout = 'longer_ago',
    this.healthLimitations = const [],
    this.mainGoals = const [],
    this.wakeUpTime = '07:00',
    this.targetSleepTime = '23:00',
    this.freeTimeStart = '20:00',
    this.freeTimeEnd = '22:00',
    this.learningTimePreference = 'evening',
    this.learningTimePreferences = const ['evening'],
    this.movementTimePreference = 'evening',
    this.movementTimePreferences = const ['evening'],
    this.breakReminderInterval = 90,
    this.breakDuration = '5',
    this.waterReminderMode = 'optimal',
    this.quietAfterTime = '22:00',
    this.preferredRewards = const [],
  });

  OnboardingData copyWith({
    String? displayName,
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? mainActivity,
    String? workScheduleType,
    String? workStartTime,
    String? workEndTime,
    String? freeTimePreference,
    List<String>? preferredFreeTimes,
    String? activityLevel,
    String? lastWorkout,
    List<String>? healthLimitations,
    List<String>? mainGoals,
    String? wakeUpTime,
    String? targetSleepTime,
    String? freeTimeStart,
    String? freeTimeEnd,
    String? learningTimePreference,
    List<String>? learningTimePreferences,
    String? movementTimePreference,
    List<String>? movementTimePreferences,
    int? breakReminderInterval,
    String? breakDuration,
    String? waterReminderMode,
    String? quietAfterTime,
    List<String>? preferredRewards,
  }) {
    return OnboardingData(
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      mainActivity: mainActivity ?? this.mainActivity,
      workScheduleType: workScheduleType ?? this.workScheduleType,
      workStartTime: workStartTime ?? this.workStartTime,
      workEndTime: workEndTime ?? this.workEndTime,
      freeTimePreference: freeTimePreference ?? this.freeTimePreference,
      preferredFreeTimes: preferredFreeTimes ?? this.preferredFreeTimes,
      activityLevel: activityLevel ?? this.activityLevel,
      lastWorkout: lastWorkout ?? this.lastWorkout,
      healthLimitations: healthLimitations ?? this.healthLimitations,
      mainGoals: mainGoals ?? this.mainGoals,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      targetSleepTime: targetSleepTime ?? this.targetSleepTime,
      freeTimeStart: freeTimeStart ?? this.freeTimeStart,
      freeTimeEnd: freeTimeEnd ?? this.freeTimeEnd,
      learningTimePreference:
          learningTimePreference ?? this.learningTimePreference,
      learningTimePreferences:
          learningTimePreferences ?? this.learningTimePreferences,
      movementTimePreference:
          movementTimePreference ?? this.movementTimePreference,
      movementTimePreferences:
          movementTimePreferences ?? this.movementTimePreferences,
      breakReminderInterval:
          breakReminderInterval ?? this.breakReminderInterval,
      breakDuration: breakDuration ?? this.breakDuration,
      waterReminderMode: waterReminderMode ?? this.waterReminderMode,
      quietAfterTime: quietAfterTime ?? this.quietAfterTime,
      preferredRewards: preferredRewards ?? this.preferredRewards,
    );
  }
}
