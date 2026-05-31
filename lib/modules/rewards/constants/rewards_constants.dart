import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../../../constants/app_color.dart';

class RewardsConstants {
  RewardsConstants._();

  static const String pageTitle = 'Phần Thưởng';
  static const String headerTitle = 'Phần Thưởng';
  static const String headerSubtitle =
      'Dùng Reward Points để đổi phần thưởng giúp bạn duy trì động lực.';

  static const String emptyTitle = 'Chưa có phần thưởng';
  static const String emptyMessage =
      'Hãy thêm phần thưởng để tạo động lực cho bản thân.';
  static const String emptyAction = 'Thêm phần thưởng';

  static const String balanceTitle = 'Reward Points';
  static const String balanceUnit = 'pts';
  static const String availableLabel = 'Có thể đổi';
  static const String claimedLabel = 'Đã đổi';

  static const String sectionTitle = 'Phần thưởng';
  static const String badgeSectionTitle = 'Badge thành tích';
  static const String historySectionTitle = 'Lịch sử';
  static const String createSectionTitle = 'Tạo phần thưởng riêng';

  static const String filterAll = 'Tất cả';

  static const String claimDialogTitle = 'Đổi phần thưởng?';
  static const String claimDialogConfirm = 'Xác nhận';
  static const String claimDialogCancel = 'Huỷ';

  static const String toastClaimed = 'Đã đổi phần thưởng thành công!';
  static const String toastNotEnough = 'Chưa đủ điểm thưởng để đổi phần thưởng này.';
  static const String toastFailed = 'Không thể đổi phần thưởng';
  static const String toastCreated = 'Đã thêm reward mới!';

  static const String protectionText =
      'Rewards bền vững. Không mất hết tiến trình khi có ngày bận. Có Streak Shield và ngày nhẹ. Tạm dừng quest không bị phạt.';

  static const String linkProgressLabel = 'Tiến trình';
  static const String linkLogsLabel = 'Nhật ký';
  static const String linkProfileLabel = 'Hồ sơ';
}

class BadgeData {
  final String name;
  final String statusText;
  final IconData icon;
  final bool unlocked;
  final double? progressPercent;

  const BadgeData({
    required this.name,
    required this.statusText,
    required this.icon,
    this.unlocked = false,
    this.progressPercent,
  });
}

class RewardsBadgeData {
  RewardsBadgeData._();

  static const List<BadgeData> badges = [
    BadgeData(
      name: 'First Quest',
      statusText: 'Đã mở',
      icon: RemixIcons.star_line,
      unlocked: true,
    ),
    BadgeData(
      name: 'Hydration',
      statusText: 'Đã mở',
      icon: RemixIcons.drop_line,
      unlocked: true,
    ),
    BadgeData(
      name: 'Focus Builder',
      statusText: 'Đã mở',
      icon: RemixIcons.book_open_line,
      unlocked: true,
    ),
    BadgeData(
      name: 'Break Friendly',
      statusText: 'Đã mở',
      icon: RemixIcons.heart_pulse_line,
      unlocked: true,
    ),
    BadgeData(
      name: 'Consistency 5',
      statusText: 'Đã mở',
      icon: RemixIcons.fire_line,
      unlocked: true,
    ),
    BadgeData(
      name: 'Night Learner',
      statusText: '5 buổi tối',
      icon: RemixIcons.moon_line,
      unlocked: false,
      progressPercent: 0.6,
    ),
    BadgeData(
      name: 'Comeback',
      statusText: 'Quay lại',
      icon: RemixIcons.restart_line,
      unlocked: false,
    ),
    BadgeData(
      name: 'Weekly Review',
      statusText: 'Hoàn thành',
      icon: RemixIcons.bar_chart_line,
      unlocked: false,
    ),
    BadgeData(
      name: 'Movement Pro',
      statusText: '7 ngày',
      icon: RemixIcons.run_line,
      unlocked: false,
    ),
  ];
}

class RewardHistoryItem {
  final String title;
  final String desc;
  final int points;
  final bool isMinus;
  final IconData icon;
  final Color iconBg;

  const RewardHistoryItem({
    required this.title,
    required this.desc,
    required this.points,
    required this.isMinus,
    required this.icon,
    required this.iconBg,
  });
}

class RewardsHistoryData {
  RewardsHistoryData._();

  static const List<RewardHistoryItem> items = [
    RewardHistoryItem(
      title: 'Đổi "Nghỉ giải trí 20 phút"',
      desc: 'Hôm qua',
      points: 80,
      isMinus: true,
      icon: RemixIcons.rest_time_line,
      iconBg: AppColor.successDim,
    ),
    RewardHistoryItem(
      title: 'Mở khóa "Consistency 5"',
      desc: 'Thứ 4 — Nhận +50 pts thưởng',
      points: 50,
      isMinus: false,
      icon: RemixIcons.fire_line,
      iconBg: AppColor.warnDim,
    ),
    RewardHistoryItem(
      title: 'Đổi "Cafe yêu thích"',
      desc: 'Tuần trước',
      points: 150,
      isMinus: true,
      icon: RemixIcons.cup_line,
      iconBg: AppColor.warnDim,
    ),
  ];
}
