import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/progress_dto.dart';
import 'package:solo_quest/core/network/api_response_parser.dart';

void main() {
  group('ProgressApiService Response Parsing', () {
    test('getProgress parses wrapped response with "item" key', () {
      final json = {
        'item': {
          'level': 5,
          'current_level_exp': 1250,
          'next_level_exp': 1500,
          'total_exp': 4800,
          'reward_points': 320,
          'streak_days': 5,
          'total_completed_quests': 45,
          'total_skipped_quests': 3,
          'weekly_completion_rate': 0.70,
          'completed_by_type': <String, dynamic>{},
          'streak_shields': 2,
          'light_days_used': 0,
          'best_streak': 5,
          'weekly_daily_data': [],
        }
      };

      final map = ApiResponseParser.extractObject(
        json,
        preferredKeys: ['item', 'data', 'progress', 'result'],
        context: 'test',
      );

      final dto = ProgressDto.fromJson(map);
      expect(dto.level, 5);
      expect(dto.currentLevelExp, 1250);
      expect(dto.nextLevelExp, 1500);
      expect(dto.rewardPoints, 320);
    });

    test('getProgress parses wrapped response with "data" key', () {
      final json = {
        'data': {
          'level': 3,
          'current_level_exp': 500,
          'next_level_exp': 800,
          'total_exp': 1500,
          'reward_points': 150,
          'streak_days': 3,
          'total_completed_quests': 20,
          'total_skipped_quests': 1,
          'weekly_completion_rate': 0.85,
          'completed_by_type': <String, dynamic>{},
          'streak_shields': 2,
          'light_days_used': 0,
          'best_streak': 3,
          'weekly_daily_data': [],
        }
      };

      final map = ApiResponseParser.extractObject(
        json,
        preferredKeys: ['item', 'data', 'progress', 'result'],
        context: 'test',
      );

      final dto = ProgressDto.fromJson(map);
      expect(dto.level, 3);
      expect(dto.currentLevelExp, 500);
      expect(dto.rewardPoints, 150);
    });

    test('getProgress parses top-level object', () {
      final json = <String, dynamic>{
        'level': 7,
        'current_level_exp': 2000,
        'next_level_exp': 2500,
        'total_exp': 10000,
        'reward_points': 500,
        'streak_days': 10,
        'total_completed_quests': 100,
        'total_skipped_quests': 5,
        'weekly_completion_rate': 0.90,
        'completed_by_type': <String, dynamic>{},
        'streak_shields': 2,
        'light_days_used': 0,
        'best_streak': 10,
        'weekly_daily_data': <dynamic>[],
      };

      final map = ApiResponseParser.extractObject(
        json,
        preferredKeys: ['item', 'data', 'progress', 'result'],
        context: 'test',
      );

      final dto = ProgressDto.fromJson(map);
      expect(dto.level, 7);
      expect(dto.currentLevelExp, 2000);
      expect(dto.rewardPoints, 500);
    });

    test('getWeeklyChart parses wrapped response with days', () {
      final json = {
        'data': {
          'days': [
            {'day_label': 'T2', 'completed': 8, 'planned': 9},
            {'day_label': 'T3', 'completed': 6, 'planned': 8},
          ],
          'total_completed': 14,
          'total_planned': 17,
          'completion_rate': 0.82,
        }
      };

      final map = ApiResponseParser.extractObject(
        json,
        preferredKeys: ['item', 'data', 'chart', 'weekly', 'weekly_chart'],
        context: 'test',
      );

      final dto = WeeklyChartDto.fromJson(map);
      expect(dto.days.length, 2);
      expect(dto.days[0].dayLabel, 'T2');
      expect(dto.days[0].completed, 8);
      expect(dto.totalCompleted, 14);
    });

    test('getWeeklyChart parses top-level object', () {
      final json = {
        'days': [
          {'day_label': 'T4', 'completed': 5, 'planned': 7},
        ],
        'total_completed': 5,
        'total_planned': 7,
        'completion_rate': 0.71,
      };

      final map = ApiResponseParser.extractObject(
        json,
        preferredKeys: ['item', 'data', 'chart', 'weekly', 'weekly_chart'],
        context: 'test',
      );

      final dto = WeeklyChartDto.fromJson(map);
      expect(dto.days.length, 1);
      expect(dto.days[0].completed, 5);
      expect(dto.completionRate, 0.71);
    });

    test('getXPHistory parses wrapped response with "history" key', () {
      final json = {
        'history': {
          'transactions': [
            {
              'id': '1',
              'type': 'quest_complete',
              'amount': 50,
              'description': 'Completed quest',
              'created_at': '2026-06-02T10:00:00Z',
            }
          ],
          'total': 1,
          'limit': 20,
          'offset': 0,
        }
      };

      final map = ApiResponseParser.extractObject(
        json,
        preferredKeys: ['item', 'data', 'history', 'xp_history', 'transactions'],
        context: 'test',
      );

      final dto = XPHistoryDto.fromJson(map);
      expect(dto.transactions.length, 1);
      expect(dto.transactions[0].amount, 50);
      expect(dto.total, 1);
    });

    test('getXPHistory parses top-level object', () {
      final json = {
        'transactions': [
          {
            'id': '1',
            'type': 'quest_complete',
            'amount': 50,
            'description': 'Completed quest',
            'created_at': '2026-06-02T10:00:00Z',
          },
          {
            'id': '2',
            'type': 'bonus',
            'amount': 25,
            'description': 'Streak bonus',
            'created_at': '2026-06-02T11:00:00Z',
          }
        ],
        'total': 2,
        'limit': 20,
        'offset': 0,
      };

      final map = ApiResponseParser.extractObject(
        json,
        preferredKeys: ['item', 'data', 'history', 'xp_history', 'transactions'],
        context: 'test',
      );

      final dto = XPHistoryDto.fromJson(map);
      expect(dto.transactions.length, 2);
      expect(dto.transactions[1].amount, 25);
      expect(dto.total, 2);
    });

    test('getXPHistory handles empty history', () {
      final json = {
        'data': {
          'transactions': [],
          'total': 0,
          'limit': 20,
          'offset': 0,
        }
      };

      final map = ApiResponseParser.extractObject(
        json,
        preferredKeys: ['item', 'data', 'history', 'xp_history', 'transactions'],
        context: 'test',
      );

      final dto = XPHistoryDto.fromJson(map);
      expect(dto.transactions.isEmpty, true);
      expect(dto.total, 0);
    });

    test('Progress DTO handles snake_case quest types', () {
      final json = {
        'level': 5,
        'current_level_exp': 1000,
        'next_level_exp': 1500,
        'total_exp': 4000,
        'reward_points': 300,
        'streak_days': 5,
        'total_completed_quests': 45,
        'total_skipped_quests': 3,
        'weekly_completion_rate': 0.70,
        'completed_by_type': <String, dynamic>{
          'water': 10,
          'break_time': 5,
          'movement': 8,
        },
        'streak_shields': 2,
        'light_days_used': 0,
        'best_streak': 5,
        'weekly_daily_data': [],
      };

      final dto = ProgressDto.fromJson(json);
      expect(dto.completedByType.length, 3);
      // Quest types should be parsed correctly via enum mapper
    });

    test('Weekly chart handles missing optional fields', () {
      final json = {
        'days': [],
        'total_completed': 0,
        'total_planned': 0,
      };

      final dto = WeeklyChartDto.fromJson(json);
      expect(dto.days.isEmpty, true);
      expect(dto.completionRate, 0.0); // Default value
    });

    test('XP transaction parses with all fields', () {
      final json = {
        'id': 'tx-123',
        'type': 'quest_complete',
        'amount': 75,
        'quest_id': 'quest-456',
        'quest_title': 'Morning water',
        'description': 'Completed morning water quest',
        'created_at': '2026-06-02T08:30:00Z',
      };

      final dto = XPTransactionDto.fromJson(json);
      expect(dto.id, 'tx-123');
      expect(dto.amount, 75);
      expect(dto.questId, 'quest-456');
      expect(dto.questTitle, 'Morning water');
      expect(dto.description, 'Completed morning water quest');
    });

    test('XP transaction parses without optional fields', () {
      final json = {
        'id': 'tx-789',
        'type': 'bonus',
        'amount': 25,
        'description': 'Daily streak bonus',
        'created_at': '2026-06-02T09:00:00Z',
      };

      final dto = XPTransactionDto.fromJson(json);
      expect(dto.id, 'tx-789');
      expect(dto.amount, 25);
      expect(dto.questId, null);
      expect(dto.questTitle, null);
    });
  });
}
