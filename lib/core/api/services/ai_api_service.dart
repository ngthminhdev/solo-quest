import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../../utils/app_time_formatter.dart';
import '../dto/daily_quest_generation_dto.dart';

class AiApiService {
  final ApiClient _client;

  AiApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// POST /api/quests/generate-today
  ///
  /// Triggers daily quest generation. The backend may respond:
  ///
  /// - **200** when quests already exist (force=false) or when prefer_ai=false
  ///   runs rule-based generation synchronously. The `data` carries `quests`.
  /// - **202** when prefer_ai=true and a background generation job is started.
  ///   The `data` carries `status: "generating"`, `job_id`, `estimated_seconds`.
  ///
  /// Both are success (2xx); 202 is NOT an error. Returns a
  /// [GenerateTodayOutcome] distinguishing the two cases, or `null` on a
  /// real HTTP/network failure (4xx/5xx).
  Future<GenerateTodayOutcome?> generateTodayQuests({
    bool preferAI = true,
    bool force = false,
    bool replacePendingOnly = true,
    String? date,
  }) async {
    try {
      final body = <String, dynamic>{
        'prefer_ai': preferAI,
        'force': force,
        'replace_pending_only': replacePendingOnly,
      };
      if (date != null && date.isNotEmpty) {
        body['date'] = date;
      }

      final outcome = await _client.post<GenerateTodayOutcome>(
        'quests/generate-today',
        body: body,
        fromJson: (json) {
          final data = ApiResponseParser.extractObject(
            json,
            preferredKeys: ['data', 'result'],
            context: 'AiApiService.generateTodayQuests',
          );
          return GenerateTodayOutcome.fromData(data);
        },
      );

      if (kDebugMode) {
        if (outcome.isGenerating) {
          developer.log(
            '[AI] generateTodayQuests started job: '
            'date=${outcome.job!.date}, status=${outcome.job!.status}, '
            'jobId=${outcome.job!.jobId}, eta=${outcome.job!.estimatedSeconds}s',
          );
        } else {
          final r = outcome.result!;
          developer.log(
            '[AI] generateTodayQuests success: '
            'date=${r.date}, mode=${r.mode}, inserted=${r.inserted}, '
            'count=${r.generatedCount}',
          );
        }
      }

      return outcome;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[AI] generateTodayQuests failed: $e');
      }
      return null;
    }
  }

  /// GET /api/quests/generate-today/status?date=YYYY-MM-DD
  ///
  /// Polls the status of the async generation job for [date] (defaults to
  /// today). Returns `null` on a real HTTP/network failure so callers can
  /// keep polling instead of treating a transient error as terminal.
  Future<DailyQuestGenerationStatusDto?> getTodayGenerationStatus({
    String? date,
  }) async {
    final dateStr = (date != null && date.isNotEmpty)
        ? date
        : AppTimeFormatter.todayLocalDateQuery();
    try {
      final status = await _client.get<DailyQuestGenerationStatusDto>(
        'quests/generate-today/status',
        queryParams: {'date': dateStr},
        fromJson: (json) {
          final data = ApiResponseParser.extractObject(
            json,
            preferredKeys: ['data', 'result'],
            context: 'AiApiService.getTodayGenerationStatus',
          );
          return DailyQuestGenerationStatusDto.fromJson(data);
        },
      );

      if (kDebugMode) {
        developer.log(
          '[AI] generationStatus: date=$dateStr, status=${status.status}, '
          'questCount=${status.questCount}, source=${status.source}, '
          'fallbackUsed=${status.fallbackUsed}',
        );
      }

      return status;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[AI] getTodayGenerationStatus failed: $e');
      }
      return null;
    }
  }
}
