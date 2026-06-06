import '../../../models/enums/reminder_enums.dart';
import '../../network/api_client.dart';
import '../../network/api_exception.dart';
import '../../network/api_response_parser.dart';
import '../dto/reminder_setting_dto.dart';

/// Reminder Settings API service.
///
/// Handles per-type reminder preference endpoints:
/// - GET /api/settings/reminders
/// - PATCH /api/settings/reminders/{type}
/// - PATCH /api/settings/reminders/{type}/toggle
class ReminderSettingsApiService {
  final ApiClient _client;

  ReminderSettingsApiService({ApiClient? client})
      : _client = client ?? ApiClient();

  /// GET /api/settings/reminders
  Future<List<ReminderSettingDto>> getReminderSettings() async {
    return await _client.get(
      'settings/reminders',
      fromJson: (json) {
        final list = ApiResponseParser.extractList(
          json,
          preferredKeys: ['data', 'items', 'reminders'],
          context: 'ReminderSettingsApiService.getReminderSettings',
        );
        return list
            .map((e) => ReminderSettingDto.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  /// PATCH /api/settings/reminders/{type}
  ///
  /// [type] is the backend api value (e.g. "break_time", "daily_review").
  Future<ReminderSettingDto> updateReminderSetting({
    required ReminderType type,
    required Map<String, dynamic> request,
  }) async {
    final path = 'settings/reminders/${type.toApiValue()}';
    return await _client.patch(
      path,
      body: request,
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data', 'item', 'setting'],
          context: 'ReminderSettingsApiService.updateReminderSetting',
        );
        return ReminderSettingDto.fromJson(map);
      },
    );
  }

  /// PATCH /api/settings/reminders/{type}/toggle
  Future<ReminderSettingDto> toggleReminder({
    required ReminderType type,
    required ReminderStatus status,
  }) async {
    final path = 'settings/reminders/${type.toApiValue()}/toggle';
    return await _client.patch(
      path,
      body: {'status': status.toApiValue()},
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data', 'item', 'setting'],
          context: 'ReminderSettingsApiService.toggleReminder',
        );
        return ReminderSettingDto.fromJson(map);
      },
    );
  }

  /// Check if an error indicates the endpoint is not yet available.
  ///
  /// During development the backend may not have the reminder settings
  /// endpoints implemented yet. In that case we fall back to local data
  /// instead of showing an error to the user.
  static bool isEndpointUnavailable(Object error) {
    if (error is ApiException) {
      // 404 Not Found or 405 Method Not Allowed
      if (error.statusCode == 404 || error.statusCode == 405) return true;
      // Network-level failures (connection refused, DNS, etc.)
      if (error.error == 'network_error') return true;
    }
    // SocketException / connection refused wrapped by ApiClient
    final msg = error.toString().toLowerCase();
    if (msg.contains('connection refused') ||
        msg.contains('connection timed out') ||
        msg.contains('network is unreachable') ||
        msg.contains('errno = 7') ||
        msg.contains('errno = 61') ||
        msg.contains('errno = 111')) {
      return true;
    }
    // FormatException from response parser when endpoint returns unexpected shape
    // (e.g. HTML error page from proxy)
    if (error is FormatException) return true;
    return false;
  }
}
