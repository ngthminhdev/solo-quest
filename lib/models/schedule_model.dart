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

  const ScheduleBlockModel({
    required this.id,
    required this.title,
    required this.timeRange,
    this.weekdays = const [1, 2, 3, 4, 5, 6, 7],
    this.type = 'activity',
    this.isFlexible = false,
  });

  ScheduleBlockModel copyWith({
    String? id,
    String? title,
    TimeRangeModel? timeRange,
    List<int>? weekdays,
    String? type,
    bool? isFlexible,
  }) {
    return ScheduleBlockModel(
      id: id ?? this.id,
      title: title ?? this.title,
      timeRange: timeRange ?? this.timeRange,
      weekdays: weekdays ?? this.weekdays,
      type: type ?? this.type,
      isFlexible: isFlexible ?? this.isFlexible,
    );
  }

  factory ScheduleBlockModel.fromJson(Map<String, dynamic> json) {
    return ScheduleBlockModel(
      id: json['id'] as String,
      title: json['title'] as String,
      timeRange: TimeRangeModel.fromJson(json['time_range'] as Map<String, dynamic>),
      weekdays: (json['weekdays'] as List<dynamic>?)?.cast<int>() ?? [1, 2, 3, 4, 5, 6, 7],
      type: json['type'] as String? ?? 'activity',
      isFlexible: json['is_flexible'] as bool? ?? false,
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
    };
  }
}
