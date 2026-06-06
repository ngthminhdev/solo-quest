import 'package:flutter/foundation.dart';

import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../dto/log_dto.dart';

/// Log API service
/// Handles activity log endpoints
class LogApiService {
  final ApiClient _client;

  LogApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get logs - GET /api/logs
  /// Backend may return: [...], {"items": [...]}, {"logs": [...]}, {"data": [...]}
  /// Or a wrapped pagination object: {"items": [...], "total": N, ...}
  Future<LogListDto> getLogs({
    String? type,
    String? questType,
    String? date,
    String? from,
    String? to,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, String?>{};

    if (type != null) queryParams['type'] = type;
    if (questType != null) queryParams['quest_type'] = questType;
    if (date != null) queryParams['date'] = date;
    if (from != null) queryParams['from'] = from;
    if (to != null) queryParams['to'] = to;
    if (limit != null) queryParams['limit'] = limit.toString();
    if (offset != null) queryParams['offset'] = offset.toString();

    return await _client.get(
      'logs',
      queryParams: queryParams.isNotEmpty ? queryParams : null,
      fromJson: (json) {
        debugPrint('[LOGS] Loading logs');
        debugPrint('[LOGS API] raw keys: ${json is Map ? json.keys.toList() : json.runtimeType}');

        // Try to extract as object first (wrapper pattern)
        try {
          final map = ApiResponseParser.extractObject(
            json,
            preferredKeys: ['data', 'item', 'result'],
            context: 'LogApiService.getLogs',
          );

          final dto = LogListDto.fromJson(map);
          debugPrint('[LOGS] parsed count: ${dto.logs.length}');
          return dto;
        } catch (e) {
          // If object extraction fails, try list extraction
          debugPrint('[LOGS API] Object extraction failed, trying list extraction: $e');

          final list = ApiResponseParser.extractList(
            json,
            preferredKeys: ['items', 'logs', 'data', 'results'],
            context: 'LogApiService.getLogs list fallback',
          );

          final logs = list.map((item) => LogEntryDto.fromJson(item as Map<String, dynamic>)).toList();
          debugPrint('[LOGS] parsed count: ${logs.length}');

          return LogListDto(
            logs: logs,
            total: logs.length,
            limit: limit ?? 20,
            offset: offset ?? 0,
          );
        }
      },
    );
  }
}
