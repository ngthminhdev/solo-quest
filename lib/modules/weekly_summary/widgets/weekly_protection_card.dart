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
          gradient: AppColor.insightCardGradient,
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              RemixIcons.shield_check_line,
              size: 18,
              color: AppColor.cyan,
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
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
