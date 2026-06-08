import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../dto/ai_generate_today_dto.dart';

class AiApiService {
  final ApiClient _client;

  AiApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// POST /api/quests/generate-today
  ///
  /// Triggers AI quest generation for today's date using the user's
  /// current preferences, schedule, and quest rules.
  ///
  /// Backend response envelope:
  /// {
  ///   "code": 200,
  ///   "data": {
  ///     "date": "yyyy-MM-dd",
  ///     "mode": "ai",
  ///     "inserted": true/false,
  ///     "generated_count": 8,
  ///     "quests": [...]
  ///   }
  /// }
  ///
  /// Returns null on HTTP-level failure (4xx/5xx/network error).
  /// Returns the result on success, even if [inserted] is false
  /// (quests already existed — not an error).
  Future<AiGenerateTodayResultDto?> generateTodayQuests() async {
    try {
      final result = await _client.post(
        'quests/generate-today',
        fromJson: (json) {
          final data = ApiResponseParser.extractObject(
            json,
            preferredKeys: ['data', 'result'],
            context: 'AiApiService.generateTodayQuests',
          );
          return AiGenerateTodayResultDto.fromJson(data);
        },
      );

      if (kDebugMode) {
        developer.log(
          '[AI] generateTodayQuests success: '
          'date=${result.date}, mode=${result.mode}, '
          'inserted=${result.inserted}, count=${result.generatedCount}',
        );
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[AI] generateTodayQuests failed: $e');
      }
      return null;
    }
  }
}
