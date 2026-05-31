import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../constants/schedule_editor_constants.dart';

class WeekdaySelector extends StatelessWidget {
  final List<int> selectedWeekdays;
  final ValueChanged<List<int>> onChanged;

  const WeekdaySelector({
    super.key,
    required this.selectedWeekdays,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [1, 2, 3, 4, 5, 6, 7].map((day) {
        final isSelected = selectedWeekdays.contains(day);
        return GestureDetector(
          onTap: () => _toggleDay(day),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? AppColor.cyanDim : AppColor.surface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: isSelected ? AppColor.cyan : AppColor.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                ScheduleEditorConstants.weekdayLabels[day] ?? '',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColor.cyan : AppColor.fgMuted,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _toggleDay(int day) {
    final newSelection = List<int>.from(selectedWeekdays);
    if (newSelection.contains(day)) {
      newSelection.remove(day);
    } else {
      newSelection.add(day);
    }
    newSelection.sort();
    onChanged(newSelection);
  }
}
