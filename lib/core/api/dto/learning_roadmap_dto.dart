import '../../utils/date_time_parser.dart';

/// Learning Roadmap DTO from backend
class LearningRoadmapDto {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final int estimatedMinutes;
  final int totalSteps;
  final int completedSteps;
  final double progressPercent;
  final String source;
  final String status;
  final bool enabled;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final List<LearningRoadmapStepDto> steps;

  LearningRoadmapDto({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.totalSteps,
    required this.completedSteps,
    required this.progressPercent,
    required this.source,
    required this.status,
    required this.enabled,
    this.startedAt,
    this.completedAt,
    required this.steps,
  });

  factory LearningRoadmapDto.fromJson(Map<String, dynamic> json) {
    return LearningRoadmapDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'beginner',
      estimatedMinutes: json['estimated_minutes'] as int? ?? 0,
      totalSteps: json['total_steps'] as int? ?? 0,
      completedSteps: json['completed_steps'] as int? ?? 0,
      progressPercent: (json['progress_percent'] as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String? ?? 'system',
      status: json['status'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
      startedAt: parseUtcDateTime(json['started_at'] as String?),
      completedAt: parseUtcDateTime(json['completed_at'] as String?),
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => LearningRoadmapStepDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
      'completed_steps': completedSteps,
      'progress_percent': progressPercent,
      'source': source,
      'status': status,
      'enabled': enabled,
      'started_at': formatUtcDateTime(startedAt),
      'completed_at': formatUtcDateTime(completedAt),
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }
}

/// Learning Roadmap Step DTO from backend
class LearningRoadmapStepDto {
  final String id;
  final String title;
  final String description;
  final int orderIndex;
  final int estimatedMinutes;
  final bool completed;
  final DateTime? completedAt;

  LearningRoadmapStepDto({
    required this.id,
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.estimatedMinutes,
    required this.completed,
    this.completedAt,
  });

  factory LearningRoadmapStepDto.fromJson(Map<String, dynamic> json) {
    return LearningRoadmapStepDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      orderIndex: json['order_index'] as int? ?? 0,
      estimatedMinutes: json['estimated_minutes'] as int? ?? 15,
      completed: json['completed'] as bool? ?? false,
      completedAt: parseUtcDateTime(json['completed_at'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'order_index': orderIndex,
      'estimated_minutes': estimatedMinutes,
      'completed': completed,
      'completed_at': formatUtcDateTime(completedAt),
    };
  }
}

/// Follow Learning Roadmap DTO from backend
class FollowLearningRoadmapDto {
  final String id;
  final String userId;
  final String roadmapId;
  final String status;
  final DateTime startedAt;
  final DateTime? completedAt;

  FollowLearningRoadmapDto({
    required this.id,
    required this.userId,
    required this.roadmapId,
    required this.status,
    required this.startedAt,
    this.completedAt,
  });

  factory FollowLearningRoadmapDto.fromJson(Map<String, dynamic> json) {
    return FollowLearningRoadmapDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      roadmapId: json['roadmap_id'] as String,
      status: json['status'] as String? ?? 'tracking',
      startedAt: parseUtcDateTime(json['started_at'] as String?) ?? DateTime.now().toUtc(),
      completedAt: parseUtcDateTime(json['completed_at'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'roadmap_id': roadmapId,
      'status': status,
      'started_at': formatUtcDateTime(startedAt),
      'completed_at': formatUtcDateTime(completedAt),
    };
  }
}

/// Toggle Learning Step Request DTO
class ToggleLearningStepRequestDto {
  final bool completed;

  ToggleLearningStepRequestDto({
    required this.completed,
  });

  Map<String, dynamic> toJson() {
    return {
      'completed': completed,
    };
  }
}

/// Toggle Learning Step Response DTO from backend
class ToggleLearningStepResponseDto {
  final String roadmapId;
  final String stepId;
  final bool completed;
  final DateTime? completedAt;
  final int completedSteps;
  final int totalSteps;
  final double progressPercent;
  final String roadmapStatus;

  ToggleLearningStepResponseDto({
    required this.roadmapId,
    required this.stepId,
    required this.completed,
    this.completedAt,
    required this.completedSteps,
    required this.totalSteps,
    required this.progressPercent,
    required this.roadmapStatus,
  });

  factory ToggleLearningStepResponseDto.fromJson(Map<String, dynamic> json) {
    return ToggleLearningStepResponseDto(
      roadmapId: json['roadmap_id'] as String,
      stepId: json['step_id'] as String,
      completed: json['completed'] as bool? ?? false,
      completedAt: parseUtcDateTime(json['completed_at'] as String?),
      completedSteps: json['completed_steps'] as int? ?? 0,
      totalSteps: json['total_steps'] as int? ?? 0,
      progressPercent: (json['progress_percent'] as num?)?.toDouble() ?? 0.0,
      roadmapStatus: json['roadmap_status'] as String? ?? 'tracking',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roadmap_id': roadmapId,
      'step_id': stepId,
      'completed': completed,
      'completed_at': formatUtcDateTime(completedAt),
      'completed_steps': completedSteps,
      'total_steps': totalSteps,
      'progress_percent': progressPercent,
      'roadmap_status': roadmapStatus,
    };
  }
}
