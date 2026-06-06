import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';

enum AppToastType { success, error, warning, info }

class AppToast extends StatelessWidget {
  final String message;
  final AppToastType type;

  const AppToast({
    super.key,
    required this.message,
    this.type = AppToastType.info,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: _borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: 16, color: _iconColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.fg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _borderColor {
    switch (type) {
      case AppToastType.success:
        return AppColor.successBorder;
      case AppToastType.error:
        return AppColor.errorStrongBorder;
      case AppToastType.warning:
        return AppColor.warningBorder;
      case AppToastType.info:
        return AppColor.borderGlowCyan;
    }
  }

  IconData get _icon {
    switch (type) {
      case AppToastType.success:
        return RemixIcons.checkbox_circle_line;
      case AppToastType.error:
        return RemixIcons.error_warning_line;
      case AppToastType.warning:
        return RemixIcons.error_warning_line;
      case AppToastType.info:
        return RemixIcons.information_line;
    }
  }

  Color get _iconColor {
    switch (type) {
      case AppToastType.success:
        return AppColor.success;
      case AppToastType.error:
        return AppColor.danger;
      case AppToastType.warning:
        return AppColor.warn;
      case AppToastType.info:
        return AppColor.cyan;
    }
  }
}
