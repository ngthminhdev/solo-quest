import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/auth_dto.dart';
import 'package:solo_quest/core/api/dto/quest_dto.dart';
import 'package:solo_quest/core/api/dto/user_dto.dart';
import 'package:solo_quest/models/enums/quest_enums.dart';

void main() {
  group('AuthSessionDto', () {
    test('parses backend snake_case response correctly', () {
      // This matches the actual backend response from POST /api/auth/dev-login
      final json = {
        'access_token': 'dev-token',
        'refresh_token': 'dev-refresh-token',
        'token_type': 'Bearer',
        'user': {
          'id': '00000000-0000-0000-0000-000000000001',
          'display_name': 'Minh Thanh',
          'avatar_url': null,
          'age': null,
          'gender': null,
          'height_cm': null,
          'weight_kg': null,
          'main_activity': null,
          'level': 1,
          'current_level_exp': 0,
          'next_level_exp': 100,
          'total_exp': 0,
          'reward_points': 100,
          'streak_days': 0,
          'best_streak': 0,
          'streak_shields': 2,
          'total_completed_quests': 0,
          'total_skipped_quests': 0,
          'has_completed_onboarding': false,
        },
      };

      final dto = AuthSessionDto.fromJson(json);

      expect(dto.accessToken, 'dev-token');
      expect(dto.refreshToken, 'dev-refresh-token');
      expect(dto.tokenType, 'Bearer');
      expect(dto.user.id, '00000000-0000-0000-0000-000000000001');
      expect(dto.user.displayName, 'Minh Thanh');
      expect(dto.user.avatarUrl, isNull);
      expect(dto.user.level, 1);
      expect(dto.user.rewardPoints, 100);
      expect(dto.user.streakShields, 2);
      expect(dto.user.hasCompletedOnboarding, isFalse);
    });

    test('parses camelCase response correctly', () {
      final json = {
        'accessToken': 'test_access_token',
        'refreshToken': 'test_refresh_token',
        'tokenType': 'Bearer',
        'user': {
          'id': 'user123',
          'displayName': 'Test User',
          'email': 'test@example.com',
          'avatarUrl': 'https://example.com/avatar.jpg',
        },
      };

      final dto = AuthSessionDto.fromJson(json);

      expect(dto.accessToken, 'test_access_token');
      expect(dto.refreshToken, 'test_refresh_token');
      expect(dto.user.displayName, 'Test User');
      expect(dto.user.email, 'test@example.com');
    });

    test('parses Google auth response with has_completed_onboarding', () {
      final json = {
        'access_token': 'google_access_token',
        'refresh_token': 'google_refresh_token',
        'token_type': 'Bearer',
        'expires_in': 900,
        'user': {
          'id': 'google-user',
          'email': 'google@example.com',
          'display_name': 'Google User',
          'avatar_url': 'https://example.com/avatar.png',
          'provider': 'google',
          'has_completed_onboarding': true,
        },
      };

      final dto = AuthSessionDto.fromJson(json);

      expect(dto.accessToken, 'google_access_token');
      expect(dto.refreshToken, 'google_refresh_token');
      expect(dto.expiresIn, 900);
      expect(dto.user.provider, 'google');
      expect(dto.user.hasCompletedOnboarding, isTrue);
    });

    test('parses has_completed_onboarding correctly', () {
      final dto = AuthUserDto.fromJson({
        'id': 'legacy-user',
        'display_name': 'Legacy User',
        'has_completed_onboarding': true,
      });

      expect(dto.hasCompletedOnboarding, isTrue);
    });

    test('defaults to false when onboarding fields are missing or null', () {
      final dtoMissing = AuthUserDto.fromJson({
        'id': 'user-1',
        'display_name': 'User 1',
      });
      expect(dtoMissing.hasCompletedOnboarding, isFalse);

      final dtoNull = AuthUserDto.fromJson({
        'id': 'user-2',
        'display_name': 'User 2',
        'has_completed_onboarding': null,
      });
      expect(dtoNull.hasCompletedOnboarding, isFalse);
    });

    test('throws clear error when access_token is missing', () {
      final json = {
        'refresh_token': 'test_refresh_token',
        'user': {'id': 'user123'},
      };

      expect(
        () => AuthSessionDto.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('access_token'),
          ),
        ),
      );
    });

    test('throws clear error when user field is missing', () {
      final json = {
        'access_token': 'test_access_token',
        'refresh_token': 'test_refresh_token',
      };

      expect(
        () => AuthSessionDto.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    });

    test('serializes to JSON correctly', () {
      final dto = AuthSessionDto(
        accessToken: 'test_access_token',
        refreshToken: 'test_refresh_token',
        user: AuthUserDto(id: 'user123', displayName: 'Test User'),
      );

      final json = dto.toJson();

      expect(json['access_token'], 'test_access_token');
      expect(json['refresh_token'], 'test_refresh_token');
      expect(json['token_type'], 'Bearer');
      expect(json['user']['id'], 'user123');
      expect(json['user']['display_name'], 'Test User');
    });
  });

  group('UserProfileDto', () {
    test('parses from JSON correctly', () {
      final json = {
        'id': 'user123',
        'email': 'test@example.com',
        'name': 'Test User',
        'level': 5,
        'current_level_exp': 250,
        'next_level_exp': 500,
        'total_exp': 1250,
        'reward_points': 100,
        'streak_days': 7,
        'total_completed_quests': 50,
        'main_goals': ['Health', 'Learning'],
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-06-01T10:00:00Z',
      };

      final dto = UserProfileDto.fromJson(json);

      expect(dto.id, 'user123');
      expect(dto.email, 'test@example.com');
      expect(dto.name, 'Test User');
      expect(dto.level, 5);
      expect(dto.currentLevelExp, 250);
      expect(dto.nextLevelExp, 500);
      expect(dto.totalExp, 1250);
      expect(dto.rewardPoints, 100);
      expect(dto.streakDays, 7);
      expect(dto.totalCompletedQuests, 50);
      expect(dto.mainGoals, ['Health', 'Learning']);
      expect(dto.createdAt.isUtc, isTrue);
      expect(dto.updatedAt.isUtc, isTrue);
    });

    test('handles missing optional fields', () {
      final json = {
        'id': 'user123',
        'email': 'test@example.com',
        'name': 'Test User',
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-06-01T10:00:00Z',
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
  });

  group('QuestDto', () {
    test('parses from JSON correctly', () {
      final json = {
        'id': 'quest123',
        'title': 'Drink water',
        'description': 'Drink a glass of water',
        'type': 'water',
        'status': 'pending',
        'difficulty': 'easy',
        'source': 'dailyPlan',
        'exp': 10,
        'estimated_minutes': 5,
        'scheduled_at': '2026-06-01T10:00:00Z',
        'tags': ['health', 'hydration'],
        'is_important': true,
        'created_at': '2026-06-01T08:00:00Z',
        'updated_at': '2026-06-01T08:00:00Z',
      };

      final dto = QuestDto.fromJson(json);

      expect(dto.id, 'quest123');
      expect(dto.title, 'Drink water');
      expect(dto.description, 'Drink a glass of water');
      expect(dto.type, QuestType.water);
      expect(dto.status, QuestStatus.pending);
      expect(dto.difficulty, QuestDifficulty.easy);
      expect(dto.source, QuestSource.dailyPlan);
      expect(dto.exp, 10);
      expect(dto.estimatedMinutes, 5);
      expect(dto.scheduledAt, isNotNull);
      expect(dto.scheduledAt!.isUtc, isTrue);
      expect(dto.tags, ['health', 'hydration']);
      expect(dto.isImportant, isTrue);
      expect(dto.createdAt.isUtc, isTrue);
      expect(dto.updatedAt.isUtc, isTrue);
    });

    test('handles unknown enum values safely', () {
      final json = {
        'id': 'quest123',
        'title': 'Test Quest',
        'type': 'unknown_type',
        'status': 'unknown_status',
        'difficulty': 'unknown_difficulty',
        'source': 'unknown_source',
        'created_at': '2026-06-01T08:00:00Z',
        'updated_at': '2026-06-01T08:00:00Z',
      };

      final dto = QuestDto.fromJson(json);

      expect(dto.type, QuestType.custom);
      expect(dto.status, QuestStatus.pending);
      expect(dto.difficulty, QuestDifficulty.medium);
      expect(dto.source, QuestSource.manual);
    });

    test('handles missing optional fields', () {
      final json = {
        'id': 'quest123',
        'title': 'Test Quest',
        'type': 'water',
        'created_at': '2026-06-01T08:00:00Z',
        'updated_at': '2026-06-01T08:00:00Z',
      };

      final dto = QuestDto.fromJson(json);

      expect(dto.description, '');
      expect(dto.exp, 10);
      expect(dto.estimatedMinutes, 5);
      expect(dto.scheduledAt, isNull);
      expect(dto.startedAt, isNull);
      expect(dto.completedAt, isNull);
      expect(dto.snoozedUntil, isNull);
      expect(dto.reason, isNull);
      expect(dto.instruction, isNull);
      expect(dto.tags, isEmpty);
      expect(dto.isImportant, isFalse);
    });
  });

  group('OnboardingStatusDto', () {
    test('parses from JSON correctly', () {
      final json = {
        'has_completed_onboarding': true,
        'current_step': 'profile',
        'data': {'name': 'Test User'},
      };

      final dto = OnboardingStatusDto.fromJson(json);

      expect(dto.completed, isTrue);
      expect(dto.currentStep, 'profile');
      expect(dto.data, {'name': 'Test User'});
    });

    test('handles missing optional fields', () {
      final json = {'has_completed_onboarding': false};

      final dto = OnboardingStatusDto.fromJson(json);

      expect(dto.completed, isFalse);
      expect(dto.currentStep, isNull);
      expect(dto.data, isNull);
    });
  });

  group('DailyStatusDto', () {
    test('parses from JSON correctly', () {
      final json = {
        'has_checked_in': true,
        'has_reviewed': false,
        'today_completed_quests': 5,
        'today_planned_quests': 10,
        'today_earned_exp': 50,
      };

      final dto = DailyStatusDto.fromJson(json);

      expect(dto.hasCheckedIn, isTrue);
      expect(dto.hasReviewed, isFalse);
      expect(dto.todayCompletedQuests, 5);
      expect(dto.todayPlannedQuests, 10);
      expect(dto.todayEarnedExp, 50);
    });

    test('handles missing fields with defaults', () {
      final json = <String, dynamic>{};

      final dto = DailyStatusDto.fromJson(json);

      expect(dto.hasCheckedIn, isFalse);
      expect(dto.hasReviewed, isFalse);
      expect(dto.todayCompletedQuests, 0);
      expect(dto.todayPlannedQuests, 0);
      expect(dto.todayEarnedExp, 0);
    });
  });
}
