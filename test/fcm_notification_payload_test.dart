import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/notifications/fcm_notification_payload.dart';

void main() {
  group('FcmNotificationPayload Parser Tests', () {
    test('parses quest_reminder with quest_id/action/display_mode', () {
      final map = {
        'source': 'soloquest_backend',
        'event': 'quest_reminder',
        'user_id': 'user_123',
        'local_date': '2026-06-08',
        'action': 'open_quest_detail',
        'display_mode': 'quest_detail',
        'quest_id': 'quest_abc',
        'quest_type': 'learning',
        'countdown_enabled': 'false',
        'countdown_minutes': '0',
      };

      final payload = FcmNotificationPayload.fromMap(map);

      expect(payload.source, 'soloquest_backend');
      expect(payload.event, 'quest_reminder');
      expect(payload.userId, 'user_123');
      expect(payload.localDate, '2026-06-08');
      expect(payload.action, 'open_quest_detail');
      expect(payload.displayMode, 'quest_detail');
      expect(payload.questId, 'quest_abc');
      expect(payload.questType, 'learning');
      expect(payload.countdownEnabled, isFalse);
      expect(payload.countdownMinutes, 0);
    });

    test('parses quest_snooze', () {
      final map = {
        'event': 'quest_snooze',
        'quest_id': 'quest_snoozed_456',
        'action': 'open_quest_detail',
        'display_mode': 'quest_detail',
      };

      final payload = FcmNotificationPayload.fromMap(map);

      expect(payload.event, 'quest_snooze');
      expect(payload.questId, 'quest_snoozed_456');
      expect(payload.action, 'open_quest_detail');
      expect(payload.displayMode, 'quest_detail');
    });

    test('parses water reminder payload', () {
      final map = {
        'event': 'reminder_setting',
        'reminder_type': 'water',
        'reminder_setting_id': 'water_setting_1',
        'frequency': 'interval',
        'occurrence_time': '10:00',
        'interval_minutes': '60',
        'schedule_mode': 'interval',
        'action': 'water_reminder',
        'display_mode': 'water_prompt',
        'countdown_enabled': 'false',
        'countdown_minutes': '0',
      };

      final payload = FcmNotificationPayload.fromMap(map);

      expect(payload.event, 'reminder_setting');
      expect(payload.reminderType, 'water');
      expect(payload.reminderSettingId, 'water_setting_1');
      expect(payload.frequency, 'interval');
      expect(payload.occurrenceTime, '10:00');
      expect(payload.intervalMinutes, 60);
      expect(payload.scheduleMode, 'interval');
      expect(payload.action, 'water_reminder');
      expect(payload.displayMode, 'water_prompt');
      expect(payload.countdownEnabled, isFalse);
      expect(payload.countdownMinutes, 0);
    });

    test('parses break_time countdown payload with string numbers and booleans', () {
      final map = {
        'event': 'reminder_setting',
        'reminder_type': 'break_time',
        'action': 'start_break_timer',
        'display_mode': 'break_timer_prompt',
        'countdown_enabled': 'true',
        'countdown_minutes': '5',
      };

      final payload = FcmNotificationPayload.fromMap(map);

      expect(payload.event, 'reminder_setting');
      expect(payload.reminderType, 'break_time');
      expect(payload.action, 'start_break_timer');
      expect(payload.displayMode, 'break_timer_prompt');
      expect(payload.countdownEnabled, isTrue);
      expect(payload.countdownMinutes, 5);
    });

    test('unknown payload does not crash and handles empty safely', () {
      final map = {
        'event': 'some_unknown_event',
        'action': 'some_unknown_action',
        'countdown_minutes': 'not-a-number',
      };

      final payload = FcmNotificationPayload.fromMap(map);

      expect(payload.event, 'some_unknown_event');
      expect(payload.action, 'some_unknown_action');
      expect(payload.countdownMinutes, 0);
      expect(payload.countdownEnabled, isFalse);
      expect(payload.questId, isNull);
    });

    test('parses fcm: prefix JSON string', () {
      const payloadStr = 'fcm:{"event":"reminder_setting","reminder_type":"break_time","action":"start_break_timer","countdown_minutes":"5"}';
      
      final payload = FcmNotificationPayload.parse(payloadStr);

      expect(payload, isNotNull);
      expect(payload!.event, 'reminder_setting');
      expect(payload.reminderType, 'break_time');
      expect(payload.action, 'start_break_timer');
      expect(payload.countdownMinutes, 5);
    });

    test('malformed fcm: payload does not crash', () {
      const payloadStr = 'fcm:{"event":invalid_json}';
      
      final payload = FcmNotificationPayload.parse(payloadStr);

      expect(payload, isNull);
    });
  });
}
