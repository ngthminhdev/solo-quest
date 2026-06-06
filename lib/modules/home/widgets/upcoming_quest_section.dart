import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../models/enums/quest_enums.dart';
import '../../../models/quest_model.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../../../widgets/quest/quest_card.dart';

class UpcomingQuestSection extends StatelessWidget {
  final List<QuestModel> quests;
  final Map<String, QuestActionType> pendingActions;
  final ValueChanged<QuestModel>? onStart;
  final ValueChanged<QuestModel>? onComplete;
  final ValueChanged<QuestModel>? onTap;

  const UpcomingQuestSection({
    super.key,
    required this.quests,
    this.pendingActions = const {},
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
          isActionPending: pendingActions.containsKey(quest.id),
          onTap: () => onTap?.call(quest),
          onStart: () => onStart?.call(quest),
          onComplete: () => onComplete?.call(quest),
        )),
      ],
    );
  }
}
