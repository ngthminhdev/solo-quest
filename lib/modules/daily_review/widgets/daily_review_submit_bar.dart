import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../extensions/localization_extension.dart';

class DailyReviewSubmitBar extends StatelessWidget {
  final bool canSubmit;
  final bool isLoading;
  final bool hasReviewed;
  final VoidCallback onSubmit;
  final VoidCallback? onViewWeekly;

  const DailyReviewSubmitBar({
    super.key,
    required this.canSubmit,
    required this.isLoading,
    required this.hasReviewed,
    required this.onSubmit,
    this.onViewWeekly,
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
                              ? context.l10n.dailyReviewUpdateText
                              : context.l10n.dailyReviewSubmitText,
                          style: TextStyle(
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

          if (onViewWeekly != null) ...[
            const SizedBox(height: AppSpacing.s8),
            GestureDetector(
              onTap: onViewWeekly,
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.transparent,
                  border: Border.all(color: AppColor.border),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                alignment: Alignment.center,
                child: Text(
                  context.l10n.dailyReviewLinkToWeekly,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fg,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
