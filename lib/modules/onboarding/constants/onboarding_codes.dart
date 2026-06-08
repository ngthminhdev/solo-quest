class OnboardingCodes {
  OnboardingCodes._();

  // ── Main activity ──
  static const mainActivitySoftwareEngineer = 'software_engineer';
  static const mainActivityStudent = 'student';
  static const mainActivityOfficeWorker = 'office_worker';
  static const mainActivityFreelancer = 'freelancer';
  static const mainActivityOther = 'other';

  static const mainActivities = [
    mainActivitySoftwareEngineer,
    mainActivityStudent,
    mainActivityOfficeWorker,
    mainActivityFreelancer,
    mainActivityOther,
  ];

  // ── Goals ──
  static const goalHealth = 'health';
  static const goalMovement = 'movement';
  static const goalLearning = 'learning';
  static const goalMindfulness = 'mindfulness';
  static const goalSleep = 'sleep';
  static const goalProductivity = 'productivity';
  static const goalWeightLoss = 'weight_loss';

  static const goals = [
    goalHealth,
    goalMovement,
    goalLearning,
    goalMindfulness,
    goalSleep,
    goalProductivity,
    goalWeightLoss,
  ];

  // ── Work schedule types ──
  static const scheduleWeekdays = 'weekdays';
  static const scheduleMondayToSaturday = 'monday_to_saturday';
  static const scheduleFullWeek = 'full_week';
  static const scheduleFlexible = 'flexible';
  static const scheduleNightShift = 'night_shift';
  static const scheduleCustom = 'custom';

  static const scheduleTypes = [
    scheduleWeekdays,
    scheduleMondayToSaturday,
    scheduleFullWeek,
    scheduleFlexible,
    scheduleNightShift,
    scheduleCustom,
  ];

  // ── Free time / Time preference ──
  static const timeEarlyMorning = 'early_morning';
  static const timeLunch = 'lunch';
  static const timeAfterWork = 'after_work';
  static const timeEvening = 'evening';

  static const timePreferences = [
    timeEarlyMorning,
    timeLunch,
    timeAfterWork,
    timeEvening,
  ];

  // ── Sleep preference ──
  static const sleepEvening = 'evening';
  static const sleepLateEvening = 'late_evening';

  // ── Nutrition preference ──
  static const nutritionMorning = 'morning';
  static const nutritionLunch = 'lunch';
  static const nutritionDinner = 'dinner';
  static const nutritionFlexible = 'flexible';

  // ── Activity level ──
  static const activitySedentary = 'sedentary';
  static const activityLight = 'light';
  static const activityModerate = 'moderate';
  static const activityActive = 'active';

  static const activityLevels = [
    activitySedentary,
    activityLight,
    activityModerate,
    activityActive,
  ];

  // ── Last workout ──
  static const workoutRecently = 'recently';
  static const workoutThisWeek = 'this_week';
  static const workoutThisMonth = 'this_month';
  static const workoutLongAgo = 'long_ago';
  static const workoutNever = 'never';

  static const lastWorkouts = [
    workoutRecently,
    workoutThisWeek,
    workoutThisMonth,
    workoutLongAgo,
    workoutNever,
  ];

  // ── Health limitations ──
  static const limitationNone = 'none';
  static const limitationBackPain = 'back_pain';
  static const limitationKneePain = 'knee_pain';
  static const limitationLowEnergy = 'low_energy';
  static const limitationLimitedMobility = 'limited_mobility';
  static const limitationInjuryRecovery = 'injury_recovery';
  static const limitationOther = 'other';

  static const healthLimitations = [
    limitationNone,
    limitationBackPain,
    limitationKneePain,
    limitationLowEnergy,
    limitationLimitedMobility,
    limitationInjuryRecovery,
    limitationOther,
  ];

  // ── Water reminder mode ──
  static const waterFixed = 'fixed';
  static const waterRandom = 'random';
  static const waterOptimal = 'optimal';

  // ── Gender ──
  static const genderMale = 'male';
  static const genderFemale = 'female';
  static const genderOther = 'other';
}
