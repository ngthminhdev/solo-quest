enum RewardType {
  rest,
  entertainment,
  food,
  shopping,
  learning,
  custom,
}

enum RewardStatus {
  locked,
  available,
  claimed,
}

extension RewardTypeX on RewardType {
  String get label {
    switch (this) {
      case RewardType.rest:
        return 'Nghỉ ngơi';
      case RewardType.entertainment:
        return 'Giải trí';
      case RewardType.food:
        return 'Ăn uống';
      case RewardType.shopping:
        return 'Mua sắm';
      case RewardType.learning:
        return 'Học tập';
      case RewardType.custom:
        return 'Tùy chỉnh';
    }
  }

  String get iconText {
    switch (this) {
      case RewardType.rest:
        return '🛋️';
      case RewardType.entertainment:
        return '🎮';
      case RewardType.food:
        return '🍕';
      case RewardType.shopping:
        return '🛍️';
      case RewardType.learning:
        return '📖';
      case RewardType.custom:
        return '🎁';
    }
  }
}

extension RewardStatusX on RewardStatus {
  String get label {
    switch (this) {
      case RewardStatus.locked:
        return 'Chưa mở';
      case RewardStatus.available:
        return 'Có thể nhận';
      case RewardStatus.claimed:
        return 'Đã nhận';
    }
  }
}
