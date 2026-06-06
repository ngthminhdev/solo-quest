/// XP transaction model for displaying XP history
class XPTransactionModel {
  final String id;
  final String type;
  final int amount;
  final String? questId;
  final String? questTitle;
  final String description;
  final DateTime createdAt;

  const XPTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    this.questId,
    this.questTitle,
    required this.description,
    required this.createdAt,
  });

  bool get isPositive => amount > 0;

  factory XPTransactionModel.fromJson(Map<String, dynamic> json) {
    return XPTransactionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: json['amount'] as int? ?? 0,
      questId: json['quest_id'] as String?,
      questTitle: json['quest_title'] as String?,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'quest_id': questId,
      'quest_title': questTitle,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// XP history list with pagination info
class XPHistoryModel {
  final List<XPTransactionModel> transactions;
  final int total;
  final int limit;
  final int offset;

  const XPHistoryModel({
    required this.transactions,
    required this.total,
    required this.limit,
    required this.offset,
  });

  bool get hasMore => offset + transactions.length < total;

  factory XPHistoryModel.fromJson(Map<String, dynamic> json) {
    final transactions = <XPTransactionModel>[];
    if (json['transactions'] != null) {
      for (final item in json['transactions'] as List<dynamic>) {
        transactions.add(XPTransactionModel.fromJson(item as Map<String, dynamic>));
      }
    }

    return XPHistoryModel(
      transactions: transactions,
      total: json['total'] as int? ?? 0,
      limit: json['limit'] as int? ?? 20,
      offset: json['offset'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'total': total,
      'limit': limit,
      'offset': offset,
    };
  }
}
