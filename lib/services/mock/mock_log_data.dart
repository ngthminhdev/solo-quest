import '../../models/log_entry_model.dart';
import '../../models/enums/log_enums.dart';
import '../../models/enums/quest_enums.dart';

class MockLogData {
  static final List<LogEntryModel> todayLogs = [
    LogEntryModel(
      id: 'l1',
      type: LogEntryType.questCompleted,
      title: 'Hoàn thành: Check-in Buổi Sáng',
      description: 'Đánh giá trạng thái · giấc ngủ, năng lượng, stress',
      createdAt: _todayAt(6, 52),
      questId: 'q1',
      questType: QuestType.review,
      expChanged: 10,
    ),
    LogEntryModel(
      id: 'l2',
      type: LogEntryType.questCompleted,
      title: 'Hoàn thành: Khởi Động Buổi Sáng',
      description: 'Uống nước + 5 cái chống đẩy',
      createdAt: _todayAt(7, 18),
      questId: 'q2',
      questType: QuestType.fitness,
      expChanged: 10,
    ),
    LogEntryModel(
      id: 'l3',
      type: LogEntryType.questCompleted,
      title: 'Hoàn thành: Uống Nước',
      description: 'Uống 250ml nước — lần 1',
      createdAt: _todayAt(8, 2),
      questId: 'q3',
      questType: QuestType.water,
      expChanged: 5,
    ),
    LogEntryModel(
      id: 'l4',
      type: LogEntryType.questCompleted,
      title: 'Hoàn thành: Nghỉ Mắt Lần 1',
      description: 'Rời màn hình 5 phút',
      createdAt: _todayAt(8, 35),
      questId: 'q4',
      questType: QuestType.breakTime,
      expChanged: 10,
    ),
    LogEntryModel(
      id: 'l5',
      type: LogEntryType.questStarted,
      title: 'Bắt đầu: Uống Nước',
      description: 'Uống 250ml nước — đổ đầy bình ngay.',
      createdAt: _todayAt(9, 30),
      questId: 'q5',
      questType: QuestType.water,
    ),
    LogEntryModel(
      id: 'l6',
      type: LogEntryType.morningCheckin,
      title: 'Check-in buổi sáng',
      description: 'Năng lượng: 3/5, Stress: 2/5, 60 phút rảnh',
      createdAt: _todayAt(6, 45),
      mood: LogMood.good,
    ),
  ];

  static DateTime _todayAt(int hour, int minute) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}
