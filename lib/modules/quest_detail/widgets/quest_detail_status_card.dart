import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/quest_model.dart';

class QuestDetailStatusCard extends StatelessWidget {
  final QuestModel quest;

  const QuestDetailStatusCard({
    super.key,
    required this.quest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuickStat(
                icon: RemixIcons.time_line,
                value: '${quest.estimatedMinutes} phút',
              ),
              const SizedBox(width: AppSpacing.s16),
              _buildQuickStat(
                icon: RemixIcons.star_fill,
                value: '+${quest.exp} EXP',
                isExp: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String value,
    bool isExp = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: isExp ? AppColor.expGold : AppColor.fgMuted,
        ),
        const SizedBox(width: AppSpacing.s6),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Exo2',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isExp ? AppColor.expGold : AppColor.fg,
          ),
        ),
      ],
    );
  }
}
