import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../models/quest_model.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../../../widgets/quest/quest_card.dart';

class ActiveQuestSection extends StatelessWidget {
  final List<QuestModel> quests;
  final ValueChanged<QuestModel>? onStart;
  final ValueChanged<QuestModel>? onComplete;
  final ValueChanged<QuestModel>? onSnooze;
  final ValueChanged<QuestModel>? onSkip;
  final ValueChanged<QuestModel>? onTap;
  final ValueChanged<QuestModel>? onViewReason;

  const ActiveQuestSection({
    super.key,
    required this.quests,
    this.onStart,
    this.onComplete,
    this.onSnooze,
    this.onSkip,
    this.onTap,
    this.onViewReason,
  });

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'Cần làm ngay',
          dotColor: AppColor.cyan,
          count: '${quests.length} quest',
        ),
        ...quests.map((quest) => QuestCard(
          quest: quest,
          highlighted: quest.isImportant || quest.isActive,
          onTap: () => onTap?.call(quest),
          onStart: () => onStart?.call(quest),
          onComplete: () => onComplete?.call(quest),
          onSnooze: () => onSnooze?.call(quest),
          onSkip: () => onSkip?.call(quest),
          onViewReason: () => onViewReason?.call(quest),
        )),
      ],
    );
  }
}
