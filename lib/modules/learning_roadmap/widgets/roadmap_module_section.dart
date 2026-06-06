import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/learning_roadmap_model.dart';
import 'module_lesson_item.dart';

enum ModuleStatus { completed, active }

class RoadmapModule {
  final String id;
  final String title;
  final int moduleNumber;
  final List<LearningRoadmapStepModel> lessons;
  final ModuleStatus status;

  const RoadmapModule({
    required this.id,
    required this.title,
    required this.moduleNumber,
    required this.lessons,
    required this.status,
  });
}

class RoadmapModuleSection extends StatelessWidget {
  final RoadmapModule module;
  final Set<String> selectedTopicIds;
  final ValueChanged<LearningRoadmapStepModel>? onToggleTopicSelection;

  const RoadmapModuleSection({
    super.key,
    required this.module,
    this.selectedTopicIds = const {},
    this.onToggleTopicSelection,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = module.lessons
        .where((topic) => topic.completed)
        .length;

    return Container(
      margin: const EdgeInsets.only(
        left: AppSpacing.s16,
        right: AppSpacing.s16,
        bottom: AppSpacing.s16,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s14,
        AppSpacing.s12,
        AppSpacing.s14,
        AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s8,
                  vertical: AppSpacing.s4,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  module.moduleNumber.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: Text(
                  module.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textPrimary,
                  ),
                ),
              ),
              _ModuleProgressBadge(
                completedCount: completedCount,
                totalCount: module.lessons.length,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          ...module.lessons.map((topic) {
            final status = _topicStatus(topic);
            return ModuleLessonItem(
              step: topic,
              status: status,
              onTap: () {
                if (topic.completed) return;
                onToggleTopicSelection?.call(topic);
              },
            );
          }),
        ],
      ),
    );
  }

  TopicStatus _topicStatus(LearningRoadmapStepModel topic) {
    if (topic.completed) return TopicStatus.completed;
    if (selectedTopicIds.contains(topic.id)) return TopicStatus.selected;
    return TopicStatus.notStarted;
  }
}

class _ModuleProgressBadge extends StatelessWidget {
  final int completedCount;
  final int totalCount;

  const _ModuleProgressBadge({
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: completedCount == totalCount
            ? AppColor.successBackground
            : AppColor.surfaceHover,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        '$completedCount/$totalCount',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: completedCount == totalCount
              ? AppColor.success
              : AppColor.textSecondary,
        ),
      ),
    );
  }
}

List<RoadmapModule> groupStepsIntoModules(
  List<LearningRoadmapStepModel> steps,
  String Function(int) getModuleTitle,
) {
  if (steps.isEmpty) return [];

  const topicsPerModule = 3;
  final modules = <RoadmapModule>[];

  for (int i = 0; i < steps.length; i += topicsPerModule) {
    final endIndex = (i + topicsPerModule < steps.length)
        ? i + topicsPerModule
        : steps.length;
    final moduleSteps = steps.sublist(i, endIndex);
    final moduleIndex = (i / topicsPerModule).floor() + 1;
    final allCompleted = moduleSteps.every((topic) => topic.completed);

    modules.add(
      RoadmapModule(
        id: 'module-$moduleIndex',
        title: getModuleTitle(moduleIndex),
        moduleNumber: moduleIndex,
        lessons: moduleSteps,
        status: allCompleted ? ModuleStatus.completed : ModuleStatus.active,
      ),
    );
  }

  return modules;
}
