import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';

class AppChoiceBottomSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String> onSelected;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final Color? selectedColor;
  final Color? selectedBorderColor;

  const AppChoiceBottomSheet({
    super.key,
    required this.title,
    this.subtitle,
    required this.options,
    this.selectedOption,
    required this.onSelected,
    required this.confirmLabel,
    required this.onConfirm,
    this.selectedColor,
    this.selectedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.5,
          ),
          itemCount: options.length,
          itemBuilder: (_, index) {
            final option = options[index];
            final isSelected = option == selectedOption;
            return GestureDetector(
              onTap: () => onSelected(option),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? (selectedColor ?? AppColor.warnDim)
                      : AppColor.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isSelected
                        ? (selectedBorderColor ?? AppColor.warn)
                        : AppColor.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? (selectedBorderColor ?? AppColor.warn)
                          : AppColor.fgSecondary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: onConfirm,
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: selectedColor ?? AppColor.warn,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Center(
              child: Text(
                confirmLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selectedBorderColor != null ? AppColor.white : AppColor.bgDeep,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: double.infinity,
            height: 44,
            color: AppColor.transparent,
            child: const Center(
              child: Text(
                'Huỷ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.fgMuted,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
