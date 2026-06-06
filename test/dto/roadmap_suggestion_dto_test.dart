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
}
