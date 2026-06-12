import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../../../extensions/localization_extension.dart';

class OnboardingBottomBar extends StatelessWidget {
  final int currentStep;
  final bool canGoBack;
  final bool canContinue;
  final bool isLastStep;
  final bool isLoading;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  const OnboardingBottomBar({
    super.key,
    required this.currentStep,
    required this.canGoBack,
    required this.canContinue,
    required this.isLastStep,
    this.isLoading = false,
    this.onBack,
    this.onNext,
  });

  String _getNextLabel(BuildContext context) {
    final l10n = context.l10n;
    if (currentStep == 0) return l10n.onboardingWelcomeStart;
    if (isLastStep) return l10n.onboardingStep8StartCheckin;
    return l10n.onboardingNext;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColor.bgRaised,
        border: Border(top: BorderSide(color: AppColor.border, width: 0.5)),
      ),
      child: Row(
        children: [
          if (canGoBack)
            GestureDetector(
              onTap: onBack,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColor.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      RemixIcons.arrow_left_s_line,
                      size: 16,
                      color: AppColor.fgSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.onboardingBack,
                      style: AppTextStyle.buttonSmall.copyWith(
                        color: AppColor.fgSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const Spacer(),
          GestureDetector(
            onTap: canContinue && !isLoading ? onNext : null,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.sm + 2,
              ),
              decoration: BoxDecoration(
                gradient: canContinue ? AppColor.levelGradient : null,
                color: canContinue ? null : AppColor.surfaceActive,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.bgDeep,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getNextLabel(context),
                          style: AppTextStyle.button.copyWith(
                            color: canContinue
                                ? AppColor.bgDeep
                                : AppColor.fgMuted,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          RemixIcons.arrow_right_s_line,
                          size: 16,
                          color: canContinue
                              ? AppColor.bgDeep
                              : AppColor.fgMuted,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
