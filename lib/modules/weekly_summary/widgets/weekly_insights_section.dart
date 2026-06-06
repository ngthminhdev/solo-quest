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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(WeeklySummaryConstants.sectionInsights),
          const SizedBox(height: AppSpacing.s12),
          ...summary.insights.asMap().entries.map((entry) {
            return _InsightCard(
              index: entry.key,
              text: entry.value,
            );
          }),
          if (summary.aiSummary != null && summary.aiSummary!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s10),
            _AiSummaryCard(text: summary.aiSummary!),
          ],
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

class _InsightCard extends StatelessWidget {
  final int index;
  final String text;

  const _InsightCard({required this.index, required this.text});

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
              color: AppColor.chipWaterBg,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(RemixIcons.lightbulb_line, size: 18, color: AppColor.fg),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColor.fgSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiSummaryCard extends StatelessWidget {
  final String text;

  const _AiSummaryCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        gradient: AppColor.insightCardGradient,
        border: Border.all(color: AppColor.borderGlowCyan),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            RemixIcons.robot_2_line,
            size: 18,
            color: AppColor.cyan,
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColor.fgSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
