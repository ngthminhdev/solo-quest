import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/requests/api_requests.dart';
import 'package:solo_quest/models/enums/user_enums.dart';

void main() {
  group('SaveDailyCheckinRequest', () {
    test('serializes to JSON correctly', () {
      final request = SaveDailyCheckinRequest(
        date: '2026-06-03',
        mood: CheckinMood.good,
        energyLevel: EnergyLevel.high,
        availability: Availability.normal,
        priority: CheckinPriority.learning,
      );

      final json = request.toJson();

      expect(json['date'], '2026-06-03');
      expect(json['mood'], 'good');
      expect(json['energy_level'], 'high');
      expect(json['availability'], 'normal');
      expect(json['priority'], 'learning');
    });

    test('always includes date field', () {
      final request = SaveDailyCheckinRequest(
        date: '2026-06-03',
        mood: CheckinMood.normal,
        energyLevel: EnergyLevel.medium,
        availability: Availability.normal,
        priority: CheckinPriority.learning,
      );

      final json = request.toJson();

      expect(json.containsKey('date'), isTrue);
      expect(json.containsKey('mood'), isTrue);
      expect(json.containsKey('energy_level'), isTrue);
      expect(json.containsKey('availability'), isTrue);
      expect(json.containsKey('priority'), isTrue);
      expect(json.length, 5);
    });

    test('includes date when provided', () {
      final request = SaveDailyCheckinRequest(
        date: '2026-06-01',
        mood: CheckinMood.normal,
        energyLevel: EnergyLevel.medium,
        availability: Availability.normal,
        priority: CheckinPriority.learning,
      );

      final json = request.toJson();

      expect(json['date'], '2026-06-01');
    });
  });

  group('SaveDailyReviewRequest', () {
    test('serializes to JSON correctly', () {
      final request = SaveDailyReviewRequest(
        date: '2026-06-03',
        mood: 'good',
        energyLevel: 'high',
        satisfaction: 4,
        reflection: 'Hôm nay học tốt',
        tomorrowPriority: 'learning',
      );

      final json = request.toJson();

      expect(json['date'], '2026-06-03');
      expect(json['mood'], 'good');
      expect(json['energy_level'], 'high');
      expect(json['satisfaction'], 4);
      expect(json['reflection'], 'Hôm nay học tốt');
      expect(json['tomorrow_priority'], 'learning');
    });

    test('omits reflection when null', () {
      final request = SaveDailyReviewRequest(
        date: '2026-06-03',
        mood: 'normal',
        energyLevel: 'medium',
        satisfaction: 3,
        tomorrowPriority: 'learning',
      );

      final json = request.toJson();

      expect(json.containsKey('reflection'), isFalse);
      expect(json.containsKey('date'), isTrue);
      expect(json.containsKey('mood'), isTrue);
      expect(json.containsKey('energy_level'), isTrue);
      expect(json.containsKey('satisfaction'), isTrue);
      expect(json.containsKey('tomorrow_priority'), isTrue);
      expect(json.length, 5);
    });

    test('omits reflection when empty string', () {
      final request = SaveDailyReviewRequest(
        date: '2026-06-03',
        mood: 'normal',
        energyLevel: 'medium',
        satisfaction: 3,
        reflection: '',
        tomorrowPriority: 'learning',
      );

      final json = request.toJson();

      expect(json.containsKey('reflection'), isFalse);
    });
  });

  group('CompleteQuestRequest', () {
    test('serializes with note', () {
      final request = CompleteQuestRequest(note: 'Completed successfully');

      final json = request.toJson();

      expect(json['note'], 'Completed successfully');
    });

    test('omits note when null', () {
      final request = CompleteQuestRequest();

      final json = request.toJson();

      expect(json.containsKey('note'), isFalse);
    });
  });

  group('SkipQuestRequest', () {
    test('serializes with reason', () {
      final request = SkipQuestRequest(reason: 'Not enough time');

      final json = request.toJson();

      expect(json['reason'], 'Not enough time');
    });

    test('omits reason when null', () {
      final request = SkipQuestRequest();

      final json = request.toJson();

      expect(json.containsKey('reason'), isFalse);
    });
  });

  group('SnoozeQuestRequest', () {
    test('serializes minutes correctly', () {
      final request = SnoozeQuestRequest(minutes: 15);

      final json = request.toJson();

      expect(json['minutes'], 15);
    });

    test('serializes different minute values', () {
      final request30 = SnoozeQuestRequest(minutes: 30);
      final request60 = SnoozeQuestRequest(minutes: 60);

      expect(request30.toJson()['minutes'], 30);
      expect(request60.toJson()['minutes'], 60);
    });
  });
}
