import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_spacing.dart';
import '../../../widgets/app_section_header/app_section_header.dart';
import 'profile_menu_tile.dart';

class ProfileSettingsSection extends StatelessWidget {
  final VoidCallback onScheduleTap;
  final VoidCallback onLearningGoalsTap;
  final VoidCallback onLearningRoadmapTap;
  final VoidCallback onReminderSettingsTap;
  final VoidCallback onQuestRulesTap;

  const ProfileSettingsSection({
    super.key,
    required this.onScheduleTap,
    required this.onLearningGoalsTap,
    required this.onLearningRoadmapTap,
    required this.onReminderSettingsTap,
    required this.onQuestRulesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(title: 'Cài Đặt & Công Cụ'),
          const SizedBox(height: AppSpacing.s12),

          // Schedule Editor
          ProfileMenuTile(
            icon: RemixIcons.calendar_line,
            title: 'Lịch sinh hoạt',
            subtitle: 'Chỉnh thời gian làm việc, học tập và nghỉ ngơi',
            onTap: onScheduleTap,
          ),

          const SizedBox(height: AppSpacing.s12),

          // Learning Goals
          ProfileMenuTile(
            icon: RemixIcons.focus_3_line,
            title: 'Mục tiêu học tập',
            subtitle: 'Quản lý mục tiêu học tập cá nhân',
            onTap: onLearningGoalsTap,
          ),

          const SizedBox(height: AppSpacing.s12),

          // Learning Roadmap
          ProfileMenuTile(
            icon: RemixIcons.road_map_line,
            title: 'Lộ trình học',
            subtitle: 'Theo dõi roadmap và tiến độ học',
            onTap: onLearningRoadmapTap,
          ),

          const SizedBox(height: AppSpacing.s12),

          // Reminder Settings
          ProfileMenuTile(
            icon: RemixIcons.notification_3_line,
            title: 'Cài đặt nhắc nhở',
            subtitle: 'Tùy chỉnh tần suất và thời điểm nhắc',
            onTap: onReminderSettingsTap,
          ),

          const SizedBox(height: AppSpacing.s12),

          // Quest Rules
          ProfileMenuTile(
            icon: RemixIcons.settings_3_line,
            title: 'Luật tạo quest',
            subtitle: 'Điều chỉnh độ khó, loại quest và giới hạn mỗi ngày',
            onTap: onQuestRulesTap,
          ),
        ],
      ),
    );
  }
}
