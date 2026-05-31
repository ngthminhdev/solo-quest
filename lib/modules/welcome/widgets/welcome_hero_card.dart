import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

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
            gradient: AppColor.levelGradient,
            boxShadow: AppShadow.glowCyan + AppShadow.glowViolet,
          ),
          child: const Icon(
            RemixIcons.star_line,
            size: 40,
            color: AppColor.bgDeep,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColor.cyan, AppColor.violet],
          ).createShader(bounds),
          child: const Text(
            'SoloQuest',
            style: TextStyle(
              fontFamily: 'Exo2',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.04,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
