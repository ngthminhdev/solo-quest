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
import 'package:solo_quest/core/network/api_client.dart';
import 'package:solo_quest/models/auth_user_model.dart';
import 'package:solo_quest/core/api/dto/user_dto.dart';

class FakeQuestService extends Fake implements QuestService {
  List<QuestModel> quests = [];
  bool getTodayQuestsCalled = false;
  String? startedQuestId;
  String? completedQuestId;
  String? snoozedQuestId;
  String? skippedQuestId;
  int? snoozedMinutes;
  String? skippedReason;

  @override
  Future<List<QuestModel>> getTodayQuests() async {
    getTodayQuestsCalled = true;
    return quests;
  }

  @override
  Future<QuestModel?> getQuestById(String id) async {
    return quests.where((q) => q.id == id).firstOrNull;
  }

  @override
  Future<List<QuestModel>> getActiveQuests() async => quests.where((q) => q.isActive).toList();

  @override
  Future<List<QuestModel>> getUpcomingQuests() async => quests.where((q) => q.isPending).toList();

  @override
  Future<List<QuestModel>> getCompletedQuests() async => quests.where((q) => q.isCompleted).toList();

  @override
  Future<QuestModel> startQuest(String questId) async {
    startedQuestId = questId;
    return quests.firstWhere((q) => q.id == questId);
  }

  @override
  Future<QuestModel> completeQuest(String questId, {String? note, String? mood}) async {
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
  @override
  Future<ProgressModel> getProgress() async {
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
  }) async =>
      [];

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
  @override
  Future<DailyStatusDto> getDailyStatus() async {
    return DailyStatusDto(
      hasCheckedIn: true,
      hasReviewed: false,
      todayCompletedQuests: 1,
      todayPlannedQuests: 5,
      todayEarnedExp: 10,
    );
  }
}

class FakeReminderService extends Fake implements ReminderService {
  Future<List<ReminderSettingModel>> getReminders() async => [];

  Future<ReminderSettingModel?> getDailyReviewReminder() async => null;
}

class FakeApiClient extends Fake implements ApiClient {
  dynamic responseData;
  String? lastPath;
  Map<String, dynamic>? lastBody;

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
}

