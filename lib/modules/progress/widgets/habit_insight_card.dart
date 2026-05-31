import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../constants/progress_constants.dart';

class HabitInsightCard extends StatelessWidget {
  final HabitInsight insight;

  const HabitInsightCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final percent = (insight.rate * 100).toInt();

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        0,
        AppSpacing.s16,
        AppSpacing.s10,
      ),
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: insight.bgColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(insight.icon, size: 18, color: AppColor.fg),
          ),
          const SizedBox(width: AppSpacing.s12),

          // Body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      insight.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColor.fg,
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: insight.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s4),

                // Progress bar
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColor.bgRaised,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: FractionallySizedBox(
                    widthFactor: insight.rate.clamp(0.0, 1.0),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: insight.color,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),

                Text(
                  insight.insight,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColor.fgMuted,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.s8),
          const Icon(
            RemixIcons.arrow_right_s_line,
            size: 16,
            color: AppColor.fgMuted,
          ),
        ],
      ),
    );
  }
}
