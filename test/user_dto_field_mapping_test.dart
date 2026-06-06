import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/user_dto.dart';

void main() {
  group('UserProfileDto', () {
    test('parses user with name field', () {
      final json = {
        'id': 'test-id',
        'email': 'test@example.com',
        'name': 'Test User',
        'level': 5,
        'current_level_exp': 150,
        'next_level_exp': 500,
        'total_exp': 1250,
        'reward_points': 300,
        'streak_days': 7,
        'total_completed_quests': 42,
        'main_goals': ['learning', 'health'],
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-15T12:30:00Z',
      };

      final dto = UserProfileDto.fromJson(json);

      expect(dto.id, 'test-id');
      expect(dto.email, 'test@example.com');
      expect(dto.name, 'Test User');
      expect(dto.level, 5);
      expect(dto.currentLevelExp, 150);
      expect(dto.nextLevelExp, 500);
      expect(dto.totalExp, 1250);
      expect(dto.rewardPoints, 300);
      expect(dto.streakDays, 7);
      expect(dto.totalCompletedQuests, 42);
      expect(dto.mainGoals, ['learning', 'health']);
    });

    test('parses user with display_name field (backend format)', () {
      final json = {
        'id': 'user-001',
        'display_name': 'Minh Thanh',
        'level': 1,
        'current_level_exp': 40,
        'next_level_exp': 100,
        'total_exp': 40,
        'reward_points': 140,
        'streak_days': 0,
        'total_completed_quests': 5,
        'main_goals': [],
        'created_at': '2024-06-01T00:00:00Z',
        'updated_at': '2024-06-02T08:00:00Z',
      };

      final dto = UserProfileDto.fromJson(json);

      expect(dto.id, 'user-001');
      expect(dto.name, 'Minh Thanh');
      expect(dto.email, ''); // Optional field defaults to empty
      expect(dto.level, 1);
    });

    test('supports missing email field for dev accounts', () {
      final json = {
        'id': '00000000-0000-0000-0000-000000000001',
        'display_name': 'Dev User',
        // No email field
        'level': 1,
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      };

      expect(() => UserProfileDto.fromJson(json), returnsNormally);

      final dto = UserProfileDto.fromJson(json);
      expect(dto.email, '');
      expect(dto.name, 'Dev User');
    });

    test('prefers name over display_name when both exist', () {
      final json = {
        'id': 'test-id',
        'name': 'Official Name',
        'display_name': 'Display Name',
        'email': 'test@example.com',
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      };

      final dto = UserProfileDto.fromJson(json);
      expect(dto.name, 'Official Name');
    });

    test('uses display_name when name is null', () {
      final json = {
        'id': 'test-id',
        'name': null,
        'display_name': 'Display Name',
        'email': 'test@example.com',
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      };

      final dto = UserProfileDto.fromJson(json);
      expect(dto.name, 'Display Name');
    });

    test('defaults to empty string when both name fields missing', () {
      final json = {
        'id': 'test-id',
        'email': 'test@example.com',
        // No name or display_name
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      };

      final dto = UserProfileDto.fromJson(json);
      expect(dto.name, '');
    });

    test('applies default values for optional numeric fields', () {
      final json = {
        'id': 'test-id',
        'name': 'Test',
        'email': 'test@example.com',
        // All numeric fields missing
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      };

      final dto = UserProfileDto.fromJson(json);
      expect(dto.level, 1);
      expect(dto.currentLevelExp, 0);
      expect(dto.nextLevelExp, 100);
      expect(dto.totalExp, 0);
      expect(dto.rewardPoints, 0);
      expect(dto.streakDays, 0);
      expect(dto.totalCompletedQuests, 0);
      expect(dto.mainGoals, isEmpty);
    });

    test('toJson produces correct output', () {
      final dto = UserProfileDto(
        id: 'test-id',
        email: 'test@example.com',
        name: 'Test User',
        avatarUrl: 'https://example.com/avatar.png',
        level: 5,
        currentLevelExp: 150,
        nextLevelExp: 500,
        totalExp: 1250,
        rewardPoints: 300,
        streakDays: 7,
        totalCompletedQuests: 42,
        mainGoals: ['learning', 'health'],
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2024-01-15T12:30:00Z'),
      );

      final json = dto.toJson();

      expect(json['id'], 'test-id');
      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
      expect(json['avatar_url'], 'https://example.com/avatar.png');
      expect(json['level'], 5);
      expect(json['current_level_exp'], 150);
      expect(json['next_level_exp'], 500);
      expect(json['total_exp'], 1250);
      expect(json['reward_points'], 300);
      expect(json['streak_days'], 7);
      expect(json['total_completed_quests'], 42);
      expect(json['main_goals'], ['learning', 'health']);
      expect(json.containsKey('created_at'), isTrue);
      expect(json.containsKey('updated_at'), isTrue);
    });
  });

  group('DailyStatusDto', () {
    test('parses has_checked_in field', () {
      final json = {
        'has_checked_in': true,
        'has_reviewed': false,
        'today_completed_quests': 3,
        'today_planned_quests': 5,
        'today_earned_exp': 75,
      };

      final dto = DailyStatusDto.fromJson(json);

      expect(dto.hasCheckedIn, true);
      expect(dto.hasReviewed, false);
      expect(dto.todayCompletedQuests, 3);
      expect(dto.todayPlannedQuests, 5);
      expect(dto.todayEarnedExp, 75);
    });

    test('parses has_checked_in_today field (alternative naming)', () {
      final json = {
        'has_checked_in_today': true,
        'has_reviewed_today': true,
        'today_completed_quests': 5,
        'today_planned_quests': 5,
        'today_earned_exp': 120,
      };

      final dto = DailyStatusDto.fromJson(json);

      expect(dto.hasCheckedIn, true);
      expect(dto.hasReviewed, true);
    });

    test('prefers has_checked_in over has_checked_in_today', () {
      final json = {
        'has_checked_in': true,
        'has_checked_in_today': false, // Should be ignored
        'has_reviewed': false,
      };

      final dto = DailyStatusDto.fromJson(json);

      expect(dto.hasCheckedIn, true);
    });

    test('defaults to false when check-in fields missing', () {
      final json = <String, dynamic>{
        // No check-in or review fields
        'today_completed_quests': 0,
      };

      final dto = DailyStatusDto.fromJson(json);

      expect(dto.hasCheckedIn, false);
      expect(dto.hasReviewed, false);
      expect(dto.todayCompletedQuests, 0);
      expect(dto.todayPlannedQuests, 0);
      expect(dto.todayEarnedExp, 0);
    });
  });
}
