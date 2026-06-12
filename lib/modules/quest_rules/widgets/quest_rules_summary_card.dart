import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../widgets/app_card/app_glow_card.dart';

class QuestRulesSummaryCard extends StatelessWidget {
  final int totalRules;
  final int enabledCount;
  final int disabledCount;
  final int dailyQuestLimit;

  const QuestRulesSummaryCard({
    super.key,
    required this.totalRules,
    required this.enabledCount,
    required this.disabledCount,
    required this.dailyQuestLimit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppGlowCard(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(RemixIcons.settings_4_line, size: 18, color: AppColor.cyan),
              const SizedBox(width: AppSpacing.s8),
              Text(
                l10n.questRulesSummaryTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColor.fg,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s14),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  icon: RemixIcons.settings_4_line,
                  label: l10n.questRulesMetricTotal,
                  value: '$totalRules',
                  color: AppColor.cyan,
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  icon: RemixIcons.checkbox_circle_line,
                  label: l10n.questRulesMetricEnabled,
                  value: '$enabledCount',
                  color: AppColor.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s10),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  icon: RemixIcons.close_circle_line,
                  label: l10n.questRulesMetricDisabled,
                  value: '$disabledCount',
                  color: AppColor.fgSecondary,
                ),
              ),
              Expanded(
                child: _SummaryMetric(
                  icon: RemixIcons.calendar_check_line,
                  label: l10n.questRulesMetricDailyLimit,
                  value: '$dailyQuestLimit quest',
                  color: AppColor.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.s8),
      padding: const EdgeInsets.all(AppSpacing.s10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: color),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColor.fg,
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fgSecondary,
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
