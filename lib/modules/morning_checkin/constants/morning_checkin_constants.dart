class MorningCheckinConstants {
  MorningCheckinConstants._();

  static const String pageTitle = 'Check-in buổi sáng';
  static const String headerTitle = 'Chào buổi sáng';
  static const String headerSubtitle =
      'Hãy dành 30 giây để app hiểu hôm nay của bạn.';

  static const String stepTitle = 'Check-in hôm nay';

  static const String energyLabel = 'Năng lượng hôm nay';
  static const String stressLabel = 'Mức stress';
  static const String focusLabel = 'Khả năng tập trung';
  static const String dayIntensityLabel = 'Mức độ bận';
  static const String mainFocusLabel = 'Hôm nay bạn muốn tập trung vào điều gì?';
  static const String mainFocusHint =
      'Ví dụ: học Flutter, hoàn thành task công ty, nghỉ ngơi tốt hơn...';
  static const String timeBlocksLabel = 'Khung thời gian rảnh';
  static const String noteLabel = 'Ghi chú thêm';
  static const String noteHint = 'Có điều gì app nên biết về hôm nay không?';

  static const String submitText = 'Hoàn tất check-in';
  static const String updateText = 'Cập nhật check-in';

  static const String toastMissing =
      'Hãy chọn năng lượng, stress, focus và mức độ bận hôm nay.';
  static const String toastSuccess = 'Check-in hoàn tất!';
  static const String toastFailed = 'Không thể lưu check-in';

  static const List<String> timeBlockOptions = [
    'Sáng sớm',
    'Buổi sáng',
    'Giờ nghỉ trưa',
    'Buổi chiều',
    'Sau giờ làm',
    'Buổi tối',
    'Trước khi ngủ',
  ];
}
