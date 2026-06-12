import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../helpers/date_helper.dart';
import '../../../models/log_entry_model.dart';
import '../../../models/enums/log_enums.dart';
import '../../../widgets/app_badge/quest_type_chip.dart';
import '../../../widgets/app_badge/exp_badge.dart';
import '../../../extensions/localization_extension.dart';

class LogTimelineItem extends StatelessWidget {
  final LogEntryModel log;
  final bool isLast;
  final VoidCallback? onTap;

  const LogTimelineItem({
    super.key,
    required this.log,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timeline line + dot
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _dotColor,
                      boxShadow: [
                        BoxShadow(
                          color: _dotColor.withAlpha(80),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 1,
                        color: AppColor.border,
                      ),
                    ),
                ],
              ),
            ),
            // Content card
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  bottom: isLast ? 0 : AppSpacing.s12,
                ),
                padding: const EdgeInsets.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColor.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time + type icon
                    Row(
                      children: [
                        Text(
                          DateHelper.formatTime(log.createdAt),
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColor.fgMuted,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Icon(
                          _typeIconData,
                          size: 14,
                          color: _typeColor,
                        ),
                        const SizedBox(width: AppSpacing.s6),
                        Expanded(
                          child: Text(
                            log.type.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _typeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    // Title
                    Text(
                      log.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColor.fg,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Description
                    if (log.description.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        log.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.fgSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    // Tags row
                    if (_hasTags) ...[
                      const SizedBox(height: AppSpacing.s8),
                      Wrap(
                        spacing: AppSpacing.s6,
                        runSpacing: AppSpacing.s4,
                        children: [
                          if (log.questType != null)
                            QuestTypeChip(type: log.questType!),
                          if (log.expChanged != null && log.expChanged! > 0)
                            ExpBadge(exp: log.expChanged!),
                          if (log.pointsChanged != null && log.pointsChanged != 0)
                            _PointsBadge(points: log.pointsChanged!),
                          if (log.mood != null)
                            _buildMoodChip(log.mood!),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _hasTags =>
      log.questType != null ||
      (log.expChanged != null && log.expChanged! > 0) ||
      (log.pointsChanged != null && log.pointsChanged != 0) ||
      log.mood != null;

  IconData get _typeIconData => log.type.icon;
  Color get _typeColor => log.type.color;

  Color get _dotColor {
    switch (log.type) {
      case LogEntryType.questCompleted:
        return AppColor.success;
      case LogEntryType.questSkipped:
        return AppColor.warn;
      case LogEntryType.questSnoozed:
        return AppColor.info;
      case LogEntryType.questStarted:
        return AppColor.cyan;
      case LogEntryType.questCreated:
        return AppColor.fgMuted;
      case LogEntryType.morningCheckin:
        return AppColor.cyan;
      case LogEntryType.dailyReview:
        return AppColor.violet;
      case LogEntryType.rewardClaimed:
        return AppColor.cyan;
      case LogEntryType.levelUp:
        return AppColor.expGold;
      case LogEntryType.streakChanged:
        return AppColor.warn;
      case LogEntryType.profileUpdated:
        return AppColor.fgSecondary;
      case LogEntryType.ruleUpdated:
        return AppColor.fgSecondary;
      case LogEntryType.learningRoadmapCreated:
        return AppColor.cyan;
      case LogEntryType.learningRoadmapFollowed:
        return AppColor.info;
      case LogEntryType.learningRoadmapStepCompleted:
        return AppColor.success;
      case LogEntryType.learningRoadmapStepUncompleted:
        return AppColor.warn;
      case LogEntryType.learningRoadmapCompleted:
        return AppColor.expGold;
      case LogEntryType.onboardingCompleted:
        return AppColor.success;
      case LogEntryType.weeklySummaryGenerated:
        return AppColor.violet;
      case LogEntryType.questSettingsUpdated:
        return AppColor.fgSecondary;
      case LogEntryType.xpGained:
        return AppColor.expGold;
      case LogEntryType.system:
        return AppColor.fgSecondary;
      case LogEntryType.unknown:
        return AppColor.fgMuted;
    }
  }

  Widget _buildMoodChip(LogMood mood) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColor.violetDim,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(mood.icon, size: 12, color: AppColor.violet),
          const SizedBox(width: 4),
          Text(
            mood.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColor.violet,
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsBadge extends StatelessWidget {
  final int points;

  const _PointsBadge({required this.points});

  @override
  Widget build(BuildContext context) {
    final isNegative = points < 0;
    final color = isNegative ? AppColor.warn : AppColor.cyan;
    final bgColor = isNegative ? AppColor.warnDim : AppColor.cyanDim;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        context.l10n.logsDetailPointsValue(
          isNegative ? '$points' : '+$points',
        ),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
