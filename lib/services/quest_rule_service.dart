import '../models/enums/quest_enums.dart';
import '../models/quest_rule_model.dart';
import '../models/schedule_model.dart';

class QuestRuleService {
  static List<QuestRuleModel>? _rules;
  static int _dailyQuestLimit = 8;

  QuestRuleService() {
    _rules ??= _defaultRules();
  }

  Future<List<QuestRuleModel>> getQuestRules() async {
    return List<QuestRuleModel>.from(_rules ?? _defaultRules());
  }

  Future<QuestRuleModel> updateQuestRule(QuestRuleModel rule) async {
    final rules = _rules ??= _defaultRules();
    final index = rules.indexWhere((item) => item.id == rule.id);
    if (index == -1) {
      throw Exception('Quest rule not found');
    }
    rules[index] = rule;
    return rules[index];
  }

  Future<QuestRuleModel> toggleQuestRule({
    required String ruleId,
    required bool enabled,
  }) async {
    final rules = _rules ??= _defaultRules();
    final index = rules.indexWhere((item) => item.id == ruleId);
    if (index == -1) {
      throw Exception('Quest rule not found');
    }
    rules[index] = rules[index].copyWith(enabled: enabled);
    return rules[index];
  }

  Future<void> updateDailyQuestLimit(int limit) async {
    if (limit < 1 || limit > 20) {
      throw Exception('Daily quest limit must be between 1 and 20');
    }
    _dailyQuestLimit = limit;
  }

  Future<int> getDailyQuestLimit() async {
    return _dailyQuestLimit;
  }

  Future<void> resetToDefaultRules() async {
    _rules = _defaultRules();
    _dailyQuestLimit = 8;
  }

  static List<QuestRuleModel> _defaultRules() {
    return const [
      QuestRuleModel(
        id: 'rule_water',
        type: QuestType.water,
        title: 'Uống nước',
        description: 'Nhắc uống nước đều trong ngày để giữ năng lượng ổn định.',
        difficulty: QuestDifficulty.easy,
        minIntervalMinutes: 90,
        maxPerDay: 8,
        activeTimeRange: TimeRangeModel(start: '08:00', end: '22:00'),
        priority: 5,
      ),
      QuestRuleModel(
        id: 'rule_break_time',
        type: QuestType.breakTime,
        title: 'Nghỉ mắt',
        description: 'Tạo nhịp nghỉ ngắn để giảm mỏi mắt và căng thẳng.',
        difficulty: QuestDifficulty.easy,
        minIntervalMinutes: 90,
        maxPerDay: 6,
        activeTimeRange: TimeRangeModel(start: '09:00', end: '18:00'),
        priority: 5,
      ),
      QuestRuleModel(
        id: 'rule_movement',
        type: QuestType.movement,
        title: 'Vận động',
        description: 'Gợi ý đứng dậy, đi bộ hoặc giãn cơ trong ngày làm việc.',
        difficulty: QuestDifficulty.medium,
        minIntervalMinutes: 180,
        maxPerDay: 3,
        activeTimeRange: TimeRangeModel(start: '10:00', end: '20:00'),
        priority: 4,
      ),
      QuestRuleModel(
        id: 'rule_learning',
        type: QuestType.learning,
        title: 'Học tập',
        description: 'Ưu tiên phiên học tập ngắn vào khung giờ dễ tập trung.',
        difficulty: QuestDifficulty.medium,
        minIntervalMinutes: 240,
        maxPerDay: 2,
        activeTimeRange: TimeRangeModel(start: '19:00', end: '22:00'),
        priority: 4,
      ),
      QuestRuleModel(
        id: 'rule_sleep',
        type: QuestType.sleep,
        title: 'Ngủ nghỉ',
        description: 'Giữ nhịp thư giãn cuối ngày và chuẩn bị ngủ đúng giờ.',
        difficulty: QuestDifficulty.easy,
        maxPerDay: 1,
        activeTimeRange: TimeRangeModel(start: '22:00', end: '23:30'),
        priority: 3,
      ),
      QuestRuleModel(
        id: 'rule_review',
        type: QuestType.review,
        title: 'Daily Review',
        description:
            'Nhắc tổng kết ngày, ghi nhận tiến trình và điều chỉnh mục tiêu.',
        difficulty: QuestDifficulty.easy,
        maxPerDay: 1,
        activeTimeRange: TimeRangeModel(start: '21:00', end: '23:00'),
        priority: 3,
      ),
    ];
  }
}
