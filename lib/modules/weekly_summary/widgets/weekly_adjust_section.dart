import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/weekly_summary_model.dart';
import '../../../models/enums/quest_enums.dart';
import '../../../modules/quests/ui/quest_ui_extensions.dart';
import '../constants/weekly_summary_constants.dart';

class WeeklyAdjustSection extends StatelessWidget {
  final WeeklySummaryModel summary;

  const WeeklyAdjustSection({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    // Derive adjustments from category breakdown: categories with rate < 0.70
    final lowCategories = summary.categoryBreakdown
        .where((c) => c.rate < 0.70)
        .toList()
      ..sort((a, b) => a.rate.compareTo(b.rate));

    if (lowCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(WeeklySummaryConstants.sectionAdjust),
          const SizedBox(height: AppSpacing.s12),
          ...lowCategories.map((data) {
            final ratePercent = (data.rate * 100).round();
            final iconData = _getCategoryIcon(data.category);
            final iconBg = _getCategoryIconBg(data.rate);
            final barColor = _getCategoryBarColor(data.rate);

            return _AdjustCard(
              icon: iconData,
              iconBg: iconBg,
              title: data.displayLabel,
              desc:
                  'Hoàn thành ${data.completed}/${data.total} ($ratePercent%). Cần cải thiện.',
              barPercent: data.rate,
              barColor: barColor,
            );
          }),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    try {
      final type = QuestType.values.byName(category);
      return type.icon;
    } catch (_) {
      switch (category) {
        case 'main':
          return RemixIcons.focus_3_line;
        case 'side':
          return RemixIcons.list_check_3;
        case 'daily':
          return RemixIcons.calendar_check_line;
        case 'weekly':
          return RemixIcons.calendar_2_line;
        default:
          return RemixIcons.question_line;
      }
    }
  }

  Color _getCategoryIconBg(double rate) {
    if (rate < 0.40) return AppColor.dangerDim;
    if (rate < 0.60) return AppColor.warnDim;
    return AppColor.chipLearningBg;
  }

  Color _getCategoryBarColor(double rate) {
    if (rate < 0.40) return AppColor.danger;
    if (rate < 0.60) return AppColor.warn;
    return AppColor.success;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      '◆ $title',
      style: TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColor.fgMuted,
        letterSpacing: 0.06,
      ),
    );
  }
}

class _AdjustCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String desc;
  final double barPercent;
  final Color barColor;

  const _AdjustCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.desc,
    required this.barPercent,
    required this.barColor,
  });

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
              color: iconBg,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, size: 18, color: AppColor.fg),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fg,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.fgSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.s8),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.surfaceActive,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: barPercent,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
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
