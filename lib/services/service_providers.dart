import 'quest_service.dart';
import 'log_service.dart';
import 'progress_service.dart';
import 'reward_service.dart';
import 'daily_checkin_service.dart';
import 'daily_review_service.dart';
import 'schedule_service.dart';
import 'learning_service.dart';
import 'reminder_service.dart';
import 'quest_rule_service.dart';
import 'local_storage_service.dart';
import 'profile_service.dart';
import 'weekly_summary_service.dart';
import 'auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final questServiceProvider = Provider<QuestService>((ref) => QuestService());
final logServiceProvider = Provider<LogService>((ref) => LogService());
final progressServiceProvider = Provider<ProgressService>(
  (ref) => ProgressService(),
);
final rewardServiceProvider = Provider<RewardService>((ref) => RewardService());
final dailyCheckinServiceProvider = Provider<DailyCheckinService>(
  (ref) => DailyCheckinService(),
);
final scheduleServiceProvider = Provider<ScheduleService>(
  (ref) => ScheduleService(),
);
final learningServiceProvider = Provider<LearningService>(
  (ref) => LearningService(),
);
final reminderServiceProvider = Provider<ReminderService>(
  (ref) => ReminderService(),
);
final questRuleServiceProvider = Provider<QuestRuleService>(
  (ref) => QuestRuleService(),
);
final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) => LocalStorageService(),
);
final profileServiceProvider = Provider<ProfileService>(
  (ref) => ProfileService(),
);
final dailyReviewServiceProvider = Provider<DailyReviewService>(
  (ref) => DailyReviewService(),
);
final weeklySummaryServiceProvider = Provider<WeeklySummaryService>(
  (ref) => WeeklySummaryService(),
);
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    localStorageService: ref.read(localStorageServiceProvider),
  );
});
