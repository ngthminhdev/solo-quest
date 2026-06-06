import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/user_profile_model.dart';
import '../../../widgets/app_card/app_glow_card.dart';
import '../../../widgets/gamification/level_badge.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserProfileModel profile;
  final int level;
  final int currentLevelExp;
  final int nextLevelExp;
  final double levelProgress;
  final int streakDays;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    required this.level,
    required this.currentLevelExp,
    required this.nextLevelExp,
    required this.levelProgress,
    required this.streakDays,
  });

  Widget _buildFallbackAvatar() {
    return Center(
      child: Text(
        profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColor.cyan,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppGlowCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        children: [
          // Avatar and Name
          Row(
            children: [
              // Avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.cyanDim,
                  border: Border.all(color: AppColor.cyan, width: 2),
                ),
                child: ClipOval(
                  child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                      ? Image.network(
                          profile.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildFallbackAvatar(),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColor.cyan,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : _buildFallbackAvatar(),
                ),
              ),

              const SizedBox(width: AppSpacing.s16),

              // Name and Level
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColor.fg,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    LevelBadge(level: level),
                  ],
                ),
              ),

              // Streak
              if (streakDays > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s12,
                    vertical: AppSpacing.s6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.warnDim,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColor.warningBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        RemixIcons.fire_line,
                        size: 16,
                        color: AppColor.warn,
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      Text(
                        '$streakDays',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColor.warn,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.s16),

          // EXP Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level EXP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColor.fgSecondary,
                    ),
                  ),
                  Text(
                    '$currentLevelExp / $nextLevelExp',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColor.cyan,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s8),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: levelProgress,
                  minHeight: 8,
                  backgroundColor: AppColor.surface,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColor.cyan),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s12),

          // Subtitle
          Text(
            'Tiếp tục giữ nhịp nhỏ mỗi ngày.',
            style: TextStyle(
              fontSize: 13,
              color: AppColor.fgMuted,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
