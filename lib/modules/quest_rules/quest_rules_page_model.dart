import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/enums/log_enums.dart';
import '../../models/enums/quest_enums.dart';
import '../../models/log_entry_model.dart';
import '../../models/quest_rule_model.dart';
import '../../services/log_service.dart';
import '../../services/quest_rule_service.dart';
import '../../services/service_providers.dart';

class QuestRulesPageState extends BasePageState {
  final AppLoadState loadState;
  final List<QuestRuleModel> rules;
  final QuestType? selectedType;
  final int dailyQuestLimit;
  final String? errorMessage;

  QuestRulesPageState({
    this.loadState = AppLoadState.idle,
    this.rules = const [],
    this.selectedType,
    this.dailyQuestLimit = 8,
    this.errorMessage,
    super.isLockedPage,
  });

  @override
  QuestRulesPageState updateState({
    AppLoadState? loadState,
    List<QuestRuleModel>? rules,
    QuestType? selectedType,
    bool clearSelectedType = false,
    int? dailyQuestLimit,
    String? errorMessage,
    bool? isLockedPage,
  }) {
    return QuestRulesPageState(
      loadState: loadState ?? this.loadState,
      rules: rules ?? this.rules,
      selectedType: clearSelectedType
          ? null
          : selectedType ?? this.selectedType,
      dailyQuestLimit: dailyQuestLimit ?? this.dailyQuestLimit,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  List<QuestRuleModel> get filteredRules {
    if (selectedType == null) return rules;
    return rules.where((rule) => rule.type == selectedType).toList();
  }

  int get totalRules => rules.length;

  int get enabledCount => rules.where((rule) => rule.enabled).length;

  int get disabledCount => rules.where((rule) => !rule.enabled).length;

  bool get hasRules => rules.isNotEmpty;
}

class QuestRulesPageModel extends BasePageModel<QuestRulesPageState> {
  QuestRulesPageModel({
    required this.questRuleService,
    required this.logService,
  }) : super(QuestRulesPageState());

  final QuestRuleService questRuleService;
  final LogService logService;

  Future<void> loadRules() async {
    try {
      state = state.updateState(loadState: AppLoadState.loading);

      final rules = await questRuleService.getQuestRules();
      final dailyLimit = await questRuleService.getDailyQuestLimit();

      state = state.updateState(
        loadState: AppLoadState.ready,
        rules: _sortRules(rules),
        dailyQuestLimit: dailyLimit,
        errorMessage: null,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshRules() async {
    try {
      final rules = await questRuleService.getQuestRules();
      final dailyLimit = await questRuleService.getDailyQuestLimit();

      state = state.updateState(
        loadState: AppLoadState.ready,
        rules: _sortRules(rules),
        dailyQuestLimit: dailyLimit,
        errorMessage: null,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> toggleRule({
    required String ruleId,
    required bool enabled,
  }) async {
    try {
      state = state.updateState(isLockedPage: true);

      final updated = await questRuleService.toggleQuestRule(
        ruleId: ruleId,
        enabled: enabled,
      );

      await _addLog(
        title: enabled ? 'Bật luật quest' : 'Tắt luật quest',
        description: updated.title,
        questType: updated.type,
      );

      await loadRules();
      state = state.updateState(isLockedPage: false);
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateRule(QuestRuleModel rule) async {
    try {
      state = state.updateState(isLockedPage: true);

      final updated = await questRuleService.updateQuestRule(rule);

      await _addLog(
        title: 'Cập nhật luật quest',
        description: updated.title,
        questType: updated.type,
      );

      await loadRules();
      state = state.updateState(isLockedPage: false);
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateDailyLimit(int limit) async {
    if (limit < 1 || limit > 20) return false;

    try {
      state = state.updateState(isLockedPage: true);

      await questRuleService.updateDailyQuestLimit(limit);
      await _addLog(
        title: 'Cập nhật giới hạn quest/ngày',
        description: '$limit quest',
      );

      await loadRules();
      state = state.updateState(isLockedPage: false);
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> resetToDefaultRules() async {
    try {
      state = state.updateState(isLockedPage: true);

      await questRuleService.resetToDefaultRules();
      await _addLog(
        title: 'Khôi phục luật mặc định',
        description: 'Bộ luật tạo quest',
      );

      await loadRules();
      state = state.updateState(isLockedPage: false);
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void selectType(QuestType? type) {
    state = state.updateState(selectedType: type);
  }

  void clearTypeFilter() {
    state = state.updateState(clearSelectedType: true);
  }

  List<QuestRuleModel> _sortRules(List<QuestRuleModel> rules) {
    final sorted = List<QuestRuleModel>.from(rules);
    sorted.sort((a, b) {
      if (a.enabled != b.enabled) return a.enabled ? -1 : 1;
      if (a.priority != b.priority) return b.priority.compareTo(a.priority);
      return a.type.index.compareTo(b.type.index);
    });
    return sorted;
  }

  Future<void> _addLog({
    required String title,
    required String description,
    QuestType? questType,
  }) {
    return logService.addLog(
      LogEntryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: LogEntryType.ruleUpdated,
        title: title,
        description: description,
        questType: questType,
        createdAt: DateTime.now(),
      ),
    );
  }
}

final questRulesPageProvider =
    StateNotifierProvider<QuestRulesPageModel, QuestRulesPageState>((ref) {
      return QuestRulesPageModel(
        questRuleService: ref.read(questRuleServiceProvider),
        logService: ref.read(logServiceProvider),
      );
    });
