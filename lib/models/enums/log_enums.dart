import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../constants/app_color.dart';

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
  learningRoadmapCreated,
  learningRoadmapFollowed,
  learningRoadmapStepCompleted,
  learningRoadmapStepUncompleted,
  learningRoadmapCompleted,
  onboardingCompleted,
  weeklySummaryGenerated,
  questSettingsUpdated,
  xpGained,
  system,
  unknown,
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
      case LogEntryType.learningRoadmapCreated:
        return 'Tạo lộ trình';
      case LogEntryType.learningRoadmapFollowed:
        return 'Theo dõi lộ trình';
      case LogEntryType.learningRoadmapStepCompleted:
        return 'Hoàn thành bước';
      case LogEntryType.learningRoadmapStepUncompleted:
        return 'Bỏ hoàn thành bước';
      case LogEntryType.learningRoadmapCompleted:
        return 'Hoàn thành lộ trình';
      case LogEntryType.onboardingCompleted:
        return 'Hoàn thành giới thiệu';
      case LogEntryType.weeklySummaryGenerated:
        return 'Báo cáo tuần';
      case LogEntryType.questSettingsUpdated:
        return 'Cập nhật cài đặt';
      case LogEntryType.xpGained:
        return 'Nhận EXP';
      case LogEntryType.system:
        return 'Hệ thống';
      case LogEntryType.unknown:
        return 'Hoạt động mới';
    }
  }

  String get apiValue {
    switch (this) {
      case LogEntryType.questCreated:
        return 'quest_created';
      case LogEntryType.questStarted:
        return 'quest_started';
      case LogEntryType.questCompleted:
        return 'questCompleted';
      case LogEntryType.questSkipped:
        return 'questSkipped';
      case LogEntryType.questSnoozed:
        return 'questSnoozed';
      case LogEntryType.morningCheckin:
        return 'morningCheckin';
      case LogEntryType.dailyReview:
        return 'dailyReview';
      case LogEntryType.rewardClaimed:
        return 'rewardClaimed';
      case LogEntryType.levelUp:
        return 'level_up';
      case LogEntryType.streakChanged:
        return 'streak_changed';
      case LogEntryType.profileUpdated:
        return 'profile_updated';
      case LogEntryType.ruleUpdated:
        return 'rule_updated';
      case LogEntryType.learningRoadmapCreated:
        return 'learning_roadmap_created';
      case LogEntryType.learningRoadmapFollowed:
        return 'learning_roadmap_followed';
      case LogEntryType.learningRoadmapStepCompleted:
        return 'learning_roadmap_step_completed';
      case LogEntryType.learningRoadmapStepUncompleted:
        return 'learning_roadmap_step_uncompleted';
      case LogEntryType.learningRoadmapCompleted:
        return 'learning_roadmap_completed';
      case LogEntryType.onboardingCompleted:
        return 'onboarding_completed';
      case LogEntryType.weeklySummaryGenerated:
        return 'weekly_summary_generated';
      case LogEntryType.questSettingsUpdated:
        return 'quest_settings_updated';
      case LogEntryType.xpGained:
        return 'xp_gained';
      case LogEntryType.system:
        return 'system';
      case LogEntryType.unknown:
        return 'unknown';
    }
  }

  IconData get icon {
    switch (this) {
      case LogEntryType.questCompleted:
        return RemixIcons.checkbox_circle_line;
      case LogEntryType.questSkipped:
        return RemixIcons.skip_forward_line;
      case LogEntryType.questSnoozed:
        return RemixIcons.time_line;
      case LogEntryType.questStarted:
        return RemixIcons.play_line;
      case LogEntryType.questCreated:
        return RemixIcons.add_line;
      case LogEntryType.morningCheckin:
        return RemixIcons.sun_line;
      case LogEntryType.dailyReview:
        return RemixIcons.file_text_line;
      case LogEntryType.rewardClaimed:
        return RemixIcons.gift_line;
      case LogEntryType.levelUp:
        return RemixIcons.star_line;
      case LogEntryType.streakChanged:
        return RemixIcons.fire_line;
      case LogEntryType.profileUpdated:
        return RemixIcons.user_3_line;
      case LogEntryType.ruleUpdated:
        return RemixIcons.settings_3_line;
      case LogEntryType.learningRoadmapCreated:
        return RemixIcons.route_line;
      case LogEntryType.learningRoadmapFollowed:
        return RemixIcons.eye_line;
      case LogEntryType.learningRoadmapStepCompleted:
        return RemixIcons.checkbox_circle_line;
      case LogEntryType.learningRoadmapStepUncompleted:
        return RemixIcons.checkbox_blank_circle_line;
      case LogEntryType.learningRoadmapCompleted:
        return RemixIcons.medal_line;
      case LogEntryType.onboardingCompleted:
        return RemixIcons.checkbox_circle_line;
      case LogEntryType.weeklySummaryGenerated:
        return RemixIcons.bar_chart_2_line;
      case LogEntryType.questSettingsUpdated:
        return RemixIcons.settings_3_line;
      case LogEntryType.xpGained:
        return RemixIcons.star_line;
      case LogEntryType.system:
        return RemixIcons.information_line;
      case LogEntryType.unknown:
        return RemixIcons.information_line;
    }
  }

  Color get color {
    switch (this) {
      case LogEntryType.questCompleted:
        return AppColor.success;
      case LogEntryType.questSkipped:
        return AppColor.warn;
      case LogEntryType.questSnoozed:
        return AppColor.info;
      case LogEntryType.questStarted:
        return AppColor.cyan;
      case LogEntryType.questCreated:
        return AppColor.fgSecondary;
      case LogEntryType.morningCheckin:
        return AppColor.cyan;
      case LogEntryType.dailyReview:
        return AppColor.violet;
      case LogEntryType.rewardClaimed:
        return AppColor.cyan;
      case LogEntryType.levelUp:
        return AppColor.expGold;
      case LogEntryType.streakChanged:
        return AppColor.warn;
      case LogEntryType.profileUpdated:
        return AppColor.fgSecondary;
      case LogEntryType.ruleUpdated:
        return AppColor.fgSecondary;
      case LogEntryType.learningRoadmapCreated:
        return AppColor.cyan;
      case LogEntryType.learningRoadmapFollowed:
        return AppColor.info;
      case LogEntryType.learningRoadmapStepCompleted:
        return AppColor.success;
      case LogEntryType.learningRoadmapStepUncompleted:
        return AppColor.warn;
      case LogEntryType.learningRoadmapCompleted:
        return AppColor.expGold;
      case LogEntryType.onboardingCompleted:
        return AppColor.success;
      case LogEntryType.weeklySummaryGenerated:
        return AppColor.violet;
      case LogEntryType.questSettingsUpdated:
        return AppColor.fgSecondary;
      case LogEntryType.xpGained:
        return AppColor.expGold;
      case LogEntryType.system:
        return AppColor.fgSecondary;
      case LogEntryType.unknown:
        return AppColor.fgMuted;
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

  IconData get icon {
    switch (this) {
      case LogMood.veryBad:
        return RemixIcons.emotion_unhappy_line;
      case LogMood.bad:
        return RemixIcons.emotion_sad_line;
      case LogMood.neutral:
        return RemixIcons.emotion_normal_line;
      case LogMood.good:
        return RemixIcons.emotion_happy_line;
      case LogMood.veryGood:
        return RemixIcons.emotion_laugh_line;
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
