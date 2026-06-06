import '../core/api/dto/log_dto.dart';
import '../core/api/services/log_api_service.dart';
import '../core/utils/app_time_formatter.dart';
import '../models/log_entry_model.dart';

class LogService {
  final LogApiService _apiService;

  LogService({LogApiService? apiService})
      : _apiService = apiService ?? LogApiService();

  /// Convert LogEntryDto to LogEntryModel
  LogEntryModel _dtoToModel(LogEntryDto dto) {
    return LogEntryModel(
      id: dto.id,
      type: dto.type,
      title: dto.title,
      description: dto.description,
      createdAt: dto.createdAt,
      questId: dto.questId,
      questType: dto.questType,
      expChanged: dto.expChanged,
      pointsChanged: dto.pointsChanged,
      mood: dto.mood,
      metadata: dto.metadata,
    );
  }

  Future<List<LogEntryModel>> getLogs({
    int page = 1,
    int limit = 20,
    String? type,
    String? questType,
    String? date,
  }) async {
    final offset = (page - 1) * limit;
    final result = await _apiService.getLogs(
      limit: limit,
      offset: offset,
      type: type,
      questType: questType,
      date: date,
    );
    return result.logs.map(_dtoToModel).toList();
  }

  Future<List<LogEntryModel>> getLogsByDate(DateTime date) async {
    final dateStr = AppTimeFormatter.formatDateOnly(date) ?? '';
    final result = await _apiService.getLogs(date: dateStr);
    return result.logs.map(_dtoToModel).toList();
  }

  @Deprecated('Backend creates logs automatically')
  Future<void> addLog(LogEntryModel log) async {
    // Backend creates logs automatically when actions happen
    // This method is kept for compatibility but does nothing
  }

  Future<List<LogEntryModel>> getQuestLogs(String questId) async {
    // Get all logs and filter by questId
    // Backend doesn't have a specific quest logs endpoint yet
    final result = await _apiService.getLogs();
    return result.logs
        .where((dto) => dto.questId == questId)
        .map(_dtoToModel)
        .toList();
  }
}
