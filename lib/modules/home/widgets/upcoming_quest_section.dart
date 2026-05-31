import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../models/quest_model.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../../../widgets/quest/quest_card.dart';

class UpcomingQuestSection extends StatelessWidget {
  final List<QuestModel> quests;
  final ValueChanged<QuestModel>? onStart;
  final ValueChanged<QuestModel>? onComplete;
  final ValueChanged<QuestModel>? onTap;

  const UpcomingQuestSection({
    super.key,
    required this.quests,
    this.onStart,
    this.onComplete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'Sắp tới',
          dotColor: AppColor.fgMuted,
          count: '${quests.length} quest',
        ),
        ...quests.map((quest) => QuestCard(
          quest: quest,
          onTap: () => onTap?.call(quest),
          onStart: () => onStart?.call(quest),
          onComplete: () => onComplete?.call(quest),
        )),
      ],
    );
  }
}
