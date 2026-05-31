import 'enums/log_enums.dart';
import 'enums/quest_enums.dart';

class LogEntryModel {
  final String id;
  final LogEntryType type;
  final String title;
  final String description;
  final DateTime createdAt;
  final String? questId;
  final QuestType? questType;
  final int? expChanged;
  final int? pointsChanged;
  final LogMood? mood;
  final Map<String, dynamic> metadata;

  const LogEntryModel({
    required this.id,
    required this.type,
    required this.title,
    this.description = '',
    required this.createdAt,
    this.questId,
    this.questType,
    this.expChanged,
    this.pointsChanged,
    this.mood,
    this.metadata = const {},
  });

  LogEntryModel copyWith({
    String? id,
    LogEntryType? type,
    String? title,
    String? description,
    DateTime? createdAt,
    String? questId,
    QuestType? questType,
    int? expChanged,
    int? pointsChanged,
    LogMood? mood,
    Map<String, dynamic>? metadata,
  }) {
    return LogEntryModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      questId: questId ?? this.questId,
      questType: questType ?? this.questType,
      expChanged: expChanged ?? this.expChanged,
      pointsChanged: pointsChanged ?? this.pointsChanged,
      mood: mood ?? this.mood,
      metadata: metadata ?? this.metadata,
    );
  }

  factory LogEntryModel.fromJson(Map<String, dynamic> json) {
    return LogEntryModel(
      id: json['id'] as String,
      type: LogEntryType.values.byName(json['type'] as String),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      questId: json['quest_id'] as String?,
      questType: json['quest_type'] != null ? QuestType.values.byName(json['quest_type'] as String) : null,
      expChanged: json['exp_changed'] as int?,
      pointsChanged: json['points_changed'] as int?,
      mood: json['mood'] != null ? LogMood.values.byName(json['mood'] as String) : null,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'quest_id': questId,
      'quest_type': questType?.name,
      'exp_changed': expChanged,
      'points_changed': pointsChanged,
      'mood': mood?.name,
      'metadata': metadata,
    };
  }
}
