import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/weekly_summary_model.dart';
import '../constants/weekly_summary_constants.dart';

class WeeklyQuestRanking extends StatelessWidget {
  final WeeklySummaryModel summary;

  const WeeklyQuestRanking({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    // Use category breakdown from model, sorted by rate descending
    final categories = List<WeeklyCategoryBreakdown>.from(
      summary.categoryBreakdown,
    )..sort((a, b) => b.rate.compareTo(a.rate));

    final topCategories = categories.take(3).toList();

    if (topCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(WeeklySummaryConstants.sectionTopQuests),
          const SizedBox(height: AppSpacing.s12),
          ...topCategories.asMap().entries.map((entry) {
            final position = entry.key + 1;
            final data = entry.value;
            final ratePercent = (data.rate * 100).round();
            final rateColor =
                ratePercent >= 70 ? AppColor.success : AppColor.warn;

            return _RankingCard(
              position: position,
              name: data.displayLabel,
              note: '${data.completed}/${data.total} hoàn thành',
              rate: ratePercent,
              rateColor: rateColor,
            );
          }),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      '◆ $title',
      style: const TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColor.fgMuted,
        letterSpacing: 0.06,
      ),
    );
  }
}

class _RankingCard extends StatelessWidget {
  final int position;
  final String name;
  final String note;
  final int rate;
  final Color rateColor;

  const _RankingCard({
    required this.position,
    required this.name,
    required this.note,
    required this.rate,
    required this.rateColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s8),
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColor.surface,
        border: Border.all(color: AppColor.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Text(
            '$position',
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColor.fgMuted,
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fg,
                  ),
                ),
                Text(
                  note,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.fgSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$rate%',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: rateColor,
            ),
          ),
        ],
      ),
    );
  }
}
