// UI reactivated with local/mock data; backend integration pending

import '../models/learning_quest_model.dart';

class LearningQuestService {
  static LearningQuestModel? _todayQuest;

  Future<LearningQuestModel?> getTodayLearningQuest() async {
    await Future.delayed(const Duration(milliseconds: 80));
    return _todayQuest;
  }

  Future<LearningQuestModel> addTopicsToTodayQuest(
    List<LearningTopicSelection> topics,
  ) async {
    await Future.delayed(const Duration(milliseconds: 120));

    final now = DateTime.now();
    final current =
        _todayQuest ??
        LearningQuestModel(
          id: 'learning-${_dateKey(now)}',
          date: DateTime(now.year, now.month, now.day),
        );

    final existingTopicIds = current.checklistItems
        .map((item) => item.topicId)
        .toSet();
    final newItems = topics
        .where((topic) => !existingTopicIds.contains(topic.topicId))
        .map(
          (topic) => LearningQuestChecklistItem(
            id: '${topic.topicId}-${now.microsecondsSinceEpoch}',
            topicId: topic.topicId,
            title: topic.title,
            sourceTitle: topic.sourceTitle,
          ),
        )
        .toList();

    _todayQuest = current.copyWith(
      checklistItems: [...current.checklistItems, ...newItems],
    );
    return _todayQuest!;
  }

  Future<LearningQuestModel?> toggleChecklistItem({
    required String itemId,
    required bool completed,
  }) async {
    await Future.delayed(const Duration(milliseconds: 80));

    final current = _todayQuest;
    if (current == null) return null;

    final items = current.checklistItems.map((item) {
      if (item.id != itemId) return item;
      return item.copyWith(completed: completed);
    }).toList();

    _todayQuest = current.copyWith(checklistItems: items);
    return _todayQuest;
  }

  Future<void> clearTodayLearningQuest() async {
    await Future.delayed(const Duration(milliseconds: 60));
    _todayQuest = null;
  }

  static String _dateKey(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
