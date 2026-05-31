import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_text_style.dart';
import '../../../models/log_entry_model.dart';
import '../constants/logs_constants.dart';
import 'log_empty_view.dart';
import 'log_timeline_item.dart';

class LogsTimelineSection extends StatelessWidget {
  final List<LogEntryModel> logs;
  final ValueChanged<LogEntryModel>? onLogTap;

  const LogsTimelineSection({
    super.key,
    required this.logs,
    this.onLogTap,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const LogEmptyView();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.s4,
              top: AppSpacing.s12,
              bottom: AppSpacing.s12,
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.cyan,
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.cyanGlow,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Text(
                  LogsConstants.sectionTitle,
                  style: AppTextStyle.sectionLabel.copyWith(
                    color: AppColor.fgSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${logs.length} hoạt động',
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 10,
                    color: AppColor.fgMuted,
                  ),
                ),
              ],
            ),
          ),
          ...logs.asMap().entries.map((entry) {
            final index = entry.key;
            final log = entry.value;
            return LogTimelineItem(
              log: log,
              isLast: index == logs.length - 1,
              onTap: onLogTap != null ? () => onLogTap!(log) : null,
            );
          }),
        ],
      ),
    );
  }
}
