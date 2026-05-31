import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';

class PageHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final TextStyle? titleStyle;

  const PageHeader({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      decoration: const BoxDecoration(
        color: AppColor.bgRaised,
        border: Border(bottom: BorderSide(color: AppColor.border, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Icon
            Icon(icon, size: 24, color: AppColor.cyan),
            const SizedBox(width: AppSpacing.s12),

            // Title
            Expanded(
              child: Text(
                title,
                style:
                    titleStyle ??
                    const TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColor.fg,
                      letterSpacing: 0.5,
                    ),
              ),
            ),

            // Trailing
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
