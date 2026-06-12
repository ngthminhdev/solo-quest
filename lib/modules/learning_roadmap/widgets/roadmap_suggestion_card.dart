import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';

enum RoadmapDifficulty {
  beginner,
  intermediate,
  advanced,
}

class RoadmapSuggestion {
  final String id;
  final String title;
  final String description;
  final String category;
  final RoadmapDifficulty difficulty;
  final int estimatedMinutes;
  final int totalSteps;

  const RoadmapSuggestion({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.totalSteps,
  });
}

class RoadmapSuggestionCard extends StatelessWidget {
  final RoadmapSuggestion suggestion;
  final bool isSelected;
  final VoidCallback onTap;

  const RoadmapSuggestionCard({
    super.key,
    required this.suggestion,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.s12),
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColor.surface,
          border: Border.all(
            color: isSelected ? AppColor.cyan : AppColor.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.cyan.withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.fg,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        suggestion.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.fgMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                // Difficulty badge
                _DifficultyBadge(difficulty: suggestion.difficulty),
              ],
            ),

            const SizedBox(height: AppSpacing.s12),

            // Description
            Text(
              suggestion.description,
              style: TextStyle(
                fontSize: 13,
                color: AppColor.fgSecondary,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppSpacing.s12),

            // Footer row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Stats
                Row(
                  children: [
                    Icon(
                      RemixIcons.list_check_2,
                      size: 16,
                      color: AppColor.fgMuted,
                    ),
                    const SizedBox(width: AppSpacing.s4),
                    Text(
                      '${suggestion.totalSteps} bước',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.fgMuted,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Icon(
                      RemixIcons.time_line,
                      size: 16,
                      color: AppColor.fgMuted,
                    ),
                    const SizedBox(width: AppSpacing.s4),
                    Text(
                      '~${suggestion.estimatedMinutes} phút',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.fgMuted,
                      ),
                    ),
                  ],
                ),

                // Select indicator
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s12,
                      vertical: AppSpacing.s6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.cyan,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          RemixIcons.check_line,
                          size: 14,
                          color: AppColor.bgDeep,
                        ),
                        SizedBox(width: AppSpacing.s4),
                        Text(
                          'Đã chọn',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.bgDeep,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final RoadmapDifficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    Color bgColor;

    switch (difficulty) {
      case RoadmapDifficulty.beginner:
        label = 'Cơ bản';
        color = AppColor.success;
        bgColor = AppColor.successDim;
        break;
      case RoadmapDifficulty.intermediate:
        label = 'Trung bình';
        color = AppColor.warn;
        bgColor = AppColor.warnDim;
        break;
      case RoadmapDifficulty.advanced:
        label = 'Nâng cao';
        color = AppColor.danger;
        bgColor = AppColor.dangerDim;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s10,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
