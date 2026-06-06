import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../generated/l10n/app_localizations.dart';

enum CheckinMood {
  veryBad,
  bad,
  normal,
  good,
  veryGood,
}

enum EnergyLevel {
  low,
  medium,
  high,
}

enum Availability {
  busy,
  normal,
  free,
}

enum CheckinPriority {
  learning,
  health,
  work,
  habit,
  rest,
}

// ── Legacy enums (kept for backward compatibility with BE / existing data) ──

enum StressLevel {
  veryLow,
  low,
  medium,
  high,
  veryHigh,
}

enum FocusLevel {
  veryLow,
  low,
  medium,
  high,
  veryHigh,
}

enum SleepQuality {
  veryLow,
  low,
  medium,
  high,
  veryHigh,
}

enum Mood {
  veryLow,
  low,
  medium,
  high,
  veryHigh,
}

enum DayIntensity {
  light,
  normal,
  busy,
  overloaded,
}

// ── Extensions ──

extension CheckinMoodX on CheckinMood {
  String get label {
    switch (this) {
      case CheckinMood.veryBad:
        return 'Rất tệ';
      case CheckinMood.bad:
        return 'Tệ';
      case CheckinMood.normal:
        return 'Bình thường';
      case CheckinMood.good:
        return 'Tốt';
      case CheckinMood.veryGood:
        return 'Rất tốt';
    }
  }

  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case CheckinMood.veryBad:
        return l10n.moodVeryBad;
      case CheckinMood.bad:
        return l10n.moodBad;
      case CheckinMood.normal:
        return l10n.moodNormal;
      case CheckinMood.good:
        return l10n.moodGood;
      case CheckinMood.veryGood:
        return l10n.moodVeryGood;
    }
  }

  String get iconText {
    switch (this) {
      case CheckinMood.veryBad:
        return '😢';
      case CheckinMood.bad:
        return '😔';
      case CheckinMood.normal:
        return '😐';
      case CheckinMood.good:
        return '😊';
      case CheckinMood.veryGood:
        return '😄';
    }
  }

  IconData get icon {
    switch (this) {
      case CheckinMood.veryBad:
        return RemixIcons.emotion_unhappy_line;
      case CheckinMood.bad:
        return RemixIcons.emotion_sad_line;
      case CheckinMood.normal:
        return RemixIcons.emotion_normal_line;
      case CheckinMood.good:
        return RemixIcons.emotion_happy_line;
      case CheckinMood.veryGood:
        return RemixIcons.emotion_laugh_line;
    }
  }
}

extension EnergyLevelX on EnergyLevel {
  String get label {
    switch (this) {
      case EnergyLevel.low:
        return 'Thấp';
      case EnergyLevel.medium:
        return 'Vừa';
      case EnergyLevel.high:
        return 'Cao';
    }
  }

  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case EnergyLevel.low:
        return l10n.energyLow;
      case EnergyLevel.medium:
        return l10n.energyMedium;
      case EnergyLevel.high:
        return l10n.energyHigh;
    }
  }

  String get iconText {
    switch (this) {
      case EnergyLevel.low:
        return '😴';
      case EnergyLevel.medium:
        return '🙂';
      case EnergyLevel.high:
        return '⚡';
    }
  }

  IconData get icon {
    switch (this) {
      case EnergyLevel.low:
        return RemixIcons.battery_low_line;
      case EnergyLevel.medium:
        return RemixIcons.battery_2_line;
      case EnergyLevel.high:
        return RemixIcons.battery_2_charge_line;
    }
  }
}

extension AvailabilityX on Availability {
  String get label {
    switch (this) {
      case Availability.busy:
        return 'Bận';
      case Availability.normal:
        return 'Vừa phải';
      case Availability.free:
        return 'Rảnh';
    }
  }

  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case Availability.busy:
        return l10n.availabilityBusy;
      case Availability.normal:
        return l10n.availabilityNormal;
      case Availability.free:
        return l10n.availabilityFree;
    }
  }

  String get iconText {
    switch (this) {
      case Availability.busy:
        return '🔥';
      case Availability.normal:
        return '📅';
      case Availability.free:
        return '🌴';
    }
  }

  IconData get icon {
    switch (this) {
      case Availability.busy:
        return RemixIcons.timer_flash_line;
      case Availability.normal:
        return RemixIcons.calendar_check_line;
      case Availability.free:
        return RemixIcons.sun_line;
    }
  }
}

