import '../../network/api_client.dart';
import '../../network/api_exception.dart';
import '../../network/api_response_parser.dart';
import '../dto/quest_settings_dto.dart';

class QuestSettingsApiService {
  final ApiClient _client;

  QuestSettingsApiService({ApiClient? client})
      : _client = client ?? ApiClient();

  Future<QuestSettingsDto> getSettings() async {
    return await _client.get(
      'quest-settings',
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data', 'item', 'settings'],
          context: 'QuestSettingsApiService.getSettings',
        );
        return QuestSettingsDto.fromJson(map);
      },
    );
  }

  Future<QuestSettingsDto> updateSettings(Map<String, dynamic> body) async {
    return await _client.patch(
      'quest-settings',
      body: body,
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data', 'item', 'settings'],
          context: 'QuestSettingsApiService.updateSettings',
        );
        return QuestSettingsDto.fromJson(map);
      },
    );
  }

  Future<QuestSettingsDto> resetSettings() async {
    return await _client.post(
      'quest-settings/reset',
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data', 'item', 'settings'],
          context: 'QuestSettingsApiService.resetSettings',
        );
        return QuestSettingsDto.fromJson(map);
      },
    );
  }

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
