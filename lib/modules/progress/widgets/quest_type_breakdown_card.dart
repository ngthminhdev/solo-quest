import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/enums/quest_enums.dart';
import '../../../widgets/app_card/app_card.dart';
import '../../../widgets/app_badge/quest_type_chip.dart';

class QuestTypeBreakdownCard extends StatelessWidget {
  final Map<QuestType, int> completedByType;

  const QuestTypeBreakdownCard({super.key, required this.completedByType});

  @override
  Widget build(BuildContext context) {
    if (completedByType.isEmpty) {
      return AppCard(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
        ).copyWith(bottom: 0),
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              title: 'Theo loại quest',
              color: AppColor.violet,
            ),
            const SizedBox(height: AppSpacing.s8),
            const Text(
              'Chưa có dữ liệu phân loại.',
              style: TextStyle(fontSize: 13, color: AppColor.fgMuted),
            ),
          ],
        ),
      );
    }

    final total = completedByType.values.fold<int>(0, (sum, v) => sum + v);
    final sortedEntries = completedByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final visibleEntries = sortedEntries.take(5).toList();
    final maxValue = sortedEntries.first.value;

    return AppCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
      ).copyWith(bottom: 0),
      padding: const EdgeInsets.all(AppSpacing.s16),
      bgColor: AppColor.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(title: 'Theo loại quest', color: AppColor.violet),
          const SizedBox(height: AppSpacing.s6),
          ...visibleEntries.map(
            (entry) => _TypeRow(
              type: entry.key,
              count: entry.value,
              total: total,
              maxCount: maxValue,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeRow extends StatelessWidget {
  final QuestType type;
  final int count;
  final int total;
  final int maxCount;

  const _TypeRow({
    required this.type,
    required this.count,
    required this.total,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : count / maxCount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Column(
        children: [
          Row(
            children: [
              QuestTypeChip(type: type),
              const SizedBox(width: AppSpacing.s10),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColor.bgRaised,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: FractionallySizedBox(
                    widthFactor: ratio.clamp(0.0, 1.0),
                    alignment: Alignment.centerLeft,
                    child: Container(color: _barColor(type)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s10),
              SizedBox(
                width: 36,
                child: Text(
                  '$count',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColor.fg,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _barColor(QuestType type) {
    switch (type) {
      case QuestType.water:
        return AppColor.chipWaterText;
      case QuestType.breakTime:
        return AppColor.chipBreakText;
      case QuestType.movement:
        return AppColor.chipMovementText;
      case QuestType.learning:
        return AppColor.chipLearningText;
      case QuestType.sleep:
        return AppColor.chipSleepText;
      case QuestType.fitness:
        return AppColor.chipFitnessText;
      case QuestType.mindfulness:
        return AppColor.violet;
      case QuestType.review:
        return AppColor.violet;
      case QuestType.custom:
        return AppColor.cyan;
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionLabel({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.s6),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: AppColor.fgMuted,
          ),
        ),
      ],
    );
  }
}
