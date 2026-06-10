import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/roadmap_suggestion_dto.dart';

void main() {
  group('RoadmapSuggestionDto', () {
    test('fromJson parses valid suggestion correctly', () {
      final json = {
        'id': 'template_riverpod',
        'title': 'State Management với Riverpod',
        'description': 'Quản lý state hiệu quả cho ứng dụng Flutter với Riverpod',
        'category': 'Flutter',
        'difficulty': 'intermediate',
        'estimated_minutes': 180,
        'total_steps': 6,
        'source': 'template',
      };

      final dto = RoadmapSuggestionDto.fromJson(json);

      expect(dto.id, 'template_riverpod');
      expect(dto.title, 'State Management với Riverpod');
      expect(dto.description, 'Quản lý state hiệu quả cho ứng dụng Flutter với Riverpod');
      expect(dto.category, 'Flutter');
      expect(dto.difficulty, 'intermediate');
      expect(dto.estimatedMinutes, 180);
      expect(dto.totalSteps, 6);
      expect(dto.source, 'template');
    });

    test('fromJson handles missing optional fields with defaults', () {
      final json = {
        'id': 'test_id',
        'title': 'Test Roadmap',
      };

      final dto = RoadmapSuggestionDto.fromJson(json);

      expect(dto.id, 'test_id');
      expect(dto.title, 'Test Roadmap');
      expect(dto.description, '');
      expect(dto.category, '');
      expect(dto.difficulty, 'beginner');
      expect(dto.estimatedMinutes, 0);
      expect(dto.totalSteps, 0);
      expect(dto.source, 'template');
    });

    test('toJson converts DTO to JSON correctly', () {
      final dto = RoadmapSuggestionDto(
        id: 'template_1',
        title: 'Flutter Basics',
        description: 'Learn Flutter fundamentals',
        category: 'Flutter',
        difficulty: 'beginner',
        estimatedMinutes: 120,
        totalSteps: 5,
        source: 'template',
      );

      final json = dto.toJson();

      expect(json['id'], 'template_1');
      expect(json['title'], 'Flutter Basics');
      expect(json['description'], 'Learn Flutter fundamentals');
      expect(json['category'], 'Flutter');
      expect(json['difficulty'], 'beginner');
      expect(json['estimated_minutes'], 120);
      expect(json['total_steps'], 5);
      expect(json['source'], 'template');
    });
  });

  group('SuggestRoadmapsRequestDto', () {
    test('toJson includes all fields when provided', () {
      final request = SuggestRoadmapsRequestDto(
        learningGoal: 'Master Riverpod',
        category: 'Flutter',
        difficulty: 'intermediate',
        maxDuration: 180,
      );

      final json = request.toJson();

      expect(json['preferences']['learning_goal'], 'Master Riverpod');
      expect(json['preferences']['category'], 'Flutter');
      expect(json['preferences']['difficulty'], 'intermediate');
      expect(json['preferences']['max_duration'], 180);
    });

    test('toJson omits optional fields when null or empty', () {
      final request = SuggestRoadmapsRequestDto(
        learningGoal: 'Learn Flutter',
      );

      final json = request.toJson();

      expect(json['preferences']['learning_goal'], 'Learn Flutter');
      expect(json['preferences'].containsKey('category'), false);
      expect(json['preferences'].containsKey('difficulty'), false);
      expect(json['preferences'].containsKey('max_duration'), false);
    });

    test('toJson omits empty string fields', () {
      final request = SuggestRoadmapsRequestDto(
        learningGoal: 'Learn Flutter',
        category: '',
        difficulty: '',
      );

      final json = request.toJson();

      expect(json['preferences']['learning_goal'], 'Learn Flutter');
      expect(json['preferences'].containsKey('category'), false);
      expect(json['preferences'].containsKey('difficulty'), false);
    });
  });

  group('CreateRoadmapFromTemplateRequestDto', () {
    test('toJson includes all fields correctly', () {
      final request = CreateRoadmapFromTemplateRequestDto(
        templateId: 'template_riverpod',
        source: 'template',
        learningGoal: 'Master Riverpod for my app',
        category: 'Flutter',
        difficulty: 'intermediate',
        maxDuration: 180,
      );

      final json = request.toJson();

      expect(json['template_id'], 'template_riverpod');
      expect(json['source'], 'template');
      expect(json['preferences']['learning_goal'], 'Master Riverpod for my app');
      expect(json['preferences']['category'], 'Flutter');
      expect(json['preferences']['difficulty'], 'intermediate');
      expect(json['preferences']['max_duration'], 180);
    });

    test('toJson uses default source as template', () {
      final request = CreateRoadmapFromTemplateRequestDto(
        templateId: 'template_1',
        learningGoal: 'Learn Flutter',
      );

      final json = request.toJson();

      expect(json['source'], 'template');
      expect(json['template_id'], 'template_1');
    });

    test('toJson omits optional preference fields when null', () {
      final request = CreateRoadmapFromTemplateRequestDto(
        templateId: 'template_1',
        learningGoal: 'Learn Flutter',
      );

      final json = request.toJson();

      expect(json['preferences']['learning_goal'], 'Learn Flutter');
      expect(json['preferences'].containsKey('category'), false);
      expect(json['preferences'].containsKey('difficulty'), false);
      expect(json['preferences'].containsKey('max_duration'), false);
    });
  });

  group('GenerateLearningRoadmapRequestDto', () {
    test('toJson includes all fields when provided', () {
      final request = GenerateLearningRoadmapRequestDto(
        learningGoal: 'Master Flutter State Management',
        category: 'Flutter',
        difficulty: 'intermediate',
        maxDuration: 240,
      );

      final json = request.toJson();

      expect(json['preferences']['learning_goal'], 'Master Flutter State Management');
      expect(json['preferences']['category'], 'Flutter');
      expect(json['preferences']['difficulty'], 'intermediate');
      expect(json['preferences']['max_duration'], 240);
    });

    test('toJson omits optional fields when null', () {
      final request = GenerateLearningRoadmapRequestDto(
        learningGoal: 'Learn AI',
      );

      final json = request.toJson();

      expect(json['preferences']['learning_goal'], 'Learn AI');
      expect(json['preferences'].containsKey('category'), false);
      expect(json['preferences'].containsKey('difficulty'), false);
      expect(json['preferences'].containsKey('max_duration'), false);
    });
  });

  group('GenerateLearningRoadmapErrorDto', () {
    test('fromJson parses error correctly', () {
      final json = {
        'type': 'ai_error',
        'message': 'AI service unavailable',
      };

      final dto = GenerateLearningRoadmapErrorDto.fromJson(json);

      expect(dto.type, 'ai_error');
      expect(dto.message, 'AI service unavailable');
    });

    test('fromJson uses defaults for missing fields', () {
      final json = <String, dynamic>{};

      final dto = GenerateLearningRoadmapErrorDto.fromJson(json);

      expect(dto.type, 'internal_error');
      expect(dto.message, 'Unknown error');
    });
  });

  group('GenerateLearningRoadmapStatusDto', () {
    test('fromJson parses running status correctly', () {
      final json = {
        'job_id': 'job-123',
        'status': 'generating',
        'started_at': '2025-01-20T10:00:00Z',
      };

      final dto = GenerateLearningRoadmapStatusDto.fromJson(json);

      expect(dto.jobId, 'job-123');
      expect(dto.status, 'generating');
      expect(dto.startedAt, isNotNull);
      expect(dto.completedAt, isNull);
      expect(dto.error, isNull);
      expect(dto.item, isNull);
      expect(dto.isRunning, true);
      expect(dto.isCompleted, false);
      expect(dto.isFailed, false);
    });

    test('fromJson parses completed status correctly', () {
      final json = {
        'job_id': 'job-456',
        'status': 'completed',
        'started_at': '2025-01-20T10:00:00Z',
        'completed_at': '2025-01-20T10:01:30Z',
        'item': {'id': 'roadmap-1', 'title': 'Test Roadmap'},
        'source': 'ai',
        'generated_step_count': 8,
      };

      final dto = GenerateLearningRoadmapStatusDto.fromJson(json);

      expect(dto.jobId, 'job-456');
      expect(dto.status, 'completed');
      expect(dto.startedAt, isNotNull);
      expect(dto.completedAt, isNotNull);
      expect(dto.item, isNotNull);
      expect(dto.item!['id'], 'roadmap-1');
      expect(dto.source, 'ai');
      expect(dto.generatedStepCount, 8);
      expect(dto.isCompleted, true);
      expect(dto.isRunning, false);
      expect(dto.isFailed, false);
    });

    test('fromJson parses failed status correctly', () {
      final json = {
        'job_id': 'job-789',
        'status': 'failed',
        'started_at': '2025-01-20T10:00:00Z',
        'completed_at': '2025-01-20T10:00:45Z',
        'error': {
          'type': 'timeout',
          'message': 'Generation took too long',
        },
      };

      final dto = GenerateLearningRoadmapStatusDto.fromJson(json);

      expect(dto.jobId, 'job-789');
      expect(dto.status, 'failed');
      expect(dto.error, isNotNull);
      expect(dto.error!.type, 'timeout');
      expect(dto.error!.message, 'Generation took too long');
      expect(dto.isFailed, true);
      expect(dto.isCompleted, false);
      expect(dto.isRunning, false);
    });

    test('isRunning returns true for pending status', () {
      final json = {
        'job_id': 'job-pending',
        'status': 'pending',
      };

      final dto = GenerateLearningRoadmapStatusDto.fromJson(json);

      expect(dto.isRunning, true);
    });

    test('isFailed returns true for stale status', () {
      final json = {
        'job_id': 'job-stale',
        'status': 'stale',
      };

      final dto = GenerateLearningRoadmapStatusDto.fromJson(json);

      expect(dto.isFailed, true);
    });
  });

  group('GenerateLearningRoadmapResult', () {
    test('completed constructor creates completed result', () {
      final roadmapItem = {'id': 'roadmap-1', 'title': 'Test'};
      final result = GenerateLearningRoadmapResult.completed(
        roadmapItem: roadmapItem,
      );

      expect(result.status, GenerateStatus.completed);
      expect(result.roadmapItem, roadmapItem);
      expect(result.jobId, isNull);
      expect(result.errorMessage, isNull);
    });

    test('started constructor creates started result', () {
      final result = GenerateLearningRoadmapResult.started(
        jobId: 'job-123',
        pollAfterSeconds: 5,
      );

      expect(result.status, GenerateStatus.started);
      expect(result.jobId, 'job-123');
      expect(result.pollAfterSeconds, 5);
      expect(result.roadmapItem, isNull);
      expect(result.errorMessage, isNull);
    });

    test('failed constructor creates failed result', () {
      final result = GenerateLearningRoadmapResult.failed(
        errorMessage: 'AI service is down',
      );

      expect(result.status, GenerateStatus.failed);
      expect(result.errorMessage, 'AI service is down');
      expect(result.roadmapItem, isNull);
      expect(result.jobId, isNull);
    });
  });
}
