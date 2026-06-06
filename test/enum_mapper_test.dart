import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/utils/enum_mapper.dart';
import 'package:solo_quest/models/enums/log_enums.dart';
import 'package:solo_quest/models/enums/quest_enums.dart';
import 'package:solo_quest/models/enums/user_enums.dart';

void main() {
  group('Enum Mapper - LogEntryType', () {
    test('parses camelCase correctly', () {
      expect(parseLogEntryType('questCompleted'), LogEntryType.questCompleted);
      expect(parseLogEntryType('questSkipped'), LogEntryType.questSkipped);
      expect(parseLogEntryType('dailyReview'), LogEntryType.dailyReview);
      expect(parseLogEntryType('morningCheckin'), LogEntryType.morningCheckin);
    });

    test('parses snake_case correctly', () {
      expect(parseLogEntryType('quest_completed'), LogEntryType.questCompleted);
      expect(parseLogEntryType('quest_skipped'), LogEntryType.questSkipped);
      expect(parseLogEntryType('daily_review'), LogEntryType.dailyReview);
      expect(parseLogEntryType('morning_checkin'), LogEntryType.morningCheckin);
    });

    test('parses UPPERCASE correctly', () {
      expect(parseLogEntryType('QUEST_COMPLETED'), LogEntryType.questCompleted);
      expect(parseLogEntryType('QUEST_SKIPPED'), LogEntryType.questSkipped);
    });

    test('parses kebab-case correctly', () {
      expect(parseLogEntryType('quest-completed'), LogEntryType.questCompleted);
      expect(parseLogEntryType('quest-skipped'), LogEntryType.questSkipped);
    });

    test('handles null with fallback', () {
      expect(parseLogEntryType(null), LogEntryType.unknown);
    });

    test('handles empty string with fallback', () {
      expect(parseLogEntryType(''), LogEntryType.unknown);
      expect(parseLogEntryType('   '), LogEntryType.unknown);
    });

    test('handles unknown value with fallback', () {
      expect(parseLogEntryType('unknown_type'), LogEntryType.unknown);
      expect(parseLogEntryType('invalid'), LogEntryType.unknown);
    });

    test('handles custom fallback', () {
      expect(
        parseLogEntryType('invalid', fallback: LogEntryType.questStarted),
        LogEntryType.questStarted,
      );
    });
  });

  group('Enum Mapper - LogMood', () {
    test('parses camelCase correctly', () {
      expect(parseLogMood('veryGood'), LogMood.veryGood);
      expect(parseLogMood('good'), LogMood.good);
      expect(parseLogMood('neutral'), LogMood.neutral);
      expect(parseLogMood('bad'), LogMood.bad);
      expect(parseLogMood('veryBad'), LogMood.veryBad);
    });

    test('parses snake_case correctly', () {
      expect(parseLogMood('very_good'), LogMood.veryGood);
      expect(parseLogMood('very_bad'), LogMood.veryBad);
    });

    test('parses UPPERCASE correctly', () {
      expect(parseLogMood('VERY_GOOD'), LogMood.veryGood);
      expect(parseLogMood('VERY_BAD'), LogMood.veryBad);
      expect(parseLogMood('NEUTRAL'), LogMood.neutral);
    });

    test('parses kebab-case correctly', () {
      expect(parseLogMood('very-good'), LogMood.veryGood);
      expect(parseLogMood('very-bad'), LogMood.veryBad);
    });

    test('handles null with fallback', () {
      expect(parseLogMood(null), LogMood.neutral);
    });

    test('handles unknown value with fallback', () {
      expect(parseLogMood('unknown_mood'), LogMood.neutral);
    });
  });

  group('Enum Mapper - QuestType', () {
    test('parses camelCase correctly', () {
      expect(parseQuestType('water'), QuestType.water);
      expect(parseQuestType('breakTime'), QuestType.breakTime);
      expect(parseQuestType('movement'), QuestType.movement);
      expect(parseQuestType('learning'), QuestType.learning);
    });

    test('parses snake_case correctly', () {
      expect(parseQuestType('break_time'), QuestType.breakTime);
    });

    test('parses UPPERCASE correctly', () {
      expect(parseQuestType('WATER'), QuestType.water);
      expect(parseQuestType('BREAK_TIME'), QuestType.breakTime);
    });

    test('handles null with fallback', () {
      expect(parseQuestType(null), QuestType.custom);
    });

    test('handles unknown value with fallback', () {
      expect(parseQuestType('unknown_type'), QuestType.custom);
    });
  });

  group('Enum Mapper - QuestStatus', () {
    test('parses camelCase correctly', () {
      expect(parseQuestStatus('pending'), QuestStatus.pending);
      expect(parseQuestStatus('active'), QuestStatus.active);
      expect(parseQuestStatus('completed'), QuestStatus.completed);
      expect(parseQuestStatus('skipped'), QuestStatus.skipped);
    });

    test('parses snake_case correctly', () {
      expect(parseQuestStatus('pending'), QuestStatus.pending);
    });

    test('parses UPPERCASE correctly', () {
      expect(parseQuestStatus('PENDING'), QuestStatus.pending);
      expect(parseQuestStatus('COMPLETED'), QuestStatus.completed);
    });

    test('handles null with fallback', () {
      expect(parseQuestStatus(null), QuestStatus.pending);
    });
  });

  group('Enum Mapper - EnergyLevel', () {
    test('parses known values correctly', () {
      expect(parseEnergyLevel('low'), EnergyLevel.low);
      expect(parseEnergyLevel('medium'), EnergyLevel.medium);
      expect(parseEnergyLevel('high'), EnergyLevel.high);
    });

    test('parses UPPERCASE correctly', () {
      expect(parseEnergyLevel('LOW'), EnergyLevel.low);
      expect(parseEnergyLevel('MEDIUM'), EnergyLevel.medium);
      expect(parseEnergyLevel('HIGH'), EnergyLevel.high);
    });

    test('handles null with fallback', () {
      expect(parseEnergyLevel(null), EnergyLevel.medium);
    });

    test('handles unknown value with fallback', () {
      expect(parseEnergyLevel('unknown'), EnergyLevel.medium);
    });
  });

  group('Enum Mapper - CheckinMood', () {
    test('parses snake_case values correctly', () {
      expect(parseCheckinMood('very_bad'), CheckinMood.veryBad);
      expect(parseCheckinMood('bad'), CheckinMood.bad);
      expect(parseCheckinMood('normal'), CheckinMood.normal);
      expect(parseCheckinMood('good'), CheckinMood.good);
      expect(parseCheckinMood('very_good'), CheckinMood.veryGood);
    });

    test('parses legacy Vietnamese labels', () {
      expect(parseCheckinMood('Rất tệ'), CheckinMood.veryBad);
      expect(parseCheckinMood('Tệ'), CheckinMood.bad);
      expect(parseCheckinMood('Bình thường'), CheckinMood.normal);
      expect(parseCheckinMood('Tốt'), CheckinMood.good);
      expect(parseCheckinMood('Rất tốt'), CheckinMood.veryGood);
    });

    test('parses legacy enum names', () {
      expect(parseCheckinMood('veryLow'), CheckinMood.veryBad);
      expect(parseCheckinMood('low'), CheckinMood.bad);
      expect(parseCheckinMood('medium'), CheckinMood.normal);
      expect(parseCheckinMood('high'), CheckinMood.good);
      expect(parseCheckinMood('veryHigh'), CheckinMood.veryGood);
    });

    test('handles null with fallback', () {
      expect(parseCheckinMood(null), CheckinMood.normal);
    });

    test('handles unknown value with fallback', () {
      expect(parseCheckinMood('unknown'), CheckinMood.normal);
    });
  });

  group('Enum Mapper - Availability', () {
    test('parses known values correctly', () {
      expect(parseAvailability('busy'), Availability.busy);
      expect(parseAvailability('normal'), Availability.normal);
      expect(parseAvailability('free'), Availability.free);
    });

    test('handles null with fallback', () {
      expect(parseAvailability(null), Availability.normal);
    });
  });

  group('Enum Mapper - CheckinPriority', () {
    test('parses known values correctly', () {
      expect(parseCheckinPriority('learning'), CheckinPriority.learning);
      expect(parseCheckinPriority('health'), CheckinPriority.health);
      expect(parseCheckinPriority('work'), CheckinPriority.work);
      expect(parseCheckinPriority('habit'), CheckinPriority.habit);
      expect(parseCheckinPriority('rest'), CheckinPriority.rest);
    });

    test('handles null with fallback', () {
      expect(parseCheckinPriority(null), CheckinPriority.learning);
    });
  });

  group('Enum Mapper - Edge Cases', () {
    test('handles values with extra whitespace', () {
      expect(parseLogEntryType('  quest_completed  '), LogEntryType.questCompleted);
      expect(parseLogMood('  very_good  '), LogMood.veryGood);
    });

    test('handles mixed case snake_case', () {
      expect(parseLogEntryType('Quest_Completed'), LogEntryType.questCompleted);
      expect(parseLogMood('Very_Good'), LogMood.veryGood);
    });

    test('all fallbacks are as specified', () {
      expect(parseQuestStatus('unknown'), QuestStatus.pending);
      expect(parseQuestType('unknown'), QuestType.custom);
      expect(parseQuestDifficulty('unknown'), QuestDifficulty.medium);
      expect(parseQuestSource('unknown'), QuestSource.manual);
      expect(parseLogEntryType('unknown'), LogEntryType.unknown);
      expect(parseLogMood('unknown'), LogMood.neutral);
      expect(parseEnergyLevel('unknown'), EnergyLevel.medium);
      expect(parseCheckinMood('unknown'), CheckinMood.normal);
      expect(parseAvailability('unknown'), Availability.normal);
      expect(parseCheckinPriority('unknown'), CheckinPriority.learning);
    });
  });
}
