import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/learning_roadmap_dto.dart';

void main() {
  group('LearningRoadmapDto', () {
    test('fromJson parses valid roadmap with steps', () {
      final json = {
        'id': 'rm-1',
        'title': 'Flutter Architecture',
        'description': 'Learn MVVM',
        'category': 'Flutter',
        'difficulty': 'intermediate',
        'estimated_minutes': 180,
        'total_steps': 5,
        'completed_steps': 2,
        'progress_percent': 40.0,
        'source': 'system',
        'status': 'tracking',
        'enabled': true,
        'started_at': '2026-06-01T10:00:00Z',
        'completed_at': null,
        'steps': [
          {
            'id': 's1',
            'title': 'Step 1',
            'description': 'First step',
            'order_index': 0,
            'estimated_minutes': 30,
            'completed': true,
            'completed_at': '2026-06-02T10:00:00Z',
          },
          {
            'id': 's2',
            'title': 'Step 2',
            'description': 'Second step',
            'order_index': 1,
            'estimated_minutes': 45,
            'completed': false,
            'completed_at': null,
          },
        ],
      };

      final dto = LearningRoadmapDto.fromJson(json);

      expect(dto.id, 'rm-1');
      expect(dto.title, 'Flutter Architecture');
      expect(dto.category, 'Flutter');
      expect(dto.difficulty, 'intermediate');
      expect(dto.totalSteps, 5);
      expect(dto.completedSteps, 2);
      expect(dto.progressPercent, 40.0);
      expect(dto.status, 'tracking');
      expect(dto.enabled, true);
      expect(dto.startedAt, isNotNull);
      expect(dto.completedAt, isNull);
      expect(dto.steps.length, 2);
      expect(dto.steps[0].completed, true);
      expect(dto.steps[1].completed, false);
    });

    test('fromJson handles nullable fields safely', () {
      final json = {
        'id': 'rm-2',
        'title': 'Dart Basics',
        'started_at': null,
        'completed_at': null,
      };

      final dto = LearningRoadmapDto.fromJson(json);

      expect(dto.id, 'rm-2');
      expect(dto.title, 'Dart Basics');
      expect(dto.description, '');
      expect(dto.category, '');
      expect(dto.difficulty, 'beginner');
      expect(dto.estimatedMinutes, 0);
      expect(dto.totalSteps, 0);
      expect(dto.completedSteps, 0);
      expect(dto.progressPercent, 0.0);
      expect(dto.source, 'system');
      expect(dto.status, '');
      expect(dto.enabled, true);
      expect(dto.startedAt, isNull);
      expect(dto.completedAt, isNull);
      expect(dto.steps, isEmpty);
    });

    test('fromJson handles empty status for not-following roadmap', () {
      final json = {
        'id': 'rm-3',
        'title': 'UI Design',
        'status': '',
      };

      final dto = LearningRoadmapDto.fromJson(json);

      expect(dto.status, '');
    });
  });

  group('LearningRoadmapStepDto', () {
    test('fromJson parses step with completion', () {
      final json = {
        'id': 's1',
        'title': 'Learn Widgets',
        'description': 'Study Flutter widgets',
        'order_index': 0,
        'estimated_minutes': 30,
        'completed': true,
        'completed_at': '2026-06-02T15:30:00Z',
      };

      final dto = LearningRoadmapStepDto.fromJson(json);

      expect(dto.id, 's1');
      expect(dto.title, 'Learn Widgets');
      expect(dto.description, 'Study Flutter widgets');
      expect(dto.orderIndex, 0);
      expect(dto.estimatedMinutes, 30);
      expect(dto.completed, true);
      expect(dto.completedAt, isNotNull);
    });

    test('fromJson handles nullable completedAt', () {
      final json = {
        'id': 's2',
        'title': 'Practice',
        'completed': false,
        'completed_at': null,
      };

      final dto = LearningRoadmapStepDto.fromJson(json);

      expect(dto.completed, false);
      expect(dto.completedAt, isNull);
    });
  });

  group('FollowLearningRoadmapDto', () {
    test('fromJson parses follow response', () {
      final json = {
        'id': 'follow-1',
        'user_id': 'user-123',
        'roadmap_id': 'rm-1',
        'status': 'tracking',
        'started_at': '2026-06-04T10:00:00Z',
        'completed_at': null,
      };

      final dto = FollowLearningRoadmapDto.fromJson(json);

      expect(dto.id, 'follow-1');
      expect(dto.userId, 'user-123');
      expect(dto.roadmapId, 'rm-1');
      expect(dto.status, 'tracking');
      expect(dto.startedAt, isNotNull);
      expect(dto.completedAt, isNull);
    });
  });

  group('ToggleLearningStepResponseDto', () {
    test('fromJson parses toggle response', () {
      final json = {
        'roadmap_id': 'rm-1',
        'step_id': 's3',
        'completed': true,
        'completed_at': '2026-06-04T12:00:00Z',
        'completed_steps': 3,
        'total_steps': 5,
        'progress_percent': 60.0,
        'roadmap_status': 'tracking',
      };

      final dto = ToggleLearningStepResponseDto.fromJson(json);

      expect(dto.roadmapId, 'rm-1');
      expect(dto.stepId, 's3');
      expect(dto.completed, true);
      expect(dto.completedAt, isNotNull);
      expect(dto.completedSteps, 3);
      expect(dto.totalSteps, 5);
      expect(dto.progressPercent, 60.0);
      expect(dto.roadmapStatus, 'tracking');
    });

    test('fromJson handles defaults', () {
      final json = {
        'roadmap_id': 'rm-1',
        'step_id': 's1',
      };

      final dto = ToggleLearningStepResponseDto.fromJson(json);

      expect(dto.completed, false);
      expect(dto.completedAt, isNull);
      expect(dto.completedSteps, 0);
      expect(dto.totalSteps, 0);
      expect(dto.progressPercent, 0.0);
      expect(dto.roadmapStatus, 'tracking');
    });
  });
}
