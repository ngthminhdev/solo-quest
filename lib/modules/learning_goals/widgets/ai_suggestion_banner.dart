import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';

class AiSuggestionBanner extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const AiSuggestionBanner({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        border: Border.all(color: AppColor.border),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              // AI badge
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColor.secondaryToPrimaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  RemixIcons.sparkling_2_fill,
                  size: 18,
                  color: AppColor.bgDeep,
                ),
              ),
              const SizedBox(width: AppSpacing.s10),
              Text(
                l10n.aiTitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.fg,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s10),

          // Description
          Text(
            l10n.aiDescription,
            style: const TextStyle(
              fontSize: 12,
              color: AppColor.fgSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: AppSpacing.s12),

          // CTA button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onTap,
              icon: Icon(
                isLoading ? RemixIcons.loader_4_line : RemixIcons.star_line,
                size: 16,
              ),
              label: Text(
                isLoading ? l10n.aiLoading : l10n.aiButton,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.bgRaised,
                foregroundColor: AppColor.fg,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  side: const BorderSide(color: AppColor.border),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
