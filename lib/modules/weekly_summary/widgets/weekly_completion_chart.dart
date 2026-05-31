import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/weekly_summary_model.dart';
import '../constants/weekly_summary_constants.dart';

class WeeklyCompletionChart extends StatelessWidget {
  final WeeklySummaryModel summary;

  const WeeklyCompletionChart({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    // Mock daily data
    final dailyRates = [0.85, 0.60, 0.75, 0.90, 0.55, 0.70, 0.65];
    final dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

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
            const Text(
              WeeklySummaryConstants.chartTitle,
              style: TextStyle(
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
                children: List.generate(7, (index) {
                  final rate = dailyRates[index];
                  final barHeight = rate * 100;
                  final isWeekend = index >= 5;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Value
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
                          // Bar
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
                          // Label
                          Text(
                            dayLabels[index],
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
