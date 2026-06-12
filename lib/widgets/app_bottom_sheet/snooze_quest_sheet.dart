import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import 'app_bottom_sheet.dart';

class SnoozeQuestSheet {
  static final List<_SnoozeOption> _options = [
    _SnoozeOption('10 phút', 10),
    _SnoozeOption('15 phút', 15),
    _SnoozeOption('30 phút', 30),
    _SnoozeOption('1 giờ', 60),
  ];

  static Future<int?> show(BuildContext context) {
    int selectedMinutes = 10;

    return AppBottomSheet.show<int>(
      context: context,
      title: 'Hoãn nhiệm vụ',
      subtitle: 'Bạn muốn hệ thống nhắc lại sau bao lâu?',
      body: StatefulBuilder(
        builder: (context, setState) {
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
                itemCount: _options.length,
                itemBuilder: (_, index) {
                  final option = _options[index];
                  final isSelected = option.minutes == selectedMinutes;
                  return GestureDetector(
                    onTap: () => setState(() => selectedMinutes = option.minutes),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColor.warnDim : AppColor.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: isSelected ? AppColor.warn : AppColor.border,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          option.label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColor.warn : AppColor.fgSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(selectedMinutes),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColor.warn,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Center(
                    child: Text(
                      'Xác nhận hoãn',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColor.bgDeep,
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
                  child: Center(
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
        },
      ),
    );
  }
}

class _SnoozeOption {
  final String label;
  final int minutes;

  const _SnoozeOption(this.label, this.minutes);
}
