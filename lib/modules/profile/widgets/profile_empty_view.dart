import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../widgets/app_button/app_button.dart';

class ProfileEmptyView extends StatelessWidget {
  final VoidCallback onRetry;

  const ProfileEmptyView({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              RemixIcons.user_3_line,
              size: 64,
              color: AppColor.fgMuted,
            ),
            const SizedBox(height: AppSpacing.s16),
            const Text(
              'Chưa có hồ sơ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.fg,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              'Không thể tải thông tin cá nhân.\nHãy thử lại.',
              style: TextStyle(
                fontSize: 14,
                color: AppColor.fgMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s24),
            AppButton(
              label: 'Tải lại',
              onPressed: onRetry,
              variant: AppButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }
}
