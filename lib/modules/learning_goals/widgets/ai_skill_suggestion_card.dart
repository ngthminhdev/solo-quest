import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';

enum SkillDifficulty {
  easy,
  medium,
  hard,
}

class AiSkillSuggestion {
  final String id;
  final String name;
  final String description;
  final SkillDifficulty difficulty;
  final int suggestedMinutesPerDay;

  const AiSkillSuggestion({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.suggestedMinutesPerDay,
  });
}

class AiSkillSuggestionCard extends StatelessWidget {
  final AiSkillSuggestion suggestion;
  final bool isSelected;
  final VoidCallback onTap;

  const AiSkillSuggestionCard({
    super.key,
    required this.suggestion,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        padding: const EdgeInsets.all(AppSpacing.s14),
        decoration: BoxDecoration(
          color: AppColor.surface,
          border: Border.all(
            color: isSelected ? AppColor.cyan : AppColor.border,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.primaryHoverOverlay,
                    blurRadius: 8,
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
                // Skill name
                Expanded(
                  child: Text(
                    suggestion.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColor.fg,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.s10),
                // Difficulty badge
                _DifficultyBadge(difficulty: suggestion.difficulty),
              ],
            ),

            const SizedBox(height: AppSpacing.s6),

            // Description
            Text(
              suggestion.description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColor.fgSecondary,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppSpacing.s10),

            // Footer row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Duration
                Row(
                  children: [
                    const Icon(
                      RemixIcons.time_line,
                      size: 14,
                      color: AppColor.fgMuted,
                    ),
                    const SizedBox(width: AppSpacing.s4),
                    Text(
                      '${suggestion.suggestedMinutesPerDay} ${l10n.lgCardMinutesPerDay}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColor.fgMuted,
                      ),
                    ),
                  ],
                ),

                // Action button
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? AppColor.success : AppColor.bgRaised,
                    foregroundColor: isSelected ? AppColor.bgDeep : AppColor.fgSecondary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s12,
                      vertical: AppSpacing.s6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      side: BorderSide(
                        color: isSelected ? AppColor.success : AppColor.border,
                      ),
                    ),
                  ),
                  child: Text(
                    isSelected ? '✓ ${l10n.aiSkillSelected}' : l10n.aiSkillSelect,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
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
  final SkillDifficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String label;
    Color color;
    Color bgColor;

    switch (difficulty) {
      case SkillDifficulty.easy:
        label = l10n.aiSkillDifficultyEasy;
        color = AppColor.success;
        bgColor = AppColor.successDim;
        break;
      case SkillDifficulty.medium:
        label = l10n.aiSkillDifficultyMedium;
        color = AppColor.warn;
        bgColor = AppColor.warnDim;
        break;
      case SkillDifficulty.hard:
        label = l10n.aiSkillDifficultyHard;
        color = AppColor.danger;
        bgColor = AppColor.dangerDim;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
