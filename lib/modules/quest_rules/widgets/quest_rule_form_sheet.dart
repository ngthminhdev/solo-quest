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
import '../../../extensions/localization_extension.dart';
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
      title: context.l10n.questRulesFormTitle,
      // subtitle: initialRule.title,
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
  late int _priority;
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

  @override
  void initState() {
    super.initState();
    final rule = widget.initialRule;
    _difficulty = rule.difficulty;
    _priority = rule.priority.clamp(1, 5);
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
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _intervalController.dispose();
    _maxPerDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.s16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: _titleController,
            label: l10n.questRulesFormTitleLabel,
            placeholder: l10n.questRulesFormTitlePlaceholder,
          ),
          const SizedBox(height: AppSpacing.s16),
          AppTextField(
            controller: _descriptionController,
            label: l10n.questRulesFormDescLabel,
            placeholder: l10n.questRulesFormDescPlaceholder,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.s16),
          _FormLabel(l10n.questRulesGeneralDifficulty),
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
                  label: l10n.questRulesFormIntervalLabel,
                  placeholder: '90',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: AppTextField(
                  controller: _maxPerDayController,
                  label: l10n.questRulesFormMaxPerDayLabel,
                  placeholder: '8',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          _FormLabel(l10n.questRulesFormPriorityLabel),
          const SizedBox(height: AppSpacing.s8),
          _PrioritySelector(
            value: _priority,
            onChanged: (value) => setState(() => _priority = value),
          ),
          const SizedBox(height: AppSpacing.s16),
          _FormLabel(l10n.questRulesFormTimeRangeLabel),
          const SizedBox(height: AppSpacing.s8),
          _TimeRangeRow(
            startTime: _startTime,
            endTime: _endTime,
            onStartChanged: (value) => setState(() => _startTime = value),
            onEndChanged: (value) => setState(() => _endTime = value),
          ),
          const SizedBox(height: AppSpacing.s16),
          _FormLabel(l10n.questRulesFormActiveDaysLabel),
          const SizedBox(height: AppSpacing.s8),
          WeekdaySelector(
            selectedWeekdays: _activeWeekdays,
            onChanged: (value) => setState(() => _activeWeekdays = value),
          ),
          const SizedBox(height: AppSpacing.s14),
          AppToggleRow(
            title: l10n.questRulesFormAdaptEnergy,
            subtitle: l10n.questRulesFormAdaptEnergySub,
            value: _adaptToEnergy,
            onChanged: (value) => setState(() => _adaptToEnergy = value),
          ),
          AppToggleRow(
            title: l10n.questRulesFormAdaptStress,
            subtitle: l10n.questRulesFormAdaptStressSub,
            value: _adaptToStress,
            onChanged: (value) => setState(() => _adaptToStress = value),
          ),
          AppToggleRow(
            title: l10n.questRulesFormAdaptSchedule,
            subtitle: l10n.questRulesFormAdaptScheduleSub,
            value: _adaptToSchedule,
            onChanged: (value) => setState(() => _adaptToSchedule = value),
          ),
          const SizedBox(height: AppSpacing.s20),
          AppButton(
            label: l10n.questRulesFormSaveButton,
            onPressed: _handleSubmit,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    final l10n = context.l10n;
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final minInterval = _parsePositiveInt(_intervalController.text);
    final maxPerDay = _parsePositiveInt(_maxPerDayController.text);

    if (title.isEmpty) {
      AppToastService.error(context, l10n.questRulesFormTitleRequired);
      return;
    }
    if (_intervalController.text.trim().isNotEmpty && minInterval == null) {
      AppToastService.error(context, l10n.questRulesFormIntervalMin);
      return;
    }
    if (_maxPerDayController.text.trim().isNotEmpty && maxPerDay == null) {
      AppToastService.error(context, l10n.questRulesFormMaxPerDayMin);
      return;
    }
    if (_activeWeekdays.isEmpty) {
      AppToastService.error(context, l10n.questRulesFormSelectActiveDays);
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
        priority: _priority,
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
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _TimePickerField(
            label: l10n.questRulesFormTimeRangeStart,
            value: startTime,
            onChanged: onStartChanged,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s10),
          child: Icon(
            RemixIcons.arrow_right_s_line,
            size: 18,
            color: AppColor.fgMuted,
          ),
        ),
        Expanded(
          child: _TimePickerField(
            label: l10n.questRulesFormTimeRangeEnd,
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
              style: TextStyle(fontSize: 11, color: AppColor.fgMuted),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              hasValue ? value! : '--:--',
              style: TextStyle(
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
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppColor.fgSecondary,
      ),
    );
  }
}

class _PrioritySelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _PrioritySelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedPriority = QuestPriorityX.fromValue(value);

    return GestureDetector(
      onTap: () => _showPriorityPicker(context),
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
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColor.cyan.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Center(
                child: Text(
                  '${selectedPriority.value}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColor.cyan,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Text(
              selectedPriority.getLocalizedLabel(l10n),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColor.fg,
              ),
            ),
            const Spacer(),
            Icon(
              RemixIcons.arrow_down_s_line,
              size: 18,
              color: AppColor.fgMuted,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPriorityPicker(BuildContext context) async {
    final l10n = context.l10n;
    final result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColor.bgRaised,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                  child: Text(
                    l10n.questRulesPrioritySelectTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColor.fg,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                ...QuestPriority.values.reversed.map((priority) {
                  final priorityValue = priority.value;
                  final selected = value == priorityValue;
                  return InkWell(
                    onTap: () => Navigator.of(context).pop(priorityValue),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                        vertical: AppSpacing.s14,
                      ),
                      color: selected ? AppColor.cyanDim : null,
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColor.cyan.withValues(alpha: 0.2)
                                  : AppColor.surface,
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                            ),
                            child: Center(
                              child: Text(
                                '$priorityValue',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: selected ? AppColor.cyan : AppColor.fgMuted,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Text(
                            priority.getLocalizedLabel(l10n),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: selected ? AppColor.cyan : AppColor.fg,
                            ),
                          ),
                          const Spacer(),
                          if (selected)
                            Icon(
                              RemixIcons.check_line,
                              size: 18,
                              color: AppColor.cyan,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }
}
