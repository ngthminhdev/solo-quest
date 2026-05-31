import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';

class AppChipSelector extends StatelessWidget {
  final List<String> options;
  final List<String> selected;
  final ValueChanged<String> onToggle;
  final bool multiSelect;

  const AppChipSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onToggle,
    this.multiSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        return GestureDetector(
          onTap: () => onToggle(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.cyanDim : AppColor.surface,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: isSelected ? AppColor.borderGlowCyan : AppColor.border,
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColor.cyan : AppColor.fgSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
