import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/weekly_summary_model.dart';
import '../constants/weekly_summary_constants.dart';

class WeeklyAdjustSection extends StatelessWidget {
  final WeeklySummaryModel summary;

  const WeeklyAdjustSection({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final adjustments = [
      _AdjustData(
        icon: RemixIcons.walk_line,
        iconBg: AppColor.dangerDim,
        title: 'Movement Quest',
        desc: 'Bị bỏ qua 4 lần trong tuần. Có thể giảm từ 5 lần/tuần xuống 3 lần/tuần.',
        barPercent: 0.3,
        barColor: AppColor.danger,
      ),
      _AdjustData(
        icon: RemixIcons.cup_line,
        iconBg: AppColor.warnDim,
        title: 'Break Quest buổi sáng',
        desc: 'Hay bị hoãn vào buổi sáng. Đề xuất đổi từ mỗi 90 phút sang mỗi 120 phút.',
        barPercent: 0.5,
        barColor: AppColor.warn,
      ),
      _AdjustData(
        icon: RemixIcons.book_open_line,
        iconBg: AppColor.chipLearningBg,
        title: 'Learning Quest giờ học',
        desc: 'Hiệu quả hơn vào buổi tối. Đề xuất ưu tiên nhắc lúc 20:00–21:30.',
        barPercent: 0.85,
        barColor: AppColor.success,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(WeeklySummaryConstants.sectionAdjust),
          const SizedBox(height: AppSpacing.s12),
          ...adjustments.map((data) => _AdjustCard(data: data)),
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

class _AdjustData {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String desc;
  final double barPercent;
  final Color barColor;

  const _AdjustData({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.desc,
    required this.barPercent,
    required this.barColor,
  });
}

class _AdjustCard extends StatelessWidget {
  final _AdjustData data;

  const _AdjustCard({required this.data});

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
                  data.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fg,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColor.fgSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                // Progress bar
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.surfaceActive,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: data.barPercent,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: data.barColor,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
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
