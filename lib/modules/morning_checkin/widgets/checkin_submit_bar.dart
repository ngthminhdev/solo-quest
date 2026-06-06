import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'dart:developer' as developer;

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../extensions/localization_extension.dart';

class CheckinSubmitBar extends StatelessWidget {
  final bool canSubmit;
  final bool isLoading;
  final bool hasCheckedIn;
  final VoidCallback onSubmit;

  const CheckinSubmitBar({
    super.key,
    required this.canSubmit,
    required this.isLoading,
    required this.hasCheckedIn,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = canSubmit && !isLoading;
    developer.log('[SUBMIT BAR] canSubmit: $canSubmit, isLoading: $isLoading, enabled: $enabled, hasCheckedIn: $hasCheckedIn');

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
      child: GestureDetector(
        onTap: () {
          developer.log('[SUBMIT BAR] GestureDetector tapped! enabled: $enabled');
          if (enabled) {
            developer.log('[SUBMIT BAR] Calling onSubmit');
            onSubmit();
          } else {
            developer.log('[SUBMIT BAR] Button disabled, ignoring tap');
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48,
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
                      hasCheckedIn
                          ? RemixIcons.refresh_line
                          : RemixIcons.checkbox_circle_line,
                      size: 18,
                      color:
                          enabled ? AppColor.bgDeep : AppColor.bgRaised,
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    Text(
                      hasCheckedIn
                          ? context.l10n.morningCheckinUpdateText
                          : context.l10n.morningCheckinSubmitText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: enabled
                            ? AppColor.bgDeep
                            : AppColor.bgRaised,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
