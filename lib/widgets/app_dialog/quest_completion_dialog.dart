import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remixicon/remixicon.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';

class QuestCompletionDialog extends StatefulWidget {
  final int exp;
  final VoidCallback? onDone;

  const QuestCompletionDialog({
    super.key,
    required this.exp,
    this.onDone,
  });

  static Future<void> show({
    required BuildContext context,
    required int exp,
    VoidCallback? onDone,
  }) {
    // Satisfying success haptic feedback
    HapticFeedback.mediumImpact();

    return showDialog(
      context: context,
      builder: (_) => QuestCompletionDialog(exp: exp, onDone: onDone),
    );
  }

  @override
  State<QuestCompletionDialog> createState() => _QuestCompletionDialogState();
}

class _QuestCompletionDialogState extends State<QuestCompletionDialog> {
  String? _selectedFeeling;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColor.bgRaised,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColor.borderGlowCyan),
          boxShadow: [
            BoxShadow(color: AppColor.cyanGlow, blurRadius: 20),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success ring
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.successDim,
                  border: Border.all(color: AppColor.success, width: 2),
                ),
                child: Icon(RemixIcons.check_line, color: AppColor.success, size: 26),
              ),
              const SizedBox(height: 12),
              Text(
                'Nhiệm vụ hoàn thành',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColor.fg,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '+${widget.exp} EXP',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColor.expGold,
                ),
              ),
              const SizedBox(height: 12),

              // Note field
              TextField(
                controller: _noteController,
                maxLines: 2,
                style: TextStyle(fontSize: 13, color: AppColor.fg),
                decoration: InputDecoration(
                  hintText: 'Bạn cảm thấy thế nào sau nhiệm vụ này?',
                  hintStyle: TextStyle(color: AppColor.fgMuted),
                  filled: true,
                  fillColor: AppColor.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: AppColor.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: AppColor.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: AppColor.cyan),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 14),

              // Feeling options
              Text(
                'Cảm nhận của bạn?',
                style: TextStyle(fontSize: 13, color: AppColor.fgSecondary),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _feelingChip('Tốt hơn', 'better'),
                  const SizedBox(width: 8),
                  _feelingChip('Bình thường', 'same'),
                  const SizedBox(width: 8),
                  _feelingChip('Mệt hơn', 'tired'),
                ],
              ),
              const SizedBox(height: 16),

              // Done button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onDone?.call();
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColor.cyan,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Center(
                    child: Text(
                      'Xong',
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
      ),
    );
  }

  Widget _feelingChip(String label, String value) {
    final isSelected = _selectedFeeling == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFeeling = value),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? AppColor.cyanDim : AppColor.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: isSelected ? AppColor.borderGlowCyan : AppColor.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColor.cyan : AppColor.fgSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
