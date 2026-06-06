import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/constants/app_constant.dart';
import 'package:solo_quest/generated/l10n/app_localizations.dart';
import 'package:solo_quest/core/network/api_client.dart';
import 'package:solo_quest/core/network/api_exception.dart';
import 'package:solo_quest/core/api/services/log_api_service.dart';
import 'package:solo_quest/modules/onboarding/onboarding_page_model.dart';
import 'package:solo_quest/modules/onboarding/models/onboarding_data.dart';
import 'package:solo_quest/modules/onboarding/widgets/onboarding_basic_info_step.dart';
import 'package:solo_quest/services/profile_service.dart';
import 'package:solo_quest/services/local_storage_service.dart';
import 'package:solo_quest/services/quest_rule_service.dart';
import 'package:solo_quest/services/log_service.dart';
import 'package:solo_quest/core/api/services/user_api_service.dart';
import 'package:solo_quest/core/api/dto/user_dto.dart';
import 'package:solo_quest/models/user_profile_model.dart';

class FakeProfileService extends ProfileService {
  FakeProfileService(UserApiService apiService) : super(apiService: apiService);

  @override
  Future<UserProfileModel> createOrUpdateProfile({
    required String name,
    List<String>? mainGoals,
  }) async {
    return UserProfileModel(
      id: 'test-user',
      name: name,
      mainGoals: mainGoals ?? const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

class FakeLocalStorageService extends LocalStorageService {
  final Map<String, dynamic> _storage = {};

  @override
  Future<bool> setBool(String key, bool value) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool?> getBool(String key) async {
    return _storage[key] as bool?;
  }
}

class FakeQuestRuleService extends QuestRuleService {
  int? updatedLimit;

  @override
  Future<void> updateDailyQuestLimit(int limit) async {
    updatedLimit = limit;
  }
}

class FakeLogService extends LogService {
  FakeLogService()
    : super(
        apiService: LogApiService(
          client: ApiClient(baseUrl: 'http://localhost'),
        ),
      );

  @override
  Future<void> addLog(dynamic log) async {
    // No-op
  }
}

class FakeUserApiService extends UserApiService {
  Map<String, dynamic>? lastSavedPayload;
  ApiException? saveException;

  FakeUserApiService() : super(client: ApiClient(baseUrl: 'http://localhost'));

  @override
  Future<OnboardingStatusDto> saveOnboarding(Map<String, dynamic> data) async {
    final exception = saveException;
    if (exception != null) throw exception;

    lastSavedPayload = data;
    return OnboardingStatusDto(completed: true);
  }
}

class CapturingApiClient extends ApiClient {
  String? lastPostPath;
  Map<String, dynamic>? lastPostBody;

  CapturingApiClient() : super(baseUrl: 'http://localhost');

  @override
  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String?>? queryParams,
    T Function(dynamic json)? fromJson,
    int timeout = 30,
  }) async {
    lastPostPath = path;
    lastPostBody = body;
    final response = <String, dynamic>{'completed': true};
    if (fromJson != null) {
      return fromJson(response);
    }
    return response as T;
  }
}

void main() {
  group('OnboardingPageModel & OnboardingData Tests', () {
    late FakeProfileService profileService;
    late FakeLocalStorageService localStorageService;
    late FakeQuestRuleService questRuleService;
    late FakeLogService logService;
    late FakeUserApiService userApiService;
    late OnboardingPageModel model;

    setUp(() {
      userApiService = FakeUserApiService();
      profileService = FakeProfileService(userApiService);
      localStorageService = FakeLocalStorageService();
      questRuleService = FakeQuestRuleService();
      logService = FakeLogService();
      model = OnboardingPageModel(
        profileService: profileService,
        localStorageService: localStorageService,
        questRuleService: questRuleService,
        logService: logService,
        userApiService: userApiService,
      );
    });

    test('initial state preferredFreeTimes is empty', () {
      expect(model.state.data.preferredFreeTimes, isEmpty);
      expect(model.state.data.freeTimePreference, isEmpty);
    });

    test('initial state uses simplified MVP onboarding step count', () {
      expect(model.state.totalSteps, 7);
      expect(model.state.currentStep, 0);
      expect(model.state.isLastStep, isFalse);
    });

    test('initial state has backend defaults for required option fields', () {
      expect(model.state.data.gender, 'male');
      expect(model.state.data.mainActivity, 'software_engineer');
      expect(model.state.data.workScheduleType, 'weekdays');
      expect(model.state.data.activityLevel, 'very_little');
      expect(model.state.data.lastWorkout, 'longer_ago');
      expect(model.state.data.learningTimePreference, 'evening');
      expect(model.state.data.learningTimePreferences, ['evening']);
      expect(model.state.data.movementTimePreference, 'evening');
      expect(model.state.data.movementTimePreferences, ['evening']);
      expect(model.state.data.breakReminderInterval, 90);
      expect(model.state.data.breakDuration, '5');
      expect(model.state.data.waterReminderMode, 'optimal');
      expect(model.state.data.quietAfterTime, '22:00');
      expect(model.state.data.preferredRewards, isEmpty);
    });

    test('togglePreferredFreeTime adds and removes options', () {
      // Toggle 'lunch' on
      model.togglePreferredFreeTime('lunch');
      expect(model.state.data.preferredFreeTimes, contains('lunch'));
      expect(model.state.data.freeTimePreference, equals('lunch'));

      // Toggle 'evening' on
      model.togglePreferredFreeTime('evening');
      expect(
        model.state.data.preferredFreeTimes,
        containsAll(['lunch', 'evening']),
      );
      expect(model.state.data.freeTimePreference, equals('lunch,evening'));

      // Toggle 'lunch' off
      model.togglePreferredFreeTime('lunch');
      expect(model.state.data.preferredFreeTimes, isNot(contains('lunch')));
      expect(model.state.data.preferredFreeTimes, contains('evening'));
      expect(model.state.data.freeTimePreference, equals('evening'));

      // Toggle 'evening' off
      model.togglePreferredFreeTime('evening');
      expect(model.state.data.preferredFreeTimes, isEmpty);
      expect(model.state.data.freeTimePreference, isEmpty);
    });

    test(
      'completeOnboarding builds correct payload with preferred_free_times',
      () async {
        // Set some dummy data
        model.updateDisplayName('Test User');
        model.updateAge('25');
        model.updateMainActivity('Software Engineer');
        model.updateWorkScheduleType('weekdays');
        model.updateWorkStartTime('09:00');
        model.updateWorkEndTime('18:00');
        model.togglePreferredFreeTime('lunch');
        model.togglePreferredFreeTime('evening');
        model.updateActivityLevel('occasional');
        model.updateLastWorkout('today');
        model.toggleMainGoal('health');
        model.updateWakeUpTime('07:00');
        model.updateTargetSleepTime('23:00');
        model.updateFreeTimeStart('19:00');
        model.updateFreeTimeEnd('22:00');
        model.toggleLearningTimePreference('lunch');
        model.toggleMovementTimePreference('morning');

        // Move steps to satisfy state.canContinue
        for (int i = 0; i < 6; i++) {
          model.nextStep();
        }

        final success = await model.completeOnboarding();
        expect(success, isTrue);

        final payload = userApiService.lastSavedPayload;
        expect(payload, isNotNull);
        expect(payload!['display_name'], 'Test User');
        expect(payload['gender'], 'male');
        expect(payload['main_activity'], 'software_engineer');
        expect(payload['work_schedule_type'], 'weekdays');
        expect(payload['free_time_preference'], 'lunch,evening');
        expect(payload['preferred_free_times'], equals(['lunch', 'evening']));
        expect(payload['activity_level'], 'occasional');
        expect(payload['last_workout'], 'today');
        expect(payload['learning_time_preference'], 'lunch');
        expect(
          payload['learning_time_preferences'],
          equals(['lunch', 'evening']),
        );
        expect(payload['movement_time_preference'], 'morning,evening');
        expect(
          payload['movement_time_preferences'],
          equals(['morning', 'evening']),
        );
        expect(payload['break_reminder_interval'], 90);
        expect(payload['break_duration'], '5');
        expect(payload['water_reminder_mode'], 'optimal');
        expect(payload['quiet_after_time'], '22:00');
        expect(payload['preferred_rewards'], isEmpty);
      },
    );

    test(
      'completeOnboarding normalizes localized labels before API save',
      () async {
        model.updateDisplayName('Test User');
        model.updateAge('25');
        model.updateMainActivity('Software Engineer');
        model.updateGender('Nam');
        model.updateWorkScheduleType('Thứ 2–6');
        model.updateWorkStartTime('09:00');
        model.updateWorkEndTime('18:00');
        model.updateFreeTimePreference('Tối (20–23h)');
        model.updateActivityLevel('Rất ít');
        model.updateLastWorkout('Hôm nay');
        model.toggleMainGoal('health');
        model.updateWakeUpTime('07:00');
        model.updateTargetSleepTime('23:00');
        model.updateFreeTimeStart('19:00');
        model.updateFreeTimeEnd('22:00');
        model.toggleLearningTimePreference('Sáng');
        model.toggleMovementTimePreference('Nghỉ trưa');

        for (int i = 0; i < 6; i++) {
          model.nextStep();
        }

        final success = await model.completeOnboarding();
        expect(success, isTrue);

        final payload = userApiService.lastSavedPayload;
        expect(payload, isNotNull);
        expect(payload!['gender'], 'male');
        expect(payload['main_activity'], 'software_engineer');
        expect(payload['work_schedule_type'], 'weekdays');
        expect(payload['preferred_free_times'], equals(['evening']));
        expect(payload['free_time_preference'], 'evening');
        expect(payload['preferred_free_times'], isA<List<String>>());
        expect(payload['activity_level'], 'very_little');
        expect(payload['last_workout'], 'today');
        expect(payload['learning_time_preference'], 'morning');
        expect(
          payload['learning_time_preferences'],
          equals(['morning', 'evening']),
        );
        expect(payload['movement_time_preference'], 'lunch,evening');
        expect(
          payload['movement_time_preferences'],
          equals(['lunch', 'evening']),
        );
        expect(payload['water_reminder_mode'], 'optimal');
        expect(payload['preferred_rewards'], isEmpty);
        expect(payload.values, isNot(contains('Nam')));
        expect(payload.values, isNot(contains('Thứ 2–6')));
        expect(payload.values, isNot(contains('Sáng')));
        expect(payload.values, isNot(contains('Ngẫu nhiên')));
      },
    );

    test('selected gender overrides default in API payload', () async {
      model.updateDisplayName('Test User');
      model.updateAge('25');
      model.updateGender('female');
      model.toggleMainGoal('health');

      for (int i = 0; i < 6; i++) {
        model.nextStep();
      }

      final success = await model.completeOnboarding();
      expect(success, isTrue);

      final payload = userApiService.lastSavedPayload;
      expect(payload, isNotNull);
      expect(payload!['gender'], 'female');
      expect(payload['gender'], isNot(''));
    });

    test(
      'completeOnboarding does not mark local completion when API save fails',
      () async {
        userApiService.saveException = ApiException.serverError(
          404,
          'page not found',
        );
        model.updateDisplayName('Test User');
        model.updateAge('25');
        model.updateMainActivity('Software Engineer');
        model.updateWorkScheduleType('weekdays');
        model.updateWorkStartTime('09:00');
        model.updateWorkEndTime('18:00');
        model.togglePreferredFreeTime('evening');
        model.updateActivityLevel('occasional');
        model.updateLastWorkout('today');
        model.toggleMainGoal('health');
        model.updateWakeUpTime('07:00');
        model.updateTargetSleepTime('23:00');
        model.updateFreeTimeStart('19:00');
        model.updateFreeTimeEnd('22:00');

        for (int i = 0; i < 6; i++) {
          model.nextStep();
        }

        final success = await model.completeOnboarding();
        expect(success, isFalse);
        expect(
          await localStorageService.getBool(
            AppStorageKey.hasCompletedOnboarding,
          ),
          isNull,
        );
      },
    );

    test(
      'removed reminder and rewards pages are not reachable in navigation',
      () {
        model.updateDisplayName('Test User');
        model.updateAge('25');
        model.toggleMainGoal('health');

        final visitedSteps = <int>[];
        for (int i = 0; i < 10; i++) {
          visitedSteps.add(model.state.currentStep);
          model.nextStep();
        }

        expect(visitedSteps, containsAll([0, 1, 2, 3, 4, 5, 6]));
        expect(model.state.currentStep, 6);
        expect(model.state.isLastStep, isTrue);
        expect(model.state.totalSteps, 7);
      },
    );

    test(
      'UserApiService.saveOnboarding posts to backend onboarding endpoint',
      () async {
        final apiClient = CapturingApiClient();
        final service = UserApiService(client: apiClient);

        await service.saveOnboarding({
          'work_schedule_type': 'weekdays',
          'preferred_free_times': ['evening'],
        });

        expect(apiClient.lastPostPath, 'onboarding');
        expect(apiClient.lastPostBody, {
          'work_schedule_type': 'weekdays',
          'preferred_free_times': ['evening'],
        });
      },
    );

    test('completeOnboarding normalizes main_goals and applies reminder & review time calculations', () async {
      // Setup model state
      model.updateDisplayName('Test User');
      model.updateAge('25');
      model.updateMainActivity('Software Engineer');
      model.updateWorkScheduleType('weekdays');
      model.updateWorkStartTime('09:00');
      model.updateWorkEndTime('18:00');
      model.togglePreferredFreeTime('evening');
      model.updateActivityLevel('occasional');
      model.updateLastWorkout('today');
      model.updateWakeUpTime('07:00');
      model.updateTargetSleepTime('23:30');
      model.updateFreeTimeStart('19:00');
      model.updateFreeTimeEnd('22:00');
      model.toggleLearningTimePreference('morning');
      model.toggleMovementTimePreference('lunch');

      // Add Vietnamese goals and one canonical goal
      model.toggleMainGoal('Uống Nước'); // Should map to 'water'
      model.toggleMainGoal('Học Tập');    // Should map to 'learning'
      model.toggleMainGoal('sleep');       // Should remain 'sleep'
      model.toggleMainGoal('unknown_goal'); // Should remain 'unknown_goal'

      // Update state-level reminders
      model.updateBreakReminderInterval(120);
      model.updateBreakDuration('10');
      model.updateWaterReminderMode('random');
      model.updateQuietAfterTime('22:00');

      for (int i = 0; i < 6; i++) {
        model.nextStep();
      }

      final success = await model.completeOnboarding();
      expect(success, isTrue);

      final payload = userApiService.lastSavedPayload;
      expect(payload, isNotNull);

      // 1. Verify main_goals normalization
      final mainGoals = payload!['main_goals'] as List<String>;
      expect(mainGoals, containsAll(['water', 'learning', 'sleep', 'unknown_goal']));
      expect(mainGoals, isNot(contains('Uống Nước')));
      expect(mainGoals, isNot(contains('Học Tập')));

      // 2. Verify reminders use state values
      expect(payload['break_reminder_interval'], 120);
      expect(payload['break_duration'], '10');
      expect(payload['water_reminder_mode'], 'random');
      expect(payload['quiet_after_time'], '22:00');

      // 3. Verify plural time preferences are canonical lists
      expect(payload['learning_time_preferences'], equals(['morning', 'evening']));
      expect(payload['movement_time_preferences'], equals(['lunch', 'evening']));

      // 4. Verify preferred_review_time calculation and clamping
      // targetSleepTime = 23:30. 1 hour before is 22:30.
      // quietAfterTime is 22:00. So 22:30 > 22:00, it clamps to 22:00.
      expect(payload['preferred_review_time'], '22:00');
    });

    test('preferred_review_time calculation without clamping', () async {
      model.updateDisplayName('Test User');
      model.updateAge('25');
      model.updateWakeUpTime('07:00');
      model.updateTargetSleepTime('22:00'); // 1 hour before is 21:00
      model.updateQuietAfterTime('22:00'); // review time 21:00 <= 22:00, no clamping
      model.toggleMainGoal('water');

      for (int i = 0; i < 6; i++) {
        model.nextStep();
      }

      final success = await model.completeOnboarding();
      expect(success, isTrue);

      final payload = userApiService.lastSavedPayload;
      expect(payload, isNotNull);
      expect(payload!['preferred_review_time'], '21:00');
    });

    testWidgets('gender dropdown displays male default from model state', (
      tester,
    ) async {
      String? selectedGender;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: OnboardingBasicInfoStep(
                data: const OnboardingData(),
                onDisplayNameChanged: (_) {},
                onAgeChanged: (_) {},
                onGenderChanged: (value) => selectedGender = value,
                onHeightChanged: (_) {},
                onWeightChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Nam'), findsOneWidget);

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nữ').last);
      await tester.pumpAndSettle();

      expect(selectedGender, 'female');
    });
  });
}
