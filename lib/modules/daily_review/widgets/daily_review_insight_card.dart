import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../constants/daily_review_constants.dart';

class DailyReviewInsightCard extends StatelessWidget {
  const DailyReviewInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0x0F00F0FF),
              Color(0x0AA855F7),
            ],
          ),
          border: Border.all(color: AppColor.borderGlowCyan),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColor.cyanDim,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    RemixIcons.lightbulb_flash_line,
                    size: 14,
                    color: AppColor.cyan,
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                const Text(
                  DailyReviewConstants.sectionInsight,
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColor.cyan,
                    letterSpacing: 0.06,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s10),
            const _InsightItem(
              text: 'Giữ Learning Quest 15 phút — bạn hoàn thành tốt',
            ),
            _InsightItem(
              text: 'Break Quest mỗi 90 phút trong giờ học/làm',
            ),
            _InsightItem(
              text: 'Dời Water Quest buổi tối sớm hơn 30 phút',
            ),
            _InsightItem(
              text: 'Ưu tiên nhiệm vụ nhẹ vào buổi sáng',
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightItem extends StatelessWidget {
  final String text;

  const _InsightItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '›',
            style: TextStyle(
              color: AppColor.cyan,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppColor.fgSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
