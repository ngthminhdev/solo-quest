import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../widgets/app_card/app_card.dart';
import '../../../widgets/app_progress/app_progress_bar.dart';
import '../../../extensions/localization_extension.dart';

class WeeklyCompletionCard extends StatelessWidget {
  final double completionRate;

  const WeeklyCompletionCard({super.key, required this.completionRate});

  @override
  Widget build(BuildContext context) {
    final rate = completionRate.clamp(0.0, 1.0);
    final percent = (rate * 100).toInt();

    String weeklyMessage(double r) {
      if (r < 0.4) return context.l10n.progressWeeklyCompletionLow;
      if (r < 0.7) return context.l10n.progressWeeklyCompletionMedium;
      return context.l10n.progressWeeklyCompletionHigh;
    }

    return AppCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
      ).copyWith(bottom: 0),
      padding: const EdgeInsets.all(AppSpacing.s16),
      bgColor: AppColor.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                RemixIcons.bar_chart_box_line,
                size: 20,
                color: AppColor.cyan,
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: Text(
                  context.l10n.progressWeeklyCompletionTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fg,
                  ),
                ),
              ),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColor.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          AppProgressBar(progress: rate, height: 10),
          const SizedBox(height: AppSpacing.s8),
          Text(
            weeklyMessage(rate),
            style: const TextStyle(
              fontSize: 12,
              color: AppColor.fgSecondary,
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

}
