import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../core/utils/app_time_formatter.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/xp_transaction_model.dart';
import 'package:remixicon/remixicon.dart';

class XPHistoryCard extends StatelessWidget {
  final List<XPTransactionModel> transactions;

  const XPHistoryCard({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (transactions.isEmpty) {
      return const SizedBox.shrink();
    }

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
          // Section label
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColor.warn,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.s6),
              Text(
                l10n.progressXPHistoryTitle,
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
          Text(
            l10n.progressXPHistoryRecent,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColor.fg,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),

          // Transaction list
          ...transactions.take(10).map((transaction) => _buildTransactionItem(transaction)),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(XPTransactionModel transaction) {
    final isPositive = transaction.isPositive;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s10,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.borderSubtle, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isPositive ? AppColor.successDim : AppColor.warnDim,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              isPositive ? RemixIcons.arrow_up_line : RemixIcons.arrow_down_line,
              size: 16,
              color: isPositive ? AppColor.success : AppColor.warn,
            ),
          ),
          const SizedBox(width: AppSpacing.s10),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fg,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  AppTimeFormatter.formatLocalDateTime(transaction.createdAt) ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColor.fgMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s10),

          // Amount
          Text(
            '${isPositive ? '+' : ''}${transaction.amount} EXP',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isPositive ? AppColor.success : AppColor.warn,
            ),
          ),
        ],
      ),
    );
  }
}
