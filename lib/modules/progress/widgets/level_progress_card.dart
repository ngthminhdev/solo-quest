import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/progress_model.dart';
import '../../../widgets/app_card/app_glow_card.dart';
import '../../../widgets/app_progress/app_progress_bar.dart';
import '../../../extensions/localization_extension.dart';

class LevelProgressCard extends StatelessWidget {
  final ProgressModel progress;

  const LevelProgressCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.levelProgress.clamp(0.0, 1.0);

    return AppGlowCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
      ).copyWith(bottom: 0),
      padding: const EdgeInsets.all(AppSpacing.s20),
      glowColor: AppColor.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LevelRing(level: progress.level),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.progressLevelCurrentLevel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColor.fgSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      'Level ${progress.level}',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: AppColor.fg,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      '${progress.currentLevelExp} / ${progress.nextLevelExp} EXP',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColor.expGold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    context.l10n.progressLevelTotalEXP,
                    style: const TextStyle(fontSize: 11, color: AppColor.fgSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${progress.totalExp}',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColor.expGold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s14),
          AppProgressBar(
            progress: clampedProgress,
            height: 11,
            label: 'Level EXP',
            valueText: '${(clampedProgress * 100).toInt()}%',
          ),
          if (progress.expToNextLevel > 0) ...[
            const SizedBox(height: AppSpacing.s8),
            Text(
              context.l10n.progressLevelEXPToNext(progress.expToNextLevel),
              style: const TextStyle(fontSize: 12, color: AppColor.fgSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _LevelRing extends StatelessWidget {
  final int level;

  const _LevelRing({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColor.levelGradient,
      ),
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: AppColor.bg,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$level',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 21,
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
