import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../widgets/app_section_header/app_section_header.dart';
import 'profile_menu_tile.dart';

class ProfileQuickActionsSection extends StatelessWidget {
  final bool hasCheckedInToday;
  final bool hasReviewedToday;
  final VoidCallback onMorningCheckinTap;
  final VoidCallback onDailyReviewTap;

  const ProfileQuickActionsSection({
    super.key,
    required this.hasCheckedInToday,
    required this.hasReviewedToday,
    required this.onMorningCheckinTap,
    required this.onDailyReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(title: 'Hoạt Động Hàng Ngày'),
          const SizedBox(height: AppSpacing.s12),

          // Morning Check-in
          ProfileMenuTile(
            icon: RemixIcons.sun_line,
            title: 'Check-in buổi sáng',
            subtitle: 'Cập nhật năng lượng và kế hoạch hôm nay',
            badgeText: hasCheckedInToday ? 'Đã xong' : 'Chưa làm',
            badgeColor: hasCheckedInToday ? AppColor.success : AppColor.warn,
            onTap: onMorningCheckinTap,
          ),

          const SizedBox(height: AppSpacing.s12),

          // Daily Review
          ProfileMenuTile(
            icon: RemixIcons.moon_line,
            title: 'Review cuối ngày',
            subtitle: 'Nhìn lại quest, mood và điều cần cải thiện',
            badgeText: hasReviewedToday ? 'Đã xong' : 'Chưa làm',
            badgeColor: hasReviewedToday ? AppColor.success : AppColor.warn,
            onTap: onDailyReviewTap,
          ),
        ],
      ),
    );
  }
}
