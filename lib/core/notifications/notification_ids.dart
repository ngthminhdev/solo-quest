class NotificationIds {
  NotificationIds._();

  static const String prefixQuestSnooze = 'quest_snooze:';
  static const String prefixCountdown = 'countdown:';
  static const String prefixQuestReminder = 'quest_reminder:';

  static const int _snoozeXorMask = 0x5A00E;
  static const int _countdownXorMask = 0xC0D0D;
  static const int _reminderXorMask = 0x0E57;

  static int questSnooze(String questId) {
    return questId.hashCode ^ _snoozeXorMask;
  }

  static int countdown(String questId) {
    return questId.hashCode ^ _countdownXorMask;
  }

  static int questReminder(String questId) {
    return questId.hashCode ^ _reminderXorMask;
  }
}
