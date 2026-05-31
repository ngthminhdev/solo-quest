import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';

class DailyReviewQuestSection extends StatelessWidget {
  final int completedCount;
  final int skippedCount;

  const DailyReviewQuestSection({
    super.key,
    required this.completedCount,
    required this.skippedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng kết nhiệm vụ',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 11,
              color: AppColor.fgMuted,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          _QuestRow(
            icon: RemixIcons.checkbox_circle_line,
            iconColor: AppColor.success,
            title: 'Hoàn thành',
            value: '$completedCount nhiệm vụ',
            borderColor: AppColor.success,
          ),
          const SizedBox(height: AppSpacing.s6),
          _QuestRow(
            icon: RemixIcons.skip_forward_line,
            iconColor: AppColor.warn,
            title: 'Bỏ qua / Hoãn',
            value: '$skippedCount nhiệm vụ',
            borderColor: AppColor.warn,
          ),
        ],
      ),
    );
  }
}

class _QuestRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final Color borderColor;

  const _QuestRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColor.surface,
        border: Border.all(color: AppColor.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppSpacing.s10),
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColor.fg,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColor.fgMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
