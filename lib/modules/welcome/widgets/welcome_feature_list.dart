import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../extensions/localization_extension.dart';

class WelcomeFeatureList extends StatelessWidget {
  const WelcomeFeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
            l10n.welcomeFeature1Title,
            l10n.welcomeFeature1Desc,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildFeature(
            RemixIcons.file_text_line,
            l10n.welcomeFeature2Title,
            l10n.welcomeFeature2Desc,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildFeature(
            RemixIcons.bar_chart_2_line,
            l10n.welcomeFeature3Title,
            l10n.welcomeFeature3Desc,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildFeature(
            RemixIcons.notification_3_line,
            l10n.welcomeFeature4Title,
            l10n.welcomeFeature4Desc,
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
