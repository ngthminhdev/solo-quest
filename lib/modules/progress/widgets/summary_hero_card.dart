import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/progress_model.dart';
import '../../../widgets/app_progress/app_progress_bar.dart';

class SummaryHeroCard extends StatelessWidget {
  final ProgressModel progress;

  const SummaryHeroCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final clampedProgress = progress.levelProgress.clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.s16, AppSpacing.s16, AppSpacing.s16, 0),
      padding: const EdgeInsets.all(AppSpacing.s20),
      decoration: BoxDecoration(
        color: AppColor.surface,
        border: Border.all(color: AppColor.borderGlowCyan),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level row
          Row(
            children: [
              _LevelRing(level: progress.level),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.progressCurrentLevel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColor.fgMuted,
                        letterSpacing: 0.06,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      'Level ${progress.level}',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColor.fg,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s16),

          // EXP bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'EXP',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: AppColor.fgSecondary,
                ),
              ),
              Text(
                '${_formatNumber(progress.currentLevelExp)} / ${_formatNumber(progress.nextLevelExp)}',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColor.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s6),
          AppProgressBar(
            progress: clampedProgress,
            height: 8,
          ),

          const SizedBox(height: AppSpacing.s16),

          // Stats grid
          Row(
            children: [
              Expanded(
                child: _StatCell(
                  value: '${progress.streakDays}',
                  suffix: l10n.progressStreakDaysSuffix,
                  label: l10n.progressStreakLabel,
                  valueColor: AppColor.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: _StatCell(
                  value: '${(progress.weeklyCompletionRate * 100).toInt()}%',
                  label: l10n.progressCompletedLabel,
                  valueColor: AppColor.cyan,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: _StatCell(
                  value: '${progress.weeklyTotalCompleted}',
                  suffix: '/${progress.weeklyTotalPlanned}',
                  label: l10n.progressWeeklyQuest,
                  valueColor: AppColor.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
    }
    return n.toString();
  }
}

class _LevelRing extends StatelessWidget {
  final int level;

  const _LevelRing({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColor.levelGradient,
      ),
      child: Center(
        child: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColor.bg,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$level',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColor.fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String? suffix;
  final String label;
  final Color valueColor;

  const _StatCell({
    required this.value,
    this.suffix,
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
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: valueColor,
                    height: 1.1,
                  ),
                ),
                if (suffix != null)
                  TextSpan(
                    text: suffix,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColor.fgMuted,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColor.fgMuted,
              letterSpacing: 0.04,
            ),
          ),
        ],
      ),
    );
  }
}
