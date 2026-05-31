import '../models/quest_model.dart';
import '../models/enums/quest_enums.dart';
import 'mock/mock_quest_data.dart';

class QuestService {
  late List<QuestModel> _quests;

  QuestService() {
    _quests = MockQuestData.todayQuests.map((q) => q).toList();
  }

  Future<List<QuestModel>> getTodayQuests() async {
    return List.from(_quests);
  }

  Future<QuestModel?> getQuestById(String id) async {
    try {
      return _quests.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<QuestModel>> getActiveQuests() async {
    return _quests.where((q) => q.isActive || q.isPending).toList();
  }

  Future<List<QuestModel>> getUpcomingQuests() async {
    return _quests.where((q) => q.isPending).toList();
  }

  Future<List<QuestModel>> getCompletedQuests() async {
    return _quests.where((q) => q.isCompleted).toList();
  }

  Future<QuestModel> startQuest(String questId) async {
    final index = _quests.indexWhere((q) => q.id == questId);
    if (index == -1) throw Exception('Quest not found');
    _quests[index] = _quests[index].copyWith(
      status: QuestStatus.active,
      startedAt: DateTime.now(),
    );
    return _quests[index];
  }

  Future<QuestModel> completeQuest(String questId, {String? note, String? mood}) async {
    final index = _quests.indexWhere((q) => q.id == questId);
    if (index == -1) throw Exception('Quest not found');
    _quests[index] = _quests[index].copyWith(
      status: QuestStatus.completed,
      completedAt: DateTime.now(),
    );
    return _quests[index];
  }

  Future<QuestModel> snoozeQuest(String questId, {required int minutes}) async {
    final index = _quests.indexWhere((q) => q.id == questId);
    if (index == -1) throw Exception('Quest not found');
    _quests[index] = _quests[index].copyWith(
      status: QuestStatus.snoozed,
      snoozedUntil: DateTime.now().add(Duration(minutes: minutes)),
    );
    return _quests[index];
  }

  Future<QuestModel> skipQuest(String questId, {required String reason}) async {
    final index = _quests.indexWhere((q) => q.id == questId);
    if (index == -1) throw Exception('Quest not found');
    _quests[index] = _quests[index].copyWith(
      status: QuestStatus.skipped,
      reason: reason,
    );
    return _quests[index];
  }
}
