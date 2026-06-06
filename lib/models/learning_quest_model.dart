class LearningQuestChecklistItem {
  final String id;
  final String topicId;
  final String title;
  final String sourceTitle;
  final bool completed;

  const LearningQuestChecklistItem({
    required this.id,
    required this.topicId,
    required this.title,
    required this.sourceTitle,
    this.completed = false,
  });

  LearningQuestChecklistItem copyWith({
    String? id,
    String? topicId,
    String? title,
    String? sourceTitle,
    bool? completed,
  }) {
    return LearningQuestChecklistItem(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      completed: completed ?? this.completed,
    );
  }
}

class LearningQuestModel {
  final String id;
  final DateTime date;
  final String title;
  final List<LearningQuestChecklistItem> checklistItems;

  const LearningQuestModel({
    required this.id,
    required this.date,
    this.title = 'Học tập hôm nay',
    this.checklistItems = const [],
  });

  bool get isCompleted =>
      checklistItems.isNotEmpty &&
      checklistItems.every((item) => item.completed);

  int get completedCount =>
      checklistItems.where((item) => item.completed).length;

  int get totalCount => checklistItems.length;

  double get progress {
    if (checklistItems.isEmpty) return 0.0;
    return (completedCount / totalCount).clamp(0.0, 1.0);
  }

  int get sourceCount =>
      checklistItems.map((item) => item.sourceTitle).toSet().length;

  String get subtitle {
    if (checklistItems.isEmpty) return 'Chưa chọn chủ đề học tập';
    return '$totalCount chủ đề từ $sourceCount lộ trình';
  }

  LearningQuestModel copyWith({
    String? id,
    DateTime? date,
    String? title,
    List<LearningQuestChecklistItem>? checklistItems,
  }) {
    return LearningQuestModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      checklistItems: checklistItems ?? this.checklistItems,
    );
  }
}

class LearningTopicSelection {
  final String topicId;
  final String title;
  final String sourceTitle;

  const LearningTopicSelection({
    required this.topicId,
    required this.title,
    required this.sourceTitle,
  });
}
