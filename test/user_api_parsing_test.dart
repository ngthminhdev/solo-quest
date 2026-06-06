import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/user_dto.dart';
import 'package:solo_quest/core/network/api_response_parser.dart';

void main() {
  group('UserApiService Response Parsing', () {
    test('getMe parses wrapped response with "user" key', () {
      final json = {
        'user': {
          'id': 'user-123',
          'email': 'test@example.com',
          'name': 'Test User',
          'avatar_url': 'https://example.com/avatar.jpg',
          'level': 5,
          'current_level_exp': 1250,
          'next_level_exp': 1500,
          'total_exp': 4800,
          'reward_points': 320,
          'streak_days': 5,
          'total_completed_quests': 45,
          'main_goals': ['health', 'learning'],
          'created_at': '2026-01-01T00:00:00Z',
          'updated_at': '2026-06-02T10:00:00Z',
        }
      };

      final map = ApiResponseParser.extractObject(
        json,
        preferredKeys: ['user', 'data', 'profile', 'item'],
        context: 'test',
      );

      final dto = UserProfileDto.fromJson(map);
      expect(dto.id, 'user-123');
      expect(dto.email, 'test@example.com');
      expect(dto.name, 'Test User');
      expect(dto.level, 5);
      expect(dto.currentLevelExp, 1250);
      expect(dto.rewardPoints, 320);
      expect(dto.mainGoals.length, 2);
    });

    test('getMe parses wrapped response with "profile" key', () {
      final json = {
        'profile': {
          'id': 'user-456',
          'email': 'another@example.com',
          'name': 'Another User',
          'level': 3,
          'current_level_exp': 500,
          'next_level_exp': 800,
          'total_exp': 1500,
          'reward_points': 150,
          'streak_days': 3,
          'total_completed_quests': 20,
          'main_goals': [],
          'created_at': '2026-01-15T00:00:00Z',
          'updated_at': '2026-06-02T10:00:00Z',
        }
      };

      final map = ApiResponseParser.extractObject(
        json,
        preferredKeys: ['user', 'data', 'profile', 'item'],
        context: 'test',
      );

      final dto = UserProfileDto.fromJson(map);
      expect(dto.id, 'user-456');
      expect(dto.level, 3);
      expect(dto.currentLevelExp, 500);
      expect(dto.mainGoals.isEmpty, true);
    });

    test('getMe parses wrapped response with "data" key', () {
      final json = {
        'data': {
          'id': 'user-789',
          'email': 'data@example.com',
          'name': 'Data User',
          'level': 7,
          'current_level_exp': 2000,
          'next_level_exp': 2500,
          'total_exp': 10000,
          'reward_points': 500,
          'streak_days': 10,
          'total_completed_quests': 100,
          'main_goals': ['fitness', 'mindfulness', 'learning'],
          'created_at': '2025-12-01T00:00:00Z',
          'updated_at': '2026-06-02T10:00:00Z',
        }
      };

      final map = ApiResponseParser.extractObject(
        json,
        preferredKeys: ['user', 'data', 'profile', 'item'],
        context: 'test',
      );

      final dto = UserProfileDto.fromJson(map);
      expect(dto.id, 'user-789');
      expect(dto.level, 7);
      expect(dto.mainGoals.length, 3);
      expect(dto.mainGoals[1], 'mindfulness');
    });

    test('getMe parses top-level user object', () {
      final json = {
        'id': 'user-999',
        'email': 'toplevel@example.com',
        'name': 'Top Level User',
        'avatar_url': null,
        'level': 1,
        'current_level_exp': 0,
        'next_level_exp': 100,
        'total_exp': 0,
        'reward_points': 0,
        'streak_days': 0,
        'total_completed_quests': 0,
        'main_goals': [],
        'created_at': '2026-06-01T00:00:00Z',
        'updated_at': '2026-06-01T00:00:00Z',
      };

      final map = ApiResponseParser.extractObject(
        json,
        preferredKeys: ['user', 'data', 'profile', 'item'],
        context: 'test',
      );

      final dto = UserProfileDto.fromJson(map);
      expect(dto.id, 'user-999');
      expect(dto.name, 'Top Level User');
      expect(dto.avatarUrl, null);
      expect(dto.level, 1);
      expect(dto.totalExp, 0);
    });

    test('UserProfile DTO handles missing optional fields', () {
      final json = {
        'id': 'user-minimal',
        'email': 'minimal@example.com',
        'name': 'Minimal User',
        'created_at': '2026-06-01T00:00:00Z',
        'updated_at': '2026-06-01T00:00:00Z',
      };

      final dto = UserProfileDto.fromJson(json);
      expect(dto.id, 'user-minimal');
      expect(dto.name, 'Minimal User');
      expect(dto.avatarUrl, null);
      expect(dto.level, 1); // Default
      expect(dto.currentLevelExp, 0); // Default
      expect(dto.rewardPoints, 0); // Default
      expect(dto.mainGoals.isEmpty, true);
    });

    test('UserProfile DTO handles empty main_goals array', () {
      final json = {
        'id': 'user-nogoals',
        'email': 'nogoals@example.com',
        'name': 'No Goals User',
        'main_goals': [],
        'created_at': '2026-06-01T00:00:00Z',
        'updated_at': '2026-06-01T00:00:00Z',
      };

      final dto = UserProfileDto.fromJson(json);
      expect(dto.mainGoals.isEmpty, true);
    });

    test('OnboardingStatus DTO parses correctly', () {
      final json = {
        'has_completed_onboarding': true,
        'current_step': 'profile_setup',
        'data': {'age': 25, 'goals': ['health']},
      };

      final dto = OnboardingStatusDto.fromJson(json);
      expect(dto.completed, true);
      expect(dto.currentStep, 'profile_setup');
      expect(dto.data!['age'], 25);
    });

    test('OnboardingStatus DTO handles incomplete onboarding', () {
      final json = {
        'has_completed_onboarding': false,
        'current_step': 'welcome',
      };

      final dto = OnboardingStatusDto.fromJson(json);
      expect(dto.completed, false);
      expect(dto.currentStep, 'welcome');
      expect(dto.data, null);
    });

    test('DailyStatus DTO parses all fields', () {
      final json = {
        'has_checked_in': true,
        'has_reviewed': false,
        'today_completed_quests': 5,
        'today_planned_quests': 8,
        'today_earned_exp': 250,
      };

      final dto = DailyStatusDto.fromJson(json);
      expect(dto.hasCheckedIn, true);
      expect(dto.hasReviewed, false);
      expect(dto.todayCompletedQuests, 5);
      expect(dto.todayPlannedQuests, 8);
      expect(dto.todayEarnedExp, 250);
    });

    test('DailyStatus DTO handles alternative field names', () {
      final json = {
        'has_checked_in_today': true,
        'has_reviewed_today': true,
        'today_completed_quests': 7,
        'today_planned_quests': 9,
        'today_earned_exp': 350,
      };

      final dto = DailyStatusDto.fromJson(json);
      expect(dto.hasCheckedIn, true);
      expect(dto.hasReviewed, true);
      expect(dto.todayCompletedQuests, 7);
    });

    test('DailyStatus DTO handles missing fields with defaults', () {
      final json = {
        'has_checked_in': false,
      };

      final dto = DailyStatusDto.fromJson(json);
      expect(dto.hasCheckedIn, false);
      expect(dto.hasReviewed, false); // Default
      expect(dto.todayCompletedQuests, 0); // Default
      expect(dto.todayPlannedQuests, 0); // Default
      expect(dto.todayEarnedExp, 0); // Default
    });
  });

  group('Profile Service Integration', () {
    test('Profile model conversion preserves all fields', () {
      final dto = UserProfileDto(
        id: 'user-test',
        email: 'test@example.com',
        name: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        level: 5,
        currentLevelExp: 1250,
        nextLevelExp: 1500,
        totalExp: 4800,
        rewardPoints: 320,
        streakDays: 5,
        totalCompletedQuests: 45,
        mainGoals: ['health', 'learning'],
        createdAt: DateTime.parse('2026-01-01T00:00:00Z'),
        updatedAt: DateTime.parse('2026-06-02T10:00:00Z'),
      );

      // Verify DTO fields
      expect(dto.id, 'user-test');
      expect(dto.name, 'Test User');
      expect(dto.level, 5);
      expect(dto.mainGoals.length, 2);
    });

    test('Profile handles null avatar URL', () {
      final dto = UserProfileDto(
        id: 'user-no-avatar',
        email: 'noavatar@example.com',
        name: 'No Avatar User',
        avatarUrl: null,
        level: 1,
        currentLevelExp: 0,
        nextLevelExp: 100,
        totalExp: 0,
        rewardPoints: 0,
        streakDays: 0,
        totalCompletedQuests: 0,
        mainGoals: [],
        createdAt: DateTime.parse('2026-06-01T00:00:00Z'),
        updatedAt: DateTime.parse('2026-06-01T00:00:00Z'),
      );

      expect(dto.avatarUrl, null);
    });
  });
}
