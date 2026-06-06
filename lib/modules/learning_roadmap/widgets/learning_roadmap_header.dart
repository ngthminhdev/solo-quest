import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';

class LearningRoadmapHeader extends StatelessWidget {
  const LearningRoadmapHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColor.infoDim,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              RemixIcons.route_line,
              size: 22,
              color: AppColor.info,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            l10n.lrPageTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColor.fg,
            ),
          ),
          const SizedBox(height: AppSpacing.s6),
          Text(
            l10n.lrPageSubtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppColor.fgSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
