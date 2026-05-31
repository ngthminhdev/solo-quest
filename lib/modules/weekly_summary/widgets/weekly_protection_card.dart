import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../constants/weekly_summary_constants.dart';

class WeeklyProtectionCard extends StatelessWidget {
  const WeeklyProtectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0x0A00F0FF),
              Color(0x0AA855F7),
            ],
          ),
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              RemixIcons.shield_check_line,
              size: 18,
              color: AppColor.cyan,
            ),
            const SizedBox(width: AppSpacing.s10),
            const Expanded(
              child: Text(
                WeeklySummaryConstants.protectionText,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.fgSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
