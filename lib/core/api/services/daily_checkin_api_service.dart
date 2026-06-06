import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../dto/daily_checkin_dto.dart';
import '../requests/api_requests.dart';

/// Daily check-in API service
/// Handles morning check-in endpoints
class DailyCheckinApiService {
  final ApiClient _client;

  DailyCheckinApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get today's check-in status - GET /api/checkins/today
  /// Backend may return new envelope: {"code": 200, "message": "OK", "data": {"has_checked_in": true, "item": {...}, "date": "..."}}
  /// Or old unwrapped: {"has_checked_in": true, "item": {...}, "date": "..."}
  /// ApiClient unwraps the standard envelope, so this method receives the payload inside "data".
  /// ApiResponseParser extracts {"data": ...} wrapper if present for extra safety.
  Future<DailyCheckinStatusDto> getToday() async {
    return await _client.get(
      'checkins/today',
      fromJson: (json) {
        // Use 'data' as preferredKey only — DO NOT include 'item' because
        // extracting 'item' would lose the outer has_checked_in and date fields.
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data'],
          context: 'DailyCheckinApiService.getToday',
        );

        if (kDebugMode) {
          developer.log('[CHECKIN API] GET /api/checkins/today response keys: ${map.keys.toList()}');
        }
        return DailyCheckinStatusDto.fromJson(map);
      },
    );
  }

  /// Get check-in by date - GET /api/checkins/{date}
  /// Same response shape as getToday.
  Future<DailyCheckinStatusDto> getByDate(String date) async {
    return await _client.get(
      'checkins/$date',
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data'],
          context: 'DailyCheckinApiService.getByDate',
        );
        return DailyCheckinStatusDto.fromJson(map);
      },
    );
  }

  /// Save daily check-in - POST /api/checkins
  Future<DailyCheckinDto> save(SaveDailyCheckinRequest request) async {
    final body = request.toJson();
    if (kDebugMode) {
      developer.log('[CHECKIN API] POST /api/checkins body: $body');
    }

    return await _client.post(
      'checkins',
      body: body,
      fromJson: (json) {
        if (kDebugMode) {
          developer.log('[CHECKIN API] POST /api/checkins response: $json');
        }
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'checkin'],
          context: 'DailyCheckinApiService.save',
        );
        return DailyCheckinDto.fromJson(map);
      },
    );
  }
}
