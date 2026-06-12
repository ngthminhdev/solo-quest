import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/models/enums/quest_enums.dart';
import 'package:solo_quest/models/quest_model.dart';
import 'package:solo_quest/models/progress_model.dart';
import 'package:solo_quest/models/log_entry_model.dart';
import 'package:solo_quest/models/reminder_setting_model.dart';
import 'package:solo_quest/modules/home/home_page_model.dart';
import 'package:solo_quest/services/quest_service.dart';
import 'package:solo_quest/services/progress_service.dart';
import 'package:solo_quest/services/log_service.dart';
import 'package:solo_quest/services/auth_service.dart';
import 'package:solo_quest/services/reminder_service.dart';
import 'package:solo_quest/core/api/services/user_api_service.dart';
import 'package:solo_quest/core/api/services/quest_api_service.dart';
import 'package:solo_quest/core/api/services/ai_api_service.dart';
import 'package:solo_quest/core/network/api_client.dart';
import 'package:solo_quest/models/auth_user_model.dart';
import 'package:solo_quest/core/api/dto/user_dto.dart';
import 'package:solo_quest/core/api/dto/ai_generate_today_dto.dart';
import 'package:solo_quest/core/api/dto/daily_quest_generation_dto.dart';

class FakeQuestService extends Fake implements QuestService {
  List<QuestModel> quests = [];
  bool getTodayQuestsCalled = false;
  int getTodayQuestsCallCount = 0;
  String? startedQuestId;
  String? completedQuestId;
  String? snoozedQuestId;
  String? skippedQuestId;
  int? snoozedMinutes;
  String? skippedReason;

  @override
  Future<List<QuestModel>> getTodayQuests() async {
    getTodayQuestsCalled = true;
    getTodayQuestsCallCount++;
    return quests;
  }

  @override
  Future<QuestModel?> getQuestById(String id) async {
    return quests.where((q) => q.id == id).firstOrNull;
  }

  @override
  Future<List<QuestModel>> getActiveQuests() async =>
      quests.where((q) => q.isActive).toList();

  @override
  Future<List<QuestModel>> getUpcomingQuests() async =>
      quests.where((q) => q.isPending).toList();

  @override
  Future<List<QuestModel>> getCompletedQuests() async =>
      quests.where((q) => q.isCompleted).toList();

  @override
  Future<QuestModel> startQuest(String questId) async {
    startedQuestId = questId;
    return quests.firstWhere((q) => q.id == questId);
  }

  @override
  Future<QuestModel> completeQuest(
    String questId, {
    String? note,
    String? mood,
  }) async {
    completedQuestId = questId;
    return quests.firstWhere((q) => q.id == questId);
  }

  @override
  Future<QuestModel> snoozeQuest(String questId, {required int minutes}) async {
    snoozedQuestId = questId;
    snoozedMinutes = minutes;
    return quests.firstWhere((q) => q.id == questId);
  }

  @override
  Future<QuestModel> skipQuest(String questId, {required String reason}) async {
    skippedQuestId = questId;
    skippedReason = reason;
    return quests.firstWhere((q) => q.id == questId);
  }
}

class FakeProgressService extends Fake implements ProgressService {
  int getProgressCallCount = 0;

  @override
  Future<ProgressModel> getProgress() async {
    getProgressCallCount++;
    return const ProgressModel(
      level: 2,
      currentLevelExp: 50,
      nextLevelExp: 100,
      totalExp: 150,
      rewardPoints: 200,
      streakDays: 3,
      bestStreak: 5,
      streakShields: 1,
      totalCompletedQuests: 12,
      totalSkippedQuests: 1,
    );
  }
}

class FakeLogService extends Fake implements LogService {
  @override
  Future<List<LogEntryModel>> getLogs({
    int page = 1,
    int limit = 20,
    String? type,
    String? questType,
    String? date,
  }) async => [];

  @override
  Future<List<LogEntryModel>> getLogsByDate(DateTime date) async => [];

  @override
  Future<List<LogEntryModel>> getQuestLogs(String questId) async => [];
}

class FakeAuthService extends Fake implements AuthService {
  @override
  Future<AuthUserModel?> getCurrentUser() async {
    return AuthUserModel(
      id: 'user-1',
      name: 'Test User',
      email: 'test@example.com',
      provider: 'dev',
    );
  }

  @override
  Future<bool> isAuthenticated() async => true;

  @override
  Future<AuthUserModel> signInWithGoogle() async {
    return AuthUserModel(
      id: 'user-1',
      name: 'Test User',
      email: 'test@example.com',
      provider: 'dev',
    );
  }
}

class FakeUserApiService extends Fake implements UserApiService {
  int getDailyStatusCallCount = 0;

  @override
  Future<DailyStatusDto> getDailyStatus() async {
    getDailyStatusCallCount++;
    return DailyStatusDto(
      hasCheckedIn: true,
      hasReviewed: false,
      totalCount: 5,
      completedCount: 1,
      skippedCount: 0,
      pendingCount: 4,
      activeCount: 0,
      snoozedCount: 0,
      completionRate: 0.2,
      earnedExpToday: 10,
      streakDays: 3,
    );
  }
}

