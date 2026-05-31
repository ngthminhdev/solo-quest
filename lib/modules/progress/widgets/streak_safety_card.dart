import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/progress_model.dart';

class StreakSafetyCard extends StatelessWidget {
  final ProgressModel progress;

  const StreakSafetyCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        0,
      ),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chuỗi ngày liên tiếp',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColor.fg,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${progress.streakDays}',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColor.warn,
                      ),
                    ),
                    const TextSpan(
                      text: ' ngày',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColor.fgSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s12),

          // Stats
          Row(
            children: [
              Expanded(
                child: _StreakStat(
                  value: '${progress.streakShields}',
                  label: 'Shield còn lại',
                  valueColor: AppColor.cyan,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: _StreakStat(
                  value: '${progress.lightDaysUsed}',
                  label: 'Ngày nhẹ đã dùng',
                  valueColor: AppColor.success,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: _StreakStat(
                  value: '${progress.bestStreak}',
                  label: 'Streak cao nhất',
                  valueColor: AppColor.warn,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s12),

          // Note
          Container(
            padding: const EdgeInsets.all(AppSpacing.s10),
            decoration: BoxDecoration(
              color: AppColor.bgRaised,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColor.fgSecondary,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'Streak Shield',
                    style: TextStyle(
                      color: AppColor.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' bảo vệ chuỗi khi bạn bận, mệt hoặc cần nghỉ. Dùng "ngày nhẹ" để giữ nhịp mà không cần hoàn thành nhiều quest.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StreakStat({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s10,
        horizontal: AppSpacing.s6,
      ),
      decoration: BoxDecoration(
        color: AppColor.bgRaised,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: valueColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColor.fgMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
