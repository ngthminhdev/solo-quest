import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../widgets/app_card/app_card.dart';

class StreakCard extends StatelessWidget {
  final int streakDays;

  const StreakCard({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
      ).copyWith(bottom: 0),
      padding: const EdgeInsets.all(AppSpacing.s16),
      bgColor: AppColor.surface,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColor.warnDim,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              RemixIcons.fire_line,
              size: 22,
              color: AppColor.warn,
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak $streakDays ngày',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fg,
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  _motivationMessage(streakDays),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.fgSecondary,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (streakDays > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.warnDim,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: AppColor.warn.withValues(alpha: 0.22),
                ),
              ),
              child: Text(
                'x$streakDays',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColor.warn,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _motivationMessage(int days) {
    if (days == 0) return 'Bắt đầu streak hôm nay';
    if (days <= 2) return 'Bạn đang khởi động rất tốt';
    if (days <= 6) return 'Chuỗi ngày đang hình thành';
    return 'Thói quen của bạn đang rất ổn định';
  }
}
