import '../../../models/enums/quest_enums.dart';
import '../../utils/date_time_parser.dart';
import '../../utils/enum_mapper.dart';

/// Quest DTO from backend
class QuestDto {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final QuestStatus status;
  final QuestDifficulty difficulty;
  final QuestSource source;
  final int exp;
  final int estimatedMinutes;
  final DateTime? scheduledAt;
  final DateTime? dueDate;
  final DateTime? reminderTime;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? snoozedUntil;
  final String? reason;
  final String? instruction;
  final List<String> tags;
  final bool isImportant;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuestDto({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.difficulty,
    required this.source,
    required this.exp,
    required this.estimatedMinutes,
    this.scheduledAt,
    this.dueDate,
    this.reminderTime,
    this.startedAt,
    this.completedAt,
    this.snoozedUntil,
    this.reason,
    this.instruction,
    required this.tags,
    required this.isImportant,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuestDto.fromJson(Map<String, dynamic> json) {
    return QuestDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      type: parseQuestType(json['type'] as String?),
      status: parseQuestStatus(json['status'] as String?),
      difficulty: parseQuestDifficulty(json['difficulty'] as String?),
      source: parseQuestSource(json['source'] as String?),
      exp: json['exp'] as int? ?? 10,
      estimatedMinutes: json['estimated_minutes'] as int? ?? 5,
      scheduledAt: parseUtcDateTime(json['scheduled_at'] as String?),
      dueDate: parseUtcDateTime(json['due_date'] as String?),
      reminderTime: parseUtcDateTime(json['reminder_time'] as String?),
      startedAt: parseUtcDateTime(json['started_at'] as String?),
      completedAt: parseUtcDateTime(json['completed_at'] as String?),
      snoozedUntil: parseUtcDateTime(json['snoozed_until'] as String?),
      reason: json['reason'] as String?,
      instruction: json['instruction'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      isImportant: json['is_important'] as bool? ?? false,
      createdAt: parseUtcDateTime(json['created_at'] as String?) ?? DateTime.now().toUtc(),
      updatedAt: parseUtcDateTime(json['updated_at'] as String?) ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'status': status.name,
      'difficulty': difficulty.name,
      'source': source.name,
      'exp': exp,
      'estimated_minutes': estimatedMinutes,
      'scheduled_at': formatUtcDateTime(scheduledAt),
      'due_date': formatUtcDateTime(dueDate),
      'reminder_time': formatUtcDateTime(reminderTime),
      'started_at': formatUtcDateTime(startedAt),
      'completed_at': formatUtcDateTime(completedAt),
      'snoozed_until': formatUtcDateTime(snoozedUntil),
      'reason': reason,
      'instruction': instruction,
      'tags': tags,
      'is_important': isImportant,
      'created_at': formatUtcDateTime(createdAt),
      'updated_at': formatUtcDateTime(updatedAt),
    };
  }
}

/// Quest action result (start, skip, snooze)
class QuestActionResultDto {
  final QuestDto quest;
  final String message;

  QuestActionResultDto({
    required this.quest,
    required this.message,
  });

  factory QuestActionResultDto.fromJson(Map<String, dynamic> json) {
    return QuestActionResultDto(
      quest: QuestDto.fromJson(json['quest'] as Map<String, dynamic>),
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quest': quest.toJson(),
      'message': message,
    };
  }
}

/// Complete quest result
class CompleteQuestResultDto {
  final QuestDto quest;
  final int expEarned;
  final int? pointsEarned;
  final bool leveledUp;
  final int? newLevel;
  final String message;

  CompleteQuestResultDto({
    required this.quest,
    required this.expEarned,
    this.pointsEarned,
    required this.leveledUp,
    this.newLevel,
    required this.message,
  });

  factory CompleteQuestResultDto.fromJson(Map<String, dynamic> json) {
    return CompleteQuestResultDto(
      quest: QuestDto.fromJson(json['quest'] as Map<String, dynamic>),
      expEarned: json['exp_earned'] as int? ?? 0,
      pointsEarned: json['points_earned'] as int?,
      leveledUp: json['leveled_up'] as bool? ?? false,
      newLevel: json['new_level'] as int?,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quest': quest.toJson(),
      'exp_earned': expEarned,
      'points_earned': pointsEarned,
      'leveled_up': leveledUp,
      'new_level': newLevel,
      'message': message,
    };
  }
}
