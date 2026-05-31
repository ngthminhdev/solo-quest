class DailyReviewConstants {
  DailyReviewConstants._();

  static const String pageTitle = 'Đánh Giá Cuối Ngày';
  static const String headerTitle = 'Đánh Giá Cuối Ngày';
  static const String headerSubtitle =
      'Phản hồi nhanh về hôm nay để SoloQuest điều chỉnh lịch và độ khó cho ngày mai.';

  static const String sectionDifficulty = 'Độ khó hôm nay';
  static const String sectionHelpful = 'Nhiệm vụ hữu ích nhất hôm nay';
  static const String sectionAnnoying = 'Nhiệm vụ gây khó chịu hoặc dễ bị bỏ qua';
  static const String sectionMood = 'Tâm trạng & năng lượng cuối ngày';
  static const String sectionTomorrow = 'Ngày mai bạn muốn điều chỉnh thế nào?';
  static const String sectionNote = 'Ghi chú thêm';
  static const String sectionInsight = 'SoloQuest sẽ điều chỉnh ngày mai';

  static const String labelMood = 'Tâm trạng cuối ngày';
  static const String labelEnergy = 'Năng lượng còn lại';
  static const String labelSatisfaction = 'Hài lòng với hôm nay';

  static const String energyLow = 'Gần hết';
  static const String energyHigh = 'Dồi dào';
  static const String satisLow = 'Kém';
  static const String satisHigh = 'Tuyệt vời';

  static const String noteHint =
      'Ví dụ: ngủ ít, bận đột xuất, học tốt hơn buổi tối, bị nhắc quá nhiều…';

  static const String submitText = 'Lưu Đánh Giá Hôm Nay';
  static const String updateText = 'Cập Nhật Đánh Giá';

  static const String toastMissing = 'Hãy chọn tâm trạng trước khi lưu đánh giá.';
  static const String toastSuccess = 'Đánh giá đã được lưu vào Nhật ký.';
  static const String toastFailed = 'Không thể lưu đánh giá. Vui lòng thử lại.';

  static const String linkToLogs = 'Đánh giá sẽ lưu vào Nhật ký để cải thiện đề xuất sau này.';
  static const String linkToWeekly = 'Xem Báo Cáo Tuần';

  // Difficulty options
  static const String diffLight = 'Quá nhẹ';
  static const String diffFit = 'Vừa sức';
  static const String diffHeavy = 'Quá nặng';

  // Helpful / Annoying quest chips
  static const List<String> questTypeChips = [
    'Learning',
    'Water',
    'Break',
    'Movement',
    'Sleep',
    'Reflection',
  ];

  static const List<String> annoyingExtraChips = [
    'Nhắc quá nhiều',
    'Thời điểm chưa phù hợp',
  ];

  // Tomorrow adjustment chips
  static const List<String> tomorrowChips = [
    'Nhẹ hơn hôm nay',
    'Giữ như hôm nay',
    'Thử thách hơn',
    'Tập trung học tập',
    'Tập trung sức khỏe',
    'Tập trung nghỉ ngơi',
  ];
}
