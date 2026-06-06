import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/enums/reminder_enums.dart';
import '../../../models/reminder_setting_model.dart';
import '../../../widgets/app_bottom_sheet/app_bottom_sheet.dart';
import '../../../widgets/app_button/app_button.dart';
import '../../../widgets/app_form/app_toggle_row.dart';
import '../../../widgets/app_text_field/app_text_field.dart';
import '../../../widgets/app_toast/app_toast_service.dart';
import '../../../extensions/localization_extension.dart';
import 'reminder_frequency_selector.dart';
import 'reminder_time_range_row.dart';

class ReminderSettingFormResult {
  final ReminderFrequency frequency;
  final String? startTime;
  final String? endTime;
  final int? intervalMinutes;
  final int? maxPerDay;
  final bool smartEnabled;

  const ReminderSettingFormResult({
    required this.frequency,
    this.startTime,
    this.endTime,
    this.intervalMinutes,
    this.maxPerDay,
    required this.smartEnabled,
  });
}

class ReminderSettingFormSheet {
  static Future<ReminderSettingFormResult?> show(
    BuildContext context, {
    required ReminderSettingModel initialSetting,
  }) async {
    return AppBottomSheet.show<ReminderSettingFormResult>(
      context: context,
      title: context.l10n.reminderSettingsFormTitle,
      subtitle: initialSetting.title,
      body: _ReminderSettingForm(initialSetting: initialSetting),
    );
  }
}

class _ReminderSettingForm extends StatefulWidget {
  final ReminderSettingModel initialSetting;

  const _ReminderSettingForm({required this.initialSetting});

  @override
  State<_ReminderSettingForm> createState() => _ReminderSettingFormState();
}

class _ReminderSettingFormState extends State<_ReminderSettingForm> {
  late ReminderFrequency _frequency;
  late String? _startTime;
  late String? _endTime;
  late bool _smartEnabled;
  late final TextEditingController _intervalController;
  late final TextEditingController _maxPerDayController;

  @override
  void initState() {
    super.initState();
    final setting = widget.initialSetting;
    _frequency = setting.frequency;
    _startTime = setting.startTime;
    _endTime = setting.endTime;
    _smartEnabled =
        setting.smartEnabled || setting.frequency == ReminderFrequency.smart;
    _intervalController = TextEditingController(
      text: setting.intervalMinutes?.toString() ?? '',
    );
    _maxPerDayController = TextEditingController(
      text: setting.maxPerDay?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _intervalController.dispose();
    _maxPerDayController.dispose();
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
          _FormLabel(context.l10n.reminderFormFrequency),
          const SizedBox(height: AppSpacing.s8),
          ReminderFrequencySelector(
            value: _frequency,
            onChanged: (value) {
              setState(() {
                _frequency = value;
                if (value == ReminderFrequency.smart) {
                  _smartEnabled = true;
                }
              });
            },
          ),
          const SizedBox(height: AppSpacing.s16),
          _FormLabel(context.l10n.reminderFormTimeWindow),
          const SizedBox(height: AppSpacing.s8),
          ReminderTimeRangeRow(
            startTime: _startTime,
            endTime: _endTime,
            onStartChanged: (value) => setState(() => _startTime = value),
            onEndChanged: (value) => setState(() => _endTime = value),
          ),
          const SizedBox(height: AppSpacing.s16),
          AppTextField(
            controller: _intervalController,
            label: context.l10n.reminderFormMinIntervalLabel,
            placeholder: context.l10n.reminderFormMinIntervalPlaceholder,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: AppSpacing.s16),
          AppTextField(
            controller: _maxPerDayController,
            label: context.l10n.reminderFormMaxPerDayLabel,
            placeholder: context.l10n.reminderFormMaxPerDayPlaceholder,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: AppSpacing.s12),
          AppToggleRow(
            title: context.l10n.reminderFormSmartTitle,
            subtitle: context.l10n.reminderFormSmartSubtitle,
            value: _smartEnabled,
            onChanged: (value) => setState(() => _smartEnabled = value),
          ),
          const SizedBox(height: AppSpacing.s20),
          AppButton(
            label: context.l10n.reminderFormSaveButton,
            onPressed: _handleSubmit,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    final intervalMinutes = _parsePositiveInt(_intervalController.text);
    final maxPerDay = _parsePositiveInt(_maxPerDayController.text);

    if (_frequency == ReminderFrequency.fixed &&
        (_startTime == null || _startTime!.isEmpty)) {
      AppToastService.error(context, context.l10n.reminderFormErrorFixedTimeRequired);
      return;
    }

    if (_frequency == ReminderFrequency.interval) {
      if ((_startTime == null || _startTime!.isEmpty) ||
          (_endTime == null || _endTime!.isEmpty)) {
        AppToastService.error(context, context.l10n.reminderFormErrorTimeRangeRequired);
        return;
      }
      if (intervalMinutes == null) {
        AppToastService.error(context, context.l10n.reminderFormErrorIntervalInvalid);
        return;
      }
    }

    if (_frequency == ReminderFrequency.randomInRange) {
      if ((_startTime == null || _startTime!.isEmpty) ||
          (_endTime == null || _endTime!.isEmpty)) {
        AppToastService.error(context, context.l10n.reminderFormErrorRandomRangeRequired);
        return;
      }
      if (_maxPerDayController.text.trim().isNotEmpty && maxPerDay == null) {
        AppToastService.error(context, context.l10n.reminderFormErrorMaxPerDayInvalid);
        return;
      }
    }

    if (_frequency == ReminderFrequency.smart && !_smartEnabled) {
      AppToastService.error(context, context.l10n.reminderFormErrorSmartRequired);
      return;
    }

    Navigator.of(context).pop(
      ReminderSettingFormResult(
        frequency: _frequency,
        startTime: _startTime,
        endTime: _endTime,
        intervalMinutes: intervalMinutes,
        maxPerDay: maxPerDay,
        smartEnabled: _smartEnabled,
      ),
    );
  }

  int? _parsePositiveInt(String raw) {
    if (raw.trim().isEmpty) return null;
    final value = int.tryParse(raw.trim());
    if (value == null || value <= 0) return null;
    return value;
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
        fontWeight: FontWeight.w700,
        color: AppColor.fgSecondary,
      ),
    );
  }
}
