import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/schedule_model.dart';
import '../../../widgets/app_bottom_sheet/app_bottom_sheet.dart';
import '../../../widgets/app_button/app_button.dart';
import '../../../widgets/app_text_field/app_text_field.dart';
import '../../../widgets/app_toast/app_toast_service.dart';
import '../constants/schedule_editor_constants.dart';
import 'weekday_selector.dart';
import 'time_range_picker_row.dart';

class ScheduleBlockFormResult {
  final String title;
  final String type;
  final String start;
  final String end;
  final List<int> weekdays;
  final bool isFlexible;

  const ScheduleBlockFormResult({
    required this.title,
    required this.type,
    required this.start,
    required this.end,
    required this.weekdays,
    required this.isFlexible,
  });
}

class ScheduleBlockFormSheet {
  static Future<ScheduleBlockFormResult?> show(
    BuildContext context, {
    ScheduleBlockModel? initialBlock,
  }) async {
    return await AppBottomSheet.show<ScheduleBlockFormResult>(
      context: context,
      title: initialBlock == null
          ? ScheduleEditorConstants.formTitleAdd
          : ScheduleEditorConstants.formTitleEdit,
      body: _ScheduleBlockForm(initialBlock: initialBlock),
    );
  }
}

class _ScheduleBlockForm extends StatefulWidget {
  final ScheduleBlockModel? initialBlock;

  const _ScheduleBlockForm({this.initialBlock});

  @override
  State<_ScheduleBlockForm> createState() => _ScheduleBlockFormState();
}

class _ScheduleBlockFormState extends State<_ScheduleBlockForm> {
  late final TextEditingController _titleController;
  late String _selectedType;
  late String _startTime;
  late String _endTime;
  late List<int> _selectedWeekdays;
  late bool _isFlexible;

  @override
  void initState() {
    super.initState();
    final block = widget.initialBlock;
    _titleController = TextEditingController(text: block?.title ?? '');
    _selectedType = block?.type ?? 'work';
    _startTime = block?.timeRange.start ?? '';
    _endTime = block?.timeRange.end ?? '';
    _selectedWeekdays = block?.weekdays ?? [1, 2, 3, 4, 5];
    _isFlexible = block?.isFlexible ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
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
            label: ScheduleEditorConstants.labelTitle,
            placeholder: 'Ví dụ: Làm việc, Học Flutter...',
          ),

          const SizedBox(height: AppSpacing.s16),

          // Type selector
          Text(
            ScheduleEditorConstants.labelType,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColor.fgSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: ScheduleEditorConstants.blockTypes.entries.map((entry) {
              final isSelected = _selectedType == entry.key;
              return GestureDetector(
                onTap: () => setState(() => _selectedType = entry.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s12,
                    vertical: AppSpacing.s8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.cyanDim : AppColor.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColor.cyan : AppColor.border,
                    ),
                  ),
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColor.cyan : AppColor.fgMuted,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.s16),

          // Time range
          Text(
            'Thời gian',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColor.fgSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          TimeRangePickerRow(
            start: _startTime,
            end: _endTime,
            onStartChanged: (value) => setState(() => _startTime = value),
            onEndChanged: (value) => setState(() => _endTime = value),
          ),

          const SizedBox(height: AppSpacing.s16),

          // Weekdays
          Text(
            ScheduleEditorConstants.labelWeekdays,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColor.fgSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          WeekdaySelector(
            selectedWeekdays: _selectedWeekdays,
            onChanged: (value) => setState(() => _selectedWeekdays = value),
          ),

          const SizedBox(height: AppSpacing.s16),

          // Flexible toggle
          GestureDetector(
            onTap: () => setState(() => _isFlexible = !_isFlexible),
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
                          ScheduleEditorConstants.labelFlexible,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.fg,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Text(
                          'Có thể điều chỉnh thời gian linh hoạt',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.fgMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isFlexible,
                    onChanged: (value) => setState(() => _isFlexible = value),
                    activeColor: AppColor.cyan,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s24),

          // Submit button
          AppButton(
            label: widget.initialBlock == null ? 'Thêm' : 'Cập nhật',
            onPressed: _handleSubmit,
            variant: AppButtonVariant.primary,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    // Validate
    if (_titleController.text.trim().isEmpty) {
      AppToastService.error(context, ScheduleEditorConstants.errorTitleRequired);
      return;
    }

    if (_startTime.isEmpty || _endTime.isEmpty) {
      AppToastService.error(context, ScheduleEditorConstants.errorTimeRequired);
      return;
    }

    if (_selectedWeekdays.isEmpty) {
      AppToastService.error(context, ScheduleEditorConstants.errorWeekdaysRequired);
      return;
    }

    final result = ScheduleBlockFormResult(
      title: _titleController.text.trim(),
      type: _selectedType,
      start: _startTime,
      end: _endTime,
      weekdays: _selectedWeekdays,
      isFlexible: _isFlexible,
    );

    Navigator.of(context).pop(result);
  }
}
