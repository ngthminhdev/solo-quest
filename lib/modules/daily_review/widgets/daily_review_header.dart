import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../helpers/date_helper.dart';
import '../constants/daily_review_constants.dart';

class DailyReviewHeader extends StatelessWidget {
  const DailyReviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s20,
        AppSpacing.s24,
        AppSpacing.s20,
        AppSpacing.s20,
      ),
      decoration: const BoxDecoration(
        color: AppColor.bgRaised,
        border: Border(bottom: BorderSide(color: AppColor.border)),
      ),
      child: Column(
        children: [
          Text(
            DateHelper.formatFullDate(now),
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              color: AppColor.fgMuted,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          const Text(
            DailyReviewConstants.headerTitle,
            style: TextStyle(
              fontFamily: 'Exo2',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColor.fg,
            ),
          ),
          const SizedBox(height: AppSpacing.s6),
          const Text(
            DailyReviewConstants.headerSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColor.fgSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
