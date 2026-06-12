import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import 'package:remixicon/remixicon.dart';

class DailyReviewCtaCard extends StatelessWidget {
  final bool hasReviewed;
  final VoidCallback? onTap;

  const DailyReviewCtaCard({
    super.key,
    required this.hasReviewed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (hasReviewed) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s8,
        ),
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          gradient: AppColor.dailyReviewCtaGradient,
          border: Border.all(color: AppColor.borderGlowViolet),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColor.violetDim,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColor.borderGlowViolet),
              ),
              child: Icon(
                RemixIcons.file_text_line,
                color: AppColor.violet,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.s14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cuối ngày rồi? Đánh giá hôm nay',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColor.fg,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Giúp hệ thống hiểu bạn hơn và tạo quest tốt hơn cho ngày mai.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.fgSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              RemixIcons.arrow_right_s_line,
              color: AppColor.fgMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
