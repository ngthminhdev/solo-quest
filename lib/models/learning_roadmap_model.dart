class LearningRoadmapModel {
  final String id;
  final String title;
  final String description;
  final List<LearningRoadmapStepModel> steps;
  final double progress;
  final String category;
  final String difficulty;
  final int estimatedMinutes;
  final String source;
  final String status;
  final bool enabled;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const LearningRoadmapModel({
    required this.id,
    required this.title,
    this.description = '',
    this.steps = const [],
    this.progress = 0.0,
    this.category = '',
    this.difficulty = 'beginner',
    this.estimatedMinutes = 0,
    this.source = 'system',
    this.status = '',
    this.enabled = true,
    this.startedAt,
    this.completedAt,
  });

  int get totalSteps => steps.length;

  int get completedSteps => steps.where((s) => s.completed).length;

  int get completedStepCount => completedSteps;

  int get totalEstimatedMinutes =>
      steps.fold<int>(0, (sum, step) => sum + step.estimatedMinutes);

  double get computedProgress {
    if (steps.isEmpty) return progress.clamp(0.0, 1.0);
    return (completedSteps / steps.length).clamp(0.0, 1.0);
  }

  bool get isTracking => status == 'tracking';
  bool get isCompleted => status == 'completed';
  bool get isFollowing => isTracking || isCompleted;

  LearningRoadmapModel copyWith({
    String? id,
    String? title,
    String? description,
    List<LearningRoadmapStepModel>? steps,
    double? progress,
    String? category,
    String? difficulty,
    int? estimatedMinutes,
    String? source,
    String? status,
    bool? enabled,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return LearningRoadmapModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      steps: steps ?? this.steps,
      progress: progress ?? this.progress,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      source: source ?? this.source,
      status: status ?? this.status,
      enabled: enabled ?? this.enabled,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  factory LearningRoadmapModel.fromJson(Map<String, dynamic> json) {
    return LearningRoadmapModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => LearningRoadmapStepModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'beginner',
      estimatedMinutes: json['estimated_minutes'] as int? ?? 0,
      source: json['source'] as String? ?? 'system',
      status: json['status'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'steps': steps.map((e) => e.toJson()).toList(),
      'progress': progress,
      'category': category,
      'difficulty': difficulty,
      'estimated_minutes': estimatedMinutes,
      'source': source,
      'status': status,
      'enabled': enabled,
    };
  }
}

class LearningRoadmapStepModel {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final int estimatedMinutes;
  final int orderIndex;
  final DateTime? completedAt;

  const LearningRoadmapStepModel({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
    this.estimatedMinutes = 15,
    this.orderIndex = 0,
    this.completedAt,
  });

  LearningRoadmapStepModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    int? estimatedMinutes,
    int? orderIndex,
    DateTime? completedAt,
  }) {
    return LearningRoadmapStepModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      orderIndex: orderIndex ?? this.orderIndex,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  factory LearningRoadmapStepModel.fromJson(Map<String, dynamic> json) {
    return LearningRoadmapStepModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      estimatedMinutes: json['estimated_minutes'] as int? ?? 15,
      orderIndex: json['order_index'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'estimated_minutes': estimatedMinutes,
      'order_index': orderIndex,
    };
  }
}
