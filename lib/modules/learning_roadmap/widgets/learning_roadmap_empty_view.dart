import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../routes/routes_config.dart';
import '../../../widgets/app_state/app_empty_state.dart';
import '../constants/learning_roadmap_constants.dart';

class LearningRoadmapEmptyView extends StatelessWidget {
  const LearningRoadmapEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: RemixIcons.map_2_line,
      title: LearningRoadmapConstants.emptyTitle,
      message: LearningRoadmapConstants.emptyMessage,
      action: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutesConfig.learningGoals);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.s12,
          ),
          decoration: BoxDecoration(
            color: AppColor.cyan,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            LearningRoadmapConstants.emptyButton,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColor.bgDeep,
            ),
          ),
        ),
      ),
    );
  }
}
