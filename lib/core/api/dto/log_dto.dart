import '../../../models/enums/log_enums.dart';
import '../../../models/enums/quest_enums.dart';
import '../../utils/date_time_parser.dart';
import '../../utils/enum_mapper.dart';

/// Log entry DTO
class LogEntryDto {
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

  LogEntryDto({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.createdAt,
    this.questId,
    this.questType,
    this.expChanged,
    this.pointsChanged,
    this.mood,
    required this.metadata,
  });

  factory LogEntryDto.fromJson(Map<String, dynamic> json) {
    return LogEntryDto(
      id: json['id'] as String,
      type: parseLogEntryType(json['type'] as String?),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      createdAt: parseUtcDateTime(json['created_at'] as String?) ?? DateTime.now().toUtc(),
      questId: json['quest_id'] as String?,
      questType: json['quest_type'] != null ? parseQuestType(json['quest_type'] as String?) : null,
      expChanged: json['exp_changed'] as int?,
      pointsChanged: json['points_changed'] as int?,
      mood: json['mood'] != null ? parseLogMood(json['mood'] as String?) : null,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'created_at': formatUtcDateTime(createdAt),
      'quest_id': questId,
      'quest_type': questType?.name,
      'exp_changed': expChanged,
      'points_changed': pointsChanged,
      'mood': mood?.name,
      'metadata': metadata,
    };
  }
}

/// Log list response from /api/logs
class LogListDto {
  final List<LogEntryDto> logs;
  final int total;
  final int limit;
  final int offset;

  LogListDto({
    required this.logs,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory LogListDto.fromJson(Map<String, dynamic> json) {
    final logs = <LogEntryDto>[];

    final rawLogs = json['items'] ?? json['logs'] ?? json['data'];
    if (rawLogs is List<dynamic>) {
      for (final item in rawLogs) {
        logs.add(LogEntryDto.fromJson(item as Map<String, dynamic>));
      }
    }

    return LogListDto(
      logs: logs,
      total: json['total'] as int? ?? logs.length,
      limit: json['limit'] as int? ?? 20,
      offset: json['offset'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logs': logs.map((l) => l.toJson()).toList(),
      'total': total,
      'limit': limit,
      'offset': offset,
    };
  }
}
