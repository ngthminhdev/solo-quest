import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../helpers/date_helper.dart';
import '../../../models/log_entry_model.dart';
import '../../../models/enums/log_enums.dart';
import '../../../routes/routes_config.dart';
import '../../../widgets/app_badge/quest_type_chip.dart';
import '../../../widgets/app_badge/exp_badge.dart';
import '../../../widgets/app_bottom_sheet/app_bottom_sheet.dart';
import '../constants/logs_constants.dart';

class LogDetailBottomSheet {
  static void show(
    BuildContext context, {
    required LogEntryModel log,
  }) {
    AppBottomSheet.show(
      context: context,
      title: log.title,
      subtitle: '${DateHelper.formatDateTime(log.createdAt)} · ${DateHelper.formatTime(log.createdAt)}',
      body: _LogDetailContent(log: log),
    );
  }
}

class _LogDetailContent extends StatelessWidget {
  final LogEntryModel log;

  const _LogDetailContent({required this.log});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Type badge
        _buildRow(
          icon: RemixIcons.folder_line,
          label: 'Loại',
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s10,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: _typeColor.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              log.type.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _typeColor,
              ),
            ),
          ),
        ),

        // Description
        if (log.description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s16),
          _buildRow(
            icon: RemixIcons.file_text_line,
            label: 'Mô tả',
            child: Text(
              log.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColor.fg,
                height: 1.5,
              ),
            ),
          ),
        ],

        // Quest type
        if (log.questType != null) ...[
          const SizedBox(height: AppSpacing.s16),
          _buildRow(
            icon: RemixIcons.flag_line,
            label: 'Quest Type',
            child: QuestTypeChip(type: log.questType!),
          ),
        ],

        // EXP
        if (log.expChanged != null && log.expChanged! > 0) ...[
          const SizedBox(height: AppSpacing.s16),
          _buildRow(
            icon: RemixIcons.star_line,
            label: 'EXP',
            child: ExpBadge(exp: log.expChanged!),
          ),
        ],

        // Points
        if (log.pointsChanged != null && log.pointsChanged != 0) ...[
          const SizedBox(height: AppSpacing.s16),
          _buildRow(
            icon: RemixIcons.gift_line,
            label: 'Điểm thưởng',
            child: Text(
              '${log.pointsChanged! > 0 ? '+' : ''}${log.pointsChanged} điểm',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: log.pointsChanged! > 0 ? AppColor.cyan : AppColor.warn,
              ),
            ),
          ),
        ],

        // Mood
        if (log.mood != null) ...[
          const SizedBox(height: AppSpacing.s16),
          _buildRow(
            icon: RemixIcons.emotion_line,
            label: 'Cảm xúc',
            child: Text(
              '${log.mood!.iconText} ${log.mood!.label}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColor.violet,
              ),
            ),
          ),
        ],

        // Metadata
        if (log.metadata.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s16),
          _buildRow(
            icon: RemixIcons.code_line,
            label: 'Metadata',
            child: Text(
              log.metadata.entries
                  .map((e) => '${e.key}: ${e.value}')
                  .join('\n'),
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'JetBrains Mono',
                color: AppColor.fgSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],

        // Navigate to quest button
        if (log.questId != null) ...[
          const SizedBox(height: AppSpacing.s20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(
                RoutesConfig.questDetail,
                arguments: {'id': log.questId},
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.s12,
              ),
              decoration: BoxDecoration(
                color: AppColor.cyanDim,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.borderGlowCyan),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    RemixIcons.external_link_line,
                    size: 16,
                    color: AppColor.cyan,
                  ),
                  SizedBox(width: AppSpacing.s8),
                  Text(
                    LogsConstants.viewQuestLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColor.cyan,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRow({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColor.fgMuted),
        const SizedBox(width: AppSpacing.s10),
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.fgMuted,
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
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
}
