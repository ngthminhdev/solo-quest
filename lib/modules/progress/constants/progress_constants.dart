import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../../../constants/app_color.dart';

import '../../../models/enums/quest_enums.dart';

class ProgressConstants {
  ProgressConstants._();

  static const String pageTitle = 'Tiến Trình';
  static const String headerTitle = 'Tiến Trình';
  static const String headerSubtitle =
      'Theo dõi level, streak, EXP và mức độ ổn định của các thói quen theo thời gian.';

  static const String emptyTitle = 'Chưa có tiến trình';
  static const String emptyMessage =
      'Hoàn thành quest đầu tiên để bắt đầu ghi nhận EXP, level và streak.';
  static const String emptyAction = 'Về Home';

  static const String expExplainTitle = 'EXP dùng để làm gì?';
  static const String expExplainText =
      'EXP thể hiện mức độ duy trì nỗ lực hằng ngày. Khi đủ EXP, bạn sẽ lên cấp và mở khóa badge, theme hoặc reward cá nhân. EXP không phải điểm phạt — chỉ dùng để ghi nhận tiến bộ. Bạn nhận EXP khi hoàn thành quest, check-in, viết log hoặc review cuối ngày.';

  static const String streakSafetyTitle = 'Streak an toàn';
  static const String streakSafetyNote =
      'Streak Shield bảo vệ chuỗi khi bạn bận, mệt hoặc cần nghỉ. Dùng "ngày nhẹ" để giữ nhịp mà không cần hoàn thành nhiều quest. Không phạt nặng nếu bỏ qua quest do stress hoặc lịch bận.';

  static const String weeklyChartTitle = 'Tuần này';
  static const String weeklyChartSection = 'Hoàn thành theo tuần';

  static const String habitSection = 'Thói quen theo nhóm';
  static const String linksSection = 'Xem thêm';
  static const String expBreakdownSection = 'EXP theo loại quest';

  static const String weeklySummaryLink = 'Báo cáo tuần';
  static const String weeklySummaryDesc =
      'Xem lại tiến bộ, quest hiệu quả và đề xuất tuần sau';
  static const String logsLink = 'Nhật ký dữ liệu';
  static const String logsDesc =
      'Xem timeline quest, check-in, review và log cá nhân';
  static const String questRulesLink = 'Luật điều chỉnh Quest';
  static const String questRulesDesc =
      'Xem cách SoloQuest dùng dữ liệu để tạo quest phù hợp';
}

class ExpBreakdownItem {
  final String name;
  final String note;
  final int exp;
  final IconData icon;
  final Color bgColor;

  const ExpBreakdownItem({
    required this.name,
    required this.note,
    required this.exp,
    required this.icon,
    required this.bgColor,
  });
}

class ProgressExpBreakdown {
  ProgressExpBreakdown._();

  static const List<ExpBreakdownItem> items = [
    ExpBreakdownItem(
      name: 'Learning Quest',
      note: 'Quest khó nhất, EXP cao nhất',
      exp: 40,
      icon: RemixIcons.book_open_line,
      bgColor: AppColor.chipLearningBg,
    ),
    ExpBreakdownItem(
      name: 'Sleep Quest',
      note: 'Chuẩn bị giấc ngủ tốt',
      exp: 25,
      icon: RemixIcons.moon_line,
      bgColor: AppColor.chipSleepBg,
    ),
    ExpBreakdownItem(
      name: 'Movement Quest',
      note: 'Vận động cơ thể',
      exp: 20,
      icon: RemixIcons.run_line,
      bgColor: AppColor.chipMovementBg,
    ),
    ExpBreakdownItem(
      name: 'Break Quest',
      note: 'Nghỉ mắt, thư giãn',
      exp: 15,
      icon: RemixIcons.heart_pulse_line,
      bgColor: AppColor.chipBreakBg,
    ),
    ExpBreakdownItem(
      name: 'Water Quest',
      note: 'Thói quen nhỏ, lặp lại nhiều',
      exp: 10,
      icon: RemixIcons.drop_line,
      bgColor: AppColor.chipWaterBg,
    ),
    ExpBreakdownItem(
      name: 'Daily Review',
      note: 'Phản hồi cuối ngày',
      exp: 30,
      icon: RemixIcons.checkbox_circle_line,
      bgColor: AppColor.cyanDim,
    ),
  ];
}

class HabitInsight {
  final String name;
  final String insight;
  final double rate;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final QuestType? questType;
  final String routeName;

  const HabitInsight({
    required this.name,
    required this.insight,
    required this.rate,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.questType,
    required this.routeName,
  });
}

class ProgressHabitInsights {
  ProgressHabitInsights._();

  // These will be computed from ProgressModel data
  static List<HabitInsight> getInsights() {
    return [
      HabitInsight(
        name: 'Learning',
        insight: 'Hiệu quả nhất sau 20:00 · 5/7 quest tuần này',
        rate: 0.85,
        icon: RemixIcons.book_open_line,
        color: AppColor.warn,
        bgColor: AppColor.chipLearningBg,
        questType: QuestType.learning,
        routeName: '/learning-goals',
      ),
      HabitInsight(
        name: 'Water',
        insight: 'Ổn định 5/7 ngày · nhắc cách nhau 90 phút hiệu quả',
        rate: 0.78,
        icon: RemixIcons.drop_line,
        color: AppColor.info,
        bgColor: AppColor.chipWaterBg,
        questType: QuestType.water,
        routeName: '/reminder-settings',
      ),
      HabitInsight(
        name: 'Break',
        insight: 'Hay bị hoãn vào buổi sáng · đề xuất đổi sang 120 phút',
        rate: 0.65,
        icon: RemixIcons.heart_pulse_line,
        color: AppColor.violet,
        bgColor: AppColor.chipBreakBg,
        questType: QuestType.breakTime,
        routeName: '/reminder-settings',
      ),
      HabitInsight(
        name: 'Movement',
        insight: 'Bị bỏ qua 4 lần · đề xuất giảm còn 3 lần/tuần',
        rate: 0.45,
        icon: RemixIcons.run_line,
        color: AppColor.success,
        bgColor: AppColor.chipMovementBg,
        questType: QuestType.movement,
        routeName: '/reminder-settings',
      ),
      HabitInsight(
        name: 'Sleep',
        insight: '3/7 ngày hoàn thành · cần cải thiện dần',
        rate: 0.43,
        icon: RemixIcons.moon_line,
        color: AppColor.chipSleepText,
        bgColor: AppColor.chipSleepBg,
        questType: QuestType.sleep,
        routeName: '/reminder-settings',
      ),
    ];
  }
}
