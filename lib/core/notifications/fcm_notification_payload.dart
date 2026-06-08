import 'dart:convert';
import 'package:flutter/foundation.dart';

class FcmNotificationPayload {
  final String? event;
  final String? source;
  final String? userId;
  final String? localDate;
  final String? action;
  final String? displayMode;
  final String? questId;
  final String? questType;
  final String? reminderType;
  final String? reminderSettingId;
  final String? frequency;
  final String? occurrenceTime;
  final int intervalMinutes;
  final String? scheduleMode;
  final bool countdownEnabled;
  final int countdownMinutes;
  final Map<String, dynamic> rawData;

  FcmNotificationPayload({
    this.event,
    this.source,
    this.userId,
    this.localDate,
    this.action,
    this.displayMode,
    this.questId,
    this.questType,
    this.reminderType,
    this.reminderSettingId,
    this.frequency,
    this.occurrenceTime,
    required this.intervalMinutes,
    this.scheduleMode,
    required this.countdownEnabled,
    required this.countdownMinutes,
    required this.rawData,
  });

  factory FcmNotificationPayload.fromMap(Map<dynamic, dynamic> map) {
    final Map<String, dynamic> raw = map.map((key, value) => MapEntry(key.toString(), value));

    int parseIntSafe(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      final str = val.toString();
      return int.tryParse(str) ?? 0;
    }

    bool parseBoolSafe(dynamic val) {
      if (val == null) return false;
      return val.toString().toLowerCase() == 'true';
    }

    return FcmNotificationPayload(
      event: raw['event']?.toString(),
      source: raw['source']?.toString(),
      userId: raw['user_id']?.toString(),
      localDate: raw['local_date']?.toString(),
      action: raw['action']?.toString(),
      displayMode: raw['display_mode']?.toString(),
      questId: raw['quest_id']?.toString(),
      questType: raw['quest_type']?.toString(),
      reminderType: raw['reminder_type']?.toString(),
      reminderSettingId: raw['reminder_setting_id']?.toString(),
      frequency: raw['frequency']?.toString(),
      occurrenceTime: raw['occurrence_time']?.toString(),
      intervalMinutes: parseIntSafe(raw['interval_minutes']),
      scheduleMode: raw['schedule_mode']?.toString(),
      countdownEnabled: parseBoolSafe(raw['countdown_enabled']),
      countdownMinutes: parseIntSafe(raw['countdown_minutes']),
      rawData: raw,
    );
  }

  static FcmNotificationPayload? parse(dynamic input) {
    if (input == null) return null;
    if (input is Map) {
      return FcmNotificationPayload.fromMap(input);
    }
    if (input is String) {
      String jsonStr = input;
      if (jsonStr.startsWith('fcm:')) {
        jsonStr = jsonStr.substring(4);
      }
      try {
        final decoded = jsonDecode(jsonStr);
        if (decoded is Map) {
          return FcmNotificationPayload.fromMap(decoded);
        }
      } catch (e) {
        debugPrint('[FcmNotificationPayload] Failed to parse JSON string: $e');
      }
    }
    return null;
  }
}
