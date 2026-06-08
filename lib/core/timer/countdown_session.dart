import '../../models/enums/quest_enums.dart';

enum CountdownStatus {
  running,
  completed,
  cancelled,
  expired,
}

class CountdownSession {
  final String sessionId;
  final String? questId;
  final String title;
  final QuestType type;
  final int durationMinutes;
  final DateTime startedAt;
  final DateTime endAt;
  final CountdownStatus status;
  final String? source;
  final String? reminderType;

  CountdownSession({
    required this.sessionId,
    this.questId,
    required this.title,
    required this.type,
    required this.durationMinutes,
    required this.startedAt,
    required this.endAt,
    required this.status,
    this.source,
    this.reminderType,
  });

  CountdownSession copyWith({
    String? sessionId,
    String? questId,
    String? title,
    QuestType? type,
    int? durationMinutes,
    DateTime? startedAt,
    DateTime? endAt,
    CountdownStatus? status,
    String? source,
    String? reminderType,
  }) {
    return CountdownSession(
      sessionId: sessionId ?? this.sessionId,
      questId: questId ?? this.questId,
      title: title ?? this.title,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      startedAt: startedAt ?? this.startedAt,
      endAt: endAt ?? this.endAt,
      status: status ?? this.status,
      source: source ?? this.source,
      reminderType: reminderType ?? this.reminderType,
    );
  }

  factory CountdownSession.fromJson(Map<String, dynamic> json) {
    return CountdownSession(
      sessionId: json['sessionId'] as String,
      questId: json['questId'] as String?,
      title: json['title'] as String,
      type: QuestType.values.byName(json['type'] as String),
      durationMinutes: json['durationMinutes'] as int,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      status: CountdownStatus.values.byName(json['status'] as String),
      source: json['source'] as String?,
      reminderType: json['reminderType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      if (questId != null) 'questId': questId,
      'title': title,
      'type': type.name,
      'durationMinutes': durationMinutes,
      'startedAt': startedAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'status': status.name,
      if (source != null) 'source': source,
      if (reminderType != null) 'reminderType': reminderType,
    };
  }
}
