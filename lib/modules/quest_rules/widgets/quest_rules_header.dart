import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../constants/quest_rules_constants.dart';

class QuestRulesHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const QuestRulesHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s12,
        AppSpacing.s16,
        AppSpacing.s16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColor.border),
              ),
              child: const Icon(
                RemixIcons.arrow_left_s_line,
                color: AppColor.fg,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  QuestRulesConstants.pageTitle,
                  style: TextStyle(
                    fontSize: 24,
                    height: 1.12,
                    fontWeight: FontWeight.w800,
                    color: AppColor.fg,
                  ),
                ),
                SizedBox(height: AppSpacing.s6),
                Text(
                  QuestRulesConstants.pageSubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: AppColor.fgSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColor.cyanDim,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColor.borderGlowCyan),
            ),
            child: const Icon(
              RemixIcons.magic_line,
              color: AppColor.cyan,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
