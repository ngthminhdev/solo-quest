import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';

class RewardCreateSection extends StatefulWidget {
  const RewardCreateSection({super.key});

  @override
  State<RewardCreateSection> createState() => _RewardCreateSectionState();
}

class _RewardCreateSectionState extends State<RewardCreateSection> {
  bool _isOpen = false;
  String _selectedType = 'Nghỉ ngơi';
  String _selectedLimit = 'Một lần';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s16,
            AppSpacing.s10,
            AppSpacing.s16,
            0,
          ),
          child: GestureDetector(
            onTap: () => setState(() => _isOpen = !_isOpen),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.s14),
              decoration: BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: _isOpen ? AppColor.cyan : AppColor.border,
                  style: _isOpen ? BorderStyle.solid : BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColor.cyanDim,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isOpen ? RemixIcons.close_line : RemixIcons.add_line,
                      size: 16,
                      color: AppColor.cyan,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  const Text(
                    'Tạo phần thưởng riêng',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColor.fgSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isOpen)
          Container(
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.s16,
              AppSpacing.s10,
              AppSpacing.s16,
              0,
            ),
            padding: const EdgeInsets.all(AppSpacing.s16),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColor.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                const _FormLabel('Tên phần thưởng'),
                const SizedBox(height: AppSpacing.s6),
                const _FormInput(hint: 'Ví dụ: Đi dạo công viên 30 phút'),
                const SizedBox(height: AppSpacing.s12),

                // Points + Limit
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FormLabel('Số điểm'),
                          const SizedBox(height: AppSpacing.s6),
                          const _FormInput(hint: '100', isNumber: true),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FormLabel('Giới hạn'),
                          const SizedBox(height: AppSpacing.s6),
                          _ChipGroup(
                            options: const ['Một lần', 'Hàng tuần', 'Milestone'],
                            selected: _selectedLimit,
                            onSelected: (v) =>
                                setState(() => _selectedLimit = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s12),

                // Type
                const _FormLabel('Loại'),
                const SizedBox(height: AppSpacing.s6),
                _ChipGroup(
                  options: const [
                    'Nghỉ ngơi',
                    'Giải trí',
                    'Ăn uống',
                    'Mua sắm',
                    'Trải nghiệm',
                  ],
                  selected: _selectedType,
                  onSelected: (v) => setState(() => _selectedType = v),
                ),
                const SizedBox(height: AppSpacing.s16),

                // Submit
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _isOpen = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã thêm reward mới!'),
                          backgroundColor: AppColor.surface,
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                      decoration: BoxDecoration(
                        color: AppColor.cyan,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Text(
                        'Thêm Reward',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColor.bgDeep,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColor.fgSecondary,
      ),
    );
  }
}

class _FormInput extends StatelessWidget {
  final String hint;
  final bool isNumber;
  const _FormInput({required this.hint, this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontSize: 14, color: AppColor.fg),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColor.fgMuted),
        filled: true,
        fillColor: AppColor.bgRaised,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColor.cyan),
        ),
      ),
    );
  }
}

class _ChipGroup extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const _ChipGroup({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s6,
      runSpacing: AppSpacing.s6,
      children: options.map((option) {
        final isSelected = option == selected;
        return GestureDetector(
          onTap: () => onSelected(option),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.cyanDim : AppColor.bgRaised,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: isSelected ? AppColor.cyan : AppColor.border,
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
