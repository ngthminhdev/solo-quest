import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';

class LoginFooterNote extends StatelessWidget {
  const LoginFooterNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.loginNote,
          style: TextStyle(
            fontSize: 12,
            color: AppColor.fgMuted,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.s12),
        Text(
          context.l10n.loginTerms,
          style: TextStyle(
            fontSize: 11,
            color: AppColor.fgMuted,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.s16),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s6,
          ),
          decoration: BoxDecoration(
            color: AppColor.violetDim,
            borderRadius: BorderRadius.circular(AppSpacing.s8),
            border: Border.all(color: AppColor.borderGlowViolet),
          ),
          child: Text(
            context.l10n.loginPrototypeNote,
            style: TextStyle(
              fontSize: 11,
              color: AppColor.violet,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
