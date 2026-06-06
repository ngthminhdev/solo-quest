import '../../../models/enums/reminder_enums.dart';
import '../../../models/reminder_setting_model.dart';

/// Reminder setting DTO from /api/settings/reminders
class ReminderSettingDto {
  final String id;
  final ReminderType type;
  final String title;
  final String description;
  final ReminderFrequency frequency;
  final ReminderStatus status;
  final String? startTime;
  final String? endTime;
  final int? intervalMinutes;
  final int? maxPerDay;
  final bool smartEnabled;

  ReminderSettingDto({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.frequency,
    required this.status,
    this.startTime,
    this.endTime,
    this.intervalMinutes,
    this.maxPerDay,
    this.smartEnabled = false,
  });

  factory ReminderSettingDto.fromJson(Map<String, dynamic> json) {
    return ReminderSettingDto(
      id: json['id'] as String,
      type: ReminderTypeApi.fromApiValue(json['type'] as String),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      frequency: ReminderFrequencyApi.fromApiValue(json['frequency'] as String),
      status: ReminderStatusApi.fromApiValue(json['status'] as String),
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      intervalMinutes: json['interval_minutes'] as int?,
      maxPerDay: json['max_per_day'] as int?,
      smartEnabled: json['smart_enabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toApiValue(),
      'title': title,
      'description': description,
      'frequency': frequency.toApiValue(),
      'status': status.toApiValue(),
      'start_time': startTime,
      'end_time': endTime,
      'interval_minutes': intervalMinutes,
      'max_per_day': maxPerDay,
      'smart_enabled': smartEnabled,
    };
  }

  /// Build PATCH request body for updating a reminder setting.
  static Map<String, dynamic> toUpdateJson(ReminderSettingModel model) {
    return {
      'frequency': model.frequency.toApiValue(),
      'status': model.status.toApiValue(),
      'start_time': model.startTime,
      'end_time': model.endTime,
      'interval_minutes': model.intervalMinutes,
      'max_per_day': model.maxPerDay,
      'smart_enabled': model.smartEnabled,
    };
  }

  /// Convert to domain model.
  ReminderSettingModel toModel() {
    return ReminderSettingModel(
      id: id,
      type: type,
      title: title,
      description: description,
      frequency: frequency,
      status: status,
      startTime: startTime,
      endTime: endTime,
      intervalMinutes: intervalMinutes,
      maxPerDay: maxPerDay,
      smartEnabled: smartEnabled,
    );
  }
}
