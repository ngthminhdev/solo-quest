import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_text_style.dart';
import '../../../helpers/date_helper.dart';
import '../constants/logs_constants.dart';

class LogsHeader extends StatelessWidget {
  final DateTime selectedDate;

  const LogsHeader({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = selectedDate.year == yesterday.year &&
        selectedDate.month == yesterday.month &&
        selectedDate.day == yesterday.day;

    String dateLabel;
    if (isToday) {
      dateLabel = LogsConstants.todayLabel;
    } else if (isYesterday) {
      dateLabel = LogsConstants.yesterdayLabel;
    } else {
      dateLabel = DateHelper.formatDateTime(selectedDate);
    }

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
            'Nhật ký cá nhân',
            style: AppTextStyle.heading.copyWith(color: AppColor.fg),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            'Theo dõi hành vi, quest và cảm xúc của bạn',
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
                const Icon(
                  RemixIcons.calendar_line,
                  size: 14,
                  color: AppColor.cyan,
                ),
                const SizedBox(width: AppSpacing.s6),
                Text(
                  dateLabel,
                  style: const TextStyle(
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
