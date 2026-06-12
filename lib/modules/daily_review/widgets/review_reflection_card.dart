import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../../../extensions/localization_extension.dart';

class ReviewReflectionCard extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const ReviewReflectionCard({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: context.l10n.dailyReviewReflectionLabel,
          dotColor: AppColor.fgSecondary,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.surface,
              border: Border.all(color: AppColor.border),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: TextField(
              onChanged: onChanged,
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: value,
                  selection: TextSelection.collapsed(offset: value.length),
                ),
              ),
              maxLines: 3,
              minLines: 2,
              maxLength: 200,
              style: TextStyle(
                fontSize: 13,
                color: AppColor.fg,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: context.l10n.dailyReviewReflectionHint,
                hintStyle: TextStyle(
                  color: AppColor.fgMuted,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(AppSpacing.s12),
                counterStyle: TextStyle(
                  fontSize: 10,
                  color: AppColor.fgMuted,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
