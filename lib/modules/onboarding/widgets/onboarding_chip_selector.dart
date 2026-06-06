import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../constants/onboarding_constants.dart';

enum ChipLayoutMode {
  /// Wrap layout - chips size to content, wraps to multiple rows
  wrap,

  /// Equal width row - all chips same width in single row (for 3 items)
  equalWidthRow,

  /// Equal width grid - 2x2 grid layout (for 4 items)
  equalWidthGrid,
}

class OnboardingChipSelector extends StatelessWidget {
  final List<OnboardingStepOption> options;
  final dynamic selected; // String for single-select, List<String> for multi-select
  final ValueChanged<String> onChanged;
  final ChipLayoutMode layoutMode;

  const OnboardingChipSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.layoutMode = ChipLayoutMode.wrap,
  });

  bool _isSelected(String key) {
    if (selected is List<String>) {
      return (selected as List<String>).contains(key);
    }
    return selected == key;
  }

  @override
  Widget build(BuildContext context) {
    switch (layoutMode) {
      case ChipLayoutMode.equalWidthRow:
        return _buildEqualWidthRow();
      case ChipLayoutMode.equalWidthGrid:
        return _buildEqualWidthGrid();
      case ChipLayoutMode.wrap:
        return _buildWrap();
    }
  }

  Widget _buildEqualWidthRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _buildChip(
                option: options[i],
                isSelected: _isSelected(options[i].key),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEqualWidthGrid() {
    // For 4 items, create 2 rows with 2 items each
    final firstRow = options.take(2).toList();
    final secondRow = options.skip(2).take(2).toList();

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < firstRow.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _buildChip(
                    option: firstRow[i],
                    isSelected: _isSelected(firstRow[i].key),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < secondRow.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _buildChip(
                    option: secondRow[i],
                    isSelected: _isSelected(secondRow[i].key),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWrap() {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: options.map((option) {
        final isSelected = _isSelected(option.key);
        return GestureDetector(
          onTap: () => onChanged(option.key),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.cyanDim : AppColor.surface,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: isSelected ? AppColor.cyan : AppColor.border,
              ),
            ),
            child: Text(
              option.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColor.cyan : AppColor.fgSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChip({
    required OnboardingStepOption option,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onChanged(option.key),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.cyanDim : AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? AppColor.cyan : AppColor.border,
          ),
        ),
        child: Text(
          option.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColor.cyan : AppColor.fgSecondary,
          ),
        ),
      ),
    );
  }
}
