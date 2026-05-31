import 'package:flutter/material.dart';

import 'app_button.dart';

class AppButtonVariantFactory {
  static Widget primary({
    required String label,
    VoidCallback? onPressed,
    bool fullWidth = true,
    bool isLoading = false,
    Widget? icon,
  }) {
    return AppButton(
      label: label,
      variant: AppButtonVariant.primary,
      onPressed: onPressed,
      fullWidth: fullWidth,
      isLoading: isLoading,
      icon: icon,
    );
  }

  static Widget secondary({
    required String label,
    VoidCallback? onPressed,
    bool fullWidth = true,
    Widget? icon,
  }) {
    return AppButton(
      label: label,
      variant: AppButtonVariant.secondary,
      onPressed: onPressed,
      fullWidth: fullWidth,
      icon: icon,
    );
  }

  static Widget ghost({
    required String label,
    VoidCallback? onPressed,
    bool fullWidth = false,
    Widget? icon,
  }) {
    return AppButton(
      label: label,
      variant: AppButtonVariant.ghost,
      onPressed: onPressed,
      fullWidth: fullWidth,
      icon: icon,
    );
  }

  static Widget success({
    required String label,
    VoidCallback? onPressed,
    bool fullWidth = true,
    Widget? icon,
  }) {
    return AppButton(
      label: label,
      variant: AppButtonVariant.success,
      onPressed: onPressed,
      fullWidth: fullWidth,
      icon: icon,
    );
  }

  static Widget warning({
    required String label,
    VoidCallback? onPressed,
    bool fullWidth = true,
    Widget? icon,
  }) {
    return AppButton(
      label: label,
      variant: AppButtonVariant.warning,
      onPressed: onPressed,
      fullWidth: fullWidth,
      icon: icon,
    );
  }

  static Widget danger({
    required String label,
    VoidCallback? onPressed,
    bool fullWidth = true,
    Widget? icon,
  }) {
    return AppButton(
      label: label,
      variant: AppButtonVariant.danger,
      onPressed: onPressed,
      fullWidth: fullWidth,
      icon: icon,
    );
  }
}
