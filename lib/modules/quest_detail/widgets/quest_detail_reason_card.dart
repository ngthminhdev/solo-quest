import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';

class QuestDetailReasonCard extends StatelessWidget {
  final String? reason;

  const QuestDetailReasonCard({
    super.key,
    this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Vì Sao Quest Này Xuất Hiện?',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              color: AppColor.fgMuted,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),

          // Why card
          Container(
            padding: const EdgeInsets.all(AppSpacing.s14),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColor.borderGlowViolet),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      RemixIcons.question_line,
                      size: 20,
                      color: AppColor.violet,
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    Text(
                      'Hệ thống đề xuất',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColor.violet,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s8),

                // Reason text
                Text(
                  reason ?? 'Nhiệm vụ này được đề xuất dựa trên lịch sinh hoạt và mục tiêu hôm nay của bạn.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.fgSecondary,
                    height: 1.5,
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
