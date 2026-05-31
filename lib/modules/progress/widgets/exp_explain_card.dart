import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../constants/progress_constants.dart';

class ExpExplainCard extends StatelessWidget {
  const ExpExplainCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s12,
        AppSpacing.s16,
        0,
      ),
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                RemixIcons.information_line,
                size: 16,
                color: AppColor.expGold,
              ),
              SizedBox(width: AppSpacing.s6),
              Text(
                ProgressConstants.expExplainTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColor.fg,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            ProgressConstants.expExplainText,
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
