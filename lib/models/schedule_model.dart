import '../core/api/dto/schedule_block_dto.dart';

class TimeRangeModel {
  final String start;
  final String end;

  const TimeRangeModel({
    required this.start,
    required this.end,
  });

  TimeRangeModel copyWith({String? start, String? end}) {
    return TimeRangeModel(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  factory TimeRangeModel.fromJson(Map<String, dynamic> json) {
    return TimeRangeModel(
      start: json['start'] as String,
      end: json['end'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'start': start, 'end': end};
  }

  @override
  String toString() => '$start - $end';
}

class ScheduleBlockModel {
  final String id;
  final String title;
  final TimeRangeModel timeRange;
  final List<int> weekdays;
  final String type;
  final bool isFlexible;
  final bool isBusy;
  final bool enabled;
  final String? location;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ScheduleBlockModel({
    required this.id,
    required this.title,
    required this.timeRange,
    this.weekdays = const [1, 2, 3, 4, 5, 6, 7],
    this.type = 'other',
    this.isFlexible = false,
    this.isBusy = false,
    this.enabled = true,
    this.location,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  ScheduleBlockModel copyWith({
    String? id,
    String? title,
    TimeRangeModel? timeRange,
    List<int>? weekdays,
    String? type,
    bool? isFlexible,
    bool? isBusy,
    bool? enabled,
    String? location,
    bool clearLocation = false,
    String? note,
    bool clearNote = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScheduleBlockModel(
      id: id ?? this.id,
      title: title ?? this.title,
      timeRange: timeRange ?? this.timeRange,
      weekdays: weekdays ?? this.weekdays,
      type: type ?? this.type,
      isFlexible: isFlexible ?? this.isFlexible,
      isBusy: isBusy ?? this.isBusy,
      enabled: enabled ?? this.enabled,
      location: clearLocation ? null : (location ?? this.location),
      note: clearNote ? null : (note ?? this.note),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Create from API DTO
  factory ScheduleBlockModel.fromDto(ScheduleBlockDto dto) {
    return ScheduleBlockModel(
      id: dto.id,
      title: dto.title,
      timeRange: TimeRangeModel(start: dto.startTime, end: dto.endTime),
      weekdays: dto.daysOfWeek,
      type: dto.type,
      isFlexible: dto.isFlexible,
      isBusy: dto.isBusy,
      enabled: dto.enabled,
      location: dto.location,
      note: dto.note,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  /// Convert to DTO for API calls
  ScheduleBlockDto toDto() {
    return ScheduleBlockDto(
      id: id,
      title: title,
      type: type,
      daysOfWeek: weekdays,
      startTime: timeRange.start,
      endTime: timeRange.end,
      isBusy: isBusy,
      isFlexible: isFlexible,
      enabled: enabled,
      location: location,
      note: note,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ScheduleBlockModel.fromJson(Map<String, dynamic> json) {
    return ScheduleBlockModel(
      id: json['id'] as String,
      title: json['title'] as String,
      timeRange: TimeRangeModel.fromJson(json['time_range'] as Map<String, dynamic>),
      weekdays: (json['weekdays'] as List<dynamic>?)?.cast<int>() ?? [1, 2, 3, 4, 5, 6, 7],
      type: json['type'] as String? ?? 'other',
      isFlexible: json['is_flexible'] as bool? ?? false,
      isBusy: json['is_busy'] as bool? ?? false,
      enabled: json['enabled'] as bool? ?? true,
      location: json['location'] as String?,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time_range': timeRange.toJson(),
      'weekdays': weekdays,
      'type': type,
      'is_flexible': isFlexible,
      'is_busy': isBusy,
      'enabled': enabled,
      'location': location,
      'note': note,
    };
  }
}
