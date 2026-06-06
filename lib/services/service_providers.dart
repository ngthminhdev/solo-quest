import 'quest_service.dart';
import 'log_service.dart';
import 'progress_service.dart';
import 'daily_checkin_service.dart';
import 'daily_review_service.dart';
import 'schedule_service.dart';
import 'learning_service.dart';
import 'learning_quest_service.dart';
import 'reminder_service.dart';
import 'quest_rule_service.dart';
import 'local_storage_service.dart';
import 'profile_service.dart';
import 'weekly_summary_service.dart';
import 'auth_service.dart';
import 'auth_session_resolver.dart';
import 'auth_token_storage.dart';
import 'google_auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api/services/quest_settings_api_service.dart';
import '../core/api/services/reminder_settings_api_service.dart';
import '../core/api/services/weekly_summary_api_service.dart';
import '../core/api/services/schedule_api_service.dart';
import '../core/api/services/learning_roadmap_api_service.dart';
import '../core/api/services/user_api_service.dart';

final questServiceProvider = Provider<QuestService>((ref) => QuestService());
final logServiceProvider = Provider<LogService>((ref) => LogService());
final progressServiceProvider = Provider<ProgressService>(
  (ref) => ProgressService(),
);
final dailyCheckinServiceProvider = Provider<DailyCheckinService>(
  (ref) => DailyCheckinService(),
);
final scheduleApiServiceProvider = Provider<ScheduleApiService>(
  (ref) => ScheduleApiService(),
);
final scheduleServiceProvider = Provider<ScheduleService>(
  (ref) => ScheduleService(apiService: ref.read(scheduleApiServiceProvider)),
);
final learningRoadmapApiServiceProvider = Provider<LearningRoadmapApiService>(
  (ref) => LearningRoadmapApiService(),
);
final learningServiceProvider = Provider<LearningService>(
  (ref) => LearningService(
    roadmapApiService: ref.read(learningRoadmapApiServiceProvider),
  ),
);
final learningQuestServiceProvider = Provider<LearningQuestService>(
  (ref) => LearningQuestService(),
);
final reminderSettingsApiServiceProvider = Provider<ReminderSettingsApiService>(
  (ref) => ReminderSettingsApiService(),
);

final reminderServiceProvider = Provider<ReminderService>(
  (ref) =>
      ReminderService(apiService: ref.read(reminderSettingsApiServiceProvider)),
);
final questSettingsApiServiceProvider = Provider<QuestSettingsApiService>(
  (ref) => QuestSettingsApiService(),
);

final questRuleServiceProvider = Provider<QuestRuleService>(
  (ref) =>
      QuestRuleService(apiService: ref.read(questSettingsApiServiceProvider)),
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
final weeklySummaryApiServiceProvider = Provider<WeeklySummaryApiService>(
  (ref) => WeeklySummaryApiService(),
);
final weeklySummaryServiceProvider = Provider<WeeklySummaryService>(
  (ref) => WeeklySummaryService(
    apiService: ref.read(weeklySummaryApiServiceProvider),
  ),
);
final authTokenStorageProvider = Provider<AuthTokenStorage>(
  (ref) => AuthTokenStorage(),
);
final googleAuthProvider = Provider<GoogleAuthProvider>(
  (ref) => GoogleSignInAuthProvider(),
);
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    localStorageService: ref.read(localStorageServiceProvider),
    tokenStorage: ref.read(authTokenStorageProvider),
    googleAuthProvider: ref.read(googleAuthProvider),
  );
});
final userApiServiceProvider = Provider<UserApiService>(
  (ref) => UserApiService(),
);
final authSessionResolverProvider = Provider<AuthSessionResolver>((ref) {
  return AuthSessionResolver(
    tokenStorage: ref.read(authTokenStorageProvider),
    localStorageService: ref.read(localStorageServiceProvider),
    userApiService: ref.read(userApiServiceProvider),
    dailyCheckinService: ref.read(dailyCheckinServiceProvider),
  );
});
