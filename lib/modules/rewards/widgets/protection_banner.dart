import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../constants/rewards_constants.dart';

class ProtectionBanner extends StatelessWidget {
  const ProtectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s10,
        AppSpacing.s16,
        0,
      ),
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x0F22C55E),
            Color(0x0A00F0FF),
          ],
        ),
        border: Border.all(color: const Color(0x2622C55E)),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            RemixIcons.shield_check_line,
            size: 16,
            color: AppColor.success,
          ),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.fgSecondary,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: 'Rewards bền vững. ',
                    style: TextStyle(
                      color: AppColor.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: RewardsConstants.protectionText,
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
