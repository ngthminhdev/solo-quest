import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../widgets/app_form/app_text_field.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../constants/morning_checkin_constants.dart';

class MainFocusInputCard extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const MainFocusInputCard({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(title: MorningCheckinConstants.mainFocusLabel),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: AppTextField(
            hint: MorningCheckinConstants.mainFocusHint,
            onChanged: onChanged,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
