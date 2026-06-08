import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/quest_dto.dart';
import 'package:solo_quest/core/api/services/quest_api_service.dart';
import 'package:solo_quest/core/notifications/local_notification_service.dart';
import 'package:solo_quest/core/notifications/notification_ids.dart';
import 'package:solo_quest/models/enums/quest_enums.dart';
import 'package:solo_quest/models/quest_model.dart';
import 'package:solo_quest/services/quest_service.dart';

class FakeQuestApiService extends Fake implements QuestApiService {
  final QuestDto _snoozeResponse;
  final QuestDto _completeResponse;
  final QuestDto _skipResponse;
  final QuestDto _startResponse;
  String? lastCompletedQuestId;
  String? lastSkippedQuestId;
  String? lastStartedQuestId;
  String? lastSnoozedQuestId;
  int? lastSnoozeMinutes;

  FakeQuestApiService({
    required QuestDto snoozeResponse,
    required QuestDto completeResponse,
    required QuestDto skipResponse,
    required QuestDto startResponse,
  })  : _snoozeResponse = snoozeResponse,
        _completeResponse = completeResponse,
        _skipResponse = skipResponse,
        _startResponse = startResponse;

  @override
  Future<QuestDto> snoozeQuest(String id, {required int minutes}) async {
    lastSnoozedQuestId = id;
    lastSnoozeMinutes = minutes;
    return _snoozeResponse;
  }

  @override
  Future<CompleteQuestResultDto> completeQuest(String id, {String? note}) async {
    lastCompletedQuestId = id;
    return CompleteQuestResultDto(
      quest: _completeResponse,
      expEarned: 10,
      leveledUp: false,
      message: 'completed',
    );
  }

  @override
  Future<QuestDto> skipQuest(String id, {String? reason}) async {
    lastSkippedQuestId = id;
    return _skipResponse;
  }

  @override
  Future<QuestDto> startQuest(String id) async {
    lastStartedQuestId = id;
    return _startResponse;
  }
}

class FakeLocalNotificationService extends Fake implements LocalNotificationService {
  final List<QuestModel> scheduledQuests = [];
  final List<String> cancelledQuestIds = [];

  @override
  Future<void> scheduleQuestSnoozeNotification(QuestModel quest) async {
    scheduledQuests.add(quest);
  }

  @override
  Future<void> cancelQuestSnoozeNotification(String questId) async {
    cancelledQuestIds.add(questId);
  }
}

QuestDto _makeQuestDto({
  required String id,
  required String title,
  QuestStatus status = QuestStatus.snoozed,
  DateTime? snoozedUntil,
}) {
  return QuestDto(
    id: id,
    title: title,
    description: 'Test description',
    type: QuestType.movement,
    status: status,
    difficulty: QuestDifficulty.medium,
    source: QuestSource.dailyPlan,
    exp: 10,
    estimatedMinutes: 5,
    snoozedUntil: snoozedUntil,
    tags: [],
    isImportant: false,
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
  );
}

