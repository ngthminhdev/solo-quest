import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../helpers/date_helper.dart';
import '../../../models/weekly_summary_model.dart';
import '../constants/weekly_summary_constants.dart';

class WeeklySummaryHeader extends StatelessWidget {
  final WeeklySummaryModel summary;

  const WeeklySummaryHeader({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s20,
        AppSpacing.s20,
        AppSpacing.s20,
        0,
      ),
      child: Column(
        children: [
          const Text(
            WeeklySummaryConstants.headerLabel,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColor.violet,
              letterSpacing: 0.12,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          const Text(
            WeeklySummaryConstants.headerTitle,
            style: TextStyle(
              fontFamily: 'Exo2',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColor.fg,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            DateHelper.formatDateRange(summary.weekStart, summary.weekEnd),
            style: const TextStyle(
              fontSize: 13,
              color: AppColor.fgSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          const Text(
            WeeklySummaryConstants.headerDesc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColor.fgMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
