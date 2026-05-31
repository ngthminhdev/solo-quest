class UserProfileModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final int level;
  final int currentLevelExp;
  final int nextLevelExp;
  final int totalExp;
  final int rewardPoints;
  final int streakDays;
  final int totalCompletedQuests;
  final List<String> mainGoals;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfileModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.level = 1,
    this.currentLevelExp = 0,
    this.nextLevelExp = 100,
    this.totalExp = 0,
    this.rewardPoints = 0,
    this.streakDays = 0,
    this.totalCompletedQuests = 0,
    this.mainGoals = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  double get levelProgress {
    if (nextLevelExp <= 0) return 0;
    return (currentLevelExp / nextLevelExp).clamp(0.0, 1.0);
  }

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    int? level,
    int? currentLevelExp,
    int? nextLevelExp,
    int? totalExp,
    int? rewardPoints,
    int? streakDays,
    int? totalCompletedQuests,
    List<String>? mainGoals,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      currentLevelExp: currentLevelExp ?? this.currentLevelExp,
      nextLevelExp: nextLevelExp ?? this.nextLevelExp,
      totalExp: totalExp ?? this.totalExp,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      streakDays: streakDays ?? this.streakDays,
      totalCompletedQuests: totalCompletedQuests ?? this.totalCompletedQuests,
      mainGoals: mainGoals ?? this.mainGoals,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      level: json['level'] as int? ?? 1,
      currentLevelExp: json['current_level_exp'] as int? ??
          json['current_exp'] as int? ??
          0,
      nextLevelExp: json['next_level_exp'] as int? ?? 100,
      totalExp: json['total_exp'] as int? ?? 0,
      rewardPoints: json['reward_points'] as int? ?? 0,
      streakDays: json['streak_days'] as int? ?? 0,
      totalCompletedQuests: json['total_completed_quests'] as int? ?? 0,
      mainGoals: (json['main_goals'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'level': level,
      'current_level_exp': currentLevelExp,
      'next_level_exp': nextLevelExp,
      'total_exp': totalExp,
      'reward_points': rewardPoints,
      'streak_days': streakDays,
      'total_completed_quests': totalCompletedQuests,
      'main_goals': mainGoals,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
