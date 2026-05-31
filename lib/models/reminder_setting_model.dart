import 'enums/reminder_enums.dart';

class ReminderSettingModel {
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

  const ReminderSettingModel({
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

  ReminderSettingModel copyWith({
    String? id,
    ReminderType? type,
    String? title,
    String? description,
    ReminderFrequency? frequency,
    ReminderStatus? status,
    String? startTime,
    String? endTime,
    int? intervalMinutes,
    int? maxPerDay,
    bool? smartEnabled,
  }) {
    return ReminderSettingModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      maxPerDay: maxPerDay ?? this.maxPerDay,
      smartEnabled: smartEnabled ?? this.smartEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'frequency': frequency.name,
      'status': status.name,
      'start_time': startTime,
      'end_time': endTime,
      'interval_minutes': intervalMinutes,
      'max_per_day': maxPerDay,
      'smart_enabled': smartEnabled,
    };
  }

  factory ReminderSettingModel.fromJson(Map<String, dynamic> json) {
    return ReminderSettingModel(
      id: json['id'] as String,
      type: ReminderType.values.byName(json['type'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      frequency: ReminderFrequency.values.byName(json['frequency'] as String),
      status: ReminderStatus.values.byName(json['status'] as String),
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      intervalMinutes: json['interval_minutes'] as int?,
      maxPerDay: json['max_per_day'] as int?,
      smartEnabled: json['smart_enabled'] as bool? ?? false,
    );
  }

  bool get isEnabled => status == ReminderStatus.enabled;
}
