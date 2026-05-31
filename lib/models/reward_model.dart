import 'enums/reward_enums.dart';

class RewardModel {
  final String id;
  final String title;
  final String description;
  final RewardType type;
  final RewardStatus status;
  final int costPoints;
  final String iconText;
  final DateTime? claimedAt;

  const RewardModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.type,
    this.status = RewardStatus.available,
    this.costPoints = 50,
    this.iconText = '🎁',
    this.claimedAt,
  });

  RewardModel copyWith({
    String? id,
    String? title,
    String? description,
    RewardType? type,
    RewardStatus? status,
    int? costPoints,
    String? iconText,
    DateTime? claimedAt,
  }) {
    return RewardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      costPoints: costPoints ?? this.costPoints,
      iconText: iconText ?? this.iconText,
      claimedAt: claimedAt ?? this.claimedAt,
    );
  }

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      type: RewardType.values.byName(json['type'] as String),
      status: RewardStatus.values.byName(json['status'] as String? ?? 'available'),
      costPoints: json['cost_points'] as int? ??
          json['cost_exp'] as int? ??
          50,
      iconText: json['icon_text'] as String? ?? '🎁',
      claimedAt: json['claimed_at'] != null ? DateTime.parse(json['claimed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'status': status.name,
      'cost_points': costPoints,
      'icon_text': iconText,
      'claimed_at': claimedAt?.toIso8601String(),
    };
  }
}
