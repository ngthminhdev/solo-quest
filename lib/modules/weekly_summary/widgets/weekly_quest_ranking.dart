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
    final rankings = [
      _RankingData('Learning Quest', 'Hiệu quả nhất sau 20:00', 85, AppColor.success),
      _RankingData('Water Quest', 'Ổn định khi nhắc cách nhau 90 phút', 78, AppColor.success),
      _RankingData('Break Quest', 'Thường bị hoãn vào buổi sáng', 65, AppColor.warn),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(WeeklySummaryConstants.sectionTopQuests),
          const SizedBox(height: AppSpacing.s12),
          ...rankings.asMap().entries.map((entry) {
            return _RankingCard(
              position: entry.key + 1,
              data: entry.value,
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

class _RankingData {
  final String name;
  final String note;
  final int rate;
  final Color rateColor;

  const _RankingData(this.name, this.note, this.rate, this.rateColor);
}

class _RankingCard extends StatelessWidget {
  final int position;
  final _RankingData data;

  const _RankingCard({required this.position, required this.data});

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
                  data.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fg,
                  ),
                ),
                Text(
                  data.note,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.fgSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${data.rate}%',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: data.rateColor,
            ),
          ),
        ],
      ),
    );
  }
}
