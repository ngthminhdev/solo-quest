import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/progress_model.dart';

class StreakSafetyCard extends StatelessWidget {
  final ProgressModel progress;

  const StreakSafetyCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.progressStreakDaysLabel(progress.streakDays),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColor.fg,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${progress.streakDays}',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColor.warn,
                      ),
                    ),
                    TextSpan(
                      text: l10n.progressStreakDaysSuffix,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColor.fgSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s12),

          // Stats
          Row(
            children: [
              Expanded(
                child: _StreakStat(
                  value: '${progress.streakShields}',
                  label: l10n.progressStreakShieldRemaining,
                  valueColor: AppColor.cyan,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: _StreakStat(
                  value: '${progress.lightDaysUsed}',
                  label: l10n.progressStreakLightDaysUsed,
                  valueColor: AppColor.success,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: _StreakStat(
                  value: '${progress.bestStreak}',
                  label: l10n.progressStreakMax,
                  valueColor: AppColor.warn,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s12),

          // Note
          Container(
            padding: const EdgeInsets.all(AppSpacing.s10),
            decoration: BoxDecoration(
              color: AppColor.bgRaised,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.fgSecondary,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: l10n.progressStreakShield,
                    style: TextStyle(
                      color: AppColor.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: l10n.progressStreakShieldNote,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StreakStat({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s10,
        horizontal: AppSpacing.s6,
      ),
      decoration: BoxDecoration(
        color: AppColor.bgRaised,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: valueColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColor.fgMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
