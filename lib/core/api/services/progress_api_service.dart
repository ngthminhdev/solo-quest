import 'package:flutter/foundation.dart';

import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../dto/progress_dto.dart';

/// Progress API service
/// Handles progress, stats, and XP history endpoints
class ProgressApiService {
  final ApiClient _client;

  ProgressApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get progress - GET /api/progress
  /// Backend may return: {"item": {...}}, {"data": {...}}, {"progress": {...}}, top-level object
  Future<ProgressDto> getProgress() async {
    return await _client.get(
      'progress',
      fromJson: (json) {
        debugPrint('[PROGRESS] Loading progress summary');
        debugPrint('[PROGRESS API] raw keys: ${json is Map ? json.keys.toList() : json.runtimeType}');

        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'progress', 'result'],
          context: 'ProgressApiService.getProgress',
        );

        final dto = ProgressDto.fromJson(map);
        debugPrint('[PROGRESS] parsed: level=${dto.level}, exp=${dto.currentLevelExp}/${dto.nextLevelExp}, points=${dto.rewardPoints}');
        return dto;
      },
    );
  }

  /// Get weekly chart - GET /api/progress/weekly-chart
  /// Backend may return: {"items": [...]}, {"data": {...}}, {"chart": {...}}, {"days": [...]}
  Future<WeeklyChartDto> getWeeklyChart() async {
    return await _client.get(
      'progress/weekly-chart',
      fromJson: (json) {
        debugPrint('[PROGRESS] Loading weekly chart');
        debugPrint('[PROGRESS API] weekly chart raw keys: ${json is Map ? json.keys.toList() : json.runtimeType}');

        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'chart', 'weekly', 'weekly_chart'],
          context: 'ProgressApiService.getWeeklyChart',
        );

        final dto = WeeklyChartDto.fromJson(map);
        debugPrint('[PROGRESS] weekly chart days: ${dto.days.length}');
        return dto;
      },
    );
  }

  /// Get XP history - GET /api/progress/xp-history
  /// Backend may return: {"items": [...]}, {"history": [...]}, {"transactions": [...]}, {"data": {...}}
  Future<XPHistoryDto> getXPHistory({
    String? currency,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, String?>{};

    if (currency != null) queryParams['currency'] = currency;
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();

    return await _client.get(
      'progress/xp-history',
      queryParams: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (json) {
        debugPrint('[PROGRESS] Loading XP history');
        debugPrint('[PROGRESS API] XP history raw keys: ${json is Map ? json.keys.toList() : json.runtimeType}');

        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'history', 'xp_history', 'transactions'],
          context: 'ProgressApiService.getXPHistory',
        );

        final dto = XPHistoryDto.fromJson(map);
        debugPrint('[PROGRESS] XP history count: ${dto.transactions.length}');
        return dto;
      },
    );
  }
}
