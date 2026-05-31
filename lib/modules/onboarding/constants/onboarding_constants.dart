class OnboardingConstants {
  static const int totalSteps = 9;

  static const String progressLabel = 'Bước';

  // Step 0 - Welcome
  static const String step0Title = 'Thiết Lập Hành Trình';
  static const String step0Subtitle =
      'SoloQuest sẽ tạo nhiệm vụ cá nhân hóa dựa trên thông tin của bạn. Quy trình gồm 8 bước.';
  static const String step0Hint = 'Mất khoảng 2 phút. Bạn có thể chỉnh lại sau.';
  static const String startLabel = 'Bắt đầu thiết lập';
  static const List<String> step0Steps = [
    'Thông tin cá nhân',
    'Công việc & lịch trình',
    'Sức khỏe & thể chất',
    'Mục tiêu cá nhân',
    'Lịch trình hàng ngày',
    'Nhắc nhở',
    'Phần thưởng',
  ];

  // Step 1 - Basic Info
  static const String step1Title = 'Thông Tin Cá Nhân';
  static const String step1Subtitle =
      'Hệ thống cần dữ liệu cơ bản để tính toán nhiệm vụ phù hợp';
  static const String displayNameLabel = 'Tên Hiển Thị';
  static const String displayNameHint = 'Nhập tên của bạn';
  static const String ageLabel = 'Tuổi';
  static const String ageHint = '25';
  static const String ageSuffix = 'tuổi';
  static const String genderLabel = 'Giới Tính';
  static const List<String> genderOptions = ['Nam', 'Nữ', 'Khác'];
  static const String heightLabel = 'Chiều Cao';
  static const String heightHint = '170';
  static const String heightSuffix = 'cm';
  static const String weightLabel = 'Cân Nặng';
  static const String weightHint = '70';
  static const String weightSuffix = 'kg';
  static const String step1SystemNote =
      '[ HỆ THỐNG ] Dữ liệu hồ sơ được mã hóa. Chỉ dùng để tối ưu hóa nhiệm vụ.';

  // Step 2 - Work & Study
  static const String step2Title = 'Công Việc & Học Tập';
  static const String step2Subtitle =
      'Hệ thống cần biết lịch làm việc để sắp xếp quest vào giờ phù hợp';
  static const String mainActivityLabel = 'Bạn Đang Làm Gì?';
  static const String workScheduleLabel = 'Lịch Làm Việc / Học';
  static const String workStartTimeLabel = 'Giờ bắt đầu';
  static const String workEndTimeLabel = 'Giờ kết thúc';
  static const String freeTimeLabel = 'Thời Gian Rảnh';
  static const String step2SystemNote =
      '[ HỆ THỐNG ] Quest sẽ không xếp vào giờ làm việc của bạn';

  static const List<String> mainActivityOptions = [
    'Software Engineer',
    'Sinh Viên',
    'Nhân Viên Văn Phòng',
    'Freelancer',
    'Khác',
  ];

  static const List<String> workScheduleOptions = [
    'Thứ 2–6',
    'Thứ 2–7',
    'Linh hoạt',
    'Ca đêm',
  ];

  static const List<String> freeTimeOptions = [
    'Sáng sớm (5–7h)',
    'Nghỉ trưa',
    'Sau giờ làm',
    'Tối (20–23h)',
  ];

  // Step 3 - Health & Activity
  static const String step3Title = 'Sức Khỏe & Vận Động';
  static const String step3Subtitle =
      'Hệ thống cần đánh giá thể trạng để tạo nhiệm vụ vừa sức';
  static const String activityLevelLabel = 'Mức Độ Vận Động Hiện Tại';
  static const String lastWorkoutLabel = 'Lần Cuối Tập Luyện';
  static const String healthLimitationsLabel = 'Có Giới Hạn Nào Không?';
  static const String step3SystemNote =
      '[ HỆ THỐNG ] Quest vận động sẽ bắt đầu từ mức phù hợp với bạn';

  static const List<String> activityLevelOptions = [
    'Rất ít',
    'Thỉnh thoảng',
    'Đều đặn',
  ];

  static const List<String> lastWorkoutOptions = [
    'Hôm nay',
    'Tuần này',
    '1 tháng trước',
    'Lâu hơn',
  ];

  static const List<String> healthLimitationOptions = [
    'Đau lưng',
    'Mỏi mắt',
    'Ít năng lượng',
    'Bận rộn',
    'Không có',
  ];

  // Step 4 - Goals
  static const String step4Title = 'Đặt Mục Tiêu';
  static const String step4Subtitle =
      'Chọn lĩnh vực bạn muốn cải thiện. Hệ thống sẽ ưu tiên trong nhiệm vụ hàng ngày.';
  static const String mainGoalsLabel = 'Mục Tiêu Chính';
  static const String step4SystemNote =
      '[ HỆ THỐNG ] Mục tiêu có thể điều chỉnh bất cứ lúc nào từ cài đặt';

  static const List<String> goalOptions = [
    'Uống Nước',
    'Vận Động',
    'Học Tập',
    'Chánh Niệm',
    'Ngủ Tốt Hơn',
    'Tập Trung Tốt Hơn',
    'Giảm Cân',
    'Kỷ Luật Hơn',
  ];

  // Step 5 - Schedule
  static const String step5Title = 'Lịch Sinh Hoạt';
  static const String step5Subtitle =
      'Hệ thống cần biết nhịp sinh hoạt để xếp quest đúng giờ';
  static const String wakeUpLabel = 'Giờ Thức Dậy';
  static const String targetSleepLabel = 'Giờ Ngủ Mục Tiêu';
  static const String freeTimeRangeLabel = 'Thời Gian Rảnh Trong Ngày';
  static const String fromLabel = 'Từ';
  static const String toLabel = 'Đến';
  static const String learningTimeLabel = 'Khung Giờ Muốn Học';
  static const String movementTimeLabel = 'Khung Giờ Muốn Vận Động';
  static const String step5SystemNote =
      '[ HỆ THỐNG ] Quest sẽ được xếp trong khoảng thời gian bạn chọn';

  static const List<String> learningTimeOptions = [
    'Sáng sớm',
    'Nghỉ trưa',
    'Tối (20–22h)',
    'Trước khi ngủ',
  ];

  static const List<String> movementTimeOptions = [
    'Sáng sớm',
    'Nghỉ trưa',
    'Sau giờ làm',
    'Tối',
  ];

  // Step 6 - Reminders
  static const String step6Title = 'Cài Đặt Nhắc Nhở';
  static const String step6Subtitle =
      'Tùy chỉnh tần suất nhắc nhở để hệ thống hoạt động phù hợp với bạn';
  static const String breakQuestLabel = 'Break Quest — Nghỉ Giải Lao';
  static const String breakQuestDesc =
      'Nhắc rời khỏi màn hình sau mỗi khoảng thời gian';
  static const String breakDurationLabel = 'Thời Gian Nghỉ';
  static const String waterQuestLabel = 'Water Quest — Uống Nước';
  static const String waterQuestDesc = 'Kiểu nhắc uống nước trong ngày';
  static const String waterQuestNote =
      'Ngẫu nhiên: nhắc mỗi 60–120 phút trong giờ hoạt động';
  static const String quietAfterLabel = 'Không Nhắc Sau';
  static const String quietAfterNote =
      'Hệ thống sẽ không gửi thông báo sau giờ này';
  static const String step6SystemNote =
      '[ HỆ THỐNG ] Bạn có thể thay đổi bất cứ lúc nào trong cài đặt';

  static const List<String> breakIntervalOptions = [
    '60',
    '90',
    '120',
  ];

  static const List<String> breakDurationOptions = [
    '3',
    '5',
    '10',
  ];

  static const List<String> waterReminderModes = [
    'Cố định',
    'Ngẫu nhiên',
  ];

  // Step 7 - Rewards
  static const String step7Title = 'Phần Thưởng';
  static const String step7Subtitle =
      'Chọn phần thưởng bạn muốn nhận khi hoàn thành nhiệm vụ';
  static const String rewardsLabel = 'Bạn muốn dùng phần thưởng nào?';
  static const String step7SystemNote =
      '[ HỆ THỐNG ] Phần thưởng sẽ mở khóa khi bạn đạt đủ EXP trong ngày';

  static const List<String> rewardOptions = [
    'Chơi game 45 phút',
    'Xem phim 1 tập',
    'Nghỉ ngơi 30 phút',
    'Mạng xã hội 20 phút',
    'Ăn món yêu thích',
    'Tự tạo reward',
  ];

  // Step 8 - Complete
  static const String step8Title = 'Hồ Sơ Đã Sẵn Sàng';
  static const String step8Subtitle =
      'Hệ thống đã ghi nhận dữ liệu. Nhiệm vụ đầu tiên sẽ được tạo ngay.';
  static const String startCheckinLabel = 'Bắt đầu check-in hôm nay';

  static const String summaryTitle = 'Tóm Tắt Hồ Sơ';
  static const String previewTitle = 'Lịch Nhiệm Vụ Mẫu';

  // Bottom bar
  static const String backLabel = 'Quay lại';
  static const String nextLabel = 'Tiếp theo';

  // Validation
  static const String validationMessage =
      'Hãy hoàn thành thông tin cần thiết trước khi tiếp tục.';

  // Completion
  static const String completionMessage = 'Bắt đầu ngày đầu tiên với SoloQuest.';
  static const String completionErrorMessage = 'Vui lòng thử lại.';
}
