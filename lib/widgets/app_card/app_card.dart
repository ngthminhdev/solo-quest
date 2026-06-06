import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_shadow.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final Color? bgColor;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final bool glow;
  final Color? glowColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.bgColor,
    this.border,
    this.boxShadow,
    this.glow = false,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(AppRadius.lg);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor ?? AppColor.surface,
          borderRadius: effectiveBorderRadius,
          border: border ?? Border.all(color: glow ? (glowColor ?? AppColor.borderGlowCyan) : AppColor.border),
          boxShadow: boxShadow ?? (glow ? (glowColor == AppColor.violet ? AppShadow.glowViolet : AppShadow.glowCyan) : null),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

class AppGlowCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color accentColor;
  final bool useGradient;

  const AppGlowCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.accentColor = AppColor.cyan,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 14),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: useGradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withValues(alpha:0.12),
                  AppColor.surface,
                ],
              )
            : null,
        color: useGradient ? null : AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: accentColor.withValues(alpha:0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha:0.14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
