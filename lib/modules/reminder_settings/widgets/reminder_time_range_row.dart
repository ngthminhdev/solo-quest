import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../helpers/time_helper.dart';
import '../../../extensions/localization_extension.dart';

class ReminderTimeRangeRow extends StatelessWidget {
  final String? startTime;
  final String? endTime;
  final ValueChanged<String> onStartChanged;
  final ValueChanged<String> onEndChanged;

  const ReminderTimeRangeRow({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TimePickerField(
            label: context.l10n.reminderSettingsTimeStart,
            value: startTime,
            onChanged: onStartChanged,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s10),
          child: Icon(
            RemixIcons.arrow_right_s_line,
            size: 18,
            color: AppColor.fgMuted,
          ),
        ),
        Expanded(
          child: _TimePickerField(
            label: context.l10n.reminderSettingsTimeEnd,
            value: endTime,
            onChanged: onEndChanged,
          ),
        ),
      ],
    );
  }
}

class _TimePickerField extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<String> onChanged;

  const _TimePickerField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return GestureDetector(
      onTap: () => _pickTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s10,
        ),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColor.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11, color: AppColor.fgMuted),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              hasValue ? value! : '',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: hasValue ? AppColor.fg : AppColor.fgMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await TimeHelper.pickTime(
      context,
      currentTime: value,
    );

    if (picked != null) {
      onChanged(picked);
    }
  }
}
