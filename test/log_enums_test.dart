import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/models/enums/log_enums.dart';
import 'package:solo_quest/core/utils/enum_mapper.dart';

void main() {
  group('LogEntryType', () {
    test('has all expected values', () {
      expect(LogEntryType.values.length, 23);
      expect(LogEntryType.values, contains(LogEntryType.questCreated));
      expect(LogEntryType.values, contains(LogEntryType.questCompleted));
      expect(LogEntryType.values, contains(LogEntryType.learningRoadmapCreated));
      expect(LogEntryType.values, contains(LogEntryType.learningRoadmapFollowed));
      expect(LogEntryType.values, contains(LogEntryType.learningRoadmapStepCompleted));
      expect(LogEntryType.values, contains(LogEntryType.learningRoadmapStepUncompleted));
      expect(LogEntryType.values, contains(LogEntryType.learningRoadmapCompleted));
      expect(LogEntryType.values, contains(LogEntryType.onboardingCompleted));
      expect(LogEntryType.values, contains(LogEntryType.weeklySummaryGenerated));
      expect(LogEntryType.values, contains(LogEntryType.questSettingsUpdated));
      expect(LogEntryType.values, contains(LogEntryType.xpGained));
      expect(LogEntryType.values, contains(LogEntryType.system));
      expect(LogEntryType.values, contains(LogEntryType.unknown));
    });

    test('labels are defined for all types', () {
      for (final type in LogEntryType.values) {
        expect(type.label, isNotEmpty);
        expect(type.label, isNot(equals(type.name)));
      }
    });

    test('unknown type has fallback label', () {
      expect(LogEntryType.unknown.label, 'Hoạt động mới');
    });

    test('learning roadmap types have correct labels', () {
      expect(LogEntryType.learningRoadmapCreated.label, 'Tạo lộ trình');
      expect(LogEntryType.learningRoadmapFollowed.label, 'Theo dõi lộ trình');
      expect(LogEntryType.learningRoadmapStepCompleted.label, 'Hoàn thành bước');
      expect(LogEntryType.learningRoadmapStepUncompleted.label, 'Bỏ hoàn thành bước');
      expect(LogEntryType.learningRoadmapCompleted.label, 'Hoàn thành lộ trình');
    });
  });

  group('parseLogEntryType', () {
    test('parses known types correctly', () {
      expect(parseLogEntryType('questCompleted'), LogEntryType.questCompleted);
      expect(parseLogEntryType('learningRoadmapCreated'), LogEntryType.learningRoadmapCreated);
      expect(parseLogEntryType('learningRoadmapFollowed'), LogEntryType.learningRoadmapFollowed);
      expect(parseLogEntryType('learningRoadmapStepCompleted'), LogEntryType.learningRoadmapStepCompleted);
      expect(parseLogEntryType('learningRoadmapStepUncompleted'), LogEntryType.learningRoadmapStepUncompleted);
      expect(parseLogEntryType('learningRoadmapCompleted'), LogEntryType.learningRoadmapCompleted);
      expect(parseLogEntryType('onboardingCompleted'), LogEntryType.onboardingCompleted);
      expect(parseLogEntryType('weeklySummaryGenerated'), LogEntryType.weeklySummaryGenerated);
      expect(parseLogEntryType('questSettingsUpdated'), LogEntryType.questSettingsUpdated);
      expect(parseLogEntryType('xpGained'), LogEntryType.xpGained);
      expect(parseLogEntryType('system'), LogEntryType.system);
    });

    test('parses snake_case types correctly', () {
      expect(parseLogEntryType('quest_completed'), LogEntryType.questCompleted);
      expect(parseLogEntryType('learning_roadmap_created'), LogEntryType.learningRoadmapCreated);
      expect(parseLogEntryType('learning_roadmap_followed'), LogEntryType.learningRoadmapFollowed);
      expect(parseLogEntryType('learning_roadmap_step_completed'), LogEntryType.learningRoadmapStepCompleted);
      expect(parseLogEntryType('learning_roadmap_step_uncompleted'), LogEntryType.learningRoadmapStepUncompleted);
      expect(parseLogEntryType('learning_roadmap_completed'), LogEntryType.learningRoadmapCompleted);
      expect(parseLogEntryType('onboarding_completed'), LogEntryType.onboardingCompleted);
      expect(parseLogEntryType('weekly_summary_generated'), LogEntryType.weeklySummaryGenerated);
      expect(parseLogEntryType('quest_settings_updated'), LogEntryType.questSettingsUpdated);
      expect(parseLogEntryType('xp_gained'), LogEntryType.xpGained);
      expect(parseLogEntryType('system'), LogEntryType.system);
    });

    test('returns unknown for unrecognized types', () {
      expect(parseLogEntryType('unknown_type'), LogEntryType.unknown);
      expect(parseLogEntryType('random_string'), LogEntryType.unknown);
      expect(parseLogEntryType(''), LogEntryType.unknown);
      expect(parseLogEntryType(null), LogEntryType.unknown);
    });

    test('handles case insensitive matching', () {
      expect(parseLogEntryType('QUESTCOMPLETED'), LogEntryType.questCompleted);
      expect(parseLogEntryType('QuestCompleted'), LogEntryType.questCompleted);
      expect(parseLogEntryType('QUEST_COMPLETED'), LogEntryType.questCompleted);
    });
  });
}
