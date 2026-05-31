class LearningGoalModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final int targetMinutesPerDay;
  final DateTime? deadline;
  final double progress;
  final bool isActive;

  const LearningGoalModel({
    required this.id,
    required this.title,
    this.description = '',
    this.category = 'general',
    this.targetMinutesPerDay = 15,
    this.deadline,
    this.progress = 0.0,
    this.isActive = true,
  });

  LearningGoalModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? targetMinutesPerDay,
    DateTime? deadline,
    double? progress,
    bool? isActive,
  }) {
    return LearningGoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      targetMinutesPerDay: targetMinutesPerDay ?? this.targetMinutesPerDay,
      deadline: deadline ?? this.deadline,
      progress: progress ?? this.progress,
      isActive: isActive ?? this.isActive,
    );
  }

  factory LearningGoalModel.fromJson(Map<String, dynamic> json) {
    return LearningGoalModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      targetMinutesPerDay: json['target_minutes_per_day'] as int? ?? 15,
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline'] as String) : null,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'target_minutes_per_day': targetMinutesPerDay,
      'deadline': deadline?.toIso8601String(),
      'progress': progress,
      'is_active': isActive,
    };
  }
}
