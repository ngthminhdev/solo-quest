import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';

class AppGlowCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Color glowColor;

  const AppGlowCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.glowColor = AppColor.cyan,
  });

  @override
  Widget build(BuildContext context) {
    final isCyan = glowColor == AppColor.cyan;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isCyan ? AppColor.borderGlowCyan : AppColor.borderGlowViolet,
          ),
        ),
        child: child,
      ),
    );
  }
}
