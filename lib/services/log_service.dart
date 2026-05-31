import '../models/log_entry_model.dart';
import 'mock/mock_log_data.dart';

class LogService {
  late List<LogEntryModel> _logs;

  LogService() {
    _logs = MockLogData.todayLogs.map((l) => l).toList();
  }

  Future<List<LogEntryModel>> getLogs({int page = 1, int limit = 20}) async {
    return List.from(_logs);
  }

  Future<List<LogEntryModel>> getLogsByDate(DateTime date) async {
    return _logs.where((l) =>
      l.createdAt.year == date.year &&
      l.createdAt.month == date.month &&
      l.createdAt.day == date.day
    ).toList();
  }

  Future<void> addLog(LogEntryModel log) async {
    _logs.insert(0, log);
  }

  Future<List<LogEntryModel>> getQuestLogs(String questId) async {
    return _logs.where((l) => l.questId == questId).toList();
  }
}
