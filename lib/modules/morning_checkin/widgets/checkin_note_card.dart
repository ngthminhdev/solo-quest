import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../widgets/app_form/app_text_area.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../constants/morning_checkin_constants.dart';

class CheckinNoteCard extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const CheckinNoteCard({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(title: MorningCheckinConstants.noteLabel),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: AppTextArea(
            hint: MorningCheckinConstants.noteHint,
            onChanged: onChanged,
            maxLines: 3,
            maxLength: 200,
          ),
        ),
      ],
    );
  }
}
