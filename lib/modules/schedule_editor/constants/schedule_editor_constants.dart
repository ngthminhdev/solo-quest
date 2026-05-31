class ScheduleEditorConstants {
  static const String pageTitle = 'Lịch sinh hoạt';
  static const String pageSubtitle = 'Cho SoloQuest biết khi nào bạn làm việc, học tập và nghỉ ngơi.';

  static const String sectionTitle = 'Các khung thời gian';
  static const String addBlockButton = 'Thêm block';

  static const String emptyTitle = 'Chưa có lịch sinh hoạt';
  static const String emptyMessage = 'Thêm khung thời gian đầu tiên để SoloQuest gợi ý quest đúng lúc hơn.';

  static const String formTitleAdd = 'Thêm block';
  static const String formTitleEdit = 'Sửa block';

  static const String labelTitle = 'Tên block';
  static const String labelType = 'Loại block';
  static const String labelStartTime = 'Giờ bắt đầu';
  static const String labelEndTime = 'Giờ kết thúc';
  static const String labelWeekdays = 'Ngày áp dụng';
  static const String labelFlexible = 'Linh hoạt';

  static const String badgeFixed = 'Cố định';
  static const String badgeFlexible = 'Linh hoạt';

  static const String deleteConfirmTitle = 'Xóa block?';
  static const String deleteConfirmMessage = 'Bạn có chắc muốn xóa block này không?';

  static const String toastAddSuccess = 'Đã thêm block';
  static const String toastAddFailed = 'Không thể thêm block';
  static const String toastUpdateSuccess = 'Đã cập nhật block';
  static const String toastUpdateFailed = 'Không thể cập nhật block';
  static const String toastDeleteSuccess = 'Đã xóa block';
  static const String toastDeleteFailed = 'Không thể xóa block';

  static const String errorTitleRequired = 'Vui lòng nhập tên block';
  static const String errorTimeRequired = 'Vui lòng chọn giờ';
  static const String errorWeekdaysRequired = 'Vui lòng chọn ít nhất 1 ngày';

  static const Map<String, String> blockTypes = {
    'work': 'Làm việc',
    'study': 'Học tập',
    'sleep': 'Ngủ nghỉ',
    'exercise': 'Tập luyện',
    'meal': 'Ăn uống',
    'freeTime': 'Thời gian rảnh',
    'personal': 'Cá nhân',
    'other': 'Khác',
  };

  static const Map<int, String> weekdayLabels = {
    1: 'T2',
    2: 'T3',
    3: 'T4',
    4: 'T5',
    5: 'T6',
    6: 'T7',
    7: 'CN',
  };
}