class FakeReminderService extends Fake implements ReminderService {
  @override
  Future<List<ReminderSettingModel>> getReminderSettings() async => [];
}

class FakeAiApiService extends Fake implements AiApiService {
  // generate-today
  GenerateTodayOutcome? generateOutcome;
  int generateCallCount = 0;
  bool? lastPreferAI;
  bool? lastForce;
  bool? lastReplacePendingOnly;
  String? lastGenerateDate;

  // status
  DailyQuestGenerationStatusDto? statusResult;
  List<DailyQuestGenerationStatusDto?>? statusQueue;
  int statusCallCount = 0;
  final List<String?> statusDates = [];

  @override
  Future<GenerateTodayOutcome?> generateTodayQuests({
    bool preferAI = true,
    bool force = false,
    bool replacePendingOnly = true,
    String? date,
  }) async {
    generateCallCount++;
    lastPreferAI = preferAI;
    lastForce = force;
    lastReplacePendingOnly = replacePendingOnly;
    lastGenerateDate = date;
    return generateOutcome;
  }

  @override
  Future<DailyQuestGenerationStatusDto?> getTodayGenerationStatus({
    String? date,
  }) async {
    statusCallCount++;
    statusDates.add(date);
    if (statusQueue != null && statusQueue!.isNotEmpty) {
      return statusQueue!.removeAt(0);
    }
    return statusResult;
  }
}

DailyQuestGenerationStatusDto _status(String status, {int questCount = 0}) {
  return DailyQuestGenerationStatusDto(
    date: '2026-06-09',
    status: status,
    jobId: 'job-1',
    questCount: questCount,
  );
}

class FakeApiClient extends Fake implements ApiClient {
  dynamic responseData;
  String? lastPath;
  String? lastGetPath;
  Map<String, dynamic>? lastBody;
  Map<String, String?>? lastGetQuery;

  @override
  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String?>? queryParams,
    T Function(dynamic json)? fromJson,
    int timeout = 30,
  }) async {
    lastPath = path;
    lastBody = body;
    if (fromJson != null) {
      return fromJson(responseData);
    }
    return responseData as T;
  }

  @override
  Future<T> get<T>(
    String path, {
    Map<String, String?>? queryParams,
    T Function(dynamic json)? fromJson,
    int timeout = 30,
  }) async {
    lastGetPath = path;
    lastGetQuery = queryParams;
    if (fromJson != null) {
      return fromJson(responseData);
    }
    return responseData as T;
  }
}

