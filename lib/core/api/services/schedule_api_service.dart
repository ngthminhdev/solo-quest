import 'package:flutter/foundation.dart';

import '../../network/api_client.dart';
import '../../network/api_exception.dart';
import '../../network/api_response_parser.dart';
import '../dto/schedule_block_dto.dart';

/// Schedule Block API service
/// Handles CRUD for /api/schedule-blocks endpoints
class ScheduleApiService {
  final ApiClient _client;

  ScheduleApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// GET /api/schedule-blocks
  /// Returns all enabled schedule blocks for the current user
  Future<List<ScheduleBlockDto>> getScheduleBlocks() async {
    return await _client.get(
      'schedule-blocks',
      fromJson: (json) {
        debugPrint('[SCHEDULE API] Loading schedule blocks');

        final list = ApiResponseParser.extractList(
          json,
          preferredKeys: ['data', 'items', 'results'],
          context: 'ScheduleApiService.getScheduleBlocks',
        );

        final blocks = list
            .map((item) =>
                ScheduleBlockDto.fromJson(item as Map<String, dynamic>))
            .toList();

        debugPrint('[SCHEDULE API] parsed block count: ${blocks.length}');
        return blocks;
      },
    );
  }

  /// POST /api/schedule-blocks
  /// Create a new schedule block
  Future<ScheduleBlockDto> createScheduleBlock(ScheduleBlockDto dto) async {
    return await _client.post(
      'schedule-blocks',
      body: dto.toCreateJson(),
      fromJson: (json) {
        debugPrint('[SCHEDULE API] Creating schedule block');

        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data', 'item', 'result'],
          context: 'ScheduleApiService.createScheduleBlock',
        );

        return ScheduleBlockDto.fromJson(map);
      },
    );
  }

  /// PUT /api/schedule-blocks/:id
  /// Full replacement update
  Future<ScheduleBlockDto> updateScheduleBlock(
      String id, ScheduleBlockDto dto) async {
    return await _client.put(
      'schedule-blocks/$id',
      body: dto.toUpdateJson(),
      fromJson: (json) {
        debugPrint('[SCHEDULE API] Updating schedule block: $id');

        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data', 'item', 'result'],
          context: 'ScheduleApiService.updateScheduleBlock',
        );

        return ScheduleBlockDto.fromJson(map);
      },
    );
  }

  /// PATCH /api/schedule-blocks/:id
  /// Partial update — only fields present in [partial] are changed
  Future<ScheduleBlockDto> patchScheduleBlock(
      String id, Map<String, dynamic> partial) async {
    return await _client.patch(
      'schedule-blocks/$id',
      body: partial,
      fromJson: (json) {
        debugPrint('[SCHEDULE API] Patching schedule block: $id');

        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data', 'item', 'result'],
          context: 'ScheduleApiService.patchScheduleBlock',
        );

        return ScheduleBlockDto.fromJson(map);
      },
    );
  }

  /// DELETE /api/schedule-blocks/:id
  /// Soft delete (sets enabled=false)
  Future<void> deleteScheduleBlock(String id) async {
    await _client.delete(
      'schedule-blocks/$id',
      fromJson: (json) {
        debugPrint('[SCHEDULE API] Deleted schedule block: $id');
        return null;
      },
    );
  }

  /// Check if an error indicates the endpoint is not yet available
  static bool isEndpointUnavailable(Object error) {
    if (error is ApiException) {
      if (error.statusCode == 404 || error.statusCode == 405) return true;
      if (error.error == 'network_error') return true;
    }
    final msg = error.toString().toLowerCase();
    if (msg.contains('connection refused') ||
        msg.contains('connection timed out') ||
        msg.contains('network is unreachable') ||
        msg.contains('errno = 7') ||
        msg.contains('errno = 61') ||
        msg.contains('errno = 111')) {
      return true;
    }
    if (error is FormatException) return true;
    return false;
  }
}
