import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/utils/enum_mapper.dart';
import 'package:solo_quest/models/enums/quest_enums.dart';
import 'package:solo_quest/models/enums/log_enums.dart';
import 'package:solo_quest/models/enums/user_enums.dart';

void main() {
  group('parseQuestStatus', () {
    test('parses known quest status correctly', () {
      expect(parseQuestStatus('pending'), QuestStatus.pending);
      expect(parseQuestStatus('active'), QuestStatus.active);
      expect(parseQuestStatus('completed'), QuestStatus.completed);
      expect(parseQuestStatus('skipped'), QuestStatus.skipped);
      expect(parseQuestStatus('snoozed'), QuestStatus.snoozed);
      expect(parseQuestStatus('expired'), QuestStatus.expired);
    });

    test('returns fallback for unknown quest status', () {
      expect(parseQuestStatus('unknown'), QuestStatus.pending);
      expect(parseQuestStatus('invalid'), QuestStatus.pending);
    });

    test('returns fallback for null input', () {
      expect(parseQuestStatus(null), QuestStatus.pending);
    });

    test('returns fallback for empty string', () {
      expect(parseQuestStatus(''), QuestStatus.pending);
    });

    test('uses custom fallback', () {
      expect(parseQuestStatus('unknown', fallback: QuestStatus.completed), QuestStatus.completed);
    });
  });

  group('parseQuestType', () {
    test('parses known quest type correctly', () {
      expect(parseQuestType('water'), QuestType.water);
      expect(parseQuestType('breakTime'), QuestType.breakTime);
      expect(parseQuestType('movement'), QuestType.movement);
      expect(parseQuestType('learning'), QuestType.learning);
      expect(parseQuestType('custom'), QuestType.custom);
    });

    test('returns fallback for unknown quest type', () {
      expect(parseQuestType('unknown'), QuestType.custom);
    });

    test('returns fallback for null input', () {
      expect(parseQuestType(null), QuestType.custom);
    });
  });

  group('parseQuestDifficulty', () {
    test('parses known quest difficulty correctly', () {
      expect(parseQuestDifficulty('easy'), QuestDifficulty.easy);
      expect(parseQuestDifficulty('medium'), QuestDifficulty.medium);
      expect(parseQuestDifficulty('hard'), QuestDifficulty.hard);
    });

    test('returns fallback for unknown difficulty', () {
      expect(parseQuestDifficulty('unknown'), QuestDifficulty.medium);
    });

    test('returns fallback for null input', () {
      expect(parseQuestDifficulty(null), QuestDifficulty.medium);
    });
  });

  group('parseLogEntryType', () {
    test('parses known log entry type correctly', () {
      expect(parseLogEntryType('questCreated'), LogEntryType.questCreated);
      expect(parseLogEntryType('questCompleted'), LogEntryType.questCompleted);
      expect(parseLogEntryType('morningCheckin'), LogEntryType.morningCheckin);
      expect(parseLogEntryType('dailyReview'), LogEntryType.dailyReview);
    });

    test('returns fallback for unknown log entry type', () {
      expect(parseLogEntryType('unknown'), LogEntryType.unknown);
    });
  });

  group('parseLogMood', () {
    test('parses known mood correctly', () {
      expect(parseLogMood('veryBad'), LogMood.veryBad);
      expect(parseLogMood('bad'), LogMood.bad);
      expect(parseLogMood('neutral'), LogMood.neutral);
      expect(parseLogMood('good'), LogMood.good);
      expect(parseLogMood('veryGood'), LogMood.veryGood);
    });

    test('returns fallback for unknown mood', () {
      expect(parseLogMood('unknown'), LogMood.neutral);
    });
  });

  group('parseEnergyLevel', () {
    test('parses known energy level correctly', () {
      expect(parseEnergyLevel('low'), EnergyLevel.low);
      expect(parseEnergyLevel('medium'), EnergyLevel.medium);
      expect(parseEnergyLevel('high'), EnergyLevel.high);
    });

    test('returns fallback for unknown energy level', () {
      expect(parseEnergyLevel('unknown'), EnergyLevel.medium);
    });

    test('returns fallback for null input', () {
      expect(parseEnergyLevel(null), EnergyLevel.medium);
    });
  });

  group('parseCheckinMood', () {
    test('parses new snake_case values', () {
      expect(parseCheckinMood('very_bad'), CheckinMood.veryBad);
      expect(parseCheckinMood('bad'), CheckinMood.bad);
      expect(parseCheckinMood('normal'), CheckinMood.normal);
      expect(parseCheckinMood('good'), CheckinMood.good);
      expect(parseCheckinMood('very_good'), CheckinMood.veryGood);
    });

    test('parses camelCase values', () {
      expect(parseCheckinMood('veryBad'), CheckinMood.veryBad);
      expect(parseCheckinMood('veryGood'), CheckinMood.veryGood);
    });

    test('parses legacy Vietnamese labels', () {
      expect(parseCheckinMood('Rất tệ'), CheckinMood.veryBad);
      expect(parseCheckinMood('Tệ'), CheckinMood.bad);
      expect(parseCheckinMood('Bình thường'), CheckinMood.normal);
      expect(parseCheckinMood('Tốt'), CheckinMood.good);
      expect(parseCheckinMood('Rất tốt'), CheckinMood.veryGood);
    });

    test('parses legacy Mood enum names', () {
      expect(parseCheckinMood('veryLow'), CheckinMood.veryBad);
      expect(parseCheckinMood('low'), CheckinMood.bad);
      expect(parseCheckinMood('medium'), CheckinMood.normal);
      expect(parseCheckinMood('high'), CheckinMood.good);
      expect(parseCheckinMood('veryHigh'), CheckinMood.veryGood);
    });

    test('returns fallback for unknown value', () {
      expect(parseCheckinMood('unknown'), CheckinMood.normal);
    });

    test('returns fallback for null input', () {
      expect(parseCheckinMood(null), CheckinMood.normal);
    });

    test('returns fallback for empty string', () {
      expect(parseCheckinMood(''), CheckinMood.normal);
    });
  });

  group('parseAvailability', () {
    test('parses known values correctly', () {
      expect(parseAvailability('busy'), Availability.busy);
      expect(parseAvailability('normal'), Availability.normal);
      expect(parseAvailability('free'), Availability.free);
    });

    test('returns fallback for unknown value', () {
      expect(parseAvailability('unknown'), Availability.normal);
    });

    test('returns fallback for null input', () {
      expect(parseAvailability(null), Availability.normal);
    });
  });

  group('parseCheckinPriority', () {
    test('parses known values correctly', () {
      expect(parseCheckinPriority('learning'), CheckinPriority.learning);
      expect(parseCheckinPriority('health'), CheckinPriority.health);
      expect(parseCheckinPriority('work'), CheckinPriority.work);
      expect(parseCheckinPriority('habit'), CheckinPriority.habit);
      expect(parseCheckinPriority('rest'), CheckinPriority.rest);
    });

    test('returns fallback for unknown value', () {
      expect(parseCheckinPriority('unknown'), CheckinPriority.learning);
    });

    test('returns fallback for null input', () {
      expect(parseCheckinPriority(null), CheckinPriority.learning);
    });
  });

  group('Legacy parsers', () {
    test('parseStressLevel still works', () {
      expect(parseStressLevel('veryLow'), StressLevel.veryLow);
      expect(parseStressLevel('medium'), StressLevel.medium);
      expect(parseStressLevel('unknown'), StressLevel.medium);
    });

    test('parseFocusLevel still works', () {
      expect(parseFocusLevel('veryLow'), FocusLevel.veryLow);
      expect(parseFocusLevel('medium'), FocusLevel.medium);
      expect(parseFocusLevel('unknown'), FocusLevel.medium);
    });

    test('parseDayIntensity still works', () {
      expect(parseDayIntensity('light'), DayIntensity.light);
      expect(parseDayIntensity('normal'), DayIntensity.normal);
      expect(parseDayIntensity('unknown'), DayIntensity.normal);
    });

    test('parseSleepQuality still works', () {
      expect(parseSleepQuality('veryLow'), SleepQuality.veryLow);
      expect(parseSleepQuality('medium'), SleepQuality.medium);
      expect(parseSleepQuality('unknown'), SleepQuality.medium);
    });

    test('parseMood (legacy) still works', () {
      expect(parseMood('veryLow'), Mood.veryLow);
      expect(parseMood('medium'), Mood.medium);
      expect(parseMood('unknown'), Mood.medium);
    });
  });
}
