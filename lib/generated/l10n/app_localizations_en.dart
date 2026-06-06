// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SoloQuest';

  @override
  String get welcomeSubtitle =>
      'Improve your life daily through personalized quests';

  @override
  String get welcomeSystemMessage =>
      '[ SYSTEM ]\nBooting...\nStatus: READY\nStart self-improvement journey?';

  @override
  String get welcomeStartButton => 'Start personal setup';

  @override
  String get welcomeSkipLink => 'Already setup? Skip';

  @override
  String get welcomeVersionTag => 'v1.0.0 — Online System';

  @override
  String get welcomeFeature1Title => 'Personalized Quests';

  @override
  String get welcomeFeature1Desc =>
      'Micro-tasks tailored to your daily routines';

  @override
  String get welcomeFeature2Title => 'Logs to Understand Self';

  @override
  String get welcomeFeature2Desc =>
      'Track activities and discover behavior patterns';

  @override
  String get welcomeFeature3Title => 'EXP, Level, Streak';

  @override
  String get welcomeFeature3Desc => 'Gamification to keep you motivated';

  @override
  String get welcomeFeature4Title => 'Smart Reminders';

  @override
  String get welcomeFeature4Desc =>
      'Remind at the right time, without disturbance';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonDone => 'Done';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonEmpty => 'No data yet';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavLogs => 'Logs';

  @override
  String get bottomNavProgress => 'Progress';

  @override
  String get bottomNavLearning => 'Path';

  @override
  String get bottomNavRewards => 'Rewards';

  @override
  String get bottomNavProfile => 'Profile';

  @override
  String get headerHome => 'Home';

  @override
  String get headerLogs => 'Logs';

  @override
  String get headerProgress => 'Progress';

  @override
  String get headerLearning => 'Learning Path';

  @override
  String get headerRewards => 'Self-Rewards';

  @override
  String get headerProfile => 'Profile';

  @override
  String get loginTagline =>
      'Turn your learning paths into small daily quests.';

  @override
  String get loginTitle => 'Start your journey';

  @override
  String get loginSubtitle =>
      'Sign in with Google to sync your quests, logs, progress, and rewards across devices.';

  @override
  String get loginGoogleButton => 'Continue with Google';

  @override
  String get loginGoogleLoading => 'Connecting to Google…';

  @override
  String get loginError => 'Unable to sign in with Google. Please try again.';

  @override
  String get loginNote =>
      'We only use your Google account for authentication and syncing your SoloQuest data.';

  @override
  String get loginTerms =>
      'By continuing, you agree to the Terms of Use and Privacy Policy.';

  @override
  String get loginPrototypeNote =>
      '[ Google auth foundation — dev fallback in debug ]';

  @override
  String get profileAccount => 'Account';

  @override
  String get profileAccountEmpty => 'No account information';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileSignOutTitle => 'Sign out?';

  @override
  String get profileSignOutMessage =>
      'You will need to sign in again to sync your SoloQuest data.';

  @override
  String get profileSignOutSuccess => 'Signed out';

  @override
  String get profileSignOutError => 'Unable to sign out. Please try again.';

  @override
  String get profileLoading => 'Loading profile...';

  @override
  String get profileSettingsTitle => 'Settings & Tools';

  @override
  String get profileScheduleTileTitle => 'Schedule';

  @override
  String get profileScheduleTileSubtitle => 'Set work, study, and rest times';

  @override
  String get profileLearningGoalsTileTitle => 'Learning Roadmap';

  @override
  String get profileLearningGoalsTileSubtitle =>
      'Track learning progress and roadmaps';

  @override
  String get profileLearningRoadmapTileTitle => 'Learning Roadmap';

  @override
  String get profileLearningRoadmapTileSubtitle =>
      'Track roadmaps and learning progress';

  @override
  String get profileReminderSettingsTileTitle => 'Reminder Settings';

  @override
  String get profileReminderSettingsTileSubtitle =>
      'Customize frequency and timing';

  @override
  String get profileQuestRulesTileTitle => 'Quest Rules';

  @override
  String get profileQuestRulesTileSubtitle =>
      'Adjust difficulty, quest types, and daily limits';

  @override
  String get profileGoalSectionTitle => 'Active Learning Path';

  @override
  String get profileGoalEmpty => 'You haven\'t started a learning path yet.';

  @override
  String get profileGoalSetupButton => 'Browse learning paths';

  @override
  String get profileGoalPursuing => 'Learning';

  @override
  String get profileGoalFromProfile => 'Learning paths from profile';

  @override
  String get profileGoalFromLearning => 'From active roadmaps';

  @override
  String get progressLoading => 'Loading progress...';

  @override
  String get progressError => 'Unable to load progress';

  @override
  String get progressWeeklySummary => 'Weekly report';

  @override
  String get progressWeeklySummaryDesc =>
      'Review progress, effective quests, and next week suggestions';

  @override
  String get progressQuestRules => 'Quest Rules';

  @override
  String get progressQuestRulesDesc =>
      'See how SoloQuest uses data to create suitable quests';

  @override
  String get progressLinksTitle => 'SEE MORE';

  @override
  String get progressHabitTitle => 'HABITS BY GROUP';

  @override
  String get progressPageTitle => 'Progress';

  @override
  String get progressHeaderTitle => 'Progress';

  @override
  String get progressHeaderSubtitle =>
      'Track level, streak, EXP, and habit consistency over time.';

  @override
  String get progressEmptyTitle => 'No Progress Yet';

  @override
  String get progressEmptyMessage =>
      'Complete your first quest to start earning EXP, levels, and streaks.';

  @override
  String get progressEmptyAction => 'Go Home';

  @override
  String get progressExpExplainTitle => 'What is EXP for?';

  @override
  String get progressExpExplainText =>
      'EXP represents daily consistency. Accumulating enough EXP levels you up to unlock badges, themes, or personal rewards. EXP is not a penalty — it only records progress. You earn EXP by completing quests, checking in, logging, or reviewing your day.';

  @override
  String get progressStreakSafetyTitle => 'Streak Safety';

  @override
  String get progressStreakSafetyNote =>
      'Streak Shield protects your streak when you\'re busy, tired, or need to rest. Use a \"light day\" to keep the rhythm without completing many quests. No heavy penalties for skipping quests due to stress or busy schedules.';

  @override
  String get progressWeeklyChartTitle => 'This Week';

  @override
  String get progressWeeklyChartSection => 'WEEKLY COMPLETION';

  @override
  String get progressHabitSection => 'Habits by Group';

  @override
  String get progressExpBreakdownSection => 'EXP BY QUEST TYPE';

  @override
  String get progressExpItemLearning => 'Learning Quest';

  @override
  String get progressExpItemLearningNote => 'Hardest quest, highest EXP';

  @override
  String get progressExpItemSleep => 'Sleep Quest';

  @override
  String get progressExpItemSleepNote => 'Prepare for good sleep';

  @override
  String get progressExpItemMovement => 'Movement Quest';

  @override
  String get progressExpItemMovementNote => 'Move your body';

  @override
  String get progressExpItemBreak => 'Break Quest';

  @override
  String get progressExpItemBreakNote => 'Rest eyes, relax';

  @override
  String get progressExpItemWater => 'Water Quest';

  @override
  String get progressExpItemWaterNote => 'Small habit, repeats often';

  @override
  String get progressExpItemReview => 'Daily Review';

  @override
  String get progressExpItemReviewNote => 'End of day reflection';

  @override
  String get progressXPHistoryTitle => 'EXP HISTORY';

  @override
  String get progressXPHistoryRecent => 'Recent';

  @override
  String progressStreakDaysLabel(Object days) {
    return 'Streak $days days';
  }

  @override
  String get progressStreakDaysSuffix => ' days';

  @override
  String get progressStreakShieldRemaining => 'Shield remaining';

  @override
  String get progressStreakLightDaysUsed => 'Light days used';

  @override
  String get progressStreakMax => 'Max streak';

  @override
  String get progressStreakShield => 'Streak Shield';

  @override
  String get progressStreakShieldNote =>
      ' protects your streak when you\'re busy, tired, or need to rest. Use \"light days\" to keep momentum without completing many quests.';

  @override
  String get progressCurrentLevel => 'Current Level';

  @override
  String get progressWeeklyQuest => 'Weekly Quest';

  @override
  String get progressStreakLabel => 'Streak';

  @override
  String get progressCompletedLabel => 'Completed';

  @override
  String progressWeeklyChartAverage(Object rate) {
    return 'Average rate: $rate%';
  }

  @override
  String progressWeeklyChartTotal(Object completed, Object planned) {
    return 'Total: $completed/$planned';
  }

  @override
  String get progressAchievementSectionTitle => 'Achievements';

  @override
  String get progressAchievementStarter => 'Starter';

  @override
  String get progressAchievementStarterDesc => 'Complete your first 5 quests';

  @override
  String get progressAchievementKeeper => 'Keeper';

  @override
  String get progressAchievementKeeperDesc => 'Maintain a 3-day streak';

  @override
  String get progressAchievementLearner => 'Learner';

  @override
  String get progressAchievementLearnerDesc => 'Complete 5 learning quests';

  @override
  String get progressAchievementUnlocked => 'Unlocked';

  @override
  String get progressStreakMotivationStart => 'Start your streak today';

  @override
  String get progressStreakMotivationGood => 'You\'re off to a great start';

  @override
  String get progressStreakMotivationForming => 'A habit is forming';

  @override
  String get progressStreakMotivationStable => 'Your habit is very stable';

  @override
  String get progressWeeklyCompletionTitle => 'Weekly completion rate';

  @override
  String get progressWeeklyCompletionLow =>
      'Consider reducing difficulty or splitting quests to improve completion rate.';

  @override
  String get progressWeeklyCompletionMedium =>
      'Looking good, stay consistent to maintain the habit.';

  @override
  String get progressWeeklyCompletionHigh =>
      'Excellent! You\'re completing quests very consistently.';

  @override
  String get progressStatsTotalEXP => 'Total EXP';

  @override
  String get progressStatsCompletedQuests => 'Completed quests';

  @override
  String get progressStatsSkippedQuests => 'Skipped quests';

  @override
  String get progressStatsStreakDays => 'days';

  @override
  String get progressQuestTypeTitle => 'By quest type';

  @override
  String get progressQuestTypeEmpty => 'No type data yet.';

  @override
  String get progressLevelCurrentLevel => 'Current level';

  @override
  String get progressLevelTotalEXP => 'Total EXP';

  @override
  String progressLevelEXPToNext(Object exp) {
    return '$exp EXP to next level';
  }

  @override
  String get questTypeWater => 'Water';

  @override
  String get questTypeBreak => 'Break';

  @override
  String get questTypeMovement => 'Movement';

  @override
  String get questTypeLearning => 'Learning';

  @override
  String get questTypeSleep => 'Sleep';

  @override
  String get questTypeFitness => 'Fitness';

  @override
  String get questTypeMindfulness => 'Mindfulness';

  @override
  String get questTypeReview => 'Review';

  @override
  String get questTypeCustom => 'Custom';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyEasyDesc => 'Small quest, easy to complete.';

  @override
  String get difficultyMediumDesc =>
      'Requires concentration or light movement.';

  @override
  String get difficultyHardDesc => 'Requires more energy or time.';

  @override
  String get priorityHighest => 'Highest';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityLowest => 'Lowest';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusActive => 'Active';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusSkipped => 'Skipped';

  @override
  String get statusSnoozed => 'Snoozed';

  @override
  String get statusExpired => 'Expired';

  @override
  String get rewardsLoading => 'Loading self-rewards...';

  @override
  String get rewardsError => 'Unable to load self-rewards';

  @override
  String get rewardsNotEnough =>
      'Not enough achievement points to unlock this self-reward suggestion.';

  @override
  String get rewardsClaimed => 'Self-reward recorded!';

  @override
  String get rewardsClaimFailed => 'Unable to record self-reward';

  @override
  String get questRulesPageTitle => 'Quest Rules';

  @override
  String get questRulesPageSubtitle =>
      'Adjust how SoloQuest creates quests suitable for your energy, schedule, and goals.';

  @override
  String get questRulesSummaryTitle => 'Quest Creation Rulebook';

  @override
  String get questRulesDailyLimitTitle => 'Daily Quest Limit';

  @override
  String get questRulesDailyLimitSubtitle =>
      'Helps avoid creating too many quests that cause overwhelm.';

  @override
  String get questRulesPriorityTitle => 'Priority Quest Types';

  @override
  String get questRulesListTitle => 'Active Quest Rules';

  @override
  String get questRulesFormTitle => 'Edit Rule';

  @override
  String get questRulesEmptyTitle => 'No Rules Yet';

  @override
  String get questRulesEmptyMessage =>
      'SoloQuest needs rules to create quests at the right pace without overwhelming you.';

  @override
  String get questRulesToastToggleOn => 'Rule enabled';

  @override
  String get questRulesToastToggleOff => 'Rule disabled';

  @override
  String get questRulesToastToggleFailed => 'Unable to update status';

  @override
  String get questRulesToastUpdateSuccess => 'Rule updated successfully';

  @override
  String get questRulesToastUpdateFailed => 'Unable to update rule';

  @override
  String get questRulesToastDailyLimitSuccess => 'Daily quest limit updated';

  @override
  String get questRulesToastDailyLimitFailed => 'Unable to update limit';

  @override
  String get questRulesToastResetSuccess => 'Default rules restored';

  @override
  String get questRulesToastResetFailed => 'Unable to restore default rules';

  @override
  String get questRulesMetricTotal => 'Total rules';

  @override
  String get questRulesMetricEnabled => 'Enabled';

  @override
  String get questRulesMetricDisabled => 'Disabled';

  @override
  String get questRulesMetricDailyLimit => 'Limit/day';

  @override
  String get questRulesFormTitleLabel => 'Title';

  @override
  String get questRulesFormTitlePlaceholder => 'Quest rule name';

  @override
  String get questRulesFormDescLabel => 'Description';

  @override
  String get questRulesFormDescPlaceholder => 'Describe how this rule works';

  @override
  String get questRulesFormIntervalLabel => 'Min interval';

  @override
  String get questRulesFormMaxPerDayLabel => 'Max per day';

  @override
  String get questRulesFormPriorityLabel => 'Priority';

  @override
  String get questRulesFormTimeRangeLabel => 'Active time range';

  @override
  String get questRulesFormTimeRangeStart => 'Start';

  @override
  String get questRulesFormTimeRangeEnd => 'End';

  @override
  String get questRulesFormActiveDaysLabel => 'Active days';

  @override
  String get questRulesFormAdaptEnergy => 'Adapt to energy';

  @override
  String get questRulesFormAdaptEnergySub =>
      'Adjust quest based on energy level.';

  @override
  String get questRulesFormAdaptStress => 'Adapt to stress';

  @override
  String get questRulesFormAdaptStressSub =>
      'Reduce intensity when stress is high.';

  @override
  String get questRulesFormAdaptSchedule => 'Adapt to schedule';

  @override
  String get questRulesFormAdaptScheduleSub =>
      'Avoid creating quests during busy times.';

  @override
  String get questRulesFormSaveButton => 'Save quest rule';

  @override
  String get questRulesFormTitleRequired => 'Title cannot be empty';

  @override
  String get questRulesFormIntervalMin => 'Min interval must be greater than 0';

  @override
  String get questRulesFormMaxPerDayMin => 'Max per day must be greater than 0';

  @override
  String get questRulesFormSelectActiveDays => 'Select at least one active day';

  @override
  String get questRulesPrioritySelectTitle => 'Select Priority';

  @override
  String get questRulesGeneralSettings => 'General Settings';

  @override
  String get questRulesGeneralDifficulty => 'Default difficulty';

  @override
  String get questRulesGeneralDuration => 'Quest duration';

  @override
  String get questRulesGeneralAutoAdjust => 'Auto-adjust quests';

  @override
  String get questRulesGeneralAutoAdjustSub =>
      'System automatically adjusts difficulty and quest count based on weekly data.';

  @override
  String get questRulesGeneralRestDay => 'Flexible rest day';

  @override
  String get questRulesGeneralRestDaySub =>
      'Allows days with no quests for rest.';

  @override
  String get questRulesGeneralDurationShort => 'Short';

  @override
  String get questRulesGeneralDurationMedium => 'Medium';

  @override
  String get questRulesGeneralDurationLong => 'Long';

  @override
  String questRulesRuleCardInterval(Object minutes) {
    return 'Every $minutes mins';
  }

  @override
  String questRulesRuleCardMaxPerDay(Object max) {
    return 'Max $max times/day';
  }

  @override
  String questRulesRuleCardPriority(Object priority) {
    return 'Priority $priority';
  }

  @override
  String get questRulesRuleCardEditButton => 'Edit';

  @override
  String get questRulesResetConfirmTitle => 'Restore default rules?';

  @override
  String get questRulesResetConfirmMessage =>
      'Current configurations will be replaced by SoloQuest default rules.';

  @override
  String get questRulesResetConfirmButton => 'Restore';

  @override
  String get questRulesResetDefault => 'Restore defaults';

  @override
  String get questRulesGeneralDifficultySelectorTitle => 'Select Difficulty';

  @override
  String get questRulesLoading => 'Loading quest settings...';

  @override
  String get questRulesError => 'Unable to load quest settings';

  @override
  String get questRulesToastDifficultyFailed => 'Unable to update difficulty';

  @override
  String get questRulesToastAutoAdjustFailed =>
      'Unable to update auto-adjust setting';

  @override
  String get questRulesToastRestDayFailed =>
      'Unable to update rest day setting';

  @override
  String get questRulesToastDurationFailed => 'Unable to update duration';

  @override
  String get questRulesFilterAll => 'All';

  @override
  String get questRulesLogToggleOn => 'Enabled quest rule';

  @override
  String get questRulesLogToggleOff => 'Disabled quest rule';

  @override
  String get questRulesLogUpdate => 'Updated quest rule';

  @override
  String get questRulesLogDailyLimit => 'Updated daily quest limit';

  @override
  String get questRulesLogReset => 'Reset to default rules';

  @override
  String get questRulesLogResetDesc => 'Default quest rules';

  @override
  String questRulesPriorityValue(Object priority) {
    return 'Priority $priority';
  }

  @override
  String get morningCheckinLoading => 'Loading...';

  @override
  String get morningCheckinError => 'Unable to load data';

  @override
  String get morningCheckinMissing =>
      'Please complete the required information before continuing.';

  @override
  String get morningCheckinSuccess => 'Check-in successful!';

  @override
  String get morningCheckinFailed =>
      'Unable to save check-in. Please try again.';

  @override
  String get morningCheckinPageTitle => 'Daily Check-in';

  @override
  String get morningCheckinHeaderTitle => 'Good Morning';

  @override
  String get morningCheckinHeaderSubtitle =>
      'Take 15 seconds to let the app understand your day.';

  @override
  String get morningCheckinStepTitle => 'Daily Check-in';

  @override
  String get morningCheckinCompleted => 'Completed';

  @override
  String get morningCheckinMoodLabel => 'How do you feel today?';

  @override
  String get morningCheckinEnergyLabel => 'Your energy today?';

  @override
  String get morningCheckinAvailabilityLabel =>
      'Do you have much free time today?';

  @override
  String get morningCheckinPriorityLabel =>
      'What do you want to prioritize today?';

  @override
  String get morningCheckinSubmitText => 'Complete Check-in';

  @override
  String get morningCheckinUpdateText => 'Update Check-in';

  @override
  String get morningCheckinToastMissing =>
      'Please select all 4 items before completing.';

  @override
  String get morningCheckinToastSuccess => 'Check-in completed!';

  @override
  String get morningCheckinToastFailed => 'Failed to save check-in.';

  @override
  String get availabilityBusy => 'Busy';

  @override
  String get availabilityNormal => 'Normal';

  @override
  String get availabilityFree => 'Free';

  @override
  String get dailyReviewLoading => 'Loading today\'s data...';

  @override
  String get dailyReviewError => 'Unable to load data';

  @override
  String get dailyReviewMissing =>
      'Please complete the required information before continuing.';

  @override
  String get dailyReviewSuccess => 'Today\'s review saved!';

  @override
  String get dailyReviewFailed => 'Unable to save review. Please try again.';

  @override
  String get dailyReviewPageTitle => 'Daily Review';

  @override
  String get dailyReviewHeaderTitle => 'Daily Review';

  @override
  String get dailyReviewHeaderSubtitle =>
      'Reflect on today in a few seconds so AI can adjust tomorrow\'s quests.';

  @override
  String get dailyReviewSummaryTitle => 'Your Today';

  @override
  String get dailyReviewMoodLabel => 'How do you feel at the end of the day?';

  @override
  String get dailyReviewEnergyLabel => 'Your remaining energy?';

  @override
  String get dailyReviewSatisfactionLabel =>
      'How satisfied are you with today?';

  @override
  String get dailyReviewReflectionLabel => 'Anything memorable today?';

  @override
  String get dailyReviewPriorityLabel =>
      'What do you want to prioritize tomorrow?';

  @override
  String get dailyReviewReflectionHint =>
      'Example: Studied better today, but was a bit distracted...';

  @override
  String get dailyReviewSubmitText => 'Complete Review';

  @override
  String get dailyReviewUpdateText => 'Update Review';

  @override
  String get dailyReviewToastMissing =>
      'Please select mood, energy, satisfaction, and tomorrow\'s priority.';

  @override
  String get dailyReviewToastSuccess => 'Review saved!';

  @override
  String get dailyReviewToastFailed =>
      'Failed to save review. Please try again.';

  @override
  String get dailyReviewLinkToWeekly => 'View Weekly Report';

  @override
  String get dailyReviewSatisVeryLow => 'Very Dissatisfied';

  @override
  String get dailyReviewSatisLow => 'Dissatisfied';

  @override
  String get dailyReviewSatisNormal => 'Neutral';

  @override
  String get dailyReviewSatisHigh => 'Satisfied';

  @override
  String get dailyReviewSatisVeryHigh => 'Very Satisfied';

  @override
  String get dailyReviewSummaryCompleted => 'Completed';

  @override
  String get dailyReviewSummaryRate => 'Rate';

  @override
  String get dailyReviewSummarySkipped => 'Skipped';

  @override
  String get moodVeryBad => 'Very Bad';

  @override
  String get moodBad => 'Bad';

  @override
  String get moodNormal => 'Normal';

  @override
  String get moodGood => 'Good';

  @override
  String get moodVeryGood => 'Very Good';

  @override
  String get energyLow => 'Low';

  @override
  String get energyMedium => 'Medium';

  @override
  String get energyHigh => 'High';

  @override
  String get priorityLearning => 'Learning';

  @override
  String get priorityHealth => 'Health';

  @override
  String get priorityWork => 'Work';

  @override
  String get priorityHabit => 'Habit';

  @override
  String get priorityRest => 'Rest';

  @override
  String get weeklySummaryLoading => 'Loading weekly data...';

  @override
  String get weeklySummaryError => 'Unable to load data';

  @override
  String get weeklySummaryNoData => 'No data available';

  @override
  String get weeklySummaryPageTitle => 'Weekly Summary';

  @override
  String get weeklySummaryHeaderLabel => '◆ WEEKLY REPORT';

  @override
  String get weeklySummaryHeaderTitle => 'Weekly Summary';

  @override
  String get weeklySummaryHeaderDesc =>
      'Review this week\'s data and choose adjustments to apply for next week.';

  @override
  String get weeklySummaryStatsCompletion => 'Completed';

  @override
  String get weeklySummaryStatsExp => 'Weekly EXP';

  @override
  String get weeklySummaryStatsStreak => 'Streak';

  @override
  String get weeklySummaryStatsSnoozed => 'Snoozed';

  @override
  String get weeklySummaryStatsSkipped => 'Skipped';

  @override
  String get weeklySummaryStatsDailyReview => 'Daily Review';

  @override
  String get weeklySummaryChartTitle => 'Daily completion rate';

  @override
  String get weeklySummarySectionCompare => 'Compare to last week';

  @override
  String get weeklySummarySectionInsights => 'This week\'s highlights';

  @override
  String get weeklySummarySectionTopQuests => 'Most effective quests';

  @override
  String get weeklySummarySectionAdjust => 'Quests to adjust';

  @override
  String get weeklySummarySectionSuggestions => 'Suggestions for next week';

  @override
  String get weeklySummarySectionSchedule => 'Next week template';

  @override
  String get weeklySummaryScheduleTitle =>
      'If you apply suggestions, SoloQuest will prioritize:';

  @override
  String get weeklySummaryScheduleWeekday => 'Monday – Friday';

  @override
  String get weeklySummaryScheduleWeekend => 'Weekend';

  @override
  String get weeklySummaryProtectionText =>
      'SoloQuest only suggests adjustments. You can always toggle, edit manually, or skip all suggestions.';

  @override
  String get weeklySummaryCtaApply => 'Apply selected suggestions';

  @override
  String get weeklySummaryCtaManual => 'Edit manually';

  @override
  String get weeklySummaryCtaApplied => '✓ Applied';

  @override
  String get weeklySummaryLinkLogs => 'View detailed logs';

  @override
  String get weeklySummaryLinkRules => 'Quest rules';

  @override
  String get weeklySummaryLinkReminders => 'Edit reminders';

  @override
  String get weeklySummaryToastApplied => 'Suggestions applied successfully.';

  @override
  String get questDetailLoading => 'Loading quest...';

  @override
  String get questDetailError => 'Unable to load quest';

  @override
  String get questDetailNotFound => 'Quest not found';

  @override
  String get logsLoading => 'Loading logs...';

  @override
  String get logsError => 'Unable to load logs';

  @override
  String get logsPageTitle => 'Logs';

  @override
  String get logsSectionTitle => 'Timeline';

  @override
  String get logsEmptyTitle => 'No logs for this day';

  @override
  String get logsEmptyMessage =>
      'Complete quests or check-in to start recording your journey.';

  @override
  String get logsHomeButton => 'Go to Home';

  @override
  String get logsDetailTitle => 'Log Details';

  @override
  String get logsViewQuest => 'View Quest';

  @override
  String get logsFilterAll => 'All';

  @override
  String get logsFilterCompleted => 'Completed';

  @override
  String get logsFilterSkipped => 'Skipped';

  @override
  String get logsFilterSnoozed => 'Snoozed';

  @override
  String get logsFilterCheckin => 'Check-in';

  @override
  String get logsFilterReview => 'Review';

  @override
  String get logsFilterReward => 'Reward';

  @override
  String get logsFilterLevelUp => 'Level Up';

  @override
  String get logsFilterRoadmap => 'Roadmap';

  @override
  String get logsFilterRoadmapStep => 'Roadmap Step';

  @override
  String get logsFilterRoadmapCompleted => 'Roadmap Done';

  @override
  String get logsToday => 'Today';

  @override
  String get logsYesterday => 'Yesterday';

  @override
  String get logsSummaryTitle => 'Today\'s Activity';

  @override
  String get logsSelectDate => 'Select Date';

  @override
  String get logsClearFilter => 'Clear Filter';

  @override
  String get logsSummaryActivities => 'Activities';

  @override
  String get logsSummaryCompleted => 'Completed';

  @override
  String get logsSummarySkipped => 'Skipped';

  @override
  String logsTimelineCount(Object count) {
    return '$count activities';
  }

  @override
  String get logsHeaderTitle => 'Personal Log';

  @override
  String get logsHeaderSubtitle => 'Track your behaviors, quests, and emotions';

  @override
  String get logsDetailTypeLabel => 'Type';

  @override
  String get logsDetailDescLabel => 'Description';

  @override
  String get logsDetailPointsLabel => 'Points';

  @override
  String logsDetailPointsValue(Object points) {
    return '$points pts';
  }

  @override
  String get logsDetailMoodLabel => 'Mood';

  @override
  String get homeLoading => 'Loading data...';

  @override
  String get homeError => 'Unable to load today\'s data';

  @override
  String get homeQuestStarted => 'Started';

  @override
  String get homeQuestCompleted => 'Quest completed';

  @override
  String get homeQuestSnoozed => 'Quest snoozed';

  @override
  String get homeQuestSkipped => 'Quest skipped';

  @override
  String get homeQuestStartError => 'Unable to start quest';

  @override
  String get homeQuestCompleteError => 'Unable to complete quest';

  @override
  String get homeQuestSnoozeError => 'Unable to snooze quest';

  @override
  String get homeQuestSkipError => 'Unable to skip quest';

  @override
  String get homeQuestReasonTitle => 'Why does this quest appear?';

  @override
  String get homeQuestReasonDefault =>
      'This quest is suggested based on your schedule and learning paths today.';

  @override
  String get onboardingValidation =>
      'Please complete the required information before continuing.';

  @override
  String get onboardingComplete => 'Start your first day with SoloQuest.';

  @override
  String get onboardingCompleteError => 'Please try again.';

  @override
  String get onboardingProgressLabel => 'Step';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingWelcomeTitle => 'Set Up Your Journey';

  @override
  String get onboardingWelcomeSubtitle =>
      'SoloQuest will create personalized quests from your essential setup data. This flow has 5 setup sections.';

  @override
  String get onboardingWelcomeHint =>
      'Takes about 2 minutes. You can adjust this later.';

  @override
  String get onboardingWelcomeStart => 'Start setup';

  @override
  String onboardingWelcomeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get onboardingWelcomeStep1 => 'Personal info';

  @override
  String get onboardingWelcomeStep2 => 'Work & schedule';

  @override
  String get onboardingWelcomeStep3 => 'Health & fitness';

  @override
  String get onboardingWelcomeStep4 => 'Personal goals';

  @override
  String get onboardingWelcomeStep5 => 'Daily schedule';

  @override
  String get onboardingWelcomeStep6 => 'Reminders';

  @override
  String get onboardingWelcomeStep7 => 'Rewards';

  @override
  String get onboardingStep1Title => 'Personal Info';

  @override
  String get onboardingStep1Subtitle =>
      'The system needs basic data to calculate suitable quests';

  @override
  String get onboardingStep1NameLabel => 'Display Name';

  @override
  String get onboardingStep1NameHint => 'Enter your name';

  @override
  String get onboardingStep1AgeLabel => 'Age';

  @override
  String get onboardingStep1AgeHint => '25';

  @override
  String get onboardingStep1AgeSuffix => ' years old';

  @override
  String get onboardingStep1GenderLabel => 'Gender';

  @override
  String get onboardingStep1GenderMale => 'Male';

  @override
  String get onboardingStep1GenderFemale => 'Female';

  @override
  String get onboardingStep1GenderOther => 'Other';

  @override
  String get onboardingStep1HeightLabel => 'Height';

  @override
  String get onboardingStep1HeightHint => '170';

  @override
  String get onboardingStep1HeightSuffix => ' cm';

  @override
  String get onboardingStep1WeightLabel => 'Weight';

  @override
  String get onboardingStep1WeightHint => '70';

  @override
  String get onboardingStep1WeightSuffix => ' kg';

  @override
  String get onboardingStep1SystemNote =>
      '[ SYSTEM ] Profile data is encrypted. Only used for quest optimization.';

  @override
  String get onboardingStep2Title => 'Work & Study';

  @override
  String get onboardingStep2Subtitle =>
      'The system needs to know your work schedule to arrange quests at suitable times';

  @override
  String get onboardingStep2MainActivityLabel => 'What Are You Doing?';

  @override
  String get onboardingStep2WorkScheduleLabel => 'Work / Study Schedule';

  @override
  String get onboardingStep2WorkStartTimeLabel => 'Start time';

  @override
  String get onboardingStep2WorkEndTimeLabel => 'End time';

  @override
  String get onboardingStep2FreeTimeLabel => 'Free Time';

  @override
  String get onboardingStep2SystemNote =>
      '[ SYSTEM ] Quests will not be scheduled during your work hours';

  @override
  String get onboardingStep2ActivityDeveloper => 'Software Engineer';

  @override
  String get onboardingStep2ActivityStudent => 'Student';

  @override
  String get onboardingStep2ActivityOffice => 'Office Worker';

  @override
  String get onboardingStep2ActivityFreelancer => 'Freelancer';

  @override
  String get onboardingStep2ActivityOther => 'Other';

  @override
  String get onboardingStep2ScheduleWeekday => 'Mon–Fri';

  @override
  String get onboardingStep2ScheduleMonSat => 'Mon–Sat';

  @override
  String get onboardingStep2ScheduleFlexible => 'Flexible';

  @override
  String get onboardingStep2ScheduleNight => 'Night Shift';

  @override
  String get onboardingStep2ScheduleHelper =>
      'This is only the initial schedule. You can adjust details later in the Routine section.';

  @override
  String get onboardingStep2FreeTimeEarlyMorning => 'Early Morning (5–7 AM)';

  @override
  String get onboardingStep2FreeTimeNoon => 'Lunch Break';

  @override
  String get onboardingStep2FreeTimeAfterWork => 'After Work';

  @override
  String get onboardingStep2FreeTimeEvening => 'Evening (8–11 PM)';

  @override
  String get onboardingStep3Title => 'Health & Activity';

  @override
  String get onboardingStep3Subtitle =>
      'The system needs to evaluate your status to create manageable quests';

  @override
  String get onboardingStep3ActivityLevelLabel => 'Current Activity Level';

  @override
  String get onboardingStep3LastWorkoutLabel => 'Last Workout';

  @override
  String get onboardingStep3HealthLimitationsLabel => 'Any Limitations?';

  @override
  String get onboardingStep3SystemNote =>
      '[ SYSTEM ] Movement quests will start at a level suitable for you';

  @override
  String get onboardingStep3ActivityLevelLittle => 'Very Little';

  @override
  String get onboardingStep3ActivityLevelLittleDesc =>
      'Almost no exercise, sitting a lot';

  @override
  String get onboardingStep3ActivityLevelOccasional => 'Occasionally';

  @override
  String get onboardingStep3ActivityLevelOccasionalDesc =>
      'Light walking, active 1-2 times/week';

  @override
  String get onboardingStep3ActivityLevelRegular => 'Regularly';

  @override
  String get onboardingStep3ActivityLevelRegularDesc =>
      'Workout 3-5 times/week';

  @override
  String get onboardingStep3LastWorkoutToday => 'Today';

  @override
  String get onboardingStep3LastWorkoutWeek => 'This Week';

  @override
  String get onboardingStep3LastWorkoutMonth => '1 Month Ago';

  @override
  String get onboardingStep3LastWorkoutLonger => 'Longer';

  @override
  String get onboardingStep3LimitationBackPain => 'Back Pain';

  @override
  String get onboardingStep3LimitationEyeStrain => 'Eye Strain';

  @override
  String get onboardingStep3LimitationLowEnergy => 'Low Energy';

  @override
  String get onboardingStep3LimitationBusy => 'Busy';

  @override
  String get onboardingStep3LimitationNone => 'None';

  @override
  String get onboardingStep4Title => 'Set Goals';

  @override
  String get onboardingStep4Subtitle =>
      'Select areas you want to improve. The system will prioritize them in daily quests.';

  @override
  String get onboardingStep4MainGoalsLabel => 'Main Goals';

  @override
  String get onboardingStep4SystemNote =>
      '[ SYSTEM ] Goals can be adjusted at any time from settings';

  @override
  String get onboardingGoalWater => 'Drink Water';

  @override
  String get onboardingGoalWaterDesc =>
      'Build habit of drinking water regularly';

  @override
  String get onboardingGoalFitness => 'Exercise';

  @override
  String get onboardingGoalFitnessDesc => 'Move and exercise daily';

  @override
  String get onboardingGoalLearning => 'Learning';

  @override
  String get onboardingGoalLearningDesc =>
      'Spend time studying and building skills';

  @override
  String get onboardingGoalMindfulness => 'Mindfulness';

  @override
  String get onboardingGoalMindfulnessDesc => 'Meditate and manage stress';

  @override
  String get onboardingGoalSleep => 'Better Sleep';

  @override
  String get onboardingGoalSleepDesc => 'Better sleep habits';

  @override
  String get onboardingGoalFocus => 'Better Focus';

  @override
  String get onboardingGoalFocusDesc =>
      'Reduce distractions, increase efficiency';

  @override
  String get onboardingGoalWeight => 'Weight Loss';

  @override
  String get onboardingGoalWeightDesc => 'Healthy weight management';

  @override
  String get onboardingGoalDiscipline => 'More Discipline';

  @override
  String get onboardingGoalDisciplineDesc => 'Build habits and routines';

  @override
  String get onboardingStep5Title => 'Daily Routine';

  @override
  String get onboardingStep5Subtitle =>
      'The system needs to know your routine to schedule quests on time';

  @override
  String get onboardingStep5WakeUpLabel => 'Wake-up Time';

  @override
  String get onboardingStep5TargetSleepLabel => 'Target Sleep Time';

  @override
  String get onboardingStep5FreeTimeRangeLabel => 'Free Time Blocks';

  @override
  String get onboardingStep5FromLabel => 'From';

  @override
  String get onboardingStep5ToLabel => 'To';

  @override
  String get onboardingStep5LearningTimeLabel => 'Preferred Learning Time';

  @override
  String get onboardingStep5MovementTimeLabel => 'Preferred Workout Time';

  @override
  String get onboardingStep5SystemNote =>
      '[ SYSTEM ] Quests will be scheduled in the time ranges you select';

  @override
  String get onboardingTimeEarlyMorning => 'Morning';

  @override
  String get onboardingTimeNoon => 'Lunch Break';

  @override
  String get onboardingTimeEvening => 'Evening';

  @override
  String get onboardingTimeBeforeSleep => 'Before Sleep';

  @override
  String get onboardingTimeAfterWork => 'After Work';

  @override
  String get onboardingTimeEveningGeneral => 'Evening';

  @override
  String get onboardingStep6Title => 'Reminder Settings';

  @override
  String get onboardingStep6Subtitle =>
      'Customize reminder frequency so the system fits your lifestyle';

  @override
  String get onboardingStep6BreakQuestLabel => 'Break Quest — Take a Break';

  @override
  String get onboardingStep6BreakQuestDesc =>
      'Remind you to look away from the screen after an interval';

  @override
  String onboardingStep6BreakIntervalOpt(Object interval) {
    return 'Every $interval minutes';
  }

  @override
  String get onboardingStep6BreakDurationLabel => 'Break Duration';

  @override
  String onboardingStep6DurationOpt(Object duration) {
    return '$duration minutes';
  }

  @override
  String get onboardingStep6WaterQuestLabel => 'Water Quest — Hydration';

  @override
  String get onboardingStep6WaterQuestDesc => 'Hydration reminder mode';

  @override
  String get onboardingStep6WaterQuestNote =>
      'Random: remind every 60-120 minutes during active hours';

  @override
  String get onboardingStep6QuietAfterLabel => 'Do Not Remind After';

  @override
  String get onboardingStep6QuietAfterNote =>
      'The system will not send notifications after this hour';

  @override
  String get onboardingStep6SystemNote =>
      '[ SYSTEM ] You can change this at any time in settings';

  @override
  String get onboardingStep6WaterModeFixed => 'Fixed';

  @override
  String get onboardingStep6WaterModeRandom => 'Random';

  @override
  String get onboardingStep7Title => 'Self-Rewards';

  @override
  String get onboardingStep7Subtitle =>
      'Choose rewards you want to unlock upon quest completion';

  @override
  String get onboardingStep7RewardsLabel =>
      'Which rewards would you like to use?';

  @override
  String get onboardingStep7SystemNote =>
      '[ SYSTEM ] Rewards will unlock when you earn enough EXP today';

  @override
  String get onboardingRewardGame => 'Play games for 45 minutes';

  @override
  String get onboardingRewardGameDesc => 'Unlock gaming time';

  @override
  String get onboardingRewardMovie => 'Watch 1 movie episode';

  @override
  String get onboardingRewardMovieDesc => 'Unlock entertainment time';

  @override
  String get onboardingRewardRest => 'Rest for 30 minutes';

  @override
  String get onboardingRewardRestDesc => 'Relaxing time doing nothing';

  @override
  String get onboardingRewardSocial => 'Social media for 20 minutes';

  @override
  String get onboardingRewardSocialDesc => 'Unlock social media time';

  @override
  String get onboardingRewardFood => 'Eat favorite food';

  @override
  String get onboardingRewardFoodDesc => 'Treat yourself to a nice meal';

  @override
  String get onboardingRewardCustom => 'Create custom reward';

  @override
  String get onboardingRewardCustomDesc => 'Customize your own reward';

  @override
  String get onboardingStep8Title => 'Profile Ready!';

  @override
  String get onboardingStep8Subtitle =>
      'Profile created successfully. Your first quest will be generated now.';

  @override
  String get onboardingStep8StartCheckin => 'Start today\'s check-in';

  @override
  String get onboardingStep8SummaryTitle => 'Profile Summary';

  @override
  String get onboardingStep8PreviewTitle => 'Sample Quest Schedule';

  @override
  String get onboardingStep8LabelName => 'Name';

  @override
  String get onboardingStep8LabelWork => 'Work';

  @override
  String get onboardingStep8LabelSchedule => 'Schedule';

  @override
  String get onboardingStep8LabelGoals => 'Goals';

  @override
  String get onboardingStep8LabelSleep => 'Sleep';

  @override
  String get onboardingStep8LabelBreak => 'Break';

  @override
  String get onboardingStep8LabelRewards => 'Rewards';

  @override
  String get onboardingStep8QuestWater => 'Drink 250ml water';

  @override
  String get onboardingStep8QuestBreak => 'Take a 5-minute break';

  @override
  String get onboardingStep8QuestWalk => 'Walk for 15 minutes';

  @override
  String get onboardingStep8QuestStudy => 'Learn Docker basics for 20 minutes';

  @override
  String get onboardingStep8QuestSleep => 'Put down phone for 15 minutes';

  @override
  String get scheduleEditorDeleteConfirm => 'Delete this time block?';

  @override
  String get scheduleEditorDeleteMessage => 'Are you sure you want to delete?';

  @override
  String get scheduleEditorPageTitle => 'Daily Schedule';

  @override
  String get scheduleEditorPageSubtitle =>
      'Let SoloQuest know when you work, study, and rest.';

  @override
  String get scheduleEditorSectionTitle => 'Time Blocks';

  @override
  String get scheduleEditorAddBlockButton => 'Add time block';

  @override
  String get scheduleEditorEmptyTitle => 'No schedule yet';

  @override
  String get scheduleEditorEmptyMessage =>
      'Complete onboarding or add time blocks so SoloQuest knows when you are busy.';

  @override
  String get scheduleEditorFormTitleAdd => 'Add time block';

  @override
  String get scheduleEditorFormTitleCreate => 'Add time block';

  @override
  String get scheduleEditorFormTitleEdit => 'Edit time block';

  @override
  String get scheduleEditorLabelTitle => 'Title';

  @override
  String get scheduleEditorTitlePlaceholder =>
      'For example: Work, Study Flutter...';

  @override
  String get scheduleEditorLabelType => 'Schedule type';

  @override
  String get scheduleEditorLabelTime => 'Time';

  @override
  String get scheduleEditorLabelStartTime => 'Start time';

  @override
  String get scheduleEditorLabelEndTime => 'End time';

  @override
  String get scheduleEditorLabelDays => 'Days';

  @override
  String get scheduleEditorLabelStatus => 'Status';

  @override
  String get scheduleEditorLabelWeekdays => 'Days';

  @override
  String get scheduleEditorLabelFlexible => 'Flexible';

  @override
  String get scheduleEditorBadgeBusy => 'Busy';

  @override
  String get scheduleEditorBadgeFree => 'Free';

  @override
  String get scheduleEditorBadgeFixed => 'Fixed';

  @override
  String get scheduleEditorBadgeFlexible => 'Flexible';

  @override
  String get scheduleEditorSummaryTotal => 'Total blocks';

  @override
  String get scheduleEditorBusyDescription =>
      'Mark this as busy time so SoloQuest avoids creating quests here.';

  @override
  String get scheduleEditorFlexibleDescription =>
      'Allow this time block to be adjusted flexibly.';

  @override
  String get scheduleEditorButtonSave => 'Save';

  @override
  String get scheduleEditorButtonCancel => 'Cancel';

  @override
  String get scheduleEditorButtonDelete => 'Delete';

  @override
  String get scheduleEditorDeleteTitle => 'Delete time block?';

  @override
  String get scheduleEditorDeleteMsg =>
      'This time block will be removed from your routine schedule.';

  @override
  String get scheduleEditorDeleteConfirmTitle => 'Delete time block?';

  @override
  String get scheduleEditorDeleteConfirmMessage =>
      'This time block will be removed from your routine schedule.';

  @override
  String get scheduleEditorDeleteConfirmAction => 'Delete';

  @override
  String get scheduleEditorToastAddSuccess => 'Time block added';

  @override
  String get scheduleEditorToastAddFailed => 'Failed to add time block';

  @override
  String get scheduleEditorToastUpdateSuccess => 'Time block updated';

  @override
  String get scheduleEditorToastUpdateFailed => 'Failed to update time block';

  @override
  String get scheduleEditorToastDeleteSuccess => 'Time block deleted';

  @override
  String get scheduleEditorToastDeleteFailed => 'Failed to delete time block';

  @override
  String get scheduleEditorErrorTitleRequired => 'Please enter a title';

  @override
  String get scheduleEditorErrorTimeRequired => 'Please select time';

  @override
  String get scheduleEditorErrorWeekdaysRequired =>
      'Please select at least 1 day';

  @override
  String get scheduleEditorTypeSchool => 'School';

  @override
  String get scheduleEditorTypeWork => 'Work';

  @override
  String get scheduleEditorTypeCommute => 'Commute';

  @override
  String get scheduleEditorTypeMeal => 'Meal';

  @override
  String get scheduleEditorTypeSleep => 'Sleep';

  @override
  String get scheduleEditorTypeStudy => 'Study';

  @override
  String get scheduleEditorTypePersonal => 'Personal';

  @override
  String get scheduleEditorTypeBusy => 'Busy';

  @override
  String get scheduleEditorTypeFree => 'Free Time';

  @override
  String get scheduleEditorTypeOther => 'Other';

  @override
  String get scheduleEditorWeekdayMon => 'Mon';

  @override
  String get scheduleEditorWeekdayTue => 'Tue';

  @override
  String get scheduleEditorWeekdayWed => 'Wed';

  @override
  String get scheduleEditorWeekdayThu => 'Thu';

  @override
  String get scheduleEditorWeekdayFri => 'Fri';

  @override
  String get scheduleEditorWeekdaySat => 'Sat';

  @override
  String get scheduleEditorWeekdaySun => 'Sun';

  @override
  String get scheduleEditorLoading => 'Loading schedule...';

  @override
  String get scheduleEditorError => 'Unable to load schedule';

  @override
  String get learningGoalDeleteConfirm => 'Delete this learning path?';

  @override
  String get learningGoalDeleteMessage =>
      'Are you sure you want to delete this learning path?';

  @override
  String get questRuleResetConfirm => 'Reset to default rules?';

  @override
  String get questRuleResetMessage => 'All rules will be reset to default.';

  @override
  String get lgPageTitle => 'Learning Roadmap';

  @override
  String get lgPageSubtitle =>
      'Choose skills you want to improve. The system will create small daily learning quests from your learning paths.';

  @override
  String get lgSectionTitle => 'Learning Paths';

  @override
  String get lgAddGoalButton => 'Add Learning Path';

  @override
  String get lgEmptyTitle => 'No learning paths yet';

  @override
  String get lgEmptyMessage =>
      'Create your first learning path and SoloQuest will turn it into small daily quests.';

  @override
  String get lgFormTitleAdd => 'Add Learning Path';

  @override
  String get lgFormTitleEdit => 'Edit Learning Path';

  @override
  String get lgLabelTitle => 'Learning path name';

  @override
  String get lgLabelDescription => 'Description';

  @override
  String get lgLabelCategory => 'Category';

  @override
  String get lgLabelTargetMinutes => 'Minutes per day';

  @override
  String get lgLabelDeadline => 'Deadline';

  @override
  String get lgLabelActive => 'Active';

  @override
  String get lgProgressSheetTitle => 'Update Progress';

  @override
  String get lgProgressSheetButton => 'Update';

  @override
  String get lgFilterAll => 'All';

  @override
  String get lgStatusActive => 'Active';

  @override
  String get lgStatusCompleted => 'Completed';

  @override
  String get lgStatusInactive => 'Paused';

  @override
  String get lgDeleteConfirmTitle => 'Delete learning path?';

  @override
  String get lgDeleteConfirmMessage =>
      'Are you sure you want to delete this learning path?';

  @override
  String get lgToastAddSuccess => 'Learning path added';

  @override
  String get lgToastAddFailed => 'Unable to add learning path';

  @override
  String get lgToastUpdateSuccess => 'Learning path updated';

  @override
  String get lgToastUpdateFailed => 'Unable to update learning path';

  @override
  String get lgToastDeleteSuccess => 'Learning path deleted';

  @override
  String get lgToastDeleteFailed => 'Unable to delete learning path';

  @override
  String get lgToastProgressSuccess => 'Progress updated';

  @override
  String get lgToastProgressFailed => 'Unable to update progress';

  @override
  String get lgErrorTitleRequired => 'Please enter a learning path name';

  @override
  String get lgErrorCategoryRequired => 'Please select a category';

  @override
  String get lgErrorTargetMinutesInvalid => 'Minutes must be greater than 0';

  @override
  String get lgErrorLoadFailed => 'Unable to load learning paths';

  @override
  String get lgSummaryTotal => 'Total';

  @override
  String get lgSummaryActive => 'Active';

  @override
  String get lgSummaryCompleted => 'Completed';

  @override
  String get lgSummaryAvgProgress => 'Avg. Progress';

  @override
  String get lgCardProgress => 'Progress';

  @override
  String get lgCardEdit => 'Edit';

  @override
  String get lgCardDelete => 'Delete';

  @override
  String get lgCardMinutesPerDay => 'min/day';

  @override
  String get lgCardFormTitlePlaceholder => 'e.g. Learn Flutter Architecture';

  @override
  String get lgCardFormDescPlaceholder =>
      'Detailed learning path description...';

  @override
  String get lgCardFormCategoryPlaceholder => 'e.g. Flutter, Dart, English...';

  @override
  String get lgCardFormNoDeadline => 'No deadline';

  @override
  String get lgCardFormSubmitAdd => 'Add';

  @override
  String get lgCardFormSubmitUpdate => 'Update';

  @override
  String get lgActiveMainBadge => 'Active';

  @override
  String lgActiveWeek(Object week) {
    return 'Week $week';
  }

  @override
  String get lgActiveSynced => 'Synced to Today\'s Quests';

  @override
  String get lgActiveWeeklyProgress => 'Weekly Progress';

  @override
  String get lgActiveViewRoadmap => 'View Roadmap';

  @override
  String get lgActiveSync => 'Sync';

  @override
  String get lgActivePause => 'Pause';

  @override
  String get aiTitle => 'Not sure what to learn?';

  @override
  String get aiDescription =>
      'Based on your profile, work, and learning paths, the system can suggest suitable skills.';

  @override
  String get aiLoading => 'Analyzing profile...';

  @override
  String get aiButton => 'Suggest based on profile';

  @override
  String get aiSkillSelected => 'Selected';

  @override
  String get aiSkillSelect => 'Select learning path';

  @override
  String get aiSkillDifficultyEasy => 'Easy';

  @override
  String get aiSkillDifficultyMedium => 'Medium';

  @override
  String get aiSkillDifficultyHard => 'Hard';

  @override
  String get syncSheetTitle => 'Sync to daily quests?';

  @override
  String get syncSheetDescription =>
      'The system will automatically take the next lesson in your roadmap to create a daily Learning Quest.';

  @override
  String get syncFrequency => 'Frequency';

  @override
  String get syncFrequencyDaily => 'Every day';

  @override
  String get syncFrequencyMonWedFri => 'Mon, Wed, Fri';

  @override
  String get syncFrequencyWeekend => 'Weekends';

  @override
  String get syncFrequencyCustom => 'Custom';

  @override
  String get syncDuration => 'Duration';

  @override
  String get syncDuration10 => '10 min';

  @override
  String get syncDuration15 => '15 min';

  @override
  String get syncDuration20 => '20 min';

  @override
  String get syncDuration30 => '30 min';

  @override
  String get syncTimeSlot => 'Time slot';

  @override
  String get syncTimeSlotMorning => 'Morning';

  @override
  String get syncTimeSlotNoon => 'Noon';

  @override
  String get syncTimeSlotEvening => 'Evening';

  @override
  String get syncTimeSlotCustom => 'Custom';

  @override
  String get syncAutoToggle => 'Auto-add to Today\'s Quests';

  @override
  String get syncAutoToggleSubtitle => 'Learning Quest will appear every day';

  @override
  String get syncConfirm => 'Sync to daily quests';

  @override
  String get syncCancel => 'Later';

  @override
  String get lrPageTitle => 'Learning Roadmap';

  @override
  String get lrPageSubtitle => 'Track small steps on your learning journey.';

  @override
  String get lrSectionTitle => 'Roadmap templates';

  @override
  String get lrSummaryTitle => 'Overview';

  @override
  String get lrSummaryTotalRoadmaps => 'Total paths';

  @override
  String get lrSummaryCompleted => 'Completed';

  @override
  String get lrSummarySteps => 'Steps';

  @override
  String get lrSummaryAvgProgress => 'Avg. progress';

  @override
  String get lrStatusLearning => 'Tracking';

  @override
  String get lrStatusCompleted => 'Completed';

  @override
  String get lrViewRoadmapButton => 'View Roadmap';

  @override
  String get lrDetailSheetTitle => 'Roadmap Details';

  @override
  String get lrDetailProgressLabel => 'Progress';

  @override
  String get lrDetailStepsLabel => 'Learning Steps';

  @override
  String get lrStepEstimatedSuffix => 'min';

  @override
  String get lrStepCompletedLabel => 'Mark as learned';

  @override
  String get lrStepUnmarkLabel => 'Unmark';

  @override
  String get lrEmptyTitle => 'No learning roadmaps yet';

  @override
  String get lrEmptyMessage =>
      'You can choose a roadmap template to start tracking each learning step.';

  @override
  String get lrEmptyButton => 'Choose template';

  @override
  String get lrToastStepCompleted => 'Step completed';

  @override
  String get lrToastStepUpdated => 'Step updated';

  @override
  String get lrToastToggleError => 'Unable to update step';

  @override
  String get lrErrorLoadFailed => 'Unable to load learning roadmap';

  @override
  String get lrLoadingMessage => 'Loading learning roadmap...';

  @override
  String get lrDetailCloseButton => 'Close';

  @override
  String lrCardSteps(Object completed, Object total) {
    return '$completed/$total steps';
  }

  @override
  String lrCardMinutes(Object minutes) {
    return '$minutes min';
  }

  @override
  String get lrDetailSteps => 'steps';

  @override
  String lrStepEstimated(Object minutes) {
    return '${minutes}m';
  }

  @override
  String get lrLocalProgressHint =>
      'Preview version: roadmap progress is only saved temporarily on this device.';

  @override
  String get lrOverviewTopics => 'Topics';

  @override
  String get lrOverviewDone => 'Done';

  @override
  String get lrOverviewRemaining => 'Remaining';

  @override
  String get lrOverviewTotalProgress => 'Overall Progress';

  @override
  String lrOverviewProgressCount(Object completed, Object total) {
    return '$completed/$total topics';
  }

  @override
  String get lrModuleFoundation => 'Foundation';

  @override
  String get lrModulePractice => 'Practice';

  @override
  String get lrModuleApplication => 'Application';

  @override
  String get lrModuleAdvanced => 'Advanced';

  @override
  String get lrModuleProject => 'Real Project';

  @override
  String lrModuleFallback(Object index) {
    return 'Topic Group $index';
  }

  @override
  String get lrTodayPlanTitle => 'Today\'s Learning Plan';

  @override
  String get lrTodayPlanDone => 'Today\'s learning plan completed!';

  @override
  String lrTodayPlanStats(Object completed, Object minutes) {
    return '$completed lessons · $minutes min';
  }

  @override
  String get lrTodayPlanStudyMore => 'Study more today';

  @override
  String lrTodayPlanNextLesson(Object minutes) {
    return 'Next lesson · $minutes min';
  }

  @override
  String get lrTodayPlanStartLearning => 'Start Learning';

  @override
  String lrTodayPlanMinutesToday(Object minutes) {
    return '${minutes}m today';
  }

  @override
  String lrTodayPlanCompletedCount(Object count) {
    return '$count lessons done';
  }

  @override
  String get lrStudyMoreTitle => 'Study More Today';

  @override
  String get lrStudyMoreDescription =>
      'Choose extra study time. You can go beyond your daily plan.';

  @override
  String get lrStudyMoreDuration15 => '15 min';

  @override
  String get lrStudyMoreDuration25 => '25 min';

  @override
  String get lrStudyMoreDuration45 => '45 min';

  @override
  String get lrStudyMoreDuration60 => '60 min';

  @override
  String lrStudyMoreButton(Object duration) {
    return 'Study $duration';
  }

  @override
  String get lrStudyMoreViewProgress => 'View Progress';

  @override
  String get lrModuleLessonDone => 'Done';

  @override
  String get lrModuleLessonSelected => 'Selected';

  @override
  String get lrModuleLessonNotStarted => 'Not started';

  @override
  String get lsCompleteTitle => 'Lesson Completed!';

  @override
  String lsCompleteStats(Object completed, Object minutes) {
    return 'Today: $completed lessons · $minutes min';
  }

  @override
  String get lsCompleteNextLesson => 'Next Lesson';

  @override
  String get lsCompleteStop => 'Stop Here';

  @override
  String get lsCompleteExtra => 'Study 15 more min';

  @override
  String lsWeek(Object week) {
    return 'Week $week';
  }

  @override
  String lsMinutes(Object minutes) {
    return '$minutes min';
  }

  @override
  String get lsCompleted => 'Completed';

  @override
  String get lsLocked => 'Locked';

  @override
  String get lsLockedInfo => 'Complete the previous lesson to unlock this one.';

  @override
  String get lsCompletedInfo => 'This lesson has been completed.';

  @override
  String get lsExtraInfo =>
      'You\'ve completed today\'s plan. Study more to go further!';

  @override
  String get lsReadyInfo => 'Ready to start this lesson.';

  @override
  String get lsClose => 'Close';

  @override
  String get lsStart => 'Start Learning';

  @override
  String get lsStudyMore => 'Study This Lesson';

  @override
  String get lsMarkDone => 'Mark Complete';

  @override
  String get lsLater => 'Later';

  @override
  String get lqCompletedToday => 'Today\'s learning completed';

  @override
  String get lqChooseMoreTopics => 'Choose more topics';

  @override
  String lqTopicsCount(Object completed, Object total) {
    return '$completed/$total topics';
  }

  @override
  String get createRoadmapFab => 'Create new roadmap';

  @override
  String get createRoadmapTitle => 'Create new learning roadmap';

  @override
  String get createRoadmapSubtitle => 'Let AI know what you want to learn';

  @override
  String get createRoadmapSubtitleSuggestion => 'AI suggests roadmaps for you';

  @override
  String get roadmapPrefGoalLabel => 'What do you want to learn?';

  @override
  String get roadmapPrefGoalHint =>
      'e.g., State Management, Testing, Performance...';

  @override
  String get roadmapPrefCategoryLabel => 'Category';

  @override
  String get roadmapPrefDifficultyLabel => 'Difficulty';

  @override
  String get roadmapPrefDurationLabel => 'Max duration';

  @override
  String get roadmapPrefSubmit => 'Generate suggestions';

  @override
  String get roadmapDiffAny => 'Any';

  @override
  String get roadmapDiffAnyDesc => 'AI will choose the right level for you';

  @override
  String get roadmapDiffBeginner => 'Beginner';

  @override
  String get roadmapDiffBeginnerDesc => 'Start from fundamentals';

  @override
  String get roadmapDiffIntermediate => 'Intermediate';

  @override
  String get roadmapDiffIntermediateDesc => 'Already have basic knowledge';

  @override
  String get roadmapDiffAdvanced => 'Advanced';

  @override
  String get roadmapDiffAdvancedDesc => 'Challenge advanced skills';

  @override
  String get roadmapDurationAny => 'Any';

  @override
  String roadmapDurationHour(Object hours) {
    return '${hours}h';
  }

  @override
  String get roadmapSuggestionLoading => 'Analyzing your profile...';

  @override
  String get roadmapSuggestionEmpty => 'No suggestions';

  @override
  String get roadmapSuggestionEmptyDesc =>
      'No suitable roadmaps available.\nPlease try again later.';

  @override
  String get roadmapSuggestionCreate => 'Create this roadmap';

  @override
  String get roadmapSuggestionSelected => 'Selected';

  @override
  String roadmapCardSteps(Object steps) {
    return '$steps steps';
  }

  @override
  String roadmapCardMinutes(Object minutes) {
    return '~$minutes min';
  }

  @override
  String get reminderSettingsPageTitle => 'Reminder Settings';

  @override
  String get reminderSettingsPageSubtitle =>
      'Adjust when SoloQuest reminds you to drink water, rest, and study.';

  @override
  String get reminderSettingsSummaryTitle => 'Reminders Overview';

  @override
  String get reminderSettingsListTitle => 'Reminders List';

  @override
  String get reminderSettingsFilterAll => 'All';

  @override
  String get reminderSettingsFormTitle => 'Edit Reminder';

  @override
  String get reminderSettingsToastUpdateSuccess => 'Reminder updated';

  @override
  String get reminderSettingsToastUpdateFailed => 'Failed to update reminder';

  @override
  String get reminderSettingsToastToggleOn => 'Reminder enabled';

  @override
  String get reminderSettingsToastToggleOff => 'Reminder disabled';

  @override
  String get reminderSettingsToastToggleFailed =>
      'Failed to toggle reminder status';

  @override
  String get reminderSettingsLoading => 'Loading reminder settings...';

  @override
  String get reminderSettingsError => 'Unable to load reminder settings';

  @override
  String get reminderSettingsTimeStart => 'Start';

  @override
  String get reminderSettingsTimeEnd => 'End';

  @override
  String get reminderSettingsLogToggleOn => 'Enabled reminder';

  @override
  String get reminderSettingsLogToggleOff => 'Disabled reminder';

  @override
  String get reminderSettingsLogUpdate => 'Updated reminder';

  @override
  String get reminderTypeWater => 'Water';

  @override
  String get reminderTypeBreak => 'Break';

  @override
  String get reminderTypeMovement => 'Movement';

  @override
  String get reminderTypeLearning => 'Learning';

  @override
  String get reminderTypeSleep => 'Sleep';

  @override
  String get reminderTypeDailyReview => 'Daily Review';

  @override
  String get reminderTypeCustom => 'Custom';

  @override
  String get reminderFrequencyFixed => 'Fixed';

  @override
  String get reminderFrequencyInterval => 'Interval';

  @override
  String get reminderFrequencyRandom => 'Random';

  @override
  String get reminderFrequencySmart => 'Smart';

  @override
  String get reminderFrequencyFixedDesc => 'Remind at a fixed time.';

  @override
  String get reminderFrequencyIntervalDesc =>
      'Repeat reminder after an interval.';

  @override
  String get reminderFrequencyRandomDesc =>
      'Remind randomly within selected time range.';

  @override
  String get reminderFrequencySmartDesc =>
      'Automatically adjust based on your schedule and state.';

  @override
  String get reminderStatusEnabled => 'On';

  @override
  String get reminderStatusDisabled => 'Off';

  @override
  String get reminderFormFrequency => 'Frequency';

  @override
  String get reminderFormTimeWindow => 'Time range';

  @override
  String get reminderFormMinIntervalLabel =>
      'Min interval between reminders (minutes)';

  @override
  String get reminderFormMinIntervalPlaceholder => 'e.g., 90';

  @override
  String get reminderFormMaxPerDayLabel => 'Max reminders per day';

  @override
  String get reminderFormMaxPerDayPlaceholder => 'e.g., 8';

  @override
  String get reminderFormSmartTitle => 'AI Smart Reminders';

  @override
  String get reminderFormSmartSubtitle =>
      'Allow SoloQuest to auto-adjust based on schedule and state.';

  @override
  String get reminderFormSaveButton => 'Save settings';

  @override
  String get reminderFormErrorFixedTimeRequired =>
      'Please select a fixed reminder time';

  @override
  String get reminderFormErrorTimeRangeRequired =>
      'Please select a complete time range';

  @override
  String get reminderFormErrorIntervalInvalid =>
      'Interval minutes must be greater than 0';

  @override
  String get reminderFormErrorRandomRangeRequired =>
      'Please select start and end times for random reminders';

  @override
  String get reminderFormErrorMaxPerDayInvalid =>
      'Max per day must be greater than 0';

  @override
  String get reminderFormErrorSmartRequired => 'Smart reminder must be enabled';

  @override
  String get reminderTitleWater => 'Drink Water';

  @override
  String get reminderDescWater =>
      'Sip water regularly instead of single large targets.';

  @override
  String get reminderTitleBreak => 'Eye Rest & Break';

  @override
  String get reminderDescBreak => 'Take a short break after focused sessions.';

  @override
  String get reminderTitleMovement => 'Movement';

  @override
  String get reminderDescMovement =>
      'Stand up and move around after sitting for long.';

  @override
  String get reminderTitleLearning => 'Learning';

  @override
  String get reminderDescLearning => 'Remind you to study in the evening.';

  @override
  String get reminderTitleSleep => 'Prepare for Sleep';

  @override
  String get reminderDescSleep => 'Wind-down before your target bedtime.';

  @override
  String get reminderTitleReview => 'Daily Review';

  @override
  String get reminderDescReview => 'Reflect on your day and record progress.';

  @override
  String get reminderTitleCustom => 'Custom Reminder';

  @override
  String get reminderDescCustom => 'Personal reminder at your selected time.';

  @override
  String reminderCardInterval(Object minutes) {
    return 'Every $minutes mins';
  }

  @override
  String reminderCardMaxPerDay(Object max) {
    return 'Max $max times/day';
  }

  @override
  String get reminderCardEditButton => 'Edit';

  @override
  String get reminderCardSmartReminder => 'Smart reminder';

  @override
  String get reminderMetricTotal => 'Total reminders';

  @override
  String get reminderMetricEnabled => 'Enabled';

  @override
  String get reminderMetricDisabled => 'Disabled';

  @override
  String get reminderEmptyTitle => 'No Reminders Yet';

  @override
  String get reminderEmptyMessage =>
      'SoloQuest will use reminder settings to help you maintain your daily routine.';

  @override
  String get rewardsPageTitle => 'Achievements & Self-Rewards';

  @override
  String get rewardsHeaderTitle => 'Self-Rewards';

  @override
  String get rewardsHeaderSubtitle =>
      'Collect achievement points from quests to unlock reward ideas.';

  @override
  String get rewardsEmptyTitle => 'No self-rewards yet';

  @override
  String get rewardsEmptyMessage =>
      'Add self-rewards to keep yourself motivated.';

  @override
  String get rewardsEmptyAction => 'Add a self-reward';

  @override
  String get rewardsBalanceTitle => 'Achievement Points';

  @override
  String get rewardsPointsSubtitle => 'Earned from completed quests';

  @override
  String get rewardsAvailableLabel => 'Unlocked';

  @override
  String get rewardsClaimedLabel => 'Recorded';

  @override
  String get rewardsSectionTitle => 'Reward Ideas';

  @override
  String get rewardsBadgeSectionTitle => 'Achievement Badges';

  @override
  String get rewardsHistorySectionTitle => 'Reward History';

  @override
  String get rewardsCreateSectionTitle => 'Create Reward Idea';

  @override
  String get rewardsFilterAll => 'All';

  @override
  String get rewardsClaimDialogTitle => 'Record this reward?';

  @override
  String rewardsClaimDialogMessage(Object name) {
    return 'You\'ve reached the milestone to reward yourself: $name. Enjoy this reward as a way to recognize your effort.';
  }

  @override
  String get rewardsClaimDialogUnlockCost => 'Unlock cost';

  @override
  String get rewardsClaimDialogCurrentPoints => 'Current achievement points';

  @override
  String get rewardsClaimDialogDuration => 'Duration';

  @override
  String get rewardsClaimDialogType => 'Type';

  @override
  String get rewardsClaimDialogPoints => 'pts';

  @override
  String get rewardsClaimDialogMinutes => 'mins';

  @override
  String get rewardsClaimDialogConfirm => 'Record';

  @override
  String get rewardsClaimDialogCancel => 'Later';

  @override
  String get rewardsToastClaimed => 'Self-reward recorded!';

  @override
  String get rewardsToastNotEnough =>
      'Not enough achievement points to unlock this reward.';

  @override
  String get rewardsToastFailed => 'Failed to record self-reward';

  @override
  String get rewardsToastCreated => 'New reward suggestion created!';

  @override
  String get rewardsProtectionTitle => 'Sustainable self-reward. ';

  @override
  String get rewardsProtectionDesc =>
      'No progress lost on busy days. Streak Shield and light days available. No penalty for pausing quests.';

  @override
  String get rewardsLinkProgressLabel => 'Progress';

  @override
  String get rewardsLinkLogsLabel => 'Logs';

  @override
  String get rewardsLinkProfileLabel => 'Profile';

  @override
  String get rewardsBadgeUnlocked => 'Unlocked';

  @override
  String get rewardsBadgeNightLearner => '5 evenings';

  @override
  String get rewardsBadgeComeback => 'Comeback';

  @override
  String get rewardsBadgeWeeklyReview => 'Completed';

  @override
  String get rewardsBadgeMovementPro => '7 days';

  @override
  String rewardsHistoryClaimTitle(Object name) {
    return 'Claimed \"$name\"';
  }

  @override
  String rewardsHistoryUnlockTitle(Object name) {
    return 'Unlocked \"$name\"';
  }

  @override
  String get rewardsHistoryYesterday => 'Yesterday';

  @override
  String get rewardsHistoryWeekAgo => 'Last week';

  @override
  String rewardsHistoryMilestone(Object points) {
    return 'Reached $points points';
  }
}
