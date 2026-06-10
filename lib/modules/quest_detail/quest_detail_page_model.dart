import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/quest_model.dart';
import '../../models/log_entry_model.dart';
import '../../models/enums/log_enums.dart';
import '../../services/quest_service.dart';
import '../../services/log_service.dart';
import '../../services/progress_service.dart';
import '../../services/service_providers.dart';

class QuestDetailPageState extends BasePageState {
  final AppLoadState loadState;
  final QuestModel? quest;
  final List<LogEntryModel> logs;
  final String? errorMessage;

  QuestDetailPageState({
    this.loadState = AppLoadState.idle,
    this.quest,
    this.logs = const [],
    this.errorMessage,
    super.isLockedPage,
  });

  bool get hasQuest => quest != null;

  @override
  QuestDetailPageState updateState({
    AppLoadState? loadState,
    QuestModel? quest,
    List<LogEntryModel>? logs,
    String? errorMessage,
    bool? isLockedPage,
  }) {
    return QuestDetailPageState(
      loadState: loadState ?? this.loadState,
      quest: quest ?? this.quest,
      logs: logs ?? this.logs,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }
}

class QuestDetailPageModel extends BasePageModel<QuestDetailPageState> {
  QuestDetailPageModel({
    required this.questService,
    required this.logService,
    required this.progressService,
  }) : super(QuestDetailPageState());

  final QuestService questService;
  final LogService logService;
  final ProgressService progressService;
  int _loadRequestVersion = 0;

  Future<void> loadQuest(String questId, {QuestModel? initialQuest}) async {
    final requestVersion = ++_loadRequestVersion;
    final cachedQuest = initialQuest?.id == questId ? initialQuest : null;

    if (questId.isEmpty) {
      state = QuestDetailPageState(
        loadState: AppLoadState.error,
        errorMessage: 'Không tìm thấy nhiệm vụ',
      );
      return;
    }

    state = QuestDetailPageState(
      loadState: AppLoadState.loading,
      quest: cachedQuest,
    );

    try {
      final quest = await questService.getQuestById(questId);
      if (requestVersion != _loadRequestVersion) return;

      if (quest == null) {
        state = cachedQuest == null
            ? QuestDetailPageState(
                loadState: AppLoadState.error,
                errorMessage: 'Không tìm thấy nhiệm vụ',
              )
            : state.updateState(
                loadState: AppLoadState.error,
                errorMessage: 'Không thể cập nhật nhiệm vụ',
              );
        return;
      }

      final logs = await logService.getQuestLogs(questId);
      if (requestVersion != _loadRequestVersion) return;

      state = state.updateState(
        loadState: AppLoadState.ready,
        quest: quest,
        logs: logs,
      );
    } catch (e) {
      if (requestVersion != _loadRequestVersion) return;

      state = cachedQuest == null
          ? QuestDetailPageState(
              loadState: AppLoadState.error,
              errorMessage: 'Không thể tải nhiệm vụ: ${e.toString()}',
            )
          : state.updateState(
              loadState: AppLoadState.error,
              errorMessage: 'Không thể cập nhật nhiệm vụ: ${e.toString()}',
            );
    }
  }

  Future<void> startQuest() async {
    if (state.quest == null) return;

    state = state.updateState(isLockedPage: true);
    try {
      final updatedQuest = await questService.startQuest(state.quest!.id);

      await logService.addLog(LogEntryModel(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        type: LogEntryType.questStarted,
        title: 'Bắt đầu nhiệm vụ',
        description: state.quest!.title,
        createdAt: DateTime.now(),
        questId: state.quest!.id,
        questType: state.quest!.type,
      ));

      final logs = await logService.getQuestLogs(state.quest!.id);

      state = state.updateState(
        quest: updatedQuest,
        logs: logs,
      );
    } catch (e) {
      state = state.updateState(
        errorMessage: 'Không thể bắt đầu nhiệm vụ',
      );
      rethrow;
    } finally {
      state = state.updateState(isLockedPage: false);
    }
  }

  Future<void> completeQuest({String? note, LogMood? mood}) async {
    if (state.quest == null) return;

    state = state.updateState(isLockedPage: true);
    try {
      final updatedQuest = await questService.completeQuest(
        state.quest!.id,
        note: note,
        mood: mood?.name,
      );

      if (updatedQuest.exp > 0) {
        await progressService.addQuestReward(
          exp: updatedQuest.exp,
          points: updatedQuest.exp,
        );
      }

      await logService.addLog(LogEntryModel(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        type: LogEntryType.questCompleted,
        title: 'Hoàn thành nhiệm vụ',
        description: state.quest!.title,
        createdAt: DateTime.now(),
        questId: state.quest!.id,
        questType: state.quest!.type,
        expChanged: state.quest!.exp,
        mood: mood,
      ));

      final logs = await logService.getQuestLogs(state.quest!.id);

      state = state.updateState(
        quest: updatedQuest,
        logs: logs,
      );
    } catch (e) {
      state = state.updateState(
        errorMessage: 'Không thể hoàn thành nhiệm vụ',
      );
      rethrow;
    } finally {
      state = state.updateState(isLockedPage: false);
    }
  }

  Future<void> snoozeQuest({required int minutes}) async {
    if (state.quest == null) return;

    state = state.updateState(isLockedPage: true);
    try {
      final updatedQuest = await questService.snoozeQuest(
        state.quest!.id,
        minutes: minutes,
      );

      await logService.addLog(LogEntryModel(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        type: LogEntryType.questSnoozed,
        title: 'Đã hoãn nhiệm vụ',
        description: '${state.quest!.title} - $minutes phút',
        createdAt: DateTime.now(),
        questId: state.quest!.id,
        questType: state.quest!.type,
        metadata: {'snooze_minutes': minutes},
      ));

      final logs = await logService.getQuestLogs(state.quest!.id);

      state = state.updateState(
        quest: updatedQuest,
        logs: logs,
      );
    } catch (e) {
      state = state.updateState(
        errorMessage: 'Không thể hoãn nhiệm vụ',
      );
      rethrow;
    } finally {
      state = state.updateState(isLockedPage: false);
    }
  }

  Future<void> skipQuest({required String reason}) async {
    if (state.quest == null) return;

    state = state.updateState(isLockedPage: true);
    try {
      final updatedQuest = await questService.skipQuest(
        state.quest!.id,
        reason: reason,
      );

      await logService.addLog(LogEntryModel(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        type: LogEntryType.questSkipped,
        title: 'Đã bỏ qua nhiệm vụ',
        description: '${state.quest!.title} - $reason',
        createdAt: DateTime.now(),
        questId: state.quest!.id,
        questType: state.quest!.type,
        metadata: {'reason': reason},
      ));

      final logs = await logService.getQuestLogs(state.quest!.id);

      state = state.updateState(
        quest: updatedQuest,
        logs: logs,
      );
    } catch (e) {
      state = state.updateState(
        errorMessage: 'Không thể bỏ qua nhiệm vụ',
      );
      rethrow;
    } finally {
      state = state.updateState(isLockedPage: false);
    }
  }
}

final questDetailPageProvider =
    StateNotifierProvider<QuestDetailPageModel, QuestDetailPageState>((ref) {
  return QuestDetailPageModel(
    questService: ref.read(questServiceProvider),
    logService: ref.read(logServiceProvider),
    progressService: ref.read(progressServiceProvider),
  );
});
