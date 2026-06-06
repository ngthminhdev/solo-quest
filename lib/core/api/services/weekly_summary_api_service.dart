import 'package:flutter/foundation.dart';
import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../dto/weekly_summary_dto.dart';

class WeeklySummaryApiService {
  final ApiClient _client;

  WeeklySummaryApiService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<WeeklySummaryDto> getCurrentWeekSummary() async {
    if (kDebugMode) {
      debugPrint('[WEEKLY SUMMARY API] GET /api/weekly-summary');
    }

    return await _client.get(
      'weekly-summary',
      fromJson: (json) {
        if (kDebugMode) {
          final keys = (json is Map) ? (json).keys.toList().cast<String>() : <String>[];
          debugPrint('[WEEKLY SUMMARY API] response keys: $keys');
        }
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'summary'],
          context: 'WeeklySummaryApiService.getCurrentWeekSummary',
        );
        return WeeklySummaryDto.fromJson(map);
      },
    );
  }

  Future<WeeklySummaryDto> getWeekSummary({required String weekStart}) async {
    if (kDebugMode) {
      debugPrint('[WEEKLY SUMMARY API] GET /api/weekly-summary?week_start=$weekStart');
    }

    return await _client.get(
      'weekly-summary',
      queryParams: {'week_start': weekStart},
      fromJson: (json) {
        if (kDebugMode) {
          final keys = (json is Map) ? (json).keys.toList().cast<String>() : <String>[];
          debugPrint('[WEEKLY SUMMARY API] response keys: $keys');
        }
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'summary'],
          context: 'WeeklySummaryApiService.getWeekSummary',
        );
        return WeeklySummaryDto.fromJson(map);
      },
    );
  }
}
