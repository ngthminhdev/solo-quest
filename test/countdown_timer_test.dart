import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo_quest/models/enums/quest_enums.dart';
import 'package:solo_quest/models/quest_model.dart';
import 'package:solo_quest/core/timer/countdown_session.dart';
import 'package:solo_quest/core/timer/countdown_timer_service.dart';
import 'package:solo_quest/core/notifications/local_notification_service.dart';
import 'package:solo_quest/services/quest_service.dart';
import 'package:solo_quest/services/service_providers.dart';

class FakeQuestService extends Fake implements QuestService {
  String? completedQuestId;
  int completeCalls = 0;

  @override
  Future<QuestModel> completeQuest(String questId, {String? note, String? mood}) async {
    completedQuestId = questId;
    completeCalls++;
    return QuestModel(
      id: questId,
      title: 'Mock Completed Quest',
      type: QuestType.movement,
      status: QuestStatus.completed,
    );
  }
}

class FakeLocalNotificationService extends Fake implements LocalNotificationService {
  final List<CountdownSession> scheduledCountdowns = [];
  final List<String> cancelledCountdownIds = [];

  @override
  Future<void> scheduleCountdownNotification(CountdownSession session) async {
    scheduledCountdowns.add(session);
  }

  @override
  Future<void> cancelCountdownNotification(String questId) async {
    cancelledCountdownIds.add(questId);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Countdown Eligibility Tests', () {
    test('movement quest with estimated_minutes > 0 is eligible', () {
      const quest = QuestModel(
        id: 'q1',
        title: 'Vận động nhẹ nhàng',
        type: QuestType.movement,
        estimatedMinutes: 10,
        status: QuestStatus.pending,
      );
      expect(isCountdownEligible(quest), isTrue);
    });

    test('learning quest with estimated_minutes > 0 is eligible', () {
      const quest = QuestModel(
        id: 'q2',
        title: 'Học lập trình',
        type: QuestType.learning,
        estimatedMinutes: 30,
        status: QuestStatus.pending,
      );
      expect(isCountdownEligible(quest), isTrue);
    });

    test('sleep quest with estimated_minutes > 0 is eligible', () {
      const quest = QuestModel(
        id: 'q3',
        title: 'Ngủ đủ giấc',
        type: QuestType.sleep,
        estimatedMinutes: 480,
        status: QuestStatus.pending,
      );
      expect(isCountdownEligible(quest), isTrue);
    });

    test('water quest is not eligible even if estimated_minutes exists', () {
      const quest = QuestModel(
        id: 'q4',
        title: 'Uống nước',
        type: QuestType.water,
        estimatedMinutes: 5,
        status: QuestStatus.pending,
      );
      expect(isCountdownEligible(quest), isFalse);
    });

    test('completed/skipped/snoozed quests are not eligible', () {
      const completedQuest = QuestModel(
        id: 'q5',
        title: 'Tập thể dục',
        type: QuestType.fitness,
        estimatedMinutes: 15,
        status: QuestStatus.completed,
      );
      const skippedQuest = QuestModel(
        id: 'q6',
        title: 'Học bài',
        type: QuestType.learning,
        estimatedMinutes: 20,
        status: QuestStatus.skipped,
      );
      const snoozedQuest = QuestModel(
        id: 'q7',
        title: 'Đọc sách',
        type: QuestType.learning,
        estimatedMinutes: 10,
        status: QuestStatus.snoozed,
      );

      expect(isCountdownEligible(completedQuest), isFalse);
      expect(isCountdownEligible(skippedQuest), isFalse);
      expect(isCountdownEligible(snoozedQuest), isFalse);
    });
  });

  group('Countdown Session Service Tests', () {
    late FakeQuestService fakeQuestService;
    late FakeLocalNotificationService fakeNotificationService;
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      fakeQuestService = FakeQuestService();
      fakeNotificationService = FakeLocalNotificationService();
      
      container = ProviderContainer(
        overrides: [
          questServiceProvider.overrideWithValue(fakeQuestService),
          localNotificationServiceProvider.overrideWithValue(fakeNotificationService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('start session stores startedAt and endAt correctly', () async {
      final service = container.read(countdownTimerServiceProvider.notifier);
      const quest = QuestModel(
        id: 'q_test_1',
        title: 'Vận động',
        type: QuestType.movement,
        estimatedMinutes: 10,
        status: QuestStatus.pending,
      );

      await service.startSession(quest);

      final session = container.read(countdownTimerServiceProvider);
      expect(session, isNotNull);
      expect(session!.questId, 'q_test_1');
      expect(session.durationMinutes, 10);
      expect(session.status, CountdownStatus.running);

      final difference = session.endAt.difference(session.startedAt);
      expect(difference.inMinutes, 10);
    });

    test('remaining time is calculated from endAt', () async {
      final service = container.read(countdownTimerServiceProvider.notifier);
      const quest = QuestModel(
        id: 'q_test_2',
        title: 'Học tập',
        type: QuestType.learning,
        estimatedMinutes: 5,
        status: QuestStatus.pending,
      );

      await service.startSession(quest);
      final remaining = service.getRemainingTime();
      expect(remaining.inMinutes, lessThanOrEqualTo(5));
      expect(remaining.inSeconds, greaterThan(0));
    });

    test('cancel session clears storage and session state', () async {
      final service = container.read(countdownTimerServiceProvider.notifier);
      const quest = QuestModel(
        id: 'q_test_3',
        title: 'Nghỉ ngơi',
        type: QuestType.breakTime,
        estimatedMinutes: 5,
        status: QuestStatus.pending,
      );

      await service.startSession(quest);
      expect(container.read(countdownTimerServiceProvider), isNotNull);

      await service.cancelSession();
      expect(container.read(countdownTimerServiceProvider), isNull);
    });

    test('completing quest cancels session and calls completeQuest API exactly once', () async {
      final service = container.read(countdownTimerServiceProvider.notifier);
      const quest = QuestModel(
        id: 'q_test_4',
        title: 'Nghỉ ngơi',
        type: QuestType.breakTime,
        estimatedMinutes: 5,
        status: QuestStatus.pending,
      );

      await service.startSession(quest);
      expect(container.read(countdownTimerServiceProvider), isNotNull);

      await service.completeSession();

      expect(container.read(countdownTimerServiceProvider), isNull);
      expect(fakeQuestService.completedQuestId, 'q_test_4');
      expect(fakeQuestService.completeCalls, 1);
    });

    test('start session schedules countdown notification', () async {
      final service = container.read(countdownTimerServiceProvider.notifier);
      const quest = QuestModel(
        id: 'q_test_5',
        title: 'Countdown quest',
        type: QuestType.movement,
        estimatedMinutes: 10,
        status: QuestStatus.pending,
      );

      await service.startSession(quest);

      expect(fakeNotificationService.scheduledCountdowns.length, equals(1));
      expect(fakeNotificationService.scheduledCountdowns.first.questId, equals('q_test_5'));
      expect(fakeNotificationService.scheduledCountdowns.first.title, equals('Countdown quest'));
    });

    test('cancel session cancels countdown notification', () async {
      final service = container.read(countdownTimerServiceProvider.notifier);
      const quest = QuestModel(
        id: 'q_test_6',
        title: 'Cancel quest',
        type: QuestType.breakTime,
        estimatedMinutes: 5,
        status: QuestStatus.pending,
      );

      await service.startSession(quest);
      await service.cancelSession();

      expect(fakeNotificationService.cancelledCountdownIds, contains('q_test_6'));
    });
  });
}
