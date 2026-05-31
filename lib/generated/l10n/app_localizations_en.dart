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
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavLogs => 'Logs';

  @override
  String get bottomNavProgress => 'Progress';

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
  String get headerRewards => 'Rewards';

  @override
  String get headerProfile => 'Profile';

  @override
  String get loginTagline =>
      'Turn your personal goals into small daily quests.';

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
  String get loginPrototypeNote => '[ Prototype — mock auth ]';

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
  String get rewardsLoading => 'Loading rewards...';

  @override
  String get rewardsError => 'Unable to load rewards';

  @override
  String get rewardsNotEnough =>
      'Not enough reward points to claim this reward.';

  @override
  String get rewardsClaimed => 'Reward claimed successfully!';

  @override
  String get rewardsClaimFailed => 'Unable to claim reward';

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
  String get weeklySummaryLoading => 'Loading weekly data...';

  @override
  String get weeklySummaryError => 'Unable to load data';

  @override
  String get weeklySummaryNoData => 'No data available';

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
      'This quest is suggested based on your schedule and goals today.';

  @override
  String get onboardingValidation =>
      'Please complete the required information before continuing.';

  @override
  String get onboardingComplete => 'Start your first day with SoloQuest.';

  @override
  String get onboardingCompleteError => 'Please try again.';

  @override
  String get scheduleEditorDeleteConfirm => 'Delete this time block?';

  @override
  String get scheduleEditorDeleteMessage => 'Are you sure you want to delete?';

  @override
  String get learningGoalDeleteConfirm => 'Delete this goal?';

  @override
  String get learningGoalDeleteMessage =>
      'Are you sure you want to delete this learning goal?';

  @override
  String get questRuleResetConfirm => 'Reset to default rules?';

  @override
  String get questRuleResetMessage => 'All rules will be reset to default.';
}
