import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/enums/reminder_enums.dart';
import '../../../models/reminder_setting_model.dart';
import '../../../widgets/app_card/app_card.dart';

class ReminderSettingCard extends StatelessWidget {
  final ReminderSettingModel setting;
  final bool isLocked;
  final VoidCallback? onEdit;
  final ValueChanged<bool>? onToggle;

  const ReminderSettingCard({
    super.key,
    required this.setting,
    required this.isLocked,
    this.onEdit,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(setting.type);

    return Opacity(
      opacity: setting.isEnabled ? 1 : 0.68,
      child: AppCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.s10),
        border: Border.all(
          color: setting.isEnabled
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
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(setting.type.icon, size: 20, color: accent),
                ),
                const SizedBox(width: AppSpacing.s10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        setting.type.getLocalizedTitle(context.l10n),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColor.fg,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s2),
                      Text(
                        setting.type.getLocalizedDescription(context.l10n),
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColor.fgMuted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                _ReminderSwitch(
                  value: setting.isEnabled,
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
                _InfoPill(
                  icon: RemixIcons.notification_badge_line,
                  label: setting.status.getLocalizedLabel(context.l10n),
                  color: setting.isEnabled
                      ? AppColor.success
                      : AppColor.fgMuted,
                ),
                _InfoPill(
                  icon: RemixIcons.repeat_line,
                  label: setting.frequency.getLocalizedLabel(context.l10n),
                  color: AppColor.cyan,
                ),
                if (_timeLabel != null)
                  _InfoPill(
                    icon: RemixIcons.time_line,
                    label: _timeLabel!,
                    color: AppColor.violet,
                  ),
                if (setting.intervalMinutes != null)
                  _InfoPill(
                    icon: RemixIcons.timer_line,
                    label: context.l10n.reminderCardInterval(setting.intervalMinutes.toString()),
                    color: AppColor.warn,
                  ),
                if (setting.maxPerDay != null)
                  _InfoPill(
                    icon: RemixIcons.speed_up_line,
                    label: context.l10n.reminderCardMaxPerDay(setting.maxPerDay.toString()),
                    color: AppColor.info,
                  ),
                if (setting.smartEnabled)
                  _InfoPill(
                    icon: RemixIcons.sparkling_line,
                    label: context.l10n.reminderCardSmartReminder,
                    color: AppColor.cyan,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    setting.frequency.getLocalizedDescription(context.l10n),
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
                          context.l10n.reminderCardEditButton,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
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

  String? get _timeLabel {
    if (setting.startTime == null && setting.endTime == null) return null;
    if (setting.endTime == null || setting.endTime!.isEmpty) {
      return setting.startTime;
    }
    return '${setting.startTime ?? ''} - ${setting.endTime}';
  }

  Color _accentColor(ReminderType type) {
    switch (type) {
      case ReminderType.water:
        return AppColor.info;
      case ReminderType.breakTime:
        return AppColor.violet;
      case ReminderType.movement:
        return AppColor.success;
      case ReminderType.learning:
        return AppColor.warn;
      case ReminderType.sleep:
        return AppColor.chipSleepText;
      case ReminderType.dailyReview:
        return AppColor.cyan;
      case ReminderType.custom:
        return AppColor.fgSecondary;
    }
  }
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

class _ReminderSwitch extends StatelessWidget {
  final bool value;
  final bool enabled;
  final ValueChanged<bool>? onChanged;

  const _ReminderSwitch({
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
