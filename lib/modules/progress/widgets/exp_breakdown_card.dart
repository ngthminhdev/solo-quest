import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../constants/progress_constants.dart';

class ExpBreakdownCard extends StatelessWidget {
  const ExpBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'EXP THEO LOẠI QUEST',
                style: TextStyle(
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
          ...ProgressExpBreakdown.items.map(
            (item) => _ExpRow(item: item),
          ),
        ],
      ),
    );
  }
}

class _ExpRow extends StatelessWidget {
  final ExpBreakdownItem item;

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
