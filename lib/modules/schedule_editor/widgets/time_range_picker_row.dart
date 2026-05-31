import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../helpers/time_helper.dart';

class TimeRangePickerRow extends StatelessWidget {
  final String start;
  final String end;
  final ValueChanged<String> onStartChanged;
  final ValueChanged<String> onEndChanged;

  const TimeRangePickerRow({
    super.key,
    required this.start,
    required this.end,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TimePickerField(
            label: 'Bắt đầu',
            value: start,
            onChanged: onStartChanged,
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        const Icon(
          RemixIcons.arrow_right_s_line,
          size: 16,
          color: AppColor.fgMuted,
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: _TimePickerField(
            label: 'Kết thúc',
            value: end,
            onChanged: onEndChanged,
          ),
        ),
      ],
    );
  }
}

class _TimePickerField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _TimePickerField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
              style: const TextStyle(
                fontSize: 11,
                color: AppColor.fgMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              value.isEmpty ? '--:--' : TimeHelper.formatOrFallback(value),
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: value.isEmpty ? AppColor.fgMuted : AppColor.fg,
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
