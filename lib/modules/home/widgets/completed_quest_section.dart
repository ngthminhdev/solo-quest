import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../models/quest_model.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../../../widgets/quest/quest_card.dart';

class CompletedQuestSection extends StatelessWidget {
  final List<QuestModel> quests;
  final ValueChanged<QuestModel>? onTap;

  const CompletedQuestSection({
    super.key,
    required this.quests,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'Hoàn thành hôm nay',
          dotColor: AppColor.success,
          count: quests.isEmpty ? null : '${quests.length} quest',
        ),
        if (quests.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Chưa có quest nào hoàn thành hôm nay.',
              style: const TextStyle(
                fontSize: 13,
                color: AppColor.fgMuted,
              ),
            ),
          )
        else
          ...quests.map((quest) => QuestCard(
            quest: quest,
            onTap: () => onTap?.call(quest),
          )),
      ],
    );
  }
}
