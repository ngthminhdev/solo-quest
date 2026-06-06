import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/progress_model.dart';
import '../../../extensions/localization_extension.dart';

class ProgressStatsGrid extends StatelessWidget {
  final ProgressModel progress;

  const ProgressStatsGrid({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppSpacing.s10,
        crossAxisSpacing: AppSpacing.s10,
        childAspectRatio: 1.72,
        children: [
          _StatCard(
            label: context.l10n.progressStatsTotalEXP,
            value: '${progress.totalExp}',
            icon: RemixIcons.flashlight_line,
            color: AppColor.expGold,
          ),
          _StatCard(
            label: context.l10n.progressStatsCompletedQuests,
            value: '${progress.totalCompletedQuests}',
            icon: RemixIcons.checkbox_circle_line,
            color: AppColor.success,
          ),
          _StatCard(
            label: context.l10n.progressStatsSkippedQuests,
            value: '${progress.totalSkippedQuests}',
            icon: RemixIcons.close_circle_line,
            color: AppColor.fgMuted,
          ),
          _StatCard(
            label: 'Streak',
            value: '${progress.streakDays}',
            suffix: context.l10n.progressStatsStreakDays,
            icon: RemixIcons.fire_line,
            color: AppColor.warn,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    this.suffix,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        height: 1,
                        color: color,
                      ),
                    ),
                    if (suffix != null)
                      TextSpan(
                        text: ' $suffix',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColor.fgSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColor.fgSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
