import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../widgets/app_card/app_card.dart';
import '../../../widgets/app_progress/app_progress_bar.dart';

class WeeklyCompletionCard extends StatelessWidget {
  final double completionRate;

  const WeeklyCompletionCard({super.key, required this.completionRate});

  @override
  Widget build(BuildContext context) {
    final rate = completionRate.clamp(0.0, 1.0);
    final percent = (rate * 100).toInt();

    return AppCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
      ).copyWith(bottom: 0),
      padding: const EdgeInsets.all(AppSpacing.s16),
      bgColor: AppColor.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                RemixIcons.bar_chart_box_line,
                size: 20,
                color: AppColor.cyan,
              ),
              const SizedBox(width: AppSpacing.s8),
              const Expanded(
                child: Text(
                  'Tỷ lệ hoàn thành tuần',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fg,
                  ),
                ),
              ),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColor.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          AppProgressBar(progress: rate, height: 10),
          const SizedBox(height: AppSpacing.s8),
          Text(
            _weeklyMessage(rate),
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
    );
  }

  String _weeklyMessage(double rate) {
    if (rate < 0.4) {
      return 'Cần giảm độ khó hoặc chia nhỏ quest để tăng tỷ lệ hoàn thành.';
    }
    if (rate < 0.7) {
      return 'Đang ổn, cần đều hơn để duy trì thói quen.';
    }
    return 'Rất tốt! Bạn đang hoàn thành rất đều đặn.';
  }
}
