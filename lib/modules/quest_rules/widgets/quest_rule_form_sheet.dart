import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../helpers/time_helper.dart';
import '../../../models/enums/quest_enums.dart';
import '../../../models/quest_rule_model.dart';
import '../../../models/schedule_model.dart';
import '../../../widgets/app_bottom_sheet/app_bottom_sheet.dart';
import '../../../widgets/app_button/app_button.dart';
import '../../../widgets/app_form/app_toggle_row.dart';
import '../../../widgets/app_text_field/app_text_field.dart';
import '../../../widgets/app_toast/app_toast_service.dart';
import '../../schedule_editor/widgets/weekday_selector.dart';
import '../constants/quest_rules_constants.dart';
import 'quest_difficulty_selector.dart';

class QuestRuleFormResult {
  final String title;
  final String description;
  final QuestDifficulty difficulty;
  final int? minIntervalMinutes;
  final int? maxPerDay;
  final TimeRangeModel? activeTimeRange;
  final List<int> activeWeekdays;
  final int priority;
  final bool adaptToEnergy;
  final bool adaptToStress;
  final bool adaptToSchedule;

  const QuestRuleFormResult({
    required this.title,
    required this.description,
    required this.difficulty,
    this.minIntervalMinutes,
    this.maxPerDay,
    this.activeTimeRange,
    required this.activeWeekdays,
    required this.priority,
    required this.adaptToEnergy,
    required this.adaptToStress,
    required this.adaptToSchedule,
  });
}

class QuestRuleFormSheet {
  static Future<QuestRuleFormResult?> show(
    BuildContext context, {
    required QuestRuleModel initialRule,
  }) {
    return AppBottomSheet.show<QuestRuleFormResult>(
      context: context,
      title: QuestRulesConstants.formTitle,
      subtitle: initialRule.title,
      body: _QuestRuleForm(initialRule: initialRule),
    );
  }
}

class _QuestRuleForm extends StatefulWidget {
  final QuestRuleModel initialRule;

  const _QuestRuleForm({required this.initialRule});

  @override
  State<_QuestRuleForm> createState() => _QuestRuleFormState();
}

class _QuestRuleFormState extends State<_QuestRuleForm> {
  late QuestDifficulty _difficulty;
  late String? _startTime;
  late String? _endTime;
  late List<int> _activeWeekdays;
  late bool _adaptToEnergy;
  late bool _adaptToStress;
  late bool _adaptToSchedule;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _intervalController;
  late final TextEditingController _maxPerDayController;
  late final TextEditingController _priorityController;

