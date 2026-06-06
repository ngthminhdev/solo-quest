import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';

class LoginLogoSection extends StatelessWidget {
  const LoginLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.bgDeep,
            boxShadow: [
              BoxShadow(
                color: AppColor.cyan.withAlpha(80),
                blurRadius: 24,
                spreadRadius: 4,
              ),
              BoxShadow(
                color: AppColor.violet.withAlpha(60),
                blurRadius: 32,
                spreadRadius: 2,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/icons/app_icon_foreground.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: AppSpacing.s20),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColor.cyan, AppColor.violet],
          ).createShader(bounds),
          child: const Text(
            'SoloQuest',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColor.white,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          context.l10n.loginTagline,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.fgSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
