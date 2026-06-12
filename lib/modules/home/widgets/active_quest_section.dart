import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../models/enums/quest_enums.dart';
import '../../../models/quest_model.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../../../widgets/quest/quest_card.dart';

class ActiveQuestSection extends StatelessWidget {
  final List<QuestModel> quests;
  final bool allCompleted;
  final Map<String, QuestActionType> pendingActions;
  final ValueChanged<QuestModel>? onStart;
  final ValueChanged<QuestModel>? onComplete;
  final ValueChanged<QuestModel>? onSnooze;
  final ValueChanged<QuestModel>? onSkip;
  final ValueChanged<QuestModel>? onTap;
  final ValueChanged<QuestModel>? onViewReason;

  const ActiveQuestSection({
    super.key,
    required this.quests,
    this.allCompleted = false,
    this.pendingActions = const {},
    this.onStart,
    this.onComplete,
    this.onSnooze,
    this.onSkip,
    this.onTap,
    this.onViewReason,
  });

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty && !allCompleted) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'Cần làm ngay',
          dotColor: AppColor.cyan,
          count: allCompleted ? 'Hoàn thành' : '${quests.length} quest',
        ),
        if (allCompleted)
          const _CompletedDayCard()
        else
          ...quests.map((quest) => QuestCard(
            quest: quest,
            highlighted: true,
            isActionPending: pendingActions.containsKey(quest.id),
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

class _CompletedDayCard extends StatelessWidget {
  const _CompletedDayCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColor.activeQuestGradient,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.successBorder),
        boxShadow: [
          BoxShadow(
            color: AppColor.successOverlay,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.successDim,
              shape: BoxShape.circle,
            ),
            child: Icon(
              RemixIcons.checkbox_circle_line,
              color: AppColor.success,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tất cả nhiệm vụ đã hoàn thành!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColor.fg,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Hôm nay thật tuyệt vời! Bạn đã hoàn thành xuất sắc tất cả các quest được giao.',
            style: TextStyle(
              fontSize: 13,
              color: AppColor.fgSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}