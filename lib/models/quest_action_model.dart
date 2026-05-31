import 'enums/quest_enums.dart';

class QuestActionModel {
  final String id;
  final String questId;
  final QuestActionType actionType;
  final DateTime createdAt;
  final String? note;
  final String? reason;
  final int? snoozeMinutes;

  const QuestActionModel({
    required this.id,
    required this.questId,
    required this.actionType,
    required this.createdAt,
    this.note,
    this.reason,
    this.snoozeMinutes,
  });

  QuestActionModel copyWith({
    String? id,
    String? questId,
    QuestActionType? actionType,
    DateTime? createdAt,
    String? note,
    String? reason,
    int? snoozeMinutes,
  }) {
    return QuestActionModel(
      id: id ?? this.id,
      questId: questId ?? this.questId,
      actionType: actionType ?? this.actionType,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      reason: reason ?? this.reason,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
    );
  }

  factory QuestActionModel.fromJson(Map<String, dynamic> json) {
    return QuestActionModel(
      id: json['id'] as String,
      questId: json['quest_id'] as String,
      actionType: QuestActionType.values.byName(json['action_type'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      note: json['note'] as String?,
      reason: json['reason'] as String?,
      snoozeMinutes: json['snooze_minutes'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quest_id': questId,
      'action_type': actionType.name,
      'created_at': createdAt.toIso8601String(),
      'note': note,
      'reason': reason,
      'snooze_minutes': snoozeMinutes,
    };
  }
}
