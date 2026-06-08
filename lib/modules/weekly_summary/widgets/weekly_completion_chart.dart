import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/weekly_summary_model.dart';
import '../../../extensions/localization_extension.dart';

class WeeklyCompletionChart extends StatelessWidget {
  final WeeklySummaryModel summary;

  const WeeklyCompletionChart({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    // Use daily breakdown from model if available, otherwise show empty
    final dailyData = summary.dailyBreakdown;

    if (dailyData.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.s16),
          decoration: BoxDecoration(
            color: AppColor.surface,
            border: Border.all(color: AppColor.border),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.weeklySummaryChartTitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColor.fgSecondary,
                  letterSpacing: 0.06,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              SizedBox(
                height: 140,
                child: Center(
                  child: Text(
                    'Chưa có dữ liệu daily breakdown',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColor.fgMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColor.surface,
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.weeklySummaryChartTitle,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColor.fgSecondary,
                letterSpacing: 0.06,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            SizedBox(
              height: 140,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(dailyData.length, (index) {
                  final day = dailyData[index];
                  final rate = day.rate;
                  final barHeight = rate * 100;
                  final isWeekend = day.date.weekday >= 6;

                  final labelIndex = index < dayLabels.length
                      ? index
                      : index % dayLabels.length;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${(rate * 100).round()}%',
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColor.fgSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            height: barHeight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: isWeekend
                                    ? [
                                        AppColor.violet.withAlpha(80),
                                        AppColor.violet,
                                      ]
                                    : [
                                        AppColor.cyan.withAlpha(80),
                                        AppColor.cyan,
                                      ],
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dayLabels[labelIndex],
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColor.fgMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
