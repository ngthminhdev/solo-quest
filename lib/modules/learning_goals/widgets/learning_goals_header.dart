import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';

class LearningGoalsHeader extends StatelessWidget {
  const LearningGoalsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColor.cyanDim,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.primaryBorder),
            ),
            child: const Icon(
              RemixIcons.book_open_line,
              color: AppColor.cyan,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.lgPageTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.fg,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  l10n.lgPageSubtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.fgMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
