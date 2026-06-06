import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

import '../core/api/dto/quest_dto.dart';
import '../core/api/services/quest_api_service.dart';
import '../core/utils/app_time_formatter.dart';
import '../models/quest_model.dart';

class QuestService {
  final QuestApiService _apiService;

  QuestService({QuestApiService? apiService})
      : _apiService = apiService ?? QuestApiService();

  /// Convert QuestDto to QuestModel
  QuestModel _dtoToModel(QuestDto dto) {
    return QuestModel(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      type: dto.type,
      status: dto.status,
      difficulty: dto.difficulty,
      source: dto.source,
      exp: dto.exp,
      estimatedMinutes: dto.estimatedMinutes,
      scheduledAt: dto.scheduledAt,
      dueDate: dto.dueDate,
      reminderTime: dto.reminderTime,
      startedAt: dto.startedAt,
      completedAt: dto.completedAt,
      snoozedUntil: dto.snoozedUntil,
      reason: dto.reason,
      instruction: dto.instruction,
      tags: dto.tags,
      isImportant: dto.isImportant,
    );
  }

  Future<List<QuestModel>> getTodayQuests() async {
    try {
      final dateStr = AppTimeFormatter.todayLocalDateQuery();
      if (kDebugMode) {
        developer.log('[QuestService] loading quests for localDate=$dateStr');
      }
      final dtos = await _apiService.getQuests(date: dateStr);
      return dtos.map(_dtoToModel).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<QuestModel?> getQuestById(String id) async {
    try {
      // Get all quests and find by ID
      // Backend doesn't have a single quest endpoint yet
      final quests = await getTodayQuests();
      return quests.where((q) => q.id == id).firstOrNull;
    } catch (_) {
      return null;
    }
  }

  Future<List<QuestModel>> getActiveQuests() async {
    final quests = await getTodayQuests();
    return quests.where((q) => q.isActive || q.isPending).toList();
  }

  Future<List<QuestModel>> getUpcomingQuests() async {
    final quests = await getTodayQuests();
    return quests.where((q) => q.isPending).toList();
  }

  Future<List<QuestModel>> getCompletedQuests() async {
    final quests = await getTodayQuests();
    return quests.where((q) => q.isCompleted).toList();
  }

  Future<QuestModel> startQuest(String questId) async {
    final dto = await _apiService.startQuest(questId);
    return _dtoToModel(dto);
  }

  Future<QuestModel> completeQuest(String questId, {String? note, String? mood}) async {
    final result = await _apiService.completeQuest(questId, note: note);
    return _dtoToModel(result.quest);
  }

  Future<QuestModel> snoozeQuest(String questId, {required int minutes}) async {
    final dto = await _apiService.snoozeQuest(questId, minutes: minutes);
    return _dtoToModel(dto);
  }

  Future<QuestModel> skipQuest(String questId, {required String reason}) async {
    final dto = await _apiService.skipQuest(questId, reason: reason);
    return _dtoToModel(dto);
  }
}
