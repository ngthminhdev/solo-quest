import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../widgets/app_form/app_chip_selector.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../constants/morning_checkin_constants.dart';

class AvailableTimeBlocksCard extends StatelessWidget {
  final List<String> selectedBlocks;
  final ValueChanged<String> onToggle;

  const AvailableTimeBlocksCard({
    super.key,
    required this.selectedBlocks,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(title: MorningCheckinConstants.timeBlocksLabel),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: AppChipSelector(
            options: MorningCheckinConstants.timeBlockOptions,
            selected: selectedBlocks,
            onToggle: onToggle,
          ),
        ),
      ],
    );
  }
}
