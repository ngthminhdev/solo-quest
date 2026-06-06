import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../dto/settings_dto.dart';

/// Settings API service
/// Handles app settings endpoints
class SettingsApiService {
  final ApiClient _client;

  SettingsApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get app settings - GET /api/settings
  Future<AppSettingsDto> getSettings() async {
    return await _client.get(
      'settings',
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'settings'],
          context: 'SettingsApiService.getSettings',
        );
        return AppSettingsDto.fromJson(map);
      },
    );
  }

  /// Update app settings - POST /api/settings
  Future<AppSettingsDto> updateSettings(Map<String, dynamic> settings) async {
    return await _client.post(
      'settings',
      body: settings,
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'settings'],
          context: 'SettingsApiService.updateSettings',
        );
        return AppSettingsDto.fromJson(map);
      },
    );
  }
}

/// Health check API service
/// Handles health check endpoints
class HealthApiService {
  final ApiClient _client;

  HealthApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Check API health - GET /api/health
  /// Returns true if API is healthy
  Future<bool> checkHealth() async {
    try {
      await _client.get('health', fromJson: (json) => json);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check database health - GET /api/health/db
  /// Returns true if database is healthy
  Future<bool> checkDbHealth() async {
    try {
      await _client.get('health/db', fromJson: (json) => json);
      return true;
    } catch (e) {
      return false;
    }
  }
}
