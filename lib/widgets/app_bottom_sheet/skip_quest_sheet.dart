import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import 'app_bottom_sheet.dart';

class SkipQuestSheet {
  static final List<String> _reasons = [
    'Đang bận',
    'Không có năng lượng',
    'Không phù hợp',
    'Quên mất',
    'Không muốn làm',
    'Khác',
  ];

  static Future<String?> show(BuildContext context) {
    String? selectedReason;

    return AppBottomSheet.show<String>(
      context: context,
      title: 'Bỏ qua nhiệm vụ',
      subtitle: 'Vì sao bạn muốn bỏ qua? Hệ thống sẽ dùng thông tin này để điều chỉnh.',
      body: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _reasons.map((reason) {
                  final isSelected = reason == selectedReason;
                  return GestureDetector(
                    onTap: () => setState(() => selectedReason = reason),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.violet.withOpacity(0.12)
                            : AppColor.surface,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: isSelected ? AppColor.violet : AppColor.border,
                        ),
                      ),
                      child: Text(
                        reason,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColor.violet : AppColor.fgSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(selectedReason),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColor.violet,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Center(
                    child: Text(
                      'Xác nhận bỏ qua',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
                  color: Colors.transparent,
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
        },
      ),
    );
  }
}
