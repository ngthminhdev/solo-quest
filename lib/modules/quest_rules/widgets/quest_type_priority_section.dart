import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/quest_rule_model.dart';
import '../../../widgets/app_badge/quest_type_chip.dart';
import '../../../widgets/app_card/app_card.dart';
import '../constants/quest_rules_constants.dart';

class QuestTypePrioritySection extends StatelessWidget {
  final List<QuestRuleModel> rules;

  const QuestTypePrioritySection({super.key, required this.rules});

  @override
  Widget build(BuildContext context) {
    final enabledRules = rules.where((rule) => rule.enabled).toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));

    if (enabledRules.isEmpty) return const SizedBox.shrink();

    return AppCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
      ).copyWith(bottom: AppSpacing.s12),
      padding: const EdgeInsets.all(AppSpacing.s14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(RemixIcons.sort_desc, size: 18, color: AppColor.violet),
              SizedBox(width: AppSpacing.s8),
              Text(
                QuestRulesConstants.priorityTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColor.fg,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: enabledRules.map((rule) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.bgRaised,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: AppColor.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QuestTypeChip(type: rule.type),
                    const SizedBox(width: AppSpacing.s6),
                    Text(
                      'Ưu tiên ${rule.priority}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColor.fgSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
