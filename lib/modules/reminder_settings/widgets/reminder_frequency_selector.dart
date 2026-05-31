import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../models/enums/reminder_enums.dart';
import '../../../widgets/app_form/app_option_card.dart';

class ReminderFrequencySelector extends StatelessWidget {
  final ReminderFrequency value;
  final ValueChanged<ReminderFrequency> onChanged;

  const ReminderFrequencySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ReminderFrequency.values.map((frequency) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s8),
          child: AppOptionCard(
            title: frequency.label,
            subtitle: frequency.description,
            selected: value == frequency,
            onTap: () => onChanged(frequency),
          ),
        );
      }).toList(),
    );
  }
}
