import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../constants/daily_review_constants.dart';

class DailyReviewNoteCard extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const DailyReviewNoteCard({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            DailyReviewConstants.sectionNote,
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              color: AppColor.fgMuted,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Container(
            decoration: BoxDecoration(
              color: AppColor.surface,
              border: Border.all(color: AppColor.border),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: TextField(
              onChanged: onChanged,
              maxLines: 3,
              minLines: 3,
              style: const TextStyle(
                fontSize: 13,
                color: AppColor.fg,
                fontFamily: 'Exo2',
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: DailyReviewConstants.noteHint,
                hintStyle: const TextStyle(
                  color: AppColor.fgMuted,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(AppSpacing.s12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
