import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/enums/quest_enums.dart';
import '../../../models/quest_rule_model.dart';
import '../../../modules/quests/ui/quest_ui_extensions.dart';
import '../../../widgets/app_badge/quest_type_chip.dart';
import '../../../widgets/app_card/app_card.dart';
import '../../../extensions/localization_extension.dart';

class QuestRuleCard extends StatelessWidget {
  final QuestRuleModel rule;
  final bool isLocked;
  final VoidCallback? onEdit;
  final ValueChanged<bool>? onToggle;

  const QuestRuleCard({
    super.key,
    required this.rule,
    required this.isLocked,
    this.onEdit,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accent = _accentColor(rule.type);

    return Opacity(
      opacity: rule.enabled ? 1 : 0.68,
      child: AppCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.s10),
        border: Border.all(
          color: rule.enabled
              ? accent.withValues(alpha: 0.35)
              : AppColor.border,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(rule.type.icon, size: 20, color: accent),
                ),
                const SizedBox(width: AppSpacing.s10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rule.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColor.fg,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s2),
                      Text(
                        rule.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColor.fgSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                _QuestRuleSwitch(
                  value: rule.enabled,
                  enabled: !isLocked,
                  onChanged: onToggle,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                QuestTypeChip(type: rule.type),
                _InfoPill(
                  icon: RemixIcons.notification_badge_line,
                  label: rule.enabled ? l10n.questRulesMetricEnabled : l10n.questRulesMetricDisabled,
                  color: rule.enabled ? AppColor.success : AppColor.fgMuted,
                ),
                _InfoPill(
                  icon: RemixIcons.flashlight_line,
                  label: rule.difficulty.getLocalizedLabel(l10n),
                  color: _difficultyColor(rule.difficulty),
                ),
                if (rule.minIntervalMinutes != null)
                  _InfoPill(
                    icon: RemixIcons.timer_line,
                    label: l10n.questRulesRuleCardInterval(rule.minIntervalMinutes!),
                    color: AppColor.cyan,
                  ),
                if (rule.maxPerDay != null)
                  _InfoPill(
                    icon: RemixIcons.speed_up_line,
                    label: l10n.questRulesRuleCardMaxPerDay(rule.maxPerDay!),
                    color: AppColor.info,
                  ),
                if (rule.activeTimeRange != null)
                  _InfoPill(
                    icon: RemixIcons.time_line,
                    label: rule.activeTimeRange.toString(),
                    color: AppColor.violet,
                  ),
                _InfoPill(
                  icon: RemixIcons.arrow_up_circle_line,
                  label: l10n.questRulesRuleCardPriority(rule.priority),
                  color: AppColor.warn,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s10),
            Wrap(
              spacing: AppSpacing.s6,
              runSpacing: AppSpacing.s6,
              children: [
                if (rule.adaptToEnergy)
                  const _AdaptChip(
                    label: 'Energy',
                    icon: RemixIcons.battery_2_charge_line,
                  ),
                if (rule.adaptToStress)
                  const _AdaptChip(
                    label: 'Stress',
                    icon: RemixIcons.mental_health_line,
                  ),
                if (rule.adaptToSchedule)
                  const _AdaptChip(
                    label: 'Schedule',
                    icon: RemixIcons.calendar_line,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    rule.difficulty.getLocalizedDescription(l10n),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.fgSecondary,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                GestureDetector(
                  onTap: isLocked ? null : onEdit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s10,
                      vertical: AppSpacing.s8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.cyanDim,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: AppColor.borderGlowCyan),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          RemixIcons.edit_2_line,
                          size: 14,
                          color: AppColor.cyan,
                        ),
                        const SizedBox(width: AppSpacing.s4),
                        Text(
                          l10n.questRulesRuleCardEditButton,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColor.cyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _accentColor(QuestType type) {
    switch (type) {
      case QuestType.water:
        return AppColor.info;
      case QuestType.breakTime:
        return AppColor.violet;
      case QuestType.movement:
        return AppColor.success;
      case QuestType.learning:
        return AppColor.warn;
      case QuestType.sleep:
        return AppColor.chipSleepText;
      case QuestType.fitness:
        return AppColor.danger;
      case QuestType.mindfulness:
        return AppColor.violet;
      case QuestType.review:
        return AppColor.cyan;
      case QuestType.custom:
        return AppColor.fgSecondary;
    }
  }

  Color _difficultyColor(QuestDifficulty difficulty) => difficulty.color;
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: AppSpacing.s4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdaptChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _AdaptChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s6,
      ),
      decoration: BoxDecoration(
        color: AppColor.surfaceHover,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColor.cyan),
          const SizedBox(width: AppSpacing.s4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColor.fgSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestRuleSwitch extends StatelessWidget {
  final bool value;
  final bool enabled;
  final ValueChanged<bool>? onChanged;

  const _QuestRuleSwitch({
    required this.value,
    required this.enabled,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => onChanged?.call(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 46,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? AppColor.cyan : AppColor.surfaceHover,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: value ? AppColor.borderGlowCyan : AppColor.border,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.fg,
            ),
          ),
        ),
      ),
    );
  }
}
