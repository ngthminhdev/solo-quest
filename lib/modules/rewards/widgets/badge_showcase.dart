import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../widgets/app_progress/app_progress_bar.dart';
import '../constants/rewards_constants.dart';

class BadgeShowcase extends StatelessWidget {
  const BadgeShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = RewardsBadgeData.badges;
    final unlockedCount = badges.where((b) => b.unlocked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s20,
            AppSpacing.s16,
            AppSpacing.s8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColor.violet,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s6),
                  const Text(
                    'BADGE THÀNH TÍCH',
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
              Text(
                '$unlockedCount/${badges.length} đã mở',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColor.cyan,
                ),
              ),
            ],
          ),
        ),

        // Badge scroll
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            itemCount: badges.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s10),
            itemBuilder: (context, index) {
              final badge = badges[index];
              return _BadgeCard(badge: badge);
            },
          ),
        ),

        // Next badge progress
        _buildNextBadgeProgress(),
      ],
    );
  }

  Widget _buildNextBadgeProgress() {
    final nextBadge = RewardsBadgeData.badges.firstWhere(
      (b) => !b.unlocked && b.progressPercent != null,
      orElse: () => RewardsBadgeData.badges.firstWhere((b) => !b.unlocked),
    );

    if (nextBadge.progressPercent == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s10,
        AppSpacing.s16,
        0,
      ),
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          // Ring
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: nextBadge.progressPercent,
                  strokeWidth: 4,
                  backgroundColor: AppColor.surfaceActive,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColor.cyan),
                ),
                Text(
                  '${(nextBadge.progressPercent! * 100).toInt()}%',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColor.cyan,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tiến độ badge tiếp theo',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fg,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${nextBadge.name} — ${nextBadge.statusText}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColor.fgMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                AppProgressBar(
                  progress: nextBadge.progressPercent!,
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final BadgeData badge;

  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: badge.unlocked ? 1.0 : 0.35,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(AppSpacing.s12),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColor.border),
        ),
        child: Column(
          children: [
            // Ring
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badge.unlocked
                    ? AppColor.cyanDim
                    : AppColor.surfaceActive,
                border: Border.all(
                  color: badge.unlocked
                      ? AppColor.borderGlowCyan
                      : AppColor.border,
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    badge.icon,
                    size: 26,
                    color: badge.unlocked
                        ? AppColor.cyan
                        : AppColor.fgMuted,
                  ),
                  if (!badge.unlocked)
                    const Positioned(
                      bottom: -2,
                      right: -2,
                      child: Text('🔒', style: TextStyle(fontSize: 10)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s6),

            // Name
            Text(
              badge.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: badge.unlocked ? AppColor.fg : AppColor.fgMuted,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),

            // Status
            Text(
              badge.statusText,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: badge.unlocked ? AppColor.success : AppColor.fgMuted,
                letterSpacing: 0.04,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
