import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../constants/daily_review_constants.dart';

class DailyReviewSubmitBar extends StatelessWidget {
  final bool canSubmit;
  final bool isLoading;
  final bool hasReviewed;
  final VoidCallback onSubmit;
  final VoidCallback onViewWeekly;

  const DailyReviewSubmitBar({
    super.key,
    required this.canSubmit,
    required this.isLoading,
    required this.hasReviewed,
    required this.onSubmit,
    required this.onViewWeekly,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = canSubmit && !isLoading;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s12,
        AppSpacing.s16,
        MediaQuery.of(context).padding.bottom + AppSpacing.s12,
      ),
      decoration: const BoxDecoration(
        color: AppColor.bgRaised,
        border: Border(top: BorderSide(color: AppColor.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Log note
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.s10),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s8,
            ),
            decoration: BoxDecoration(
              color: AppColor.bgDeep,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                const Icon(
                  RemixIcons.file_text_line,
                  size: 14,
                  color: AppColor.fgMuted,
                ),
                const SizedBox(width: AppSpacing.s8),
                const Expanded(
                  child: Text(
                    DailyReviewConstants.linkToLogs,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColor.fgMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Submit button
          GestureDetector(
            onTap: enabled ? onSubmit : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: enabled ? AppColor.cyan : AppColor.fgMuted,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              alignment: Alignment.center,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.bgDeep,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          hasReviewed
                              ? RemixIcons.refresh_line
                              : RemixIcons.checkbox_circle_line,
                          size: 18,
                          color: enabled ? AppColor.bgDeep : AppColor.bgRaised,
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        Text(
                          hasReviewed
                              ? DailyReviewConstants.updateText
                              : DailyReviewConstants.submitText,
                          style: TextStyle(
                            fontFamily: 'Exo2',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color:
                                enabled ? AppColor.bgDeep : AppColor.bgRaised,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: AppSpacing.s8),

          // View weekly button
          GestureDetector(
            onTap: onViewWeekly,
            child: Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: AppColor.border),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              alignment: Alignment.center,
              child: const Text(
                DailyReviewConstants.linkToWeekly,
                style: TextStyle(
                  fontFamily: 'Exo2',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.fg,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
