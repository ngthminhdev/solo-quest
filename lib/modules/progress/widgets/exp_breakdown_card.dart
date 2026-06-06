import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../extensions/localization_extension.dart';

class _ExpBreakdownItem {
  final String name;
  final String note;
  final int exp;
  final IconData icon;
  final Color bgColor;

  const _ExpBreakdownItem({
    required this.name,
    required this.note,
    required this.exp,
    required this.icon,
    required this.bgColor,
  });
}

class ExpBreakdownCard extends StatelessWidget {
  const ExpBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final items = [
      _ExpBreakdownItem(
        name: l10n.progressExpItemLearning,
        note: l10n.progressExpItemLearningNote,
        exp: 40,
        icon: RemixIcons.book_open_line,
        bgColor: AppColor.chipLearningBg,
      ),
      _ExpBreakdownItem(
        name: l10n.progressExpItemSleep,
        note: l10n.progressExpItemSleepNote,
        exp: 25,
        icon: RemixIcons.moon_line,
        bgColor: AppColor.chipSleepBg,
      ),
      _ExpBreakdownItem(
        name: l10n.progressExpItemMovement,
        note: l10n.progressExpItemMovementNote,
        exp: 20,
        icon: RemixIcons.run_line,
        bgColor: AppColor.chipMovementBg,
      ),
      _ExpBreakdownItem(
        name: l10n.progressExpItemBreak,
        note: l10n.progressExpItemBreakNote,
        exp: 15,
        icon: RemixIcons.heart_pulse_line,
        bgColor: AppColor.chipBreakBg,
      ),
      _ExpBreakdownItem(
        name: l10n.progressExpItemWater,
        note: l10n.progressExpItemWaterNote,
        exp: 10,
        icon: RemixIcons.drop_line,
        bgColor: AppColor.chipWaterBg,
      ),
      _ExpBreakdownItem(
        name: l10n.progressExpItemReview,
        note: l10n.progressExpItemReviewNote,
        exp: 30,
        icon: RemixIcons.checkbox_circle_line,
        bgColor: AppColor.cyanDim,
      ),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s12,
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
          // Section label
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColor.expGold,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.s6),
              Text(
                l10n.progressExpBreakdownSection,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: AppColor.fgMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          ...items.map(
            (item) => _ExpRow(item: item),
          ),
        ],
      ),
    );
  }
}

class _ExpRow extends StatelessWidget {
  final _ExpBreakdownItem item;

  const _ExpRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: item.bgColor,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(item.icon, size: 16, color: AppColor.fg),
          ),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fg,
                  ),
                ),
                Text(
                  item.note,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColor.fgMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${item.exp}',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColor.expGold,
            ),
          ),
        ],
      ),
    );
  }
}
