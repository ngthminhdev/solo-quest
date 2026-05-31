import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color? bgColor;
  final Color? textColor;
  final Color? selectedBgColor;
  final Color? selectedTextColor;
  final Color? selectedBorderColor;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.bgColor,
    this.textColor,
    this.selectedBgColor,
    this.selectedTextColor,
    this.selectedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? (selectedBgColor ?? AppColor.cyanDim)
              : (bgColor ?? AppColor.surface),
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: selected
                ? (selectedBorderColor ?? AppColor.borderGlowCyan)
                : AppColor.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected
                ? (selectedTextColor ?? AppColor.cyan)
                : (textColor ?? AppColor.fgSecondary),
          ),
        ),
      ),
    );
  }
}
