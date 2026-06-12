import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/quest_model.dart';
import '../../../widgets/app_section/app_section_header.dart';
import 'package:remixicon/remixicon.dart';

class SnoozedQuestSection extends StatelessWidget {
  final List<QuestModel> quests;
  final ValueChanged<QuestModel>? onTap;

  const SnoozedQuestSection({
    super.key,
    required this.quests,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'Đã hoãn',
          dotColor: AppColor.warn,
          count: '${quests.length} quest',
        ),
        ...quests.map((quest) => _SnoozedQuestCard(
              quest: quest,
              onTap: onTap,
            )),
      ],
    );
  }
}

class _SnoozedQuestCard extends StatelessWidget {
  final QuestModel quest;
  final ValueChanged<QuestModel>? onTap;

  const _SnoozedQuestCard({
    required this.quest,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(quest),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s4,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s14,
          vertical: AppSpacing.s12,
        ),
        decoration: BoxDecoration(
          color: AppColor.surface,
          border: Border.all(
            color: AppColor.warningOverlay,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Opacity(
          opacity: 0.7,
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColor.warnDim,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Icon(
                  RemixIcons.time_line,
                  color: AppColor.warn,
                  size: 16,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColor.fgSecondary,
                      ),
                    ),
                    if (quest.description.isNotEmpty)
                      Text(
                        quest.description,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColor.fgMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
