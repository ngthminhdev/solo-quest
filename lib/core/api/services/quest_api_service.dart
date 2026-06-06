import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../dto/quest_dto.dart';
import '../requests/api_requests.dart';

/// Quest API service
/// Handles quest CRUD and action endpoints
class QuestApiService {
  final ApiClient _client;

  QuestApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get quests - GET /api/quests
  /// Backend may return: [...], {"items": [...]}, {"quests": [...]}, {"data": [...]}
  Future<List<QuestDto>> getQuests({String? date}) async {
    final queryParams = date != null ? {'date': date} : null;

    return await _client.get(
      'quests',
      queryParams: queryParams,
      fromJson: (json) {
        final list = ApiResponseParser.extractList(
          json,
          preferredKeys: ['items', 'quests', 'data', 'results'],
          context: 'QuestApiService.getQuests',
        );
        return list
            .map((item) => QuestDto.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }

  /// Extract the quest map from an action response (start, skip, snooze).
  /// The action response may contain:
  ///   {"item": {"id": "...", "title": "...", ...}}
  ///   {"data": {"id": "...", "title": "...", ...}}
  ///   {"quest": {"id": "...", "title": "...", ...}}
  ///   {"result": {"id": "...", "title": "...", ...}}
  ///   {"id": "...", "title": "...", ...} (direct)
  Map<String, dynamic> _extractQuestMap(dynamic json, String context) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
        '[$context] Expected Map for quest action response, got ${json.runtimeType}',
      );
    }

    if (kDebugMode) {
      developer.log('[QUEST API] $context raw keys: ${json.keys.toList()}');
    }

    for (final key in ['item', 'data', 'quest', 'result']) {
      if (json.containsKey(key) && json[key] is Map<String, dynamic>) {
        final nested = json[key] as Map<String, dynamic>;
        if (nested.containsKey('id') && nested.containsKey('title')) {
          if (kDebugMode) {
            developer.log('[QUEST API] $context extracted via "$key": $nested');
          }
          return nested;
        }
      }
    }

    // Direct quest object
    if (json.containsKey('id') && json.containsKey('title')) {
      if (kDebugMode) {
        developer.log('[QUEST API] $context direct object: $json');
      }
      return json;
    }

    throw FormatException(
      '[$context] Could not extract quest from response. '
      'Available keys: ${json.keys.toList()}',
    );
  }

  /// Extract the complete quest result map.
  /// Response shape:
  ///   {"item": {"quest": {...}, "exp_earned": 10, "leveled_up": false, ...}}
  ///   {"data": {"quest": {...}, "exp_earned": 10, ...}}
  ///   {"result": {"quest": {...}, "exp_earned": 10, ...}}
  ///   {"quest": {...}, "exp_earned": 10, ...} (direct)
  Map<String, dynamic> _extractCompleteMap(dynamic json, String context) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
        '[$context] Expected Map for complete response, got ${json.runtimeType}',
      );
    }

    if (kDebugMode) {
      developer.log('[QUEST API] $context raw keys: ${json.keys.toList()}');
    }

    for (final key in ['item', 'data', 'result']) {
      if (json.containsKey(key) && json[key] is Map<String, dynamic>) {
        final nested = json[key] as Map<String, dynamic>;
        if (nested.containsKey('quest')) {
          if (kDebugMode) {
            developer.log('[QUEST API] $context extracted via "$key": $nested');
          }
          return nested;
        }
      }
    }

    // Direct response with quest field
    if (json.containsKey('quest')) {
      if (kDebugMode) {
        developer.log('[QUEST API] $context direct response: $json');
      }
      return json;
    }

    throw FormatException(
      '[$context] Could not extract complete result from response. '
      'Available keys: ${json.keys.toList()}',
    );
  }

  /// Start quest - POST /api/quests/{id}/start
  Future<QuestDto> startQuest(String id) async {
    return await _client.post(
      'quests/$id/start',
      fromJson: (json) {
        final map = _extractQuestMap(json, 'QuestApiService.startQuest');
        return QuestDto.fromJson(map);
      },
    );
  }

  /// Complete quest - POST /api/quests/{id}/complete
  Future<CompleteQuestResultDto> completeQuest(String id, {String? note}) async {
    final request = CompleteQuestRequest(note: note);

    return await _client.post(
      'quests/$id/complete',
      body: request.toJson(),
      fromJson: (json) {
        final map = _extractCompleteMap(json, 'QuestApiService.completeQuest');
        return CompleteQuestResultDto.fromJson(map);
      },
    );
  }

  /// Skip quest - POST /api/quests/{id}/skip
  Future<QuestDto> skipQuest(String id, {String? reason}) async {
    final request = SkipQuestRequest(reason: reason);

    return await _client.post(
      'quests/$id/skip',
      body: request.toJson(),
      fromJson: (json) {
        final map = _extractQuestMap(json, 'QuestApiService.skipQuest');
        return QuestDto.fromJson(map);
      },
    );
  }

  /// Snooze quest - POST /api/quests/{id}/snooze
  Future<QuestDto> snoozeQuest(String id, {required int minutes}) async {
    final request = SnoozeQuestRequest(minutes: minutes);

    return await _client.post(
      'quests/$id/snooze',
      body: request.toJson(),
      fromJson: (json) {
        final map = _extractQuestMap(json, 'QuestApiService.snoozeQuest');
        return QuestDto.fromJson(map);
      },
    );
  }
}
