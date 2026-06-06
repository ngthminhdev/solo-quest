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

  // Global settings from backend API
  final String globalDifficulty;
  final bool autoAdjustEnabled;
  final List<String> enabledCategories;
  final String preferredDuration;
  final bool restDayEnabled;

  QuestRulesPageState({
    this.loadState = AppLoadState.idle,
    this.rules = const [],
    this.selectedType,
    this.dailyQuestLimit = 8,
    this.errorMessage,
    this.globalDifficulty = 'medium',
    this.autoAdjustEnabled = true,
    this.enabledCategories = const [],
    this.preferredDuration = 'medium',
    this.restDayEnabled = false,
    bool isLockedPage = false,
  }) : super(isLockedPage: isLockedPage);

  QuestRulesPageState copyWith({
    AppLoadState? loadState,
    List<QuestRuleModel>? rules,
    QuestType? selectedType,
    bool clearSelectedType = false,
    int? dailyQuestLimit,
    String? errorMessage,
    bool? isLockedPage,
    String? globalDifficulty,
    bool? autoAdjustEnabled,
    List<String>? enabledCategories,
    String? preferredDuration,
    bool? restDayEnabled,
  }) {
    return QuestRulesPageState(
      loadState: loadState ?? this.loadState,
      rules: rules ?? this.rules,
      selectedType:
          clearSelectedType ? null : selectedType ?? this.selectedType,
      dailyQuestLimit: dailyQuestLimit ?? this.dailyQuestLimit,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
      globalDifficulty: globalDifficulty ?? this.globalDifficulty,
      autoAdjustEnabled: autoAdjustEnabled ?? this.autoAdjustEnabled,
      enabledCategories: enabledCategories ?? this.enabledCategories,
      preferredDuration: preferredDuration ?? this.preferredDuration,
      restDayEnabled: restDayEnabled ?? this.restDayEnabled,
    );
  }

  @override
  QuestRulesPageState updateState({
    AppLoadState? loadState,
    List<QuestRuleModel>? rules,
    QuestType? selectedType,
    bool clearSelectedType = false,
    int? dailyQuestLimit,
    String? errorMessage,
    bool? isLockedPage,
    String? globalDifficulty,
    bool? autoAdjustEnabled,
    List<String>? enabledCategories,
    String? preferredDuration,
    bool? restDayEnabled,
  }) {
    return copyWith(
      loadState: loadState,
      rules: rules,
      selectedType: selectedType,
      clearSelectedType: clearSelectedType,
      dailyQuestLimit: dailyQuestLimit,
      errorMessage: errorMessage,
      isLockedPage: isLockedPage,
      globalDifficulty: globalDifficulty,
      autoAdjustEnabled: autoAdjustEnabled,
      enabledCategories: enabledCategories,
      preferredDuration: preferredDuration,
      restDayEnabled: restDayEnabled,
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

  String get globalDifficultyLabel {
    switch (globalDifficulty) {
      case 'easy':
        return QuestDifficulty.easy.label;
      case 'hard':
        return QuestDifficulty.hard.label;
      case 'medium':
      default:
        return QuestDifficulty.medium.label;
    }
  }

  String get preferredDurationLabel {
    switch (preferredDuration) {
      case 'short':
        return 'Ngắn';
      case 'long':
        return 'Dài';
      case 'medium':
      default:
        return 'Vừa';
    }
  }
}

class QuestRulesPageModel extends BasePageModel<QuestRulesPageState> {
  QuestRulesPageModel({
    required this.questRuleService,
    required this.logService,
  }) : super(QuestRulesPageState());

  final QuestRuleService questRuleService;
  final LogService logService;

  Future<void> loadSettings() async {
    try {
      state = state.updateState(loadState: AppLoadState.loading);

      final data = await questRuleService.loadSettings();

      state = state.updateState(
        loadState: AppLoadState.ready,
        rules: _sortRules(data.rules),
        dailyQuestLimit: data.dailyQuestCount,
        globalDifficulty: data.difficulty,
        autoAdjustEnabled: data.autoAdjustEnabled,
        enabledCategories: data.enabledCategories,
        preferredDuration: data.preferredDuration,
        restDayEnabled: data.restDayEnabled,
        errorMessage: null,
        isLockedPage: false,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.toString(),
        isLockedPage: false,
      );
    }
  }

  Future<void> refreshSettings() async {
    try {
      final data = await questRuleService.loadSettings();

      state = state.updateState(
        loadState: AppLoadState.ready,
        rules: _sortRules(data.rules),
        dailyQuestLimit: data.dailyQuestCount,
        globalDifficulty: data.difficulty,
        autoAdjustEnabled: data.autoAdjustEnabled,
        enabledCategories: data.enabledCategories,
        preferredDuration: data.preferredDuration,
        restDayEnabled: data.restDayEnabled,
        errorMessage: null,
        isLockedPage: false,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.toString(),
        isLockedPage: false,
      );
    }
  }

  Future<bool> toggleRule({
    required String ruleId,
    required bool enabled,
  }) async {
    try {
      state = state.updateState(isLockedPage: true);

      final rule = state.rules.firstWhere((r) => r.id == ruleId);
      final updated = rule.copyWith(enabled: enabled);

      await questRuleService.updateSettings(
        QuestSettingsDataUpdate(ruleUpdate: updated),
      );

      await _addLog(
        title: enabled ? 'Bật luật quest' : 'Tắt luật quest',
        description: updated.title,
        questType: updated.type,
      );

      await loadSettings();
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

      await questRuleService.updateSettings(
        QuestSettingsDataUpdate(ruleUpdate: rule),
      );

      await _addLog(
        title: 'Cập nhật luật quest',
        description: rule.title,
        questType: rule.type,
      );

      await loadSettings();
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

      await questRuleService.updateSettings(
        QuestSettingsDataUpdate(dailyQuestCount: limit),
      );

      await _addLog(
        title: 'Cập nhật giới hạn quest/ngày',
        description: '$limit quest',
      );

      await loadSettings();
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

  Future<bool> updateGlobalDifficulty(String difficulty) async {
    try {
      state = state.updateState(isLockedPage: true);
      await questRuleService.updateSettings(
        QuestSettingsDataUpdate(difficulty: difficulty),
      );
      await loadSettings();
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

  Future<bool> toggleAutoAdjust(bool enabled) async {
    try {
      state = state.updateState(isLockedPage: true);
      await questRuleService.updateSettings(
        QuestSettingsDataUpdate(autoAdjustEnabled: enabled),
      );
      await loadSettings();
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

  Future<bool> toggleRestDay(bool enabled) async {
    try {
      state = state.updateState(isLockedPage: true);
      await questRuleService.updateSettings(
        QuestSettingsDataUpdate(restDayEnabled: enabled),
      );
      await loadSettings();
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

  Future<bool> updatePreferredDuration(String duration) async {
    try {
      state = state.updateState(isLockedPage: true);
      await questRuleService.updateSettings(
        QuestSettingsDataUpdate(preferredDuration: duration),
      );
      await loadSettings();
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

      await questRuleService.resetToDefaultSettings();

      await _addLog(
        title: 'Khôi phục luật mặc định',
        description: 'Bộ luật tạo quest',
      );

      await loadSettings();
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
    if (type == null) {
      state = state.updateState(clearSelectedType: true);
    } else {
      state = state.updateState(selectedType: type);
    }
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