extension CheckinPriorityX on CheckinPriority {
  String get label {
    switch (this) {
      case CheckinPriority.learning:
        return 'Học tập';
      case CheckinPriority.health:
        return 'Sức khỏe';
      case CheckinPriority.work:
        return 'Công việc';
      case CheckinPriority.habit:
        return 'Thói quen';
      case CheckinPriority.rest:
        return 'Nghỉ ngơi';
    }
  }

  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case CheckinPriority.learning:
        return l10n.priorityLearning;
      case CheckinPriority.health:
        return l10n.priorityHealth;
      case CheckinPriority.work:
        return l10n.priorityWork;
      case CheckinPriority.habit:
        return l10n.priorityHabit;
      case CheckinPriority.rest:
        return l10n.priorityRest;
    }
  }

  String get iconText {
    switch (this) {
      case CheckinPriority.learning:
        return '📚';
      case CheckinPriority.health:
        return '💪';
      case CheckinPriority.work:
        return '💼';
      case CheckinPriority.habit:
        return '🔄';
      case CheckinPriority.rest:
        return '😴';
    }
  }

  IconData get icon {
    switch (this) {
      case CheckinPriority.learning:
        return RemixIcons.book_open_line;
      case CheckinPriority.health:
        return RemixIcons.heart_pulse_line;
      case CheckinPriority.work:
        return RemixIcons.briefcase_line;
      case CheckinPriority.habit:
        return RemixIcons.loop_left_line;
      case CheckinPriority.rest:
        return RemixIcons.moon_line;
    }
  }
}

// ── Legacy extensions (kept for backward compatibility) ──

extension StressLevelX on StressLevel {
  String get label {
    switch (this) {
      case StressLevel.veryLow:
        return 'Rất thấp';
      case StressLevel.low:
        return 'Thấp';
      case StressLevel.medium:
        return 'Trung bình';
      case StressLevel.high:
        return 'Cao';
      case StressLevel.veryHigh:
        return 'Rất cao';
    }
  }
}

extension FocusLevelX on FocusLevel {
  String get label {
    switch (this) {
      case FocusLevel.veryLow:
        return 'Rất thấp';
      case FocusLevel.low:
        return 'Thấp';
      case FocusLevel.medium:
        return 'Trung bình';
      case FocusLevel.high:
        return 'Cao';
      case FocusLevel.veryHigh:
        return 'Rất cao';
    }
  }
}

extension SleepQualityX on SleepQuality {
  String get label {
    switch (this) {
      case SleepQuality.veryLow:
        return 'Rất tệ';
      case SleepQuality.low:
        return 'Tệ';
      case SleepQuality.medium:
        return 'Bình thường';
      case SleepQuality.high:
        return 'Tốt';
      case SleepQuality.veryHigh:
        return 'Tuyệt vời';
    }
  }
}

extension MoodX on Mood {
  String get label {
    switch (this) {
      case Mood.veryLow:
        return 'Chán nản';
      case Mood.low:
        return 'Buồn';
      case Mood.medium:
        return 'Bình thường';
      case Mood.high:
        return 'Tốt';
      case Mood.veryHigh:
        return 'Vui vẻ';
    }
  }
}

extension DayIntensityX on DayIntensity {
  String get label {
    switch (this) {
      case DayIntensity.light:
        return 'Nhẹ nhàng';
      case DayIntensity.normal:
        return 'Bình thường';
      case DayIntensity.busy:
        return 'Bận rộn';
      case DayIntensity.overloaded:
        return 'Quá tải';
    }
  }
}
