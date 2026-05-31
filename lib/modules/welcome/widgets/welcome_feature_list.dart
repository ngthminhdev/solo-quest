import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';

class WelcomeFeatureList extends StatelessWidget {
  const WelcomeFeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.borderGlowCyan),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeature(
            RemixIcons.gamepad_line,
            'Quest cá nhân hóa',
            'Nhiệm vụ nhỏ phù hợp thói quen',
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildFeature(
            RemixIcons.file_text_line,
            'Logs để hiểu bản thân',
            'Theo dõi và phát hiện pattern',
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildFeature(
            RemixIcons.bar_chart_2_line,
            'EXP, Level, Streak',
            'Gamification duy trì động lực',
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildFeature(
            RemixIcons.notification_3_line,
            'Reminder thông minh',
            'Nhắc đúng lúc, không làm phiền',
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String desc) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColor.cyanDim,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Icon(icon, size: 16, color: AppColor.cyan),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                desc,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColor.fgMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
