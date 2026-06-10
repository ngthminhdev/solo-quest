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

/// Generate Learning Roadmap Request DTO
class GenerateLearningRoadmapRequestDto {
  final String learningGoal;
  final String? category;
  final String? difficulty;
  final int? maxDuration;

  GenerateLearningRoadmapRequestDto({
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

/// Generate Learning Roadmap Error DTO
class GenerateLearningRoadmapErrorDto {
  final String type;
  final String message;

  GenerateLearningRoadmapErrorDto({
    required this.type,
    required this.message,
  });

  factory GenerateLearningRoadmapErrorDto.fromJson(Map<String, dynamic> json) {
    return GenerateLearningRoadmapErrorDto(
      type: json['type'] as String? ?? 'internal_error',
      message: json['message'] as String? ?? 'Unknown error',
    );
  }
}

/// Generate Learning Roadmap Status Response DTO
class GenerateLearningRoadmapStatusDto {
  final String jobId;
  final String status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final GenerateLearningRoadmapErrorDto? error;
  final Map<String, dynamic>? item;
  final String? source;
  final int? generatedStepCount;

  GenerateLearningRoadmapStatusDto({
    required this.jobId,
    required this.status,
    this.startedAt,
    this.completedAt,
    this.error,
    this.item,
    this.source,
    this.generatedStepCount,
  });

  factory GenerateLearningRoadmapStatusDto.fromJson(Map<String, dynamic> json) {
    return GenerateLearningRoadmapStatusDto(
      jobId: json['job_id'] as String,
      status: json['status'] as String,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
      error: json['error'] != null
          ? GenerateLearningRoadmapErrorDto.fromJson(json['error'] as Map<String, dynamic>)
          : null,
      item: json['item'] as Map<String, dynamic>?,
      source: json['source'] as String?,
      generatedStepCount: json['generated_step_count'] as int?,
    );
  }

  bool get isCompleted => status == 'completed' && item != null;
  bool get isFailed => status == 'failed' || status == 'stale';
  bool get isRunning => status == 'generating' || status == 'pending';
}

/// Generate Learning Roadmap Result
class GenerateLearningRoadmapResult {
  final Map<String, dynamic>? roadmapItem;
  final String? jobId;
  final int? pollAfterSeconds;
  final String? errorMessage;
  final GenerateStatus status;

  GenerateLearningRoadmapResult.completed({
    required this.roadmapItem,
  })  : jobId = null,
        pollAfterSeconds = null,
        errorMessage = null,
        status = GenerateStatus.completed;

  GenerateLearningRoadmapResult.started({
    required this.jobId,
    this.pollAfterSeconds,
  })  : roadmapItem = null,
        errorMessage = null,
        status = GenerateStatus.started;

  GenerateLearningRoadmapResult.failed({
    required this.errorMessage,
  })  : roadmapItem = null,
        jobId = null,
        pollAfterSeconds = null,
        status = GenerateStatus.failed;
}

enum GenerateStatus {
  completed,
  started,
  failed,
}