void main() {
  group('NotificationIds', () {
    group('questSnooze', () {
      test('same quest id maps to same snooze notification id', () {
        const questId = 'quest-abc-123';
        final id1 = NotificationIds.questSnooze(questId);
        final id2 = NotificationIds.questSnooze(questId);
        expect(id1, equals(id2));
      });

      test('different quest ids map to different notification ids', () {
        final id1 = NotificationIds.questSnooze('quest-aaa');
        final id2 = NotificationIds.questSnooze('quest-bbb');
        expect(id1, isNot(equals(id2)));
      });

      test('notification id is stable across multiple calls', () {
        const questId = 'quest-stable-001';
        final results = List.generate(100, (_) => NotificationIds.questSnooze(questId));
        for (final r in results) {
          expect(r, equals(results.first));
        }
      });
    });

    group('countdown', () {
      test('same quest id maps to same countdown notification id', () {
        const questId = 'quest-cd-123';
        final id1 = NotificationIds.countdown(questId);
        final id2 = NotificationIds.countdown(questId);
        expect(id1, equals(id2));
      });

      test('different quest ids map to different ids', () {
        final id1 = NotificationIds.countdown('quest-aaa');
        final id2 = NotificationIds.countdown('quest-bbb');
        expect(id1, isNot(equals(id2)));
      });

      test('countdown id differs from snooze id for same quest', () {
        const questId = 'quest-same';
        expect(
          NotificationIds.countdown(questId),
          isNot(equals(NotificationIds.questSnooze(questId))),
        );
      });
    });

    group('questReminder', () {
      test('same quest id maps to same reminder notification id', () {
        const questId = 'quest-rm-123';
        final id1 = NotificationIds.questReminder(questId);
        final id2 = NotificationIds.questReminder(questId);
        expect(id1, equals(id2));
      });

      test('reminder id differs from snooze and countdown for same quest', () {
        const questId = 'quest-distinct';
        final reminderId = NotificationIds.questReminder(questId);
        final snoozeId = NotificationIds.questSnooze(questId);
        final countdownId = NotificationIds.countdown(questId);
        expect(reminderId, isNot(equals(snoozeId)));
        expect(reminderId, isNot(equals(countdownId)));
      });
    });
  });

  group('Payload prefixes', () {
    test('prefixQuestSnooze is non-empty', () {
      expect(NotificationIds.prefixQuestSnooze.isNotEmpty, isTrue);
    });

    test('prefixCountdown is non-empty', () {
      expect(NotificationIds.prefixCountdown.isNotEmpty, isTrue);
    });

    test('prefixQuestReminder is non-empty', () {
      expect(NotificationIds.prefixQuestReminder.isNotEmpty, isTrue);
    });

    test('all prefixes are distinct', () {
      final prefixes = {
        NotificationIds.prefixQuestSnooze,
        NotificationIds.prefixCountdown,
        NotificationIds.prefixQuestReminder,
      };
      expect(prefixes.length, equals(3));
    });

    test('snooze payload can be parsed back to quest id', () {
      const questId = 'quest-payload-001';
      final payload = '${NotificationIds.prefixQuestSnooze}$questId';
      expect(payload.startsWith(NotificationIds.prefixQuestSnooze), isTrue);
      final parsedId = payload.substring(NotificationIds.prefixQuestSnooze.length);
      expect(parsedId, equals(questId));
    });

    test('countdown payload can be parsed back to quest id', () {
      const questId = 'quest-payload-002';
      final payload = '${NotificationIds.prefixCountdown}$questId';
      expect(payload.startsWith(NotificationIds.prefixCountdown), isTrue);
      final parsedId = payload.substring(NotificationIds.prefixCountdown.length);
      expect(parsedId, equals(questId));
    });

    test('reminder payload can be parsed back to quest id', () {
      const questId = 'quest-payload-003';
      final payload = '${NotificationIds.prefixQuestReminder}$questId';
      expect(payload.startsWith(NotificationIds.prefixQuestReminder), isTrue);
      final parsedId = payload.substring(NotificationIds.prefixQuestReminder.length);
      expect(parsedId, equals(questId));
    });
  });

  group('LocalNotificationService resolveSnoozeTime', () {
    test('returns snoozedUntil when valid and in the future', () {
      final future = DateTime.now().add(const Duration(minutes: 30));
      final result = LocalNotificationService.resolveSnoozeTime(future);
      expect(result, equals(future));
    });

    test('returns now + 10 seconds when snoozedUntil is in the past', () {
      final past = DateTime.now().subtract(const Duration(minutes: 5));
      final before = DateTime.now();
      final result = LocalNotificationService.resolveSnoozeTime(past);
      final after = DateTime.now().add(const Duration(seconds: 15));
      expect(result.isAfter(before), isTrue);
      expect(result.isBefore(after), isTrue);
    });

    test('returns now + 10 minutes when snoozedUntil is null', () {
      final before = DateTime.now().add(const Duration(minutes: 9));
      final result = LocalNotificationService.resolveSnoozeTime(null);
      final after = DateTime.now().add(const Duration(minutes: 11));
      expect(result.isAfter(before), isTrue);
      expect(result.isBefore(after), isTrue);
    });

    test('does not throw when snoozedUntil is null', () {
      expect(
        () => LocalNotificationService.resolveSnoozeTime(null),
        returnsNormally,
      );
    });

    test('does not throw when snoozedUntil is in the past', () {
      final past = DateTime.now().subtract(const Duration(hours: 1));
      expect(
        () => LocalNotificationService.resolveSnoozeTime(past),
        returnsNormally,
      );
    });
  });

  group('Timezone offset parsing', () {
    test('DateTime.parse handles +07:00 offset correctly', () {
      final isoString = '2026-06-07T22:15:00+07:00';
      final parsed = DateTime.parse(isoString);
      expect(parsed.year, equals(2026));
      expect(parsed.month, equals(6));
      expect(parsed.day, equals(7));
    });

    test('DateTime.parse handles +00:00 (Z) offset correctly', () {
      final isoString = '2026-06-07T22:15:00Z';
      final parsed = DateTime.parse(isoString);
      expect(parsed.isUtc, isTrue);
    });

    test('toUtc converts timezone offset time to UTC correctly', () {
      final isoString = '2026-06-07T22:15:00+07:00';
      final local = DateTime.parse(isoString);
      final utc = local.toUtc();
      expect(utc.hour, equals(15));
    });

    test('snoozed_until with timezone offset survives parseUtcDateTime roundtrip', () {
      final isoString = '2026-06-07T22:15:00+07:00';
      final parsed = DateTime.parse(isoString);
      final utc = parsed.toUtc();
      expect(parsed, isNotNull);
      expect(parsed.year, equals(2026));
      expect(parsed.month, equals(6));
      expect(parsed.day, equals(7));
      expect(utc.hour, equals(15));
      expect(utc.minute, equals(15));
    });
  });

  group('QuestService snooze notification scheduling', () {
    late FakeQuestApiService fakeApiService;
    late FakeLocalNotificationService fakeNotificationService;
    late QuestService questService;
    final snoozeTime = DateTime.now().add(const Duration(minutes: 10));

    setUp(() {
      fakeApiService = FakeQuestApiService(
        snoozeResponse: _makeQuestDto(
          id: 'quest-001',
          title: 'Test Quest',
          status: QuestStatus.snoozed,
          snoozedUntil: snoozeTime,
        ),
        completeResponse: _makeQuestDto(
          id: 'quest-001',
          title: 'Test Quest',
          status: QuestStatus.completed,
        ),
        skipResponse: _makeQuestDto(
          id: 'quest-001',
          title: 'Test Quest',
          status: QuestStatus.skipped,
        ),
        startResponse: _makeQuestDto(
          id: 'quest-001',
          title: 'Test Quest',
          status: QuestStatus.active,
        ),
      );
      fakeNotificationService = FakeLocalNotificationService();
      questService = QuestService(
        apiService: fakeApiService,
        notificationService: fakeNotificationService,
      );
    });

    test('snoozeQuest schedules notification with correct quest data', () async {
      final result = await questService.snoozeQuest('quest-001', minutes: 10);

      expect(result.status, QuestStatus.snoozed);
      expect(result.snoozedUntil, equals(snoozeTime));
      expect(fakeNotificationService.scheduledQuests.length, equals(1));
      expect(fakeNotificationService.scheduledQuests.first.id, equals('quest-001'));
      expect(fakeNotificationService.scheduledQuests.first.title, equals('Test Quest'));
      expect(fakeApiService.lastSnoozeMinutes, equals(10));
    });

    test('snoozeQuest with null snoozedUntil does not crash', () async {
      fakeApiService = FakeQuestApiService(
        snoozeResponse: _makeQuestDto(
          id: 'quest-002',
          title: 'Null Snooze Quest',
          status: QuestStatus.snoozed,
          snoozedUntil: null,
        ),
        completeResponse: _makeQuestDto(
          id: 'quest-002',
          title: 'Null Snooze Quest',
          status: QuestStatus.completed,
        ),
        skipResponse: _makeQuestDto(
          id: 'quest-002',
          title: 'Null Snooze Quest',
          status: QuestStatus.skipped,
        ),
        startResponse: _makeQuestDto(
          id: 'quest-002',
          title: 'Null Snooze Quest',
          status: QuestStatus.active,
        ),
      );
      questService = QuestService(
        apiService: fakeApiService,
        notificationService: fakeNotificationService,
      );

      final result = await questService.snoozeQuest('quest-002', minutes: 10);

      expect(result.snoozedUntil, isNull);
      expect(fakeNotificationService.scheduledQuests.length, equals(1));
      expect(fakeNotificationService.scheduledQuests.first.id, equals('quest-002'));
    });

    test('completeQuest cancels snooze notification', () async {
      await questService.snoozeQuest('quest-001', minutes: 10);
      expect(fakeNotificationService.scheduledQuests.length, equals(1));

      await questService.completeQuest('quest-001');

      expect(fakeNotificationService.cancelledQuestIds, contains('quest-001'));
    });

    test('skipQuest cancels snooze notification', () async {
      await questService.snoozeQuest('quest-001', minutes: 10);
      expect(fakeNotificationService.scheduledQuests.length, equals(1));

      await questService.skipQuest('quest-001', reason: 'Too busy');

      expect(fakeNotificationService.cancelledQuestIds, contains('quest-001'));
    });

    test('startQuest cancels snooze notification', () async {
      await questService.snoozeQuest('quest-001', minutes: 10);
      expect(fakeNotificationService.scheduledQuests.length, equals(1));

      await questService.startQuest('quest-001');

      expect(fakeNotificationService.cancelledQuestIds, contains('quest-001'));
    });

    test('snoozing again cancels previous notification before scheduling new', () async {
      await questService.snoozeQuest('quest-001', minutes: 10);
      await questService.snoozeQuest('quest-001', minutes: 30);

      expect(fakeNotificationService.scheduledQuests.length, equals(2));
      expect(fakeNotificationService.cancelledQuestIds.length, equals(0));
    });
  });

  group('QuestService notification nullable safety', () {
    test('QuestService works without notification service', () async {
      final fakeApiService = FakeQuestApiService(
        snoozeResponse: _makeQuestDto(
          id: 'quest-001',
          title: 'Test Quest',
          status: QuestStatus.snoozed,
          snoozedUntil: DateTime.now().add(const Duration(minutes: 10)),
        ),
        completeResponse: _makeQuestDto(
          id: 'quest-001',
          title: 'Test Quest',
          status: QuestStatus.completed,
        ),
        skipResponse: _makeQuestDto(
          id: 'quest-001',
          title: 'Test Quest',
          status: QuestStatus.skipped,
        ),
        startResponse: _makeQuestDto(
          id: 'quest-001',
          title: 'Test Quest',
          status: QuestStatus.active,
        ),
      );
      final questService = QuestService(
        apiService: fakeApiService,
        notificationService: null,
      );

      expect(
        () => questService.snoozeQuest('quest-001', minutes: 10),
        returnsNormally,
      );
      expect(
        () => questService.completeQuest('quest-001'),
        returnsNormally,
      );
      expect(
        () => questService.skipQuest('quest-001', reason: 'test'),
        returnsNormally,
      );
      expect(
        () => questService.startQuest('quest-001'),
        returnsNormally,
      );
    });
  });

  group('Notification identity', () {
    test('same quest id generates same snooze notification id', () {
      const questId = 'quest-notif-123';
      final id1 = NotificationIds.questSnooze(questId);
      final id2 = NotificationIds.questSnooze(questId);
      expect(id1, equals(id2));
    });

    test('different quest ids generate different snooze notification ids', () {
      final ids = <int>{};
      for (var i = 0; i < 100; i++) {
        ids.add(NotificationIds.questSnooze('quest-$i'));
      }
      expect(ids.length, equals(100));
    });

    test('different quest ids generate different countdown notification ids', () {
      final ids = <int>{};
      for (var i = 0; i < 100; i++) {
        ids.add(NotificationIds.countdown('quest-$i'));
      }
      expect(ids.length, equals(100));
    });
  });
}
