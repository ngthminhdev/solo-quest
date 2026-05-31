import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../constants/reminder_settings_constants.dart';

class ReminderSettingsHeader extends StatelessWidget {
  final VoidCallback onBack;

  const ReminderSettingsHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColor.border),
              ),
              child: const Icon(
                RemixIcons.arrow_left_s_line,
                color: AppColor.fg,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      RemixIcons.notification_3_line,
                      color: AppColor.cyan,
                      size: 18,
                    ),
                    SizedBox(width: AppSpacing.s8),
                    Expanded(
                      child: Text(
                        ReminderSettingsConstants.pageTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColor.fg,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.s4),
                Text(
                  ReminderSettingsConstants.pageSubtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.fgSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
