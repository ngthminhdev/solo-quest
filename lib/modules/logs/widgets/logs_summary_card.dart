import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_text_style.dart';
import '../../../extensions/localization_extension.dart';

class LogsSummaryCard extends StatelessWidget {
  final int totalLogs;
  final int completedQuests;
  final int skippedQuests;
  final int earnedExp;

  const LogsSummaryCard({
    super.key,
    required this.totalLogs,
    required this.completedQuests,
    required this.skippedQuests,
    required this.earnedExp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.s16, AppSpacing.s16, AppSpacing.s16, AppSpacing.s8),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.borderGlowCyan),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.logsSummaryTitle,
            style: AppTextStyle.sectionLabel.copyWith(
              color: AppColor.fgSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Row(
            children: [
              _buildStat(
                value: totalLogs.toString(),
                label: context.l10n.logsSummaryActivities,
                color: AppColor.cyan,
              ),
              const SizedBox(width: AppSpacing.s8),
              _buildStat(
                value: completedQuests.toString(),
                label: context.l10n.logsSummaryCompleted,
                color: AppColor.success,
              ),
              const SizedBox(width: AppSpacing.s8),
              _buildStat(
                value: skippedQuests.toString(),
                label: context.l10n.logsSummarySkipped,
                color: AppColor.warn,
              ),
              const SizedBox(width: AppSpacing.s8),
              _buildStat(
                value: '+$earnedExp',
                label: 'EXP',
                color: AppColor.expGold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColor.border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColor.fgMuted,
                letterSpacing: 0.04,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
