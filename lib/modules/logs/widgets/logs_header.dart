import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_text_style.dart';
import '../../../core/utils/app_time_formatter.dart';
import '../../../extensions/localization_extension.dart';

class LogsHeader extends StatelessWidget {
  final DateTime selectedDate;

  const LogsHeader({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final dateLabel = AppTimeFormatter.formatRelativeDay(selectedDate) ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s20,
        AppSpacing.s16,
        AppSpacing.s20,
        AppSpacing.s4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.logsHeaderTitle,
            style: AppTextStyle.heading.copyWith(color: AppColor.fg),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            context.l10n.logsHeaderSubtitle,
            style: AppTextStyle.caption.copyWith(color: AppColor.fgSecondary),
          ),
          const SizedBox(height: AppSpacing.s8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s6,
            ),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  RemixIcons.calendar_line,
                  size: 14,
                  color: AppColor.cyan,
                ),
                const SizedBox(width: AppSpacing.s6),
                Text(
                  dateLabel,
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColor.cyan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
