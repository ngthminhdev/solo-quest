import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../../generated/l10n/app_localizations.dart';

enum ReminderType {
  water,
  breakTime,
  movement,
  learning,
  sleep,
  dailyReview,
  custom,
}

enum ReminderFrequency { fixed, interval, randomInRange, smart }

enum ReminderStatus { enabled, disabled }

extension ReminderTypeX on ReminderType {
  String get label {
    switch (this) {
      case ReminderType.water:
        return 'Uống nước';
      case ReminderType.breakTime:
        return 'Nghỉ giải lao';
      case ReminderType.movement:
        return 'Vận động';
      case ReminderType.learning:
        return 'Học tập';
      case ReminderType.sleep:
        return 'Ngủ nghỉ';
      case ReminderType.dailyReview:
        return 'Đánh giá ngày';
      case ReminderType.custom:
        return 'Tùy chỉnh';
    }
  }

  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case ReminderType.water:
        return l10n.reminderTypeWater;
      case ReminderType.breakTime:
        return l10n.reminderTypeBreak;
      case ReminderType.movement:
        return l10n.reminderTypeMovement;
      case ReminderType.learning:
        return l10n.reminderTypeLearning;
      case ReminderType.sleep:
        return l10n.reminderTypeSleep;
      case ReminderType.dailyReview:
        return l10n.reminderTypeDailyReview;
      case ReminderType.custom:
        return l10n.reminderTypeCustom;
    }
  }

  String getLocalizedTitle(AppLocalizations l10n) {
    switch (this) {
      case ReminderType.water:
        return l10n.reminderTitleWater;
      case ReminderType.breakTime:
        return l10n.reminderTitleBreak;
      case ReminderType.movement:
        return l10n.reminderTitleMovement;
      case ReminderType.learning:
        return l10n.reminderTitleLearning;
      case ReminderType.sleep:
        return l10n.reminderTitleSleep;
      case ReminderType.dailyReview:
        return l10n.reminderTitleReview;
      case ReminderType.custom:
        return l10n.reminderTitleCustom;
    }
  }

  String getLocalizedDescription(AppLocalizations l10n) {
    switch (this) {
      case ReminderType.water:
        return l10n.reminderDescWater;
      case ReminderType.breakTime:
        return l10n.reminderDescBreak;
      case ReminderType.movement:
        return l10n.reminderDescMovement;
      case ReminderType.learning:
        return l10n.reminderDescLearning;
      case ReminderType.sleep:
        return l10n.reminderDescSleep;
      case ReminderType.dailyReview:
        return l10n.reminderDescReview;
      case ReminderType.custom:
        return l10n.reminderDescCustom;
    }
  }

  IconData get icon {
    switch (this) {
      case ReminderType.water:
        return RemixIcons.drop_line;
      case ReminderType.breakTime:
        return RemixIcons.eye_line;
      case ReminderType.movement:
        return RemixIcons.walk_line;
      case ReminderType.learning:
        return RemixIcons.book_open_line;
      case ReminderType.sleep:
        return RemixIcons.moon_line;
      case ReminderType.dailyReview:
        return RemixIcons.file_list_3_line;
      case ReminderType.custom:
        return RemixIcons.notification_3_line;
    }
  }
}

