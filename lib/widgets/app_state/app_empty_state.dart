import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
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
            color: AppColor.surface.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColor.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColor.primarySubtleOverlay,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColor.primaryBorder),
                ),
                child: Icon(icon, size: 28, color: AppColor.cyan),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColor.fg,
                ),
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.s8),
                Text(
                  message!,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: AppColor.fgSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: AppSpacing.s24),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
