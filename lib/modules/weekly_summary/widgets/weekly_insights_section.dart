import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/weekly_summary_model.dart';
import '../constants/weekly_summary_constants.dart';

class WeeklyInsightsSection extends StatelessWidget {
  final WeeklySummaryModel summary;

  const WeeklyInsightsSection({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    if (summary.insights.isEmpty) return const SizedBox.shrink();

    final insightData = [
      _InsightData(
        icon: RemixIcons.drop_line,
        iconBg: AppColor.chipWaterBg,
        label: 'Ổn định',
        labelColor: AppColor.success,
        title: 'Water Quest 5/7 ngày',
        desc: summary.insights.isNotEmpty
            ? summary.insights[0]
            : 'Thói quen uống nước đang rất ổn định.',
      ),
      _InsightData(
        icon: RemixIcons.book_open_line,
        iconBg: AppColor.chipLearningBg,
        label: 'Hiệu quả',
        labelColor: AppColor.info,
        title: 'Learning Quest tốt nhất sau 20:00',
        desc: summary.insights.length > 1
            ? summary.insights[1]
            : 'Bạn hoàn thành học tập tốt hơn vào buổi tối.',
      ),
      _InsightData(
        icon: RemixIcons.cup_line,
        iconBg: AppColor.warnDim,
        label: 'Cần chú ý',
        labelColor: AppColor.warn,
        title: 'Break Quest hay bị hoãn buổi sáng',
        desc: summary.insights.length > 2
            ? summary.insights[2]
            : 'Bạn thường hoãn nghỉ mắt vào buổi sáng.',
      ),
      _InsightData(
        icon: RemixIcons.walk_line,
        iconBg: AppColor.dangerDim,
        label: 'Bỏ qua nhiều',
        labelColor: AppColor.danger,
        title: 'Movement Quest bị bỏ qua 4 lần',
        desc: summary.insights.length > 3
            ? summary.insights[3]
            : 'Quest vận động đang bị bỏ qua nhiều nhất.',
      ),
      _InsightData(
        icon: RemixIcons.file_list_3_line,
        iconBg: AppColor.violetDim,
        label: 'Tốt',
        labelColor: AppColor.violet,
        title: 'Daily Review 4/7 ngày',
        desc: summary.insights.length > 4
            ? summary.insights[4]
            : 'Bạn đang đều đặn đánh giá cuối ngày.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(WeeklySummaryConstants.sectionInsights),
          const SizedBox(height: AppSpacing.s12),
          ...insightData.map((data) => _InsightCard(data: data)),
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

class _InsightData {
  final IconData icon;
  final Color iconBg;
  final String label;
  final Color labelColor;
  final String title;
  final String desc;

  const _InsightData({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.labelColor,
    required this.title,
    required this.desc,
  });
}

class _InsightCard extends StatelessWidget {
  final _InsightData data;

  const _InsightCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s10),
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        border: Border.all(color: AppColor.border),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.iconBg,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(data.icon, size: 18, color: AppColor.fg),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: data.labelColor,
                    letterSpacing: 0.06,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fg,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColor.fgSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
