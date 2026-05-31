import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/enums/quest_enums.dart';
import '../../../models/quest_rule_model.dart';
import '../constants/quest_rules_constants.dart';
import 'quest_rule_card.dart';
import 'quest_rules_empty_view.dart';

class QuestRuleListSection extends StatelessWidget {
  final List<QuestRuleModel> rules;
  final QuestType? selectedType;
  final bool isLocked;
  final ValueChanged<QuestType?> onFilterChanged;
  final ValueChanged<QuestRuleModel> onEdit;
  final void Function(QuestRuleModel rule, bool enabled) onToggle;
  final VoidCallback? onReset;

  const QuestRuleListSection({
    super.key,
    required this.rules,
    required this.selectedType,
    required this.isLocked,
    required this.onFilterChanged,
    required this.onEdit,
    required this.onToggle,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            QuestRulesConstants.listTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColor.fg,
            ),
          ),
          const SizedBox(height: AppSpacing.s10),
          _TypeFilterBar(
            selectedType: selectedType,
            onChanged: onFilterChanged,
          ),
          const SizedBox(height: AppSpacing.s14),
          if (rules.isEmpty)
            QuestRulesEmptyView(onReset: onReset)
          else
            ...rules.map(
              (rule) => QuestRuleCard(
                rule: rule,
                isLocked: isLocked,
                onEdit: () => onEdit(rule),
                onToggle: (enabled) => onToggle(rule, enabled),
              ),
            ),
        ],
      ),
    );
  }
}

class _TypeFilterBar extends StatelessWidget {
  final QuestType? selectedType;
  final ValueChanged<QuestType?> onChanged;

  const _TypeFilterBar({required this.selectedType, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      _FilterChip(
        label: 'Tất cả',
        selected: selectedType == null,
        onTap: () => onChanged(null),
      ),
      ...QuestType.values.map(
        (type) => _FilterChip(
          label: type.label,
          selected: selectedType == type,
          onTap: () => onChanged(type),
        ),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: chips),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.s8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s8,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColor.cyanDim : AppColor.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: selected ? AppColor.borderGlowCyan : AppColor.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: selected ? AppColor.cyan : AppColor.fgSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
