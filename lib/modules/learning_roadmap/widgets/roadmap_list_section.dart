import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/learning_roadmap_model.dart';
import '../../../widgets/app_section_header/app_section_header.dart';
import 'learning_roadmap_empty_view.dart';
import 'roadmap_card.dart';

class RoadmapListSection extends StatelessWidget {
  final List<LearningRoadmapModel> roadmaps;
  final ValueChanged<LearningRoadmapModel> onOpenRoadmap;
  final VoidCallback? onCreateRoadmap;

  const RoadmapListSection({
    super.key,
    required this.roadmaps,
    required this.onOpenRoadmap,
    this.onCreateRoadmap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (roadmaps.isEmpty) {
      return LearningRoadmapEmptyView(onCreateRoadmap: onCreateRoadmap);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: l10n.lrSectionTitle,
            subtitle: '${roadmaps.length} lộ trình',
          ),
          const SizedBox(height: AppSpacing.s12),
          ...roadmaps.map(
            (roadmap) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s12),
              child: RoadmapCard(
                roadmap: roadmap,
                onTap: () => onOpenRoadmap(roadmap),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
