import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';

class LoginErrorBanner extends StatelessWidget {
  final String? message;

  const LoginErrorBanner({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColor.dangerDim,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColor.danger.withAlpha(80)),
      ),
      child: Row(
        children: [
          const Icon(
            RemixIcons.error_warning_line,
            size: 16,
            color: AppColor.danger,
          ),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(
              message!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColor.danger,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
