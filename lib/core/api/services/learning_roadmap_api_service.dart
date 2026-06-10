import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../dto/learning_roadmap_dto.dart';
import '../dto/roadmap_suggestion_dto.dart';

/// Learning Roadmap API service
/// Handles learning roadmap endpoints
class LearningRoadmapApiService {
  final ApiClient _client;

  LearningRoadmapApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get all learning roadmaps - GET /api/learning-roadmaps
  Future<List<LearningRoadmapDto>> getRoadmaps() async {
    return await _client.get(
      'learning-roadmaps',
      fromJson: (json) {
        final list = ApiResponseParser.extractList(
          json,
          preferredKeys: ['items', 'roadmaps', 'data', 'results'],
          context: 'LearningRoadmapApiService.getRoadmaps',
        );
        return list
            .map((item) => LearningRoadmapDto.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }

  /// Get learning roadmap detail - GET /api/learning-roadmaps/:id
  Future<LearningRoadmapDto> getRoadmapDetail(String id) async {
    return await _client.get(
      'learning-roadmaps/$id',
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'roadmap', 'data'],
          context: 'LearningRoadmapApiService.getRoadmapDetail',
        );
        return LearningRoadmapDto.fromJson(map);
      },
    );
  }

  /// Follow a learning roadmap - POST /api/learning-roadmaps/:id/follow
  Future<FollowLearningRoadmapDto> followRoadmap(String id) async {
    return await _client.post(
      'learning-roadmaps/$id/follow',
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'result'],
          context: 'LearningRoadmapApiService.followRoadmap',
        );
        return FollowLearningRoadmapDto.fromJson(map);
      },
    );
  }

  /// Toggle learning step completion - PATCH /api/learning-roadmaps/:roadmapId/steps/:stepId
  Future<ToggleLearningStepResponseDto> toggleStep(
    String roadmapId,
    String stepId,
    bool completed,
  ) async {
    final request = ToggleLearningStepRequestDto(completed: completed);

    return await _client.patch(
      'learning-roadmaps/$roadmapId/steps/$stepId',
      body: request.toJson(),
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'result'],
          context: 'LearningRoadmapApiService.toggleStep',
        );
        return ToggleLearningStepResponseDto.fromJson(map);
      },
    );
  }

  /// Suggest roadmap templates - POST /api/learning-roadmaps/suggest
  Future<List<RoadmapSuggestionDto>> suggestRoadmaps(
    SuggestRoadmapsRequestDto request,
  ) async {
    return await _client.post(
      'learning-roadmaps/suggest',
      body: request.toJson(),
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data'],
          context: 'LearningRoadmapApiService.suggestRoadmaps',
        );
        final list = map['suggestions'] as List<dynamic>? ?? [];
        return list
            .map((item) => RoadmapSuggestionDto.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }

  /// Create roadmap from template - POST /api/learning-roadmaps
  Future<LearningRoadmapDto> createRoadmapFromTemplate(
    CreateRoadmapFromTemplateRequestDto request,
  ) async {
    return await _client.post(
      'learning-roadmaps',
      body: request.toJson(),
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data'],
          context: 'LearningRoadmapApiService.createRoadmapFromTemplate',
        );
        final roadmapMap = map['roadmap'] as Map<String, dynamic>;
        return LearningRoadmapDto.fromJson(roadmapMap);
      },
    );
  }

  /// Generate roadmap with AI - POST /api/learning-roadmaps/generate
  /// Returns either sync (201) or async (202) response
  Future<GenerateLearningRoadmapResult> generateRoadmap(
    GenerateLearningRoadmapRequestDto request,
  ) async {
    return await _client.post(
      'learning-roadmaps/generate',
      body: request.toJson(),
      timeout: 60,
      fromJson: (json) {
        final data = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data'],
          context: 'LearningRoadmapApiService.generateRoadmap',
        );

        // Case A: Sync response (201) - roadmap completed immediately
        if (data.containsKey('item') && data['item'] != null) {
          return GenerateLearningRoadmapResult.completed(
            roadmapItem: data['item'] as Map<String, dynamic>,
          );
        }

        // Case B: Async response (202) - job started
        if (data.containsKey('job_id') && data['job_id'] != null) {
          return GenerateLearningRoadmapResult.started(
            jobId: data['job_id'] as String,
            pollAfterSeconds: data['poll_after_seconds'] as int? ?? 3,
          );
        }

        throw Exception('Invalid generate response: missing item or job_id');
      },
    );
  }

  /// Get generation status - GET /api/learning-roadmaps/generate/status
  Future<GenerateLearningRoadmapStatusDto> getGenerateRoadmapStatus(
    String jobId,
  ) async {
    return await _client.get(
      'learning-roadmaps/generate/status',
      queryParams: {'job_id': jobId},
      fromJson: (json) {
        final data = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data'],
          context: 'LearningRoadmapApiService.getGenerateRoadmapStatus',
        );
        return GenerateLearningRoadmapStatusDto.fromJson(data);
      },
    );
  }

  /// Delete learning roadmap - DELETE /api/learning-roadmaps/:id
  Future<void> deleteRoadmap(String id) async {
    await _client.delete(
      'learning-roadmaps/$id',
      fromJson: (json) => null,
    );
  }
}
