import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/enums/reminder_enums.dart';
import '../../../models/reminder_setting_model.dart';
import '../../../extensions/localization_extension.dart';
import 'reminder_setting_card.dart';
import 'reminder_settings_empty_view.dart';

class ReminderListSection extends StatelessWidget {
  final List<ReminderSettingModel> settings;
  final ReminderType? selectedType;
  final bool isLocked;
  final ValueChanged<ReminderType?> onFilterChanged;
  final ValueChanged<ReminderSettingModel> onEdit;
  final void Function(ReminderSettingModel setting, bool enabled) onToggle;

  const ReminderListSection({
    super.key,
    required this.settings,
    required this.selectedType,
    required this.isLocked,
    required this.onFilterChanged,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.reminderSettingsListTitle,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColor.fgMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.s10),
          _ReminderTypeFilterBar(
            selectedType: selectedType,
            onChanged: onFilterChanged,
          ),
          const SizedBox(height: AppSpacing.s12),
          if (settings.isEmpty)
            const ReminderSettingsEmptyView()
          else
            ...settings.map(
              (setting) => ReminderSettingCard(
                setting: setting,
                isLocked: isLocked,
                onEdit: () => onEdit(setting),
                onToggle: (enabled) => onToggle(setting, enabled),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReminderTypeFilterBar extends StatelessWidget {
  final ReminderType? selectedType;
  final ValueChanged<ReminderType?> onChanged;

  const _ReminderTypeFilterBar({
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s6,
      runSpacing: AppSpacing.s8,
      children: [
        _FilterChip(
          label: context.l10n.reminderSettingsFilterAll,
          selected: selectedType == null,
          onTap: () => onChanged(null),
        ),
        ...ReminderType.values.map(
          (type) => _FilterChip(
            label: type.getLocalizedLabel(context.l10n),
            selected: selectedType == type,
            onTap: () => onChanged(type),
          ),
        ),
      ],
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
    return GestureDetector(
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
            fontWeight: FontWeight.w700,
            color: selected ? AppColor.cyan : AppColor.fgSecondary,
          ),
        ),
      ),
    );
  }
}
