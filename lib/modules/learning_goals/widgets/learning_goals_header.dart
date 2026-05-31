import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../constants/learning_goals_constants.dart';

class LearningGoalsHeader extends StatelessWidget {
  const LearningGoalsHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
              border: Border.all(color: AppColor.cyan.withOpacity(0.3)),
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
                  LearningGoalsConstants.pageTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.fg,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  LearningGoalsConstants.pageSubtitle,
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
