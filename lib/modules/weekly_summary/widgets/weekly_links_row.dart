import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../constants/weekly_summary_constants.dart';

class WeeklyLinksRow extends StatelessWidget {
  final VoidCallback onRulesTap;
  final VoidCallback onRemindersTap;

  const WeeklyLinksRow({
    super.key,
    required this.onRulesTap,
    required this.onRemindersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LinkItem(
            icon: RemixIcons.settings_3_line,
            label: WeeklySummaryConstants.linkRules,
            onTap: onRulesTap,
          ),
          const SizedBox(width: AppSpacing.s20),
          _LinkItem(
            icon: RemixIcons.notification_3_line,
            label: WeeklySummaryConstants.linkReminders,
            onTap: onRemindersTap,
          ),
        ],
      ),
    );
  }
}

class _LinkItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LinkItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColor.fgSecondary),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColor.fgSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
