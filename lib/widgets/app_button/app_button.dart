import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';

class AppButton extends StatefulWidget {
  final String label;
  final AppButtonVariant variant;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final bool isLoading;
  final bool disabled;
  final Widget? icon;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    this.variant = AppButtonVariant.primary,
    this.onPressed,
    this.fullWidth = true,
    this.isLoading = false,
    this.disabled = false,
    this.icon,
    this.height,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

enum AppButtonVariant { primary, secondary, ghost, success, warning, danger }

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  Color get _backgroundColor {
    if (widget.disabled) return _disabledBg;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColor.cyan;
      case AppButtonVariant.secondary:
        return AppColor.transparent;
      case AppButtonVariant.ghost:
        return AppColor.transparent;
      case AppButtonVariant.success:
        return AppColor.successDim;
      case AppButtonVariant.warning:
        return AppColor.warnDim;
      case AppButtonVariant.danger:
        return AppColor.danger;
    }
  }

  Color get _textColor {
    if (widget.disabled) return AppColor.fgMuted;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColor.bgDeep;
      case AppButtonVariant.secondary:
        return AppColor.fg;
      case AppButtonVariant.ghost:
        return AppColor.fgSecondary;
      case AppButtonVariant.success:
        return AppColor.success;
      case AppButtonVariant.warning:
        return AppColor.warn;
      case AppButtonVariant.danger:
        return AppColor.white;
    }
  }

  Color get _disabledBg {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColor.surface;
      case AppButtonVariant.secondary:
        return AppColor.transparent;
      case AppButtonVariant.ghost:
        return AppColor.transparent;
      case AppButtonVariant.success:
        return AppColor.successDisabledBackground;
      case AppButtonVariant.warning:
        return AppColor.warningDisabledBackground;
      case AppButtonVariant.danger:
        return AppColor.errorStrongBorder;
    }
  }

  Border? get _border {
    if (widget.disabled) return Border.all(color: AppColor.border);
    switch (widget.variant) {
      case AppButtonVariant.secondary:
        return Border.all(color: AppColor.border);
      case AppButtonVariant.warning:
        return Border.all(color: AppColor.warningSoftBorder);
      default:
        return null;
    }
  }

  double get _minHeight {
    if (widget.height != null) return widget.height!;
    switch (widget.variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.success:
      case AppButtonVariant.danger:
        return 48;
      case AppButtonVariant.secondary:
      case AppButtonVariant.warning:
        return 44;
      case AppButtonVariant.ghost:
        return 40;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.disabled || widget.isLoading || widget.onPressed == null;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: isDisabled ? null : (_) => setState(() => _pressed = false),
      onTapCancel: isDisabled ? null : () => setState(() => _pressed = false),
      onTap: isDisabled ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          constraints: BoxConstraints(
            minWidth: widget.fullWidth ? double.infinity : 0,
            minHeight: _minHeight,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(
              widget.variant == AppButtonVariant.primary ? AppRadius.pill : AppRadius.md,
            ),
            border: _border,
          ),
          child: Row(
            mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _textColor,
                  ),
                )
              else ...[
                if (widget.icon != null) ...[
                  widget.icon!,
                  const SizedBox(width: 6),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
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
