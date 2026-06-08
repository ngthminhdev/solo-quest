import '../core/utils/app_time_formatter.dart';
import 'enums/quest_enums.dart';

class QuestModel {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final QuestStatus status;
  final QuestDifficulty difficulty;
  final QuestSource source;
  final int exp;
  final int estimatedMinutes;
  final DateTime? scheduledAt;
  final DateTime? dueDate;
  final DateTime? reminderTime;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? snoozedUntil;
  final String? reason;
  final String? instruction;
  final List<String> tags;
  final bool isImportant;

  const QuestModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.type,
    this.status = QuestStatus.pending,
    this.difficulty = QuestDifficulty.medium,
    this.source = QuestSource.dailyPlan,
    this.exp = 10,
    this.estimatedMinutes = 5,
    this.scheduledAt,
    this.dueDate,
    this.reminderTime,
    this.startedAt,
    this.completedAt,
    this.snoozedUntil,
    this.reason,
    this.instruction,
    this.tags = const [],
    this.isImportant = false,
  });

  bool get isCompleted => status == QuestStatus.completed;
  bool get isActive => status == QuestStatus.active;
  bool get isPending => status == QuestStatus.pending;
  bool get isSnoozed => status == QuestStatus.snoozed;
  bool get isSkipped => status == QuestStatus.skipped;

  /// Returns quest display time label with prefix.
  /// Priority:
  /// 1. If snoozed: "Hoãn đến HH:mm"
  /// 2. If reminderTime exists: "Nhắc HH:mm"
  /// 3. Else: "Linh hoạt"
  String get displayTimeLabel {
    final snoozed = AppTimeFormatter.formatSnoozedUntil(snoozedUntil);
    if (snoozed != null) return snoozed;
    final reminder = AppTimeFormatter.formatReminderTime(reminderTime);
    if (reminder != null) return reminder;
    return 'Linh hoạt';
  }

  /// Returns raw time (HH:mm) for display, or null if no time exists.
  /// Priority: snoozedUntil > reminderTime > null
  /// UI should hide time display when this returns null.
  String? get displayTime {
    return AppTimeFormatter.formatQuestActiveTime(snoozedUntil, reminderTime);
  }

  QuestModel copyWith({
    String? id,
    String? title,
    String? description,
    QuestType? type,
    QuestStatus? status,
    QuestDifficulty? difficulty,
    QuestSource? source,
    int? exp,
    int? estimatedMinutes,
    DateTime? scheduledAt,
    DateTime? dueDate,
    DateTime? reminderTime,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? snoozedUntil,
    String? reason,
    String? instruction,
    List<String>? tags,
    bool? isImportant,
  }) {
    return QuestModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      source: source ?? this.source,
      exp: exp ?? this.exp,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      dueDate: dueDate ?? this.dueDate,
      reminderTime: reminderTime ?? this.reminderTime,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      reason: reason ?? this.reason,
      instruction: instruction ?? this.instruction,
      tags: tags ?? this.tags,
      isImportant: isImportant ?? this.isImportant,
    );
  }

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      type: QuestType.values.byName(json['type'] as String),
      status: QuestStatus.values.byName(json['status'] as String? ?? 'pending'),
      difficulty: QuestDifficulty.values.byName(json['difficulty'] as String? ?? 'medium'),
      source: QuestSource.values.byName(json['source'] as String? ?? 'dailyPlan'),
      exp: json['exp'] as int? ?? 10,
      estimatedMinutes: json['estimated_minutes'] as int? ?? 5,
      scheduledAt: json['scheduled_at'] != null ? DateTime.parse(json['scheduled_at'] as String) : null,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      reminderTime: json['reminder_time'] != null ? DateTime.parse(json['reminder_time'] as String) : null,
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      snoozedUntil: json['snoozed_until'] != null ? DateTime.parse(json['snoozed_until'] as String) : null,
      reason: json['reason'] as String?,
      instruction: json['instruction'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      isImportant: json['is_important'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'status': status.name,
      'difficulty': difficulty.name,
      'source': source.name,
      'exp': exp,
      'estimated_minutes': estimatedMinutes,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'reminder_time': reminderTime?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'snoozed_until': snoozedUntil?.toIso8601String(),
      'reason': reason,
      'instruction': instruction,
      'tags': tags,
      'is_important': isImportant,
    };
  }
}

bool isCountdownEligible(QuestModel quest) {
  if (quest.type == QuestType.water) return false;
  if (quest.status == QuestStatus.completed ||
      quest.status == QuestStatus.skipped ||
      quest.status == QuestStatus.snoozed) {
    return false;
  }
  return quest.estimatedMinutes > 0;
}