void main() {
  late FakeQuestService fakeQuestService;
  late FakeProgressService fakeProgressService;
  late FakeLogService fakeLogService;
  late FakeAuthService fakeAuthService;
  late FakeUserApiService fakeUserApiService;
  late FakeAiApiService fakeAiApiService;
  late HomePageModel homePageModel;

  HomePageModel buildModel({
    Duration? pollInterval,
    int maxPolls = 10,
    Duration? tabRefreshDebounce,
    Duration? tabRefreshCacheTtl,
  }) {
    return HomePageModel(
      questService: fakeQuestService,
      progressService: fakeProgressService,
      logService: fakeLogService,
      authService: fakeAuthService,
      reminderService: FakeReminderService(),
      userApiService: fakeUserApiService,
      aiApiService: fakeAiApiService,
      pollInterval: pollInterval ?? const Duration(seconds: 10),
      maxPolls: maxPolls,
      tabRefreshDebounce:
          tabRefreshDebounce ?? const Duration(milliseconds: 450),
      tabRefreshCacheTtl: tabRefreshCacheTtl ?? const Duration(seconds: 20),
    );
  }

  setUp(() {
    fakeQuestService = FakeQuestService();
    fakeProgressService = FakeProgressService();
    fakeLogService = FakeLogService();
    fakeAuthService = FakeAuthService();
    fakeUserApiService = FakeUserApiService();
    fakeAiApiService = FakeAiApiService();
    // Default: no in-flight generation job (empty days resolve to idle without
    // hitting the network or starting timers).
    fakeAiApiService.statusResult = _status(
      DailyQuestGenerationStatus.completed,
    );

    homePageModel = buildModel();
  });

  group('Featured Quest Selection', () {
    test('featured selector picks earliest overdue pending quest', () async {
      final now = DateTime.now();
      fakeQuestService.quests = [
        QuestModel(
          id: 'q1',
          title: 'Late Morning',
          type: QuestType.learning,
          status: QuestStatus.pending,
          reminderTime: now.subtract(const Duration(hours: 3)),
        ),
        QuestModel(
          id: 'q2',
          title: 'Late Afternoon',
          type: QuestType.water,
          status: QuestStatus.pending,
          reminderTime: now.subtract(const Duration(hours: 1)),
        ),
        QuestModel(
          id: 'q3',
          title: 'Evening',
          type: QuestType.movement,
          status: QuestStatus.pending,
          reminderTime: now.add(const Duration(hours: 2)),
        ),
      ];

      await homePageModel.loadHomeData();

      expect(homePageModel.state.activeQuests.length, 1);
      expect(homePageModel.state.activeQuests.first.id, 'q1');
    });

    test(
      'featured selector picks earliest upcoming quest when none are overdue',
      () async {
        final now = DateTime.now();
        fakeQuestService.quests = [
          QuestModel(
            id: 'q1',
            title: 'Evening Quest',
            type: QuestType.movement,
            status: QuestStatus.pending,
            reminderTime: now.add(const Duration(hours: 4)),
          ),
          QuestModel(
            id: 'q2',
            title: 'Next Quest',
            type: QuestType.water,
            status: QuestStatus.pending,
            reminderTime: now.add(const Duration(hours: 1)),
          ),
          QuestModel(
            id: 'q3',
            title: 'Later Quest',
            type: QuestType.learning,
            status: QuestStatus.pending,
            reminderTime: now.add(const Duration(hours: 6)),
          ),
        ];

        await homePageModel.loadHomeData();

        expect(homePageModel.state.activeQuests.length, 1);
        expect(homePageModel.state.activeQuests.first.id, 'q2');
      },
    );

    test('active quest is featured among pending quests', () async {
      final now = DateTime.now();
      fakeQuestService.quests = [
        QuestModel(
          id: 'q1',
          title: 'Pending First',
          type: QuestType.learning,
          status: QuestStatus.pending,
          reminderTime: now.add(const Duration(hours: 1)),
        ),
        QuestModel(
          id: 'q2',
          title: 'Active Quest',
          type: QuestType.water,
          status: QuestStatus.active,
          reminderTime: now.add(const Duration(hours: 2)),
        ),
      ];

      await homePageModel.loadHomeData();

      expect(homePageModel.state.activeQuests.length, 1);
      expect(homePageModel.state.activeQuests.first.id, 'q1');
    });

    test(
      'quests without reminderTime come after those with reminderTime',
      () async {
        final now = DateTime.now();
        fakeQuestService.quests = [
          const QuestModel(
            id: 'q1',
            title: 'No Time Quest 1',
            type: QuestType.learning,
            status: QuestStatus.pending,
          ),
          const QuestModel(
            id: 'q2',
            title: 'No Time Quest 2',
            type: QuestType.water,
            status: QuestStatus.pending,
          ),
          QuestModel(
            id: 'q3',
            title: 'Timed Quest',
            type: QuestType.movement,
            status: QuestStatus.pending,
            reminderTime: now.add(const Duration(hours: 1)),
          ),
        ];

        await homePageModel.loadHomeData();

        expect(homePageModel.state.activeQuests.length, 1);
        expect(homePageModel.state.activeQuests.first.id, 'q3');
      },
    );

    test('upcoming list excludes featured quest', () async {
      final now = DateTime.now();
      fakeQuestService.quests = [
        QuestModel(
          id: 'q1',
          title: 'Featured',
          type: QuestType.water,
          status: QuestStatus.pending,
          reminderTime: now.add(const Duration(hours: 1)),
        ),
        QuestModel(
          id: 'q2',
          title: 'Upcoming 1',
          type: QuestType.learning,
          status: QuestStatus.pending,
          reminderTime: now.add(const Duration(hours: 2)),
        ),
        QuestModel(
          id: 'q3',
          title: 'Upcoming 2',
          type: QuestType.movement,
          status: QuestStatus.pending,
          reminderTime: now.add(const Duration(hours: 3)),
        ),
      ];

      await homePageModel.loadHomeData();

      expect(homePageModel.state.activeQuests.length, 1);
      expect(homePageModel.state.activeQuests.first.id, 'q1');

      expect(
        homePageModel.state.upcomingQuests.any((q) => q.id == 'q1'),
        isFalse,
      );
      expect(homePageModel.state.upcomingQuests.length, 2);
    });

    test(
      'upcoming count is total remaining quests (excluding completed & featured)',
      () async {
        final now = DateTime.now();
        fakeQuestService.quests = [
          QuestModel(
            id: 'q1',
            title: 'Featured',
            type: QuestType.water,
            status: QuestStatus.pending,
            reminderTime: now.add(const Duration(hours: 1)),
          ),
          QuestModel(
            id: 'q2',
            title: 'Upcoming 1',
            type: QuestType.learning,
            status: QuestStatus.pending,
            reminderTime: now.add(const Duration(hours: 2)),
          ),
          QuestModel(
            id: 'q3',
            title: 'Upcoming 2',
            type: QuestType.movement,
            status: QuestStatus.pending,
            reminderTime: now.add(const Duration(hours: 3)),
          ),
          const QuestModel(
            id: 'q4',
            title: 'Done',
            type: QuestType.sleep,
            status: QuestStatus.completed,
          ),
        ];

        await homePageModel.loadHomeData();

        expect(homePageModel.state.activeQuests.length, 1);
        expect(homePageModel.state.upcomingQuests.length, 2);
        expect(homePageModel.state.completedQuests.length, 1);
      },
    );

    test(
      'no duplicate quest ids between featured and upcoming sections',
      () async {
        final now = DateTime.now();
        fakeQuestService.quests = [
          QuestModel(
            id: 'q1',
            title: 'Featured',
            type: QuestType.water,
            status: QuestStatus.pending,
            reminderTime: now.add(const Duration(hours: 1)),
          ),
          QuestModel(
            id: 'q2',
            title: 'Upcoming',
            type: QuestType.learning,
            status: QuestStatus.pending,
            reminderTime: now.add(const Duration(hours: 2)),
          ),
        ];

        await homePageModel.loadHomeData();

        final activeIds = homePageModel.state.activeQuests
            .map((q) => q.id)
            .toSet();
        final upcomingIds = homePageModel.state.upcomingQuests
            .map((q) => q.id)
            .toSet();

        final intersection = activeIds.intersection(upcomingIds);
        expect(intersection.isEmpty, isTrue);
      },
    );
  });

  group('Pull-to-refresh & Button Actions', () {
    test('loading home data calls getTodayQuests', () async {
      expect(fakeQuestService.getTodayQuestsCalled, isFalse);
      await homePageModel.loadHomeData();
      expect(fakeQuestService.getTodayQuestsCalled, isTrue);
    });

    test('startQuest calls startQuest on service and reloads', () async {
      fakeQuestService.quests = [
        const QuestModel(
          id: 'q1',
          title: 'Q1',
          type: QuestType.water,
          status: QuestStatus.pending,
        ),
      ];
      await homePageModel.startQuest('q1');
      expect(fakeQuestService.startedQuestId, 'q1');
    });

    test('completeQuest calls completeQuest on service and reloads', () async {
      fakeQuestService.quests = [
        const QuestModel(
          id: 'q1',
          title: 'Q1',
          type: QuestType.water,
          status: QuestStatus.active,
        ),
      ];
      await homePageModel.completeQuest('q1');
      expect(fakeQuestService.completedQuestId, 'q1');
    });

    test('snoozeQuest calls snoozeQuest on service and reloads', () async {
      fakeQuestService.quests = [
        const QuestModel(
          id: 'q1',
          title: 'Q1',
          type: QuestType.water,
          status: QuestStatus.active,
        ),
      ];
      await homePageModel.snoozeQuest('q1', minutes: 15);
      expect(fakeQuestService.snoozedQuestId, 'q1');
      expect(fakeQuestService.snoozedMinutes, 15);
    });

    test('skipQuest calls skipQuest on service and reloads', () async {
      fakeQuestService.quests = [
        const QuestModel(
          id: 'q1',
          title: 'Q1',
          type: QuestType.water,
          status: QuestStatus.active,
        ),
      ];
      await homePageModel.skipQuest('q1', reason: 'Too busy');
      expect(fakeQuestService.skippedQuestId, 'q1');
      expect(fakeQuestService.skippedReason, 'Too busy');
    });

    test(
      'tab visible refresh reuses fresh cache without another API call',
      () async {
        homePageModel = buildModel(
          tabRefreshDebounce: const Duration(milliseconds: 10),
          tabRefreshCacheTtl: const Duration(seconds: 30),
        );
        fakeQuestService.quests = [
          const QuestModel(
            id: 'q1',
            title: 'Q1',
            type: QuestType.water,
            status: QuestStatus.pending,
          ),
        ];

        await homePageModel.loadHomeData();
        final callsAfterInitialLoad = fakeQuestService.getTodayQuestsCallCount;

        homePageModel.scheduleTabVisibleRefresh();
        await Future.delayed(const Duration(milliseconds: 30));

        expect(fakeQuestService.getTodayQuestsCallCount, callsAfterInitialLoad);
      },
    );

    test('tab visible refresh debounces stale cache reloads', () async {
      homePageModel = buildModel(
        tabRefreshDebounce: const Duration(milliseconds: 10),
        tabRefreshCacheTtl: Duration.zero,
      );
      fakeQuestService.quests = [
        const QuestModel(
          id: 'q1',
          title: 'Q1',
          type: QuestType.water,
          status: QuestStatus.pending,
        ),
      ];

      await homePageModel.loadHomeData();
      final callsAfterInitialLoad = fakeQuestService.getTodayQuestsCallCount;

      homePageModel.scheduleTabVisibleRefresh();
      homePageModel.scheduleTabVisibleRefresh();
      homePageModel.scheduleTabVisibleRefresh();
      await Future.delayed(const Duration(milliseconds: 40));

      expect(
        fakeQuestService.getTodayQuestsCallCount,
        callsAfterInitialLoad + 1,
      );
    });

    test('external quest update moves completed quest immediately', () async {
      fakeQuestService.quests = [
        const QuestModel(
          id: 'q1',
          title: 'Q1',
          type: QuestType.water,
          status: QuestStatus.active,
        ),
        const QuestModel(
          id: 'q2',
          title: 'Q2',
          type: QuestType.learning,
          status: QuestStatus.pending,
        ),
      ];
      await homePageModel.loadHomeData();

      homePageModel.applyQuestUpdate(
        fakeQuestService.quests.first.copyWith(
          status: QuestStatus.completed,
          completedAt: DateTime.now(),
        ),
        refreshInBackground: false,
      );

      expect(homePageModel.state.completedQuests.map((q) => q.id), ['q1']);
      expect(homePageModel.state.activeQuests.map((q) => q.id), ['q2']);
      expect(homePageModel.state.completedTodayQuestCount, 1);
    });

    test(
      'stale read-after-write does not revert an optimistically completed quest',
      () async {
        fakeQuestService.quests = [
          const QuestModel(
            id: 'q1',
            title: 'Q1',
            type: QuestType.water,
            status: QuestStatus.active,
          ),
          const QuestModel(
            id: 'q2',
            title: 'Q2',
            type: QuestType.learning,
            status: QuestStatus.pending,
          ),
        ];
        await homePageModel.loadHomeData();

        // Optimistically mark q1 completed, as the action API response would.
        homePageModel.applyQuestUpdate(
          const QuestModel(
            id: 'q1',
            title: 'Q1',
            type: QuestType.water,
            status: QuestStatus.completed,
          ),
          refreshInBackground: false,
        );
        expect(homePageModel.state.completedQuests.map((q) => q.id), ['q1']);

        // Backend read-after-write is still stale: getTodayQuests returns q1
        // as active (fakeQuestService.quests was never updated).
        await homePageModel.loadHomeData(
          autoGenerateIfEmpty: false,
          forceRefresh: true,
          showLoading: false,
        );

        // Overlay keeps q1 completed; it must not snap back to active.
        expect(homePageModel.state.completedQuests.map((q) => q.id), ['q1']);
        expect(
          homePageModel.state.activeQuests.any((q) => q.id == 'q1'),
          isFalse,
        );
      },
    );

    test(
      'overlay clears once backend reflects the optimistic status',
      () async {
        fakeQuestService.quests = [
          const QuestModel(
            id: 'q1',
            title: 'Q1',
            type: QuestType.water,
            status: QuestStatus.active,
          ),
        ];
        await homePageModel.loadHomeData();

        homePageModel.applyQuestUpdate(
          const QuestModel(
            id: 'q1',
            title: 'Q1',
            type: QuestType.water,
            status: QuestStatus.completed,
          ),
          refreshInBackground: false,
        );

        // Backend catches up: q1 is now genuinely completed.
        fakeQuestService.quests = [
          const QuestModel(
            id: 'q1',
            title: 'Q1',
            type: QuestType.water,
            status: QuestStatus.completed,
          ),
        ];
        await homePageModel.loadHomeData(
          autoGenerateIfEmpty: false,
          forceRefresh: true,
          showLoading: false,
        );
        expect(homePageModel.state.completedQuests.map((q) => q.id), ['q1']);

        // Server now legitimately moves q1 back to pending (e.g. another
        // device). The overlay was already dropped, so the server state wins.
        fakeQuestService.quests = [
          const QuestModel(
            id: 'q1',
            title: 'Q1',
            type: QuestType.water,
            status: QuestStatus.pending,
          ),
        ];
        await homePageModel.loadHomeData(
          autoGenerateIfEmpty: false,
          forceRefresh: true,
          showLoading: false,
        );

        expect(homePageModel.state.completedQuests, isEmpty);
        expect(homePageModel.state.activeQuests.map((q) => q.id), ['q1']);
      },
    );
  });

  group('Duplicate Tap Prevention & Action Loading Map', () {
    test('startQuest updates pendingActions state map correctly', () async {
      fakeQuestService.quests = [
        const QuestModel(
          id: 'q1',
          title: 'Q1',
          type: QuestType.water,
          status: QuestStatus.pending,
        ),
      ];

      final future = homePageModel.startQuest('q1');
      expect(homePageModel.state.pendingActions.containsKey('q1'), isTrue);
      expect(homePageModel.state.pendingActions['q1'], QuestActionType.start);
      expect(homePageModel.state.isLockedPage, isTrue);

      await future;

      expect(homePageModel.state.pendingActions.containsKey('q1'), isFalse);
      expect(homePageModel.state.isLockedPage, isFalse);
    });
  });

  group('QuestApiService Response Parsing', () {
    late FakeApiClient fakeApiClient;
    late QuestApiService questApiService;

    setUp(() {
      fakeApiClient = FakeApiClient();
      questApiService = QuestApiService(client: fakeApiClient);
    });

    test('startQuest parses {"item": {...}} successfully', () async {
      fakeApiClient.responseData = {
        'item': {
          'id': 'q-100',
          'title': 'Start Item Test',
          'type': 'learning',
          'status': 'active',
          'difficulty': 'hard',
          'source': 'dailyPlan',
          'exp': 20,
          'estimated_minutes': 15,
        },
      };

      final result = await questApiService.startQuest('q-100');
      expect(result.id, 'q-100');
      expect(result.title, 'Start Item Test');
      expect(result.status, QuestStatus.active);
    });

    test('startQuest parses {"data": {...}} successfully', () async {
      fakeApiClient.responseData = {
        'data': {
          'id': 'q-200',
          'title': 'Start Data Test',
          'type': 'learning',
          'status': 'active',
          'difficulty': 'hard',
          'source': 'dailyPlan',
          'exp': 20,
          'estimated_minutes': 15,
        },
      };

      final result = await questApiService.startQuest('q-200');
      expect(result.id, 'q-200');
      expect(result.title, 'Start Data Test');
    });

    test(
      'startQuest throws FormatException when response only has message',
      () async {
        fakeApiClient.responseData = {'message': 'success'};

        expect(
          () => questApiService.startQuest('q-300'),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test('completeQuest parses {"result": {...}} successfully', () async {
      fakeApiClient.responseData = {
        'result': {
          'quest': {
            'id': 'q-400',
            'title': 'Complete Result Test',
            'type': 'learning',
            'status': 'completed',
            'difficulty': 'hard',
            'source': 'dailyPlan',
            'exp': 20,
            'estimated_minutes': 15,
          },
          'exp_earned': 25,
          'leveled_up': true,
          'new_level': 3,
          'message': 'completed successfully',
        },
      };

      final result = await questApiService.completeQuest('q-400');
      expect(result.quest.id, 'q-400');
      expect(result.quest.status, QuestStatus.completed);
      expect(result.expEarned, 25);
      expect(result.leveledUp, isTrue);
      expect(result.newLevel, 3);
    });

    test(
      'completeQuest throws FormatException when response only has message',
      () async {
        fakeApiClient.responseData = {'message': 'success'};

        expect(
          () => questApiService.completeQuest('q-500'),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test(
      'startQuest parses new standardized envelope {"item": {"id": ..., "title": ...}} within response',
      () async {
        fakeApiClient.responseData = {
          'item': {
            'id': 'q-std-1',
            'title': 'Standardized Start',
            'type': 'learning',
            'status': 'active',
            'difficulty': 'hard',
            'source': 'dailyPlan',
            'exp': 20,
            'estimated_minutes': 15,
          },
        };

        final result = await questApiService.startQuest('q-std-1');
        expect(result.id, 'q-std-1');
        expect(result.title, 'Standardized Start');
        expect(result.status, QuestStatus.active);
      },
    );
  });

  group('Async Quest Generation', () {
    const result200 = AiGenerateTodayResultDto(
      date: '2026-06-09',
      mode: 'rule_based',
      inserted: true,
      generatedCount: 1,
      quests: [],
    );

    test(
      '200 outcome reloads quests without entering generating state',
      () async {
        fakeQuestService.quests = [
          const QuestModel(
            id: 'q1',
            title: 'Q1',
            type: QuestType.water,
            status: QuestStatus.pending,
          ),
        ];
        fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
          result: result200,
        );

        await homePageModel.generateTodayQuests();

        expect(homePageModel.state.isGeneratingQuests, isFalse);
        expect(homePageModel.isPolling, isFalse);
        expect(homePageModel.state.activeQuests.length, 1);
        expect(fakeAiApiService.generateCallCount, 1);
      },
    );

    test('202 outcome enters generating state and starts polling', () async {
      homePageModel = buildModel(
        pollInterval: const Duration(milliseconds: 20),
      );
      fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
        job: DailyQuestGenerationStartDto(
          date: '2026-06-09',
          status: 'generating',
          jobId: 'job-202',
          estimatedSeconds: 15,
        ),
      );
      // Keep it generating so the test can observe the polling state.
      fakeAiApiService.statusResult = _status(
        DailyQuestGenerationStatus.generating,
      );

      await homePageModel.generateTodayQuests();

      expect(homePageModel.state.isGeneratingQuests, isTrue);
      expect(homePageModel.state.generationJobId, 'job-202');
      expect(homePageModel.isPolling, isTrue);
      expect(homePageModel.state.isGenerationFailed, isFalse);
      expect(fakeAiApiService.statusCallCount, 0);

      homePageModel.dispose();
    });

    test('retry sends prefer_ai + force + replace_pending_only', () async {
      fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
        job: DailyQuestGenerationStartDto(
          date: '2026-06-09',
          status: 'generating',
          jobId: 'job-r',
          estimatedSeconds: 15,
        ),
      );
      fakeAiApiService.statusResult = _status(
        DailyQuestGenerationStatus.generating,
      );
      homePageModel = buildModel(
        pollInterval: const Duration(milliseconds: 20),
      );

      await homePageModel.retryGeneration();

      expect(fakeAiApiService.lastPreferAI, isTrue);
      expect(fakeAiApiService.lastForce, isTrue);
      expect(fakeAiApiService.lastReplacePendingOnly, isTrue);

      homePageModel.dispose();
    });

    test(
      'polling completed stops polling, reloads, clears generating',
      () async {
        homePageModel = buildModel(
          pollInterval: const Duration(milliseconds: 20),
        );
        fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
          job: DailyQuestGenerationStartDto(
            date: '2026-06-09',
            status: 'generating',
            jobId: 'job-c',
            estimatedSeconds: 15,
          ),
        );
        // First the job is generating, then completes; on reload quests appear.
        fakeAiApiService.statusQueue = [
          _status(DailyQuestGenerationStatus.completed, questCount: 1),
        ];
        fakeAiApiService.statusResult = _status(
          DailyQuestGenerationStatus.completed,
          questCount: 1,
        );

        await homePageModel.generateTodayQuests();
        expect(homePageModel.isPolling, isTrue);

        // Quests are available on the next reload.
        fakeQuestService.quests = [
          const QuestModel(
            id: 'qc',
            title: 'Generated',
            type: QuestType.learning,
            status: QuestStatus.pending,
          ),
        ];

        await Future.delayed(const Duration(milliseconds: 80));

        expect(homePageModel.isPolling, isFalse);
        expect(homePageModel.state.isGeneratingQuests, isFalse);
        expect(homePageModel.state.generationPhase, HomeGenerationPhase.idle);
        expect(homePageModel.state.activeQuests.length, 1);
        expect(
          fakeQuestService.getTodayQuestsCallCount,
          greaterThanOrEqualTo(1),
        );
        expect(
          fakeUserApiService.getDailyStatusCallCount,
          greaterThanOrEqualTo(1),
        );
        expect(
          fakeProgressService.getProgressCallCount,
          greaterThanOrEqualTo(1),
        );

        homePageModel.dispose();
      },
    );

    test('polling failed stops polling and shows retry/failed state', () async {
      homePageModel = buildModel(
        pollInterval: const Duration(milliseconds: 20),
      );
      fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
        job: DailyQuestGenerationStartDto(
          date: '2026-06-09',
          status: 'generating',
          jobId: 'job-f',
          estimatedSeconds: 15,
        ),
      );
      fakeAiApiService.statusResult = _status(
        DailyQuestGenerationStatus.failed,
      );

      await homePageModel.generateTodayQuests();
      await Future.delayed(const Duration(milliseconds: 60));

      expect(homePageModel.isPolling, isFalse);
      expect(homePageModel.state.isGeneratingQuests, isFalse);
      expect(homePageModel.state.isGenerationFailed, isTrue);

      homePageModel.dispose();
    });

    test('polling stale stops polling and shows retry/failed state', () async {
      homePageModel = buildModel(
        pollInterval: const Duration(milliseconds: 20),
      );
      fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
        job: DailyQuestGenerationStartDto(
          date: '2026-06-09',
          status: 'generating',
          jobId: 'job-s',
          estimatedSeconds: 15,
        ),
      );
      fakeAiApiService.statusResult = _status(DailyQuestGenerationStatus.stale);

      await homePageModel.generateTodayQuests();
      await Future.delayed(const Duration(milliseconds: 60));

      expect(homePageModel.isPolling, isFalse);
      expect(homePageModel.state.isGenerationFailed, isTrue);

      homePageModel.dispose();
    });

    test(
      'poll budget exhausted stops polling and shows slow message',
      () async {
        homePageModel = buildModel(
          pollInterval: const Duration(milliseconds: 15),
          maxPolls: 2,
        );
        fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
          job: DailyQuestGenerationStartDto(
            date: '2026-06-09',
            status: 'generating',
            jobId: 'job-slow',
            estimatedSeconds: 15,
          ),
        );
        // Always still generating → poll budget runs out.
        fakeAiApiService.statusResult = _status(
          DailyQuestGenerationStatus.generating,
        );

        await homePageModel.generateTodayQuests();
        await Future.delayed(const Duration(milliseconds: 120));

        expect(homePageModel.isPolling, isFalse);
        expect(fakeAiApiService.statusCallCount, 2);
        expect(homePageModel.state.isGenerationSlow, isTrue);
        expect(homePageModel.state.isGeneratingQuests, isFalse);
        expect(
          homePageModel.state.generationMessage,
          'Quest vẫn đang được tạo. Bạn có thể kéo để làm mới sau.',
        );

        homePageModel.dispose();
      },
    );

    test('dispose cancels the polling timer', () async {
      homePageModel = buildModel(
        pollInterval: const Duration(milliseconds: 20),
      );
      fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
        job: DailyQuestGenerationStartDto(
          date: '2026-06-09',
          status: 'generating',
          jobId: 'job-d',
          estimatedSeconds: 15,
        ),
      );
      fakeAiApiService.statusResult = _status(
        DailyQuestGenerationStatus.generating,
      );

      await homePageModel.generateTodayQuests();
      expect(homePageModel.isPolling, isTrue);

      homePageModel.dispose();
      expect(homePageModel.isPolling, isFalse);

      final callsAfterDispose = fakeAiApiService.statusCallCount;
      await Future.delayed(const Duration(milliseconds: 70));
      expect(fakeAiApiService.statusCallCount, callsAfterDispose);
    });

    test('concurrent generate calls do not start two timers', () async {
      homePageModel = buildModel(
        pollInterval: const Duration(milliseconds: 20),
      );
      fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
        job: DailyQuestGenerationStartDto(
          date: '2026-06-09',
          status: 'generating',
          jobId: 'job-x',
          estimatedSeconds: 15,
        ),
      );
      fakeAiApiService.statusResult = _status(
        DailyQuestGenerationStatus.generating,
      );

      await homePageModel.generateTodayQuests();
      await homePageModel.generateTodayQuests(); // guarded — should no-op

      expect(homePageModel.isPolling, isTrue);
      expect(fakeAiApiService.generateCallCount, 1);

      homePageModel.dispose();
    });

    test(
      'pull-to-refresh resets polling and restarts from attempt 1 when still generating',
      () async {
        homePageModel = buildModel(
          pollInterval: const Duration(milliseconds: 20),
          maxPolls: 10,
        );
        fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
          job: DailyQuestGenerationStartDto(
            date: '2026-06-09',
            status: 'generating',
            jobId: 'job-refresh',
            estimatedSeconds: 15,
          ),
        );
        fakeAiApiService.statusResult = _status(
          DailyQuestGenerationStatus.generating,
        );

        await homePageModel.generateTodayQuests();
        await Future.delayed(const Duration(milliseconds: 55));
        expect(homePageModel.pollCount, greaterThanOrEqualTo(1));

        await homePageModel.refresh();

        expect(homePageModel.isPolling, isTrue);
        expect(homePageModel.pollCount, 0);
        expect(fakeAiApiService.statusCallCount, greaterThanOrEqualTo(1));

        await Future.delayed(const Duration(milliseconds: 25));

        expect(homePageModel.pollCount, 1);
        homePageModel.dispose();
      },
    );

    test(
      'pull-to-refresh completed status reloads quests without starting a new job',
      () async {
        homePageModel = buildModel(
          pollInterval: const Duration(milliseconds: 20),
        );
        fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
          job: DailyQuestGenerationStartDto(
            date: '2026-06-09',
            status: 'generating',
            jobId: 'job-refresh-completed',
            estimatedSeconds: 15,
          ),
        );
        fakeAiApiService.statusResult = _status(
          DailyQuestGenerationStatus.generating,
        );

        await homePageModel.generateTodayQuests();
        expect(homePageModel.isPolling, isTrue);

        fakeQuestService.quests = [
          const QuestModel(
            id: 'qr',
            title: 'Reloaded',
            type: QuestType.learning,
            status: QuestStatus.pending,
          ),
        ];
        fakeAiApiService.statusResult = _status(
          DailyQuestGenerationStatus.completed,
          questCount: 1,
        );
        final generateCallsBeforeRefresh = fakeAiApiService.generateCallCount;

        await homePageModel.refresh();

        expect(homePageModel.isPolling, isFalse);
        expect(homePageModel.state.generationPhase, HomeGenerationPhase.idle);
        expect(homePageModel.state.activeQuests.length, 1);
        expect(fakeAiApiService.generateCallCount, generateCallsBeforeRefresh);

        homePageModel.dispose();
      },
    );

    test('status null keeps polling until budget without crashing', () async {
      homePageModel = buildModel(
        pollInterval: const Duration(milliseconds: 15),
        maxPolls: 2,
      );
      fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
        job: DailyQuestGenerationStartDto(
          date: '2026-06-09',
          status: 'generating',
          jobId: 'job-null',
          estimatedSeconds: 15,
        ),
      );
      fakeAiApiService.statusResult = null;

      await homePageModel.generateTodayQuests();
      await Future.delayed(const Duration(milliseconds: 80));

      expect(fakeAiApiService.statusCallCount, 2);
      expect(homePageModel.isPolling, isFalse);
      expect(homePageModel.state.isGenerationSlow, isTrue);

      homePageModel.dispose();
    });

    test('status calls use yyyy-MM-dd date from generation flow', () async {
      homePageModel = buildModel(
        pollInterval: const Duration(milliseconds: 20),
      );
      fakeAiApiService.generateOutcome = const GenerateTodayOutcome(
        job: DailyQuestGenerationStartDto(
          date: '2026-06-09',
          status: 'generating',
          jobId: 'job-date',
          estimatedSeconds: 15,
        ),
      );
      fakeAiApiService.statusResult = _status(
        DailyQuestGenerationStatus.generating,
      );

      await homePageModel.generateTodayQuests();
      await Future.delayed(const Duration(milliseconds: 25));

      expect(
        fakeAiApiService.lastGenerateDate,
        matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')),
      );
      expect(fakeAiApiService.statusDates, isNotEmpty);
      expect(
        fakeAiApiService.statusDates.last,
        matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')),
      );

      homePageModel.dispose();
    });

    test('empty day with a running job resumes polling on load', () async {
      homePageModel = buildModel(
        pollInterval: const Duration(milliseconds: 20),
      );
      fakeQuestService.quests = []; // empty day
      fakeAiApiService.statusResult = _status(
        DailyQuestGenerationStatus.generating,
      );

      await homePageModel.loadHomeData();

      expect(homePageModel.state.isGeneratingQuests, isTrue);
      expect(homePageModel.isPolling, isTrue);
      // No new job started; we resumed the existing one.
      expect(fakeAiApiService.generateCallCount, 0);

      homePageModel.dispose();
    });

    test('non-empty day clears generation state and does not poll', () async {
      fakeQuestService.quests = [
        const QuestModel(
          id: 'q1',
          title: 'Q1',
          type: QuestType.water,
          status: QuestStatus.pending,
        ),
      ];

      await homePageModel.loadHomeData();

      expect(homePageModel.state.isGeneratingQuests, isFalse);
      expect(homePageModel.isPolling, isFalse);
      expect(fakeAiApiService.statusCallCount, 0);
    });
  });
}
