import 'ai_generate_today_dto.dart';

/// Status values returned by the async generation job endpoints.
class DailyQuestGenerationStatus {
  static const String notStarted = 'not_started';
  static const String generating = 'generating';
  static const String completed = 'completed';
  static const String failed = 'failed';
  static const String stale = 'stale';

  DailyQuestGenerationStatus._();
}

/// Returned by POST /api/quests/generate-today when the backend starts a
/// background generation job (HTTP 202 "generating").
class DailyQuestGenerationStartDto {
  final String date;
  final String status; // expected: "generating"
  final String jobId;
  final int estimatedSeconds;

  const DailyQuestGenerationStartDto({
    required this.date,
    required this.status,
    required this.jobId,
    required this.estimatedSeconds,
  });

  factory DailyQuestGenerationStartDto.fromJson(Map<String, dynamic> json) {
    return DailyQuestGenerationStartDto(
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? DailyQuestGenerationStatus.generating,
      jobId: (json['job_id'] ?? json['jobId'] ?? '').toString(),
      estimatedSeconds:
          (json['estimated_seconds'] as num?)?.toInt() ??
          (json['estimatedSeconds'] as num?)?.toInt() ??
          15,
    );
  }

  /// A response is an async-start payload when it carries a job id and a
  /// generation status (and no inline quests).
  static bool looksLikeStart(Map<String, dynamic> json) {
    final hasJob = json.containsKey('job_id') || json.containsKey('jobId');
    final hasQuests = json.containsKey('quests');
    return hasJob && !hasQuests;
  }
}

/// Returned by GET /api/quests/generate-today/status.
class DailyQuestGenerationStatusDto {
  final String date;
  final String status; // not_started | generating | completed | failed | stale
  final String? jobId;
  final int questCount;
  final String? source; // ai | rule_based | null
  final bool fallbackUsed;
  final String? errorMessage;

  const DailyQuestGenerationStatusDto({
    required this.date,
    required this.status,
    this.jobId,
    this.questCount = 0,
    this.source,
    this.fallbackUsed = false,
    this.errorMessage,
  });

  bool get isGenerating => status == DailyQuestGenerationStatus.generating;
  bool get isCompleted => status == DailyQuestGenerationStatus.completed;
  bool get isFailed => status == DailyQuestGenerationStatus.failed;
  bool get isStale => status == DailyQuestGenerationStatus.stale;
  bool get isNotStarted => status == DailyQuestGenerationStatus.notStarted;

  factory DailyQuestGenerationStatusDto.fromJson(Map<String, dynamic> json) {
    return DailyQuestGenerationStatusDto(
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? DailyQuestGenerationStatus.notStarted,
      jobId: (json['job_id'] ?? json['jobId'])?.toString(),
      questCount:
          (json['quest_count'] as num?)?.toInt() ??
          (json['questCount'] as num?)?.toInt() ??
          0,
      source: json['source'] as String?,
      fallbackUsed:
          json['fallback_used'] as bool? ?? json['fallbackUsed'] as bool? ?? false,
      errorMessage: json['error_message'] as String? ?? json['errorMessage'] as String?,
    );
  }
}

/// Outcome of POST /api/quests/generate-today.
///
/// Exactly one of [result] (HTTP 200, quests ready / already existed) or
/// [job] (HTTP 202, background generation started) is non-null.
class GenerateTodayOutcome {
  final AiGenerateTodayResultDto? result;
  final DailyQuestGenerationStartDto? job;

  const GenerateTodayOutcome({this.result, this.job});

  bool get isGenerating => job != null;

  factory GenerateTodayOutcome.fromData(Map<String, dynamic> data) {
    if (DailyQuestGenerationStartDto.looksLikeStart(data)) {
      return GenerateTodayOutcome(
        job: DailyQuestGenerationStartDto.fromJson(data),
      );
    }
    return GenerateTodayOutcome(
      result: AiGenerateTodayResultDto.fromJson(data),
    );
  }
}
