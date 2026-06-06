import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../widgets/app_card/app_card.dart';
import '../../../extensions/localization_extension.dart';

class StreakCard extends StatelessWidget {
  final int streakDays;

  const StreakCard({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    String motivationMessage(int days) {
      if (days == 0) return context.l10n.progressStreakMotivationStart;
      if (days <= 2) return context.l10n.progressStreakMotivationGood;
      if (days <= 6) return context.l10n.progressStreakMotivationForming;
      return context.l10n.progressStreakMotivationStable;
    }

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
                  context.l10n.progressStreakDaysLabel(streakDays),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColor.fg,
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  motivationMessage(streakDays),
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
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: AppColor.warningStrongOverlay,
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

}
