import '../../utils/date_time_parser.dart';

/// DTO for FCM token registration responses from POST /api/notifications/tokens
class NotificationTokenDto {
  final String id;
  final String userId;
  final String token;
  final String platform;
  final String? deviceName;
  final bool isActive;
  final DateTime? lastUsedAt;

  NotificationTokenDto({
    required this.id,
    required this.userId,
    required this.token,
    required this.platform,
    this.deviceName,
    required this.isActive,
    this.lastUsedAt,
  });

  factory NotificationTokenDto.fromJson(Map<String, dynamic> json) {
    return NotificationTokenDto(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      token: json['token'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      deviceName: json['device_name'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      lastUsedAt: parseUtcDateTime(json['last_used_at'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'token': token,
      'platform': platform,
      'device_name': deviceName,
      'is_active': isActive,
      'last_used_at': formatUtcDateTime(lastUsedAt),
    };
  }
}
