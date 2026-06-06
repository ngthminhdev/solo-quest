import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../core/utils/app_time_formatter.dart';
import '../../../models/log_entry_model.dart';
import '../../../models/enums/log_enums.dart';

class QuestDetailHistorySection extends StatelessWidget {
  final List<LogEntryModel> logs;

  const QuestDetailHistorySection({
    super.key,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Lịch Sử Nhiệm Vụ',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              color: AppColor.fgMuted,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),

          // History list
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s14,
              vertical: AppSpacing.s12,
            ),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColor.border),
            ),
            child: Column(
              children: logs.map((log) => _buildHistoryItem(log)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(LogEntryModel log) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        children: [
          // Date
          SizedBox(
            width: 50,
            child: Text(
              _formatDate(log.createdAt),
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: AppColor.fgMuted,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s12),

          // Status with icon
          Expanded(
            child: Row(
              children: [
                Text(
                  _getStatusIcon(log.type),
                  style: TextStyle(
                    color: _getStatusColor(log.type),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: AppSpacing.s4),
                Expanded(
                  child: Text(
                    log.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(log.type),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return AppTimeFormatter.formatLocalDayMonth(date) ?? '';
  }

  String _getStatusIcon(LogEntryType type) {
    switch (type) {
      case LogEntryType.questCompleted:
        return '✓';
      case LogEntryType.questSkipped:
        return '—';
      case LogEntryType.questSnoozed:
        return '◷';
      case LogEntryType.questStarted:
        return '▶';
      default:
        return '•';
    }
  }

  Color _getStatusColor(LogEntryType type) {
    switch (type) {
      case LogEntryType.questCompleted:
        return AppColor.success;
      case LogEntryType.questSkipped:
        return AppColor.fgMuted;
      case LogEntryType.questSnoozed:
        return AppColor.warn;
      case LogEntryType.questStarted:
        return AppColor.cyan;
      default:
        return AppColor.fgSecondary;
    }
  }
}
