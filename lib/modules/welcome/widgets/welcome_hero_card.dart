import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_shadow.dart';
import '../../../constants/app_spacing.dart';

class WelcomeHeroCard extends StatelessWidget {
  const WelcomeHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.bgDeep,
            boxShadow: AppShadow.glowCyan + AppShadow.glowViolet,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/icons/app_icon_foreground.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [AppColor.cyan, AppColor.violet],
          ).createShader(bounds),
          child: Text(
            'SoloQuest',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.04,
              color: AppColor.white,
            ),
          ),
        ),
      ],
    );
  }
}
