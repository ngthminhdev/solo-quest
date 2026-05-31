import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../constants/learning_goals_constants.dart';

class LearningGoalsEmptyView extends StatelessWidget {
  const LearningGoalsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColor.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.border),
            ),
            child: const Icon(
              RemixIcons.add_circle_line,
              size: 36,
              color: AppColor.fgMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            LearningGoalsConstants.emptyTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.fg,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            LearningGoalsConstants.emptyMessage,
            style: TextStyle(
              fontSize: 13,
              color: AppColor.fgMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
