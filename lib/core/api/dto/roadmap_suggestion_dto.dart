/// Roadmap Suggestion DTO from backend suggest API
class RoadmapSuggestionDto {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final int estimatedMinutes;
  final int totalSteps;
  final String source;

  RoadmapSuggestionDto({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.totalSteps,
    required this.source,
  });

  factory RoadmapSuggestionDto.fromJson(Map<String, dynamic> json) {
    return RoadmapSuggestionDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'beginner',
      estimatedMinutes: json['estimated_minutes'] as int? ?? 0,
      totalSteps: json['total_steps'] as int? ?? 0,
      source: json['source'] as String? ?? 'template',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'estimated_minutes': estimatedMinutes,
      'total_steps': totalSteps,
      'source': source,
    };
  }
}

/// Suggest Roadmaps Request DTO
class SuggestRoadmapsRequestDto {
  final String learningGoal;
  final String? category;
  final String? difficulty;
  final int? maxDuration;

  SuggestRoadmapsRequestDto({
    required this.learningGoal,
    this.category,
    this.difficulty,
    this.maxDuration,
  });

  Map<String, dynamic> toJson() {
    return {
      'preferences': {
        'learning_goal': learningGoal,
        if (category != null && category!.isNotEmpty) 'category': category,
        if (difficulty != null && difficulty!.isNotEmpty) 'difficulty': difficulty,
        if (maxDuration != null) 'max_duration': maxDuration,
      },
    };
  }
}

/// Create Roadmap from Template Request DTO
class CreateRoadmapFromTemplateRequestDto {
  final String templateId;
  final String source;
  final String learningGoal;
  final String? category;
  final String? difficulty;
  final int? maxDuration;

  CreateRoadmapFromTemplateRequestDto({
    required this.templateId,
    this.source = 'template',
    required this.learningGoal,
    this.category,
    this.difficulty,
    this.maxDuration,
  });

  Map<String, dynamic> toJson() {
    return {
      'template_id': templateId,
      'source': source,
      'preferences': {
        'learning_goal': learningGoal,
        if (category != null && category!.isNotEmpty) 'category': category,
        if (difficulty != null && difficulty!.isNotEmpty) 'difficulty': difficulty,
        if (maxDuration != null) 'max_duration': maxDuration,
      },
    };
  }
}