void main() {
  late FakeQuestService fakeQuestService;
  late FakeProgressService fakeProgressService;
  late FakeLogService fakeLogService;
  late FakeAuthService fakeAuthService;
  late FakeUserApiService fakeUserApiService;
  late HomePageModel homePageModel;

  setUp(() {
    fakeQuestService = FakeQuestService();
    fakeProgressService = FakeProgressService();
    fakeLogService = FakeLogService();
    fakeAuthService = FakeAuthService();
    fakeUserApiService = FakeUserApiService();

    homePageModel = HomePageModel(
      questService: fakeQuestService,
      progressService: fakeProgressService,
      logService: fakeLogService,
      authService: fakeAuthService,
      reminderService: FakeReminderService(),
      userApiService: fakeUserApiService,
    );
  });

  group('Featured Quest Selection', () {
    test('featured selector picks in_progress (active) quest first', () async {
      fakeQuestService.quests = [
        const QuestModel(id: 'q1', title: 'Pending Quest 1', type: QuestType.learning, status: QuestStatus.pending),
        const QuestModel(id: 'q2', title: 'Active Quest 1', type: QuestType.water, status: QuestStatus.active),
        const QuestModel(id: 'q3', title: 'Active Quest 2', type: QuestType.movement, status: QuestStatus.active),
      ];

      await homePageModel.loadHomeData();

      expect(homePageModel.state.activeQuests.length, 1);
      expect(homePageModel.state.activeQuests.first.id, 'q2');
    });

    test('featured selector picks pending quest when no in_progress, prioritizing highest difficulty', () async {
      fakeQuestService.quests = [
        const QuestModel(
          id: 'q1',
          title: 'Easy Pending',
          type: QuestType.learning,
          status: QuestStatus.pending,
          difficulty: QuestDifficulty.easy,
        ),
        const QuestModel(
          id: 'q2',
          title: 'Hard Pending',
          type: QuestType.water,
          status: QuestStatus.pending,
          difficulty: QuestDifficulty.hard,
        ),
        const QuestModel(
          id: 'q3',
          title: 'Medium Pending',
          type: QuestType.movement,
          status: QuestStatus.pending,
          difficulty: QuestDifficulty.medium,
        ),
      ];

      await homePageModel.loadHomeData();

      expect(homePageModel.state.activeQuests.length, 1);
      expect(homePageModel.state.activeQuests.first.id, 'q2');
    });

    test('featured selector picks pending quest when no in_progress, prioritizing isImportant', () async {
      fakeQuestService.quests = [
        const QuestModel(
          id: 'q1',
          title: 'Hard Pending',
          type: QuestType.learning,
          status: QuestStatus.pending,
          difficulty: QuestDifficulty.hard,
          isImportant: false,
        ),
        const QuestModel(
          id: 'q2',
          title: 'Medium Important Pending',
          type: QuestType.water,
          status: QuestStatus.pending,
          difficulty: QuestDifficulty.medium,
          isImportant: true,
        ),
      ];

      await homePageModel.loadHomeData();

      expect(homePageModel.state.activeQuests.length, 1);
      expect(homePageModel.state.activeQuests.first.id, 'q2');
    });

    test('upcoming list excludes featured quest', () async {
      fakeQuestService.quests = [
        const QuestModel(id: 'q1', title: 'Q1', type: QuestType.water, status: QuestStatus.active),
        const QuestModel(id: 'q2', title: 'Q2', type: QuestType.learning, status: QuestStatus.pending),
        const QuestModel(id: 'q3', title: 'Q3', type: QuestType.movement, status: QuestStatus.pending),
      ];

      await homePageModel.loadHomeData();

      expect(homePageModel.state.activeQuests.length, 1);
      expect(homePageModel.state.activeQuests.first.id, 'q1');
      
      expect(homePageModel.state.upcomingQuests.any((q) => q.id == 'q1'), isFalse);
      expect(homePageModel.state.upcomingQuests.length, 2);
    });

    test('upcoming count is total remaining quests (excluding completed & featured)', () async {
      fakeQuestService.quests = [
        const QuestModel(id: 'q1', title: 'Q1', type: QuestType.water, status: QuestStatus.active),
        const QuestModel(id: 'q2', title: 'Q2', type: QuestType.learning, status: QuestStatus.pending),
        const QuestModel(id: 'q3', title: 'Q3', type: QuestType.movement, status: QuestStatus.pending),
        const QuestModel(id: 'q4', title: 'Q4', type: QuestType.sleep, status: QuestStatus.completed),
      ];

      await homePageModel.loadHomeData();

      expect(homePageModel.state.activeQuests.length, 1);
      expect(homePageModel.state.upcomingQuests.length, 2);
      expect(homePageModel.state.completedQuests.length, 1);
    });

    test('no duplicate quest ids between featured and upcoming sections', () async {
      fakeQuestService.quests = [
        const QuestModel(id: 'q1', title: 'Q1', type: QuestType.water, status: QuestStatus.active),
        const QuestModel(id: 'q2', title: 'Q2', type: QuestType.learning, status: QuestStatus.pending),
      ];

      await homePageModel.loadHomeData();

      final activeIds = homePageModel.state.activeQuests.map((q) => q.id).toSet();
      final upcomingIds = homePageModel.state.upcomingQuests.map((q) => q.id).toSet();

      final intersection = activeIds.intersection(upcomingIds);
      expect(intersection.isEmpty, isTrue);
    });
  });

  group('Pull-to-refresh & Button Actions', () {
    test('loading home data calls getTodayQuests', () async {
      expect(fakeQuestService.getTodayQuestsCalled, isFalse);
      await homePageModel.loadHomeData();
      expect(fakeQuestService.getTodayQuestsCalled, isTrue);
    });

    test('startQuest calls startQuest on service and reloads', () async {
      fakeQuestService.quests = [
        const QuestModel(id: 'q1', title: 'Q1', type: QuestType.water, status: QuestStatus.pending),
      ];
      await homePageModel.startQuest('q1');
      expect(fakeQuestService.startedQuestId, 'q1');
    });

    test('completeQuest calls completeQuest on service and reloads', () async {
      fakeQuestService.quests = [
        const QuestModel(id: 'q1', title: 'Q1', type: QuestType.water, status: QuestStatus.active),
      ];
      await homePageModel.completeQuest('q1');
      expect(fakeQuestService.completedQuestId, 'q1');
    });

    test('snoozeQuest calls snoozeQuest on service and reloads', () async {
      fakeQuestService.quests = [
        const QuestModel(id: 'q1', title: 'Q1', type: QuestType.water, status: QuestStatus.active),
      ];
      await homePageModel.snoozeQuest('q1', minutes: 15);
      expect(fakeQuestService.snoozedQuestId, 'q1');
      expect(fakeQuestService.snoozedMinutes, 15);
    });

    test('skipQuest calls skipQuest on service and reloads', () async {
      fakeQuestService.quests = [
        const QuestModel(id: 'q1', title: 'Q1', type: QuestType.water, status: QuestStatus.active),
      ];
      await homePageModel.skipQuest('q1', reason: 'Too busy');
      expect(fakeQuestService.skippedQuestId, 'q1');
      expect(fakeQuestService.skippedReason, 'Too busy');
    });
  });

  group('Duplicate Tap Prevention & Action Loading Map', () {
    test('startQuest updates pendingActions state map correctly', () async {
      fakeQuestService.quests = [
        const QuestModel(id: 'q1', title: 'Q1', type: QuestType.water, status: QuestStatus.pending),
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
        }
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
        }
      };

      final result = await questApiService.startQuest('q-200');
      expect(result.id, 'q-200');
      expect(result.title, 'Start Data Test');
    });

    test('startQuest throws FormatException when response only has message', () async {
      fakeApiClient.responseData = {
        'message': 'success'
      };

      expect(
        () => questApiService.startQuest('q-300'),
        throwsA(isA<FormatException>()),
      );
    });

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
          'message': 'completed successfully'
        }
      };

      final result = await questApiService.completeQuest('q-400');
      expect(result.quest.id, 'q-400');
      expect(result.quest.status, QuestStatus.completed);
      expect(result.expEarned, 25);
      expect(result.leveledUp, isTrue);
      expect(result.newLevel, 3);
    });

    test('completeQuest throws FormatException when response only has message', () async {
      fakeApiClient.responseData = {
        'message': 'success'
      };

      expect(
        () => questApiService.completeQuest('q-500'),
        throwsA(isA<FormatException>()),
      );
    });

    test('startQuest parses new standardized envelope {"item": {"id": ..., "title": ...}} within response', () async {
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
        }
      };

      final result = await questApiService.startQuest('q-std-1');
      expect(result.id, 'q-std-1');
      expect(result.title, 'Standardized Start');
      expect(result.status, QuestStatus.active);
    });
  });
}
