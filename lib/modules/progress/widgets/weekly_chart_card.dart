import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/progress_model.dart';

class WeeklyChartCard extends StatelessWidget {
  final List<DailyCompletion> dailyData;
  final int weeklyTotal;
  final int weeklyPlanned;
  final double avgRate;

  const WeeklyChartCard({
    super.key,
    required this.dailyData,
    required this.weeklyTotal,
    required this.weeklyPlanned,
    required this.avgRate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final maxPlanned = dailyData.fold<int>(
      0,
      (max, d) => d.planned > max ? d.planned : max,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        0,
      ),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColor.cyan,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.s6),
              Text(
                l10n.progressWeeklyChartSection,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: AppColor.fgMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            l10n.progressWeeklyChartTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColor.fg,
            ),
          ),
          const SizedBox(height: AppSpacing.s14),

          // Bar chart
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: dailyData.map((day) {
                final ratio =
                    maxPlanned == 0 ? 0.0 : day.completed / maxPlanned;
                final barHeight = (ratio * 90).clamp(4.0, 90.0);
                final isLow = day.rate < 0.5;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${day.completed}/${day.planned}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
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
                            color: isLow
                                ? AppColor.warn
                                : day.dayLabel == 'CN'
                                    ? AppColor.violet
                                    : AppColor.cyan,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          day.dayLabel,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10,
                            color: AppColor.fgMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.s8),

          // Legend
          Container(
            padding: const EdgeInsets.only(top: AppSpacing.s8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColor.borderSubtle, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.progressWeeklyChartAverage((avgRate * 100).toInt()),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColor.fgMuted,
                  ),
                ),
                Text(
                  l10n.progressWeeklyChartTotal(weeklyTotal, weeklyPlanned),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fgSecondary,
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
