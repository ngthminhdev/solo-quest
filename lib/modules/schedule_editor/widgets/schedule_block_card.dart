import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/schedule_model.dart';
import '../constants/schedule_editor_constants.dart';

class ScheduleBlockCard extends StatelessWidget {
  final ScheduleBlockModel block;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ScheduleBlockCard({
    super.key,
    required this.block,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Type icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColor.bgRaised,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  _getTypeIcon(block.type),
                  size: 18,
                  color: AppColor.cyan,
                ),
              ),
              const SizedBox(width: AppSpacing.s10),
              // Title
              Expanded(
                child: Text(
                  block.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fg,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Actions
              IconButton(
                icon: const Icon(RemixIcons.edit_2_line, size: 18),
                color: AppColor.fgMuted,
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: AppSpacing.s8),
              IconButton(
                icon: const Icon(RemixIcons.delete_bin_6_line, size: 18),
                color: AppColor.fgMuted,
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s10),

          // Time range
          Row(
            children: [
              Icon(RemixIcons.time_line, size: 14, color: AppColor.fgMuted),
              const SizedBox(width: AppSpacing.s6),
              Text(
                block.timeRange.toString(),
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.fgSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s8),

          // Weekdays
          Wrap(
            spacing: AppSpacing.s4,
            runSpacing: AppSpacing.s4,
            children: block.weekdays.map((day) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s6,
                  vertical: AppSpacing.s2,
                ),
                decoration: BoxDecoration(
                  color: AppColor.bgRaised,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  ScheduleEditorConstants.weekdayLabel(l10n, day),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fgMuted,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.s8),

          // Badges row
          Wrap(
            spacing: AppSpacing.s6,
            runSpacing: AppSpacing.s4,
            children: [
              // Busy badge
              if (block.isBusy)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s8,
                    vertical: AppSpacing.s4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.warnDim,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    border: Border.all(
                      color: AppColor.warn.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        RemixIcons.prohibited_line,
                        size: 12,
                        color: AppColor.warn,
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      Text(
                        ScheduleEditorConstants.text(
                          l10n,
                          ScheduleEditorConstants.badgeBusy,
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColor.warn,
                        ),
                      ),
                    ],
                  ),
                ),
              // Flexible badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s4,
                ),
                decoration: BoxDecoration(
                  color: block.isFlexible
                      ? AppColor.cyanDim
                      : AppColor.bgRaised,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  border: Border.all(
                    color: block.isFlexible
                        ? AppColor.cyan.withValues(alpha: 0.3)
                        : AppColor.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      block.isFlexible
                          ? RemixIcons.shuffle_line
                          : RemixIcons.lock_line,
                      size: 12,
                      color: block.isFlexible
                          ? AppColor.cyan
                          : AppColor.fgMuted,
                    ),
                    const SizedBox(width: AppSpacing.s4),
                    Text(
                      block.isFlexible
                          ? ScheduleEditorConstants.text(
                              l10n,
                              ScheduleEditorConstants.badgeFlexible,
                            )
                          : ScheduleEditorConstants.text(
                              l10n,
                              ScheduleEditorConstants.badgeFixed,
                            ),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: block.isFlexible
                            ? AppColor.cyan
                            : AppColor.fgMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'school':
        return RemixIcons.graduation_cap_line;
      case 'work':
        return RemixIcons.briefcase_4_line;
      case 'commute':
        return RemixIcons.bus_line;
      case 'meal':
        return RemixIcons.restaurant_line;
      case 'sleep':
        return RemixIcons.moon_line;
      case 'study':
        return RemixIcons.book_open_line;
      case 'personal':
        return RemixIcons.user_3_line;
      case 'busy':
        return RemixIcons.prohibited_line;
      case 'free':
        return RemixIcons.time_line;
      default:
        return RemixIcons.more_line;
    }
  }
}
