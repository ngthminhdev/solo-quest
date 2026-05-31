import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../helpers/date_helper.dart';
import '../../../models/log_entry_model.dart';
import '../../../models/enums/log_enums.dart';
import '../../../widgets/app_badge/quest_type_chip.dart';
import '../../../widgets/app_badge/exp_badge.dart';

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
                          style: const TextStyle(
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
                      style: const TextStyle(
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
                        style: const TextStyle(
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

  IconData get _typeIconData {
    switch (log.type) {
      case LogEntryType.questCompleted:
        return RemixIcons.checkbox_circle_line;
      case LogEntryType.questSkipped:
        return RemixIcons.skip_forward_line;
      case LogEntryType.questSnoozed:
        return RemixIcons.time_line;
      case LogEntryType.questStarted:
        return RemixIcons.play_line;
      case LogEntryType.questCreated:
        return RemixIcons.add_line;
      case LogEntryType.morningCheckin:
        return RemixIcons.sun_line;
      case LogEntryType.dailyReview:
        return RemixIcons.file_text_line;
      case LogEntryType.rewardClaimed:
        return RemixIcons.gift_line;
      case LogEntryType.levelUp:
        return RemixIcons.star_line;
      case LogEntryType.streakChanged:
        return RemixIcons.fire_line;
      case LogEntryType.profileUpdated:
        return RemixIcons.user_3_line;
      case LogEntryType.ruleUpdated:
        return RemixIcons.settings_3_line;
    }
  }

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
    }
  }

  Color get _typeColor {
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
        return AppColor.fgSecondary;
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
    }
  }

  Widget _buildMoodChip(LogMood mood) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColor.violetDim,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        '${mood.iconText} ${mood.label}',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColor.violet,
        ),
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
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        '${isNegative ? '' : '+'}$points điểm',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
