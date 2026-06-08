import 'package:flutter/foundation.dart';
import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../dto/notification_token_dto.dart';

/// Service for calling backend notification token endpoints.
class NotificationApiService {
  final ApiClient _client;

  NotificationApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Register FCM token - POST /api/notifications/tokens
  Future<NotificationTokenDto> registerToken({
    required String token,
    required String platform,
    String? deviceName,
  }) async {
    final body = {
      'token': token,
      'platform': platform,
      if (deviceName != null) 'device_name': deviceName,
    };

    if (kDebugMode) {
      debugPrint('[NotificationApiService] Registering token: platform=$platform, deviceName=$deviceName');
    }

    return await _client.post(
      'notifications/tokens',
      body: body,
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'token'],
          context: 'NotificationApiService.registerToken',
        );
        return NotificationTokenDto.fromJson(map);
      },
    );
  }

  /// Delete notification token - DELETE /api/notifications/tokens/:id
  Future<void> deleteToken(String tokenId) async {
    if (kDebugMode) {
      debugPrint('[NotificationApiService] Deleting token: id=$tokenId');
    }
    await _client.delete('notifications/tokens/$tokenId');
  }

  /// Send a test notification - POST /api/notifications/test
  Future<void> sendTestNotification() async {
    if (kDebugMode) {
      debugPrint('[NotificationApiService] Triggering test notification');
    }
    await _client.post('notifications/test');
  }
}
