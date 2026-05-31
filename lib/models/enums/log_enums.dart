enum LogEntryType {
  questCreated,
  questStarted,
  questCompleted,
  questSkipped,
  questSnoozed,
  morningCheckin,
  dailyReview,
  rewardClaimed,
  levelUp,
  streakChanged,
  profileUpdated,
  ruleUpdated,
}

enum LogMood {
  veryBad,
  bad,
  neutral,
  good,
  veryGood,
}

extension LogEntryTypeX on LogEntryType {
  String get label {
    switch (this) {
      case LogEntryType.questCreated:
        return 'Tạo nhiệm vụ';
      case LogEntryType.questStarted:
        return 'Bắt đầu';
      case LogEntryType.questCompleted:
        return 'Hoàn thành';
      case LogEntryType.questSkipped:
        return 'Bỏ qua';
      case LogEntryType.questSnoozed:
        return 'Hoãn';
      case LogEntryType.morningCheckin:
        return 'Check-in sáng';
      case LogEntryType.dailyReview:
        return 'Đánh giá ngày';
      case LogEntryType.rewardClaimed:
        return 'Nhận thưởng';
      case LogEntryType.levelUp:
        return 'Tăng cấp';
      case LogEntryType.streakChanged:
        return 'Thay đổi chuỗi';
      case LogEntryType.profileUpdated:
        return 'Cập nhật hồ sơ';
      case LogEntryType.ruleUpdated:
        return 'Cập nhật quy tắc';
    }
  }
}

extension LogMoodX on LogMood {
  String get label {
    switch (this) {
      case LogMood.veryBad:
        return 'Rất tệ';
      case LogMood.bad:
        return 'Tệ';
      case LogMood.neutral:
        return 'Bình thường';
      case LogMood.good:
        return 'Tốt';
      case LogMood.veryGood:
        return 'Rất tốt';
    }
  }

  String get iconText {
    switch (this) {
      case LogMood.veryBad:
        return '😞';
      case LogMood.bad:
        return '😔';
      case LogMood.neutral:
        return '😐';
      case LogMood.good:
        return '🙂';
      case LogMood.veryGood:
        return '😊';
    }
  }

  int get value {
    switch (this) {
      case LogMood.veryBad:
        return 1;
      case LogMood.bad:
        return 2;
      case LogMood.neutral:
        return 3;
      case LogMood.good:
        return 4;
      case LogMood.veryGood:
        return 5;
    }
  }
}
