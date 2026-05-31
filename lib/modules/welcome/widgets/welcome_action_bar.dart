import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';

class WelcomeActionBar extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback? onSkip;

  const WelcomeActionBar({
    super.key,
    required this.onStart,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onStart,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: AppColor.levelGradient,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: [
                BoxShadow(
                  color: AppColor.cyan.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  RemixIcons.rocket_2_line,
                  size: 18,
                  color: AppColor.bgDeep,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Bắt đầu thiết lập',
                  style: AppTextStyle.button.copyWith(
                    color: AppColor.bgDeep,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (onSkip != null) ...[
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: onSkip,
            child: Text(
              'Đã thiết lập? Bỏ qua',
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColor.fgSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
