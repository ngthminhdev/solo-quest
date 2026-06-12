import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/progress_model.dart';
import '../../../models/enums/quest_enums.dart';
import '../../../extensions/localization_extension.dart';

class AchievementPreviewSection extends StatelessWidget {
  final ProgressModel progress;

  const AchievementPreviewSection({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      _Achievement(
        title: context.l10n.progressAchievementStarter,
        description: context.l10n.progressAchievementStarterDesc,
        icon: RemixIcons.rocket_line,
        color: AppColor.cyan,
        unlocked: progress.totalCompletedQuests >= 5,
      ),
      _Achievement(
        title: context.l10n.progressAchievementKeeper,
        description: context.l10n.progressAchievementKeeperDesc,
        icon: RemixIcons.fire_line,
        color: AppColor.warn,
        unlocked: progress.streakDays >= 3,
      ),
      _Achievement(
        title: context.l10n.progressAchievementLearner,
        description: context.l10n.progressAchievementLearnerDesc,
        icon: RemixIcons.book_open_line,
        color: AppColor.violet,
        unlocked: (progress.completedByType[QuestType.learning] ?? 0) >= 5,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Row(
            children: [
              Icon(RemixIcons.award_line, size: 16, color: AppColor.expGold),
              const SizedBox(width: AppSpacing.s6),
              Text(
                context.l10n.progressAchievementSectionTitle,
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
        ),
        const SizedBox(height: AppSpacing.s10),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            itemCount: achievements.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s10),
            itemBuilder: (context, index) {
              final a = achievements[index];
              return _AchievementMiniCard(achievement: a);
            },
          ),
        ),
      ],
    );
  }
}

class _Achievement {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool unlocked;

  const _Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.unlocked,
  });
}

class _AchievementMiniCard extends StatelessWidget {
  final _Achievement achievement;

  const _AchievementMiniCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s10),
        decoration: BoxDecoration(
          color: achievement.unlocked ? AppColor.surface : AppColor.bgRaised,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: achievement.unlocked
                ? achievement.color.withValues(alpha: 0.3)
                : AppColor.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: achievement.unlocked
                    ? achievement.color.withValues(alpha: 0.15)
                    : AppColor.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement.icon,
                size: 16,
                color: achievement.unlocked
                    ? achievement.color
                    : AppColor.fgMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.s6),
            Text(
              achievement.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: achievement.unlocked ? AppColor.fg : AppColor.fgMuted,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.s2),
            Text(
              achievement.description,
              style: TextStyle(
                fontSize: 10,
                color: achievement.unlocked
                    ? AppColor.fgSecondary
                    : AppColor.fgMuted,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (achievement.unlocked)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: achievement.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  context.l10n.progressAchievementUnlocked,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: achievement.color,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
