import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/notification_token_dto.dart';

void main() {
  group('NotificationTokenDto', () {
    test('fromJson parses correct fields', () {
      final json = {
        'id': 'token-id-123',
        'user_id': 'user-456',
        'token': 'fcm-token-abc',
        'platform': 'android',
        'device_name': 'Pixel 7',
        'is_active': true,
        'last_used_at': '2026-06-08T00:07:26Z',
      };

      final dto = NotificationTokenDto.fromJson(json);

      expect(dto.id, 'token-id-123');
      expect(dto.userId, 'user-456');
      expect(dto.token, 'fcm-token-abc');
      expect(dto.platform, 'android');
      expect(dto.deviceName, 'Pixel 7');
      expect(dto.isActive, true);
      expect(dto.lastUsedAt, isNotNull);
      expect(dto.lastUsedAt!.toIso8601String(), '2026-06-08T00:07:26.000Z');
    });

    test('fromJson handles null/missing fields gracefully', () {
      final json = <String, dynamic>{};

      final dto = NotificationTokenDto.fromJson(json);

      expect(dto.id, '');
      expect(dto.userId, '');
      expect(dto.token, '');
      expect(dto.platform, '');
      expect(dto.deviceName, isNull);
      expect(dto.isActive, true);
      expect(dto.lastUsedAt, isNull);
    });

    test('toJson generates correct map representation', () {
      final dto = NotificationTokenDto(
        id: 'id-1',
        userId: 'user-1',
        token: 'token-1',
        platform: 'ios',
        deviceName: 'iPhone 15',
        isActive: false,
        lastUsedAt: DateTime.parse('2026-06-08T00:00:00Z').toUtc(),
      );

      final json = dto.toJson();

      expect(json['id'], 'id-1');
      expect(json['user_id'], 'user-1');
      expect(json['token'], 'token-1');
      expect(json['platform'], 'ios');
      expect(json['device_name'], 'iPhone 15');
      expect(json['is_active'], false);
      expect(json['last_used_at'], '2026-06-08T00:00:00.000Z');
    });
  });
}
