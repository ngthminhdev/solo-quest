import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/learning_goal_model.dart';
import '../../../widgets/app_bottom_sheet/app_bottom_sheet.dart';
import '../../../widgets/app_button/app_button.dart';
import '../../../widgets/app_text_field/app_text_field.dart';
import '../../../widgets/app_toast/app_toast_service.dart';
import '../constants/learning_goals_constants.dart';

class LearningGoalFormResult {
  final String title;
  final String description;
  final String category;
  final int targetMinutesPerDay;
  final DateTime? deadline;
  final bool isActive;

  const LearningGoalFormResult({
    required this.title,
    required this.description,
    required this.category,
    required this.targetMinutesPerDay,
    this.deadline,
    required this.isActive,
  });
}

class LearningGoalFormSheet {
  static Future<LearningGoalFormResult?> show(
    BuildContext context, {
    LearningGoalModel? initialGoal,
  }) async {
    return await AppBottomSheet.show<LearningGoalFormResult>(
      context: context,
      title: initialGoal == null
          ? LearningGoalsConstants.formTitleAdd
          : LearningGoalsConstants.formTitleEdit,
      body: _LearningGoalForm(initialGoal: initialGoal),
    );
  }
}

class _LearningGoalForm extends StatefulWidget {
  final LearningGoalModel? initialGoal;

  const _LearningGoalForm({this.initialGoal});

  @override
  State<_LearningGoalForm> createState() => _LearningGoalFormState();
}

class _LearningGoalFormState extends State<_LearningGoalForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _targetMinutesController;
  late DateTime? _deadline;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final goal = widget.initialGoal;
    _titleController = TextEditingController(text: goal?.title ?? '');
    _descriptionController = TextEditingController(text: goal?.description ?? '');
    _categoryController = TextEditingController(text: goal?.category ?? '');
    _targetMinutesController = TextEditingController(
      text: goal?.targetMinutesPerDay.toString() ?? '30',
    );
    _deadline = goal?.deadline;
    _isActive = goal?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _targetMinutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.s16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title field
          AppTextField(
            controller: _titleController,
            label: LearningGoalsConstants.labelTitle,
            placeholder: 'Ví dụ: Học Flutter Architecture',
          ),

          const SizedBox(height: AppSpacing.s16),

          // Description field
          AppTextField(
            controller: _descriptionController,
            label: LearningGoalsConstants.labelDescription,
            placeholder: 'Mô tả chi tiết mục tiêu...',
            maxLines: 3,
          ),

          const SizedBox(height: AppSpacing.s16),

          // Category field
          AppTextField(
            controller: _categoryController,
            label: LearningGoalsConstants.labelCategory,
            placeholder: 'Ví dụ: Flutter, Dart, English...',
          ),

          const SizedBox(height: AppSpacing.s8),

          // Category suggestions
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: LearningGoalsConstants.suggestedCategories.map((cat) {
              return GestureDetector(
                onTap: () {
                  _categoryController.text = cat;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s10,
                    vertical: AppSpacing.s6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColor.border),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.fgMuted,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.s16),

          // Target minutes field
          AppTextField(
            controller: _targetMinutesController,
            label: LearningGoalsConstants.labelTargetMinutes,
            placeholder: '30',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),

          const SizedBox(height: AppSpacing.s16),

          // Deadline field
          GestureDetector(
            onTap: _pickDeadline,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.s12),
              decoration: BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LearningGoalsConstants.labelDeadline,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColor.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Text(
                          _deadline != null
                              ? '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}'
                              : 'Không có deadline',
                          style: TextStyle(
                            fontSize: 14,
                            color: _deadline != null
                                ? AppColor.fg
                                : AppColor.fgMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_deadline != null)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      color: AppColor.fgMuted,
                      onPressed: () {
                        setState(() {
                          _deadline = null;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s16),

          // Active toggle
          GestureDetector(
            onTap: () => setState(() => _isActive = !_isActive),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.s12),
              decoration: BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      LearningGoalsConstants.labelActive,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColor.fg,
                      ),
                    ),
                  ),
                  Switch(
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                    activeColor: AppColor.cyan,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s24),

          // Submit button
          AppButton(
            label: widget.initialGoal == null ? 'Thêm' : 'Cập nhật',
            onPressed: _handleSubmit,
            variant: AppButtonVariant.primary,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColor.cyan,
              onPrimary: AppColor.bgDeep,
              surface: AppColor.surface,
              onSurface: AppColor.fg,
            ),
            dialogBackgroundColor: AppColor.bgRaised,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  void _handleSubmit() {
    // Validate
    if (_titleController.text.trim().isEmpty) {
      AppToastService.error(
        context,
        LearningGoalsConstants.errorTitleRequired,
      );
      return;
    }

    if (_categoryController.text.trim().isEmpty) {
      AppToastService.error(
        context,
        LearningGoalsConstants.errorCategoryRequired,
      );
      return;
    }

    final targetMinutes = int.tryParse(_targetMinutesController.text) ?? 0;
    if (targetMinutes <= 0) {
      AppToastService.error(
        context,
        LearningGoalsConstants.errorTargetMinutesInvalid,
      );
      return;
    }

    final result = LearningGoalFormResult(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      targetMinutesPerDay: targetMinutes,
      deadline: _deadline,
      isActive: _isActive,
    );

    Navigator.of(context).pop(result);
  }
}
