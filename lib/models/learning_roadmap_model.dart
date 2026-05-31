class LearningRoadmapModel {
  final String id;
  final String title;
  final String description;
  final List<LearningRoadmapStepModel> steps;
  final double progress;

  const LearningRoadmapModel({
    required this.id,
    required this.title,
    this.description = '',
    this.steps = const [],
    this.progress = 0.0,
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

  LearningRoadmapModel copyWith({
    String? id,
    String? title,
    String? description,
    List<LearningRoadmapStepModel>? steps,
    double? progress,
  }) {
    return LearningRoadmapModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      steps: steps ?? this.steps,
      progress: progress ?? this.progress,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'steps': steps.map((e) => e.toJson()).toList(),
      'progress': progress,
    };
  }
}

class LearningRoadmapStepModel {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final int estimatedMinutes;

  const LearningRoadmapStepModel({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
    this.estimatedMinutes = 15,
  });

  LearningRoadmapStepModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    int? estimatedMinutes,
  }) {
    return LearningRoadmapStepModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }

  factory LearningRoadmapStepModel.fromJson(Map<String, dynamic> json) {
    return LearningRoadmapStepModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      estimatedMinutes: json['estimated_minutes'] as int? ?? 15,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'estimated_minutes': estimatedMinutes,
    };
  }
}