  @override
  void initState() {
    super.initState();
    final rule = widget.initialRule;
    _difficulty = rule.difficulty;
    _startTime = rule.activeTimeRange?.start;
    _endTime = rule.activeTimeRange?.end;
    _activeWeekdays = List<int>.from(rule.activeWeekdays);
    _adaptToEnergy = rule.adaptToEnergy;
    _adaptToStress = rule.adaptToStress;
    _adaptToSchedule = rule.adaptToSchedule;
    _titleController = TextEditingController(text: rule.title);
    _descriptionController = TextEditingController(text: rule.description);
    _intervalController = TextEditingController(
      text: rule.minIntervalMinutes?.toString() ?? '',
    );
    _maxPerDayController = TextEditingController(
      text: rule.maxPerDay?.toString() ?? '',
    );
    _priorityController = TextEditingController(text: rule.priority.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _intervalController.dispose();
    _maxPerDayController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.s16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: _titleController,
            label: 'Title',
            placeholder: 'Tên luật quest',
          ),
          const SizedBox(height: AppSpacing.s16),
          AppTextField(
            controller: _descriptionController,
            label: 'Description',
            placeholder: 'Mô tả cách luật này hoạt động',
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.s16),
          const _FormLabel('Độ khó mặc định'),
          const SizedBox(height: AppSpacing.s8),
          QuestDifficultySelector(
            value: _difficulty,
            onChanged: (value) => setState(() => _difficulty = value),
          ),
          const SizedBox(height: AppSpacing.s16),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _intervalController,
                  label: 'Min interval',
                  placeholder: '90',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: AppTextField(
                  controller: _maxPerDayController,
                  label: 'Max per day',
                  placeholder: '8',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          AppTextField(
            controller: _priorityController,
            label: 'Priority',
            placeholder: '1 - 5',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: AppSpacing.s16),
          const _FormLabel('Khung giờ hoạt động'),
          const SizedBox(height: AppSpacing.s8),
          _TimeRangeRow(
            startTime: _startTime,
            endTime: _endTime,
            onStartChanged: (value) => setState(() => _startTime = value),
            onEndChanged: (value) => setState(() => _endTime = value),
          ),
          const SizedBox(height: AppSpacing.s16),
          const _FormLabel('Ngày hoạt động'),
          const SizedBox(height: AppSpacing.s8),
          WeekdaySelector(
            selectedWeekdays: _activeWeekdays,
            onChanged: (value) => setState(() => _activeWeekdays = value),
          ),
          const SizedBox(height: AppSpacing.s14),
          AppToggleRow(
            title: 'Adapt to energy',
            subtitle: 'Điều chỉnh quest theo mức năng lượng.',
            value: _adaptToEnergy,
            onChanged: (value) => setState(() => _adaptToEnergy = value),
          ),
          AppToggleRow(
            title: 'Adapt to stress',
            subtitle: 'Giảm độ nặng khi stress cao.',
            value: _adaptToStress,
            onChanged: (value) => setState(() => _adaptToStress = value),
          ),
          AppToggleRow(
            title: 'Adapt to schedule',
            subtitle: 'Tránh tạo quest trùng lịch bận.',
            value: _adaptToSchedule,
            onChanged: (value) => setState(() => _adaptToSchedule = value),
          ),
          const SizedBox(height: AppSpacing.s20),
          AppButton(
            label: 'Lưu luật quest',
            onPressed: _handleSubmit,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final minInterval = _parsePositiveInt(_intervalController.text);
    final maxPerDay = _parsePositiveInt(_maxPerDayController.text);
    final priority = int.tryParse(_priorityController.text.trim()) ?? 0;

    if (title.isEmpty) {
      AppToastService.error(context, 'Title không được rỗng');
      return;
    }
    if (_intervalController.text.trim().isNotEmpty && minInterval == null) {
      AppToastService.error(context, 'Min interval phải lớn hơn 0');
      return;
    }
    if (_maxPerDayController.text.trim().isNotEmpty && maxPerDay == null) {
      AppToastService.error(context, 'Max per day phải lớn hơn 0');
      return;
    }
    if (priority < 1 || priority > 5) {
      AppToastService.error(context, 'Priority phải từ 1 đến 5');
      return;
    }
    if (_activeWeekdays.isEmpty) {
      AppToastService.error(context, 'Cần chọn ít nhất một ngày hoạt động');
      return;
    }

    Navigator.of(context).pop(
      QuestRuleFormResult(
        title: title,
        description: description,
        difficulty: _difficulty,
        minIntervalMinutes: minInterval,
        maxPerDay: maxPerDay,
        activeTimeRange: _buildTimeRange(),
        activeWeekdays: _activeWeekdays,
        priority: priority,
        adaptToEnergy: _adaptToEnergy,
        adaptToStress: _adaptToStress,
        adaptToSchedule: _adaptToSchedule,
      ),
    );
  }

  TimeRangeModel? _buildTimeRange() {
    if ((_startTime == null || _startTime!.isEmpty) &&
        (_endTime == null || _endTime!.isEmpty)) {
      return null;
    }
    return TimeRangeModel(
      start: _startTime?.isNotEmpty == true ? _startTime! : '00:00',
      end: _endTime?.isNotEmpty == true ? _endTime! : '23:59',
    );
  }

  int? _parsePositiveInt(String raw) {
    if (raw.trim().isEmpty) return null;
    final value = int.tryParse(raw.trim());
    if (value == null || value <= 0) return null;
    return value;
  }
}

class _TimeRangeRow extends StatelessWidget {
  final String? startTime;
  final String? endTime;
  final ValueChanged<String> onStartChanged;
  final ValueChanged<String> onEndChanged;

  const _TimeRangeRow({
    required this.startTime,
    required this.endTime,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TimePickerField(
            label: 'Bắt đầu',
            value: startTime,
            onChanged: onStartChanged,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s10),
          child: Icon(
            RemixIcons.arrow_right_s_line,
            size: 18,
            color: AppColor.fgMuted,
          ),
        ),
        Expanded(
          child: _TimePickerField(
            label: 'Kết thúc',
            value: endTime,
            onChanged: onEndChanged,
          ),
        ),
      ],
    );
  }
}

class _TimePickerField extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<String> onChanged;

  const _TimePickerField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return GestureDetector(
      onTap: () => _pickTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s10,
        ),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColor.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColor.fgMuted),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              hasValue ? value! : '--:--',
              style: TextStyle(
                fontFamily: 'Exo2',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: hasValue ? AppColor.fg : AppColor.fgMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await TimeHelper.pickTime(
      context,
      currentTime: value,
    );

    if (picked != null) {
      onChanged(picked);
    }
  }
}

class _FormLabel extends StatelessWidget {
  final String label;

  const _FormLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppColor.fgSecondary,
      ),
    );
  }
}