extension ReminderFrequencyX on ReminderFrequency {
  String get label {
    switch (this) {
      case ReminderFrequency.fixed:
        return 'Cố định';
      case ReminderFrequency.interval:
        return 'Khoảng cách';
      case ReminderFrequency.randomInRange:
        return 'Ngẫu nhiên';
      case ReminderFrequency.smart:
        return 'Thông minh';
    }
  }

  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case ReminderFrequency.fixed:
        return l10n.reminderFrequencyFixed;
      case ReminderFrequency.interval:
        return l10n.reminderFrequencyInterval;
      case ReminderFrequency.randomInRange:
        return l10n.reminderFrequencyRandom;
      case ReminderFrequency.smart:
        return l10n.reminderFrequencySmart;
    }
  }

  String get description {
    switch (this) {
      case ReminderFrequency.fixed:
        return 'Nhắc vào một thời điểm cố định.';
      case ReminderFrequency.interval:
        return 'Nhắc lặp lại sau mỗi khoảng thời gian.';
      case ReminderFrequency.randomInRange:
        return 'Nhắc ngẫu nhiên trong khung giờ đã chọn.';
      case ReminderFrequency.smart:
        return 'Tự điều chỉnh theo lịch và trạng thái của bạn.';
    }
  }

  String getLocalizedDescription(AppLocalizations l10n) {
    switch (this) {
      case ReminderFrequency.fixed:
        return l10n.reminderFrequencyFixedDesc;
      case ReminderFrequency.interval:
        return l10n.reminderFrequencyIntervalDesc;
      case ReminderFrequency.randomInRange:
        return l10n.reminderFrequencyRandomDesc;
      case ReminderFrequency.smart:
        return l10n.reminderFrequencySmartDesc;
    }
  }
}

extension ReminderStatusX on ReminderStatus {
  String get label {
    switch (this) {
      case ReminderStatus.enabled:
        return 'Đang bật';
      case ReminderStatus.disabled:
        return 'Đang tắt';
    }
  }

  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case ReminderStatus.enabled:
        return l10n.reminderStatusEnabled;
      case ReminderStatus.disabled:
        return l10n.reminderStatusDisabled;
    }
  }
}

/// API serialization helpers — maps Dart enums to/from snake_case backend values.
extension ReminderTypeApi on ReminderType {
  static const _toApi = {
    ReminderType.water: 'water',
    ReminderType.breakTime: 'break_time',
    ReminderType.movement: 'movement',
    ReminderType.learning: 'learning',
    ReminderType.sleep: 'sleep',
    ReminderType.dailyReview: 'daily_review',
    ReminderType.custom: 'custom',
  };

  static const _fromApi = {
    'water': ReminderType.water,
    'break_time': ReminderType.breakTime,
    'breakTime': ReminderType.breakTime,
    'movement': ReminderType.movement,
    'learning': ReminderType.learning,
    'sleep': ReminderType.sleep,
    'daily_review': ReminderType.dailyReview,
    'dailyReview': ReminderType.dailyReview,
    'custom': ReminderType.custom,
  };

  String toApiValue() => _toApi[this] ?? name;

  static ReminderType fromApiValue(String value) {
    final result = _fromApi[value];
    if (result != null) return result;
    throw ArgumentError('Unknown ReminderType api value: $value');
  }

  static ReminderType? tryFromApiValue(String value) => _fromApi[value];
}

extension ReminderFrequencyApi on ReminderFrequency {
  static const _toApi = {
    ReminderFrequency.fixed: 'fixed',
    ReminderFrequency.interval: 'interval',
    ReminderFrequency.randomInRange: 'random_in_range',
    ReminderFrequency.smart: 'smart',
  };

  static const _fromApi = {
    'fixed': ReminderFrequency.fixed,
    'interval': ReminderFrequency.interval,
    'random_in_range': ReminderFrequency.randomInRange,
    'randomInRange': ReminderFrequency.randomInRange,
    'smart': ReminderFrequency.smart,
  };

  String toApiValue() => _toApi[this] ?? name;

  static ReminderFrequency fromApiValue(String value) {
    final result = _fromApi[value];
    if (result != null) return result;
    throw ArgumentError('Unknown ReminderFrequency api value: $value');
  }

  static ReminderFrequency? tryFromApiValue(String value) => _fromApi[value];
}

extension ReminderStatusApi on ReminderStatus {
  static const _toApi = {
    ReminderStatus.enabled: 'enabled',
    ReminderStatus.disabled: 'disabled',
  };

  static const _fromApi = {
    'enabled': ReminderStatus.enabled,
    'disabled': ReminderStatus.disabled,
  };

  String toApiValue() => _toApi[this] ?? name;

  static ReminderStatus fromApiValue(String value) {
    final result = _fromApi[value];
    if (result != null) return result;
    throw ArgumentError('Unknown ReminderStatus api value: $value');
  }

  static ReminderStatus? tryFromApiValue(String value) => _fromApi[value];
}
