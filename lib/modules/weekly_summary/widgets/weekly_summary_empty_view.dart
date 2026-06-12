import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';

class WeeklySummaryEmptyView extends StatelessWidget {
  final VoidCallback? onRetry;

  const WeeklySummaryEmptyView({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              RemixIcons.bar_chart_2_line,
              size: 48,
              color: AppColor.fgMuted,
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              'Chưa có dữ liệu tuần',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColor.fg,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              'Hoàn thành quest để xem báo cáo tuần.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColor.fgSecondary,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.s20),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s20,
                    vertical: AppSpacing.s10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.cyan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Thử lại',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColor.bgDeep,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
