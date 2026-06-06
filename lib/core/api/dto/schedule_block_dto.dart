import '../../utils/date_time_parser.dart';

/// Schedule Block DTO
/// Maps to backend /api/schedule-blocks endpoints
class ScheduleBlockDto {
  final String id;
  final String title;
  final String type;
  final List<int> daysOfWeek;
  final String startTime;
  final String endTime;
  final bool isBusy;
  final bool isFlexible;
  final bool enabled;
  final String? location;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ScheduleBlockDto({
    required this.id,
    required this.title,
    required this.type,
    required this.daysOfWeek,
    required this.startTime,
    required this.endTime,
    this.isBusy = false,
    this.isFlexible = false,
    this.enabled = true,
    this.location,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  /// Parse from backend JSON response
  factory ScheduleBlockDto.fromJson(Map<String, dynamic> json) {
    return ScheduleBlockDto(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? 'other',
      daysOfWeek: (json['days_of_week'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      isBusy: json['is_busy'] as bool? ?? false,
      isFlexible: json['is_flexible'] as bool? ?? false,
      enabled: json['enabled'] as bool? ?? true,
      location: json['location'] as String?,
      note: json['note'] as String?,
      createdAt: parseUtcDateTime(json['created_at'] as String?),
      updatedAt: parseUtcDateTime(json['updated_at'] as String?),
    );
  }

  /// Full JSON (for internal use, includes id and timestamps)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'days_of_week': daysOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'is_busy': isBusy,
      'is_flexible': isFlexible,
      'enabled': enabled,
      'location': location,
      'note': note,
      'created_at': formatUtcDateTime(createdAt),
      'updated_at': formatUtcDateTime(updatedAt),
    };
  }

  /// JSON for POST /api/schedule-blocks (no id, no timestamps)
  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'type': type,
      'days_of_week': daysOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'is_busy': isBusy,
      'is_flexible': isFlexible,
      if (location != null) 'location': location,
      if (note != null) 'note': note,
    };
  }

  /// JSON for PUT /api/schedule-blocks/:id (full replacement, no id/timestamps)
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'type': type,
      'days_of_week': daysOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'is_busy': isBusy,
      'is_flexible': isFlexible,
      'enabled': enabled,
      if (location != null) 'location': location,
      if (note != null) 'note': note,
    };
  }
}
