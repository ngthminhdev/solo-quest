import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    this.message = 'Đã xảy ra lỗi',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 360),
          padding: const EdgeInsets.all(AppSpacing.s24),
          decoration: BoxDecoration(
            color: AppColor.surface.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColor.errorBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColor.errorBackground,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColor.errorBorder),
                ),
                child: Icon(
                  RemixIcons.error_warning_line,
                  size: 28,
                  color: AppColor.danger,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                  color: AppColor.fg,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.s24),
                GestureDetector(
                  onTap: onRetry,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s20,
                      vertical: AppSpacing.s12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.primarySubtleOverlay,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColor.primaryBorder),
                    ),
                    child: Text(
                      'Thử lại',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColor.cyan,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
