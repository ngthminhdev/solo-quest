import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

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
}
