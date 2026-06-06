import '../core/api/services/schedule_api_service.dart';
import '../models/schedule_model.dart';

/// Schedule service — API-backed, no hardcoded mock data.
/// Falls back to empty list if API is unreachable.
class ScheduleService {
  final ScheduleApiService _apiService;

  ScheduleService({ScheduleApiService? apiService})
      : _apiService = apiService ?? ScheduleApiService();

  /// GET all schedule blocks
  Future<List<ScheduleBlockModel>> getScheduleBlocks() async {
    final dtos = await _apiService.getScheduleBlocks();
    return dtos.map(ScheduleBlockModel.fromDto).toList();
  }

  /// POST create a new schedule block
  Future<ScheduleBlockModel> addScheduleBlock(ScheduleBlockModel block) async {
    final dto = block.toDto();
    final resultDto = await _apiService.createScheduleBlock(dto);
    return ScheduleBlockModel.fromDto(resultDto);
  }

  /// PUT full replacement update
  Future<ScheduleBlockModel> updateScheduleBlock(
      ScheduleBlockModel block) async {
    final dto = block.toDto();
    final resultDto = await _apiService.updateScheduleBlock(block.id, dto);
    return ScheduleBlockModel.fromDto(resultDto);
  }

  /// PATCH partial update
  Future<ScheduleBlockModel> patchScheduleBlock(
      String blockId, Map<String, dynamic> partial) async {
    final resultDto = await _apiService.patchScheduleBlock(blockId, partial);
    return ScheduleBlockModel.fromDto(resultDto);
  }

  /// DELETE (soft delete — sets enabled=false)
  Future<void> deleteScheduleBlock(String blockId) async {
    await _apiService.deleteScheduleBlock(blockId);
  }

  /// Check if an error indicates the schedule API endpoint is unavailable
  static bool isEndpointUnavailable(Object error) {
    return ScheduleApiService.isEndpointUnavailable(error);
  }
}
