import '../models/learning_roadmap_model.dart';
import '../core/api/services/learning_roadmap_api_service.dart';
import '../core/api/dto/roadmap_suggestion_dto.dart';
import '../core/api/dto/learning_roadmap_dto.dart';
import '../core/network/api_exception.dart';

class LearningService {
  final LearningRoadmapApiService _roadmapApiService;

  LearningService({LearningRoadmapApiService? roadmapApiService})
      : _roadmapApiService = roadmapApiService ?? LearningRoadmapApiService();

  // ── Roadmap methods (API-backed) ──

  Future<List<LearningRoadmapModel>> getRoadmaps() async {
    try {
      final dtos = await _roadmapApiService.getRoadmaps();
      return dtos.map((dto) => _convertRoadmapDtoToModel(dto)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to load roadmaps: $e');
    }
  }

  Future<LearningRoadmapModel> getRoadmapById(String roadmapId) async {
    try {
      final dto = await _roadmapApiService.getRoadmapDetail(roadmapId);
      return _convertRoadmapDtoToModel(dto);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to load roadmap: $e');
    }
  }

  Future<void> followRoadmap(String roadmapId) async {
    try {
      await _roadmapApiService.followRoadmap(roadmapId);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to follow roadmap: $e');
    }
  }

  Future<LearningRoadmapModel> toggleRoadmapStep({
    required String roadmapId,
    required String stepId,
    required bool completed,
  }) async {
    try {
      await _roadmapApiService.toggleStep(roadmapId, stepId, completed);

      // Fetch updated roadmap to get complete state
      final updatedRoadmap = await getRoadmapById(roadmapId);
      return updatedRoadmap;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to toggle step: $e');
    }
  }

  /// Convert DTO to Model
  LearningRoadmapModel _convertRoadmapDtoToModel(dynamic dto) {
    return LearningRoadmapModel(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      category: dto.category,
      difficulty: dto.difficulty,
      estimatedMinutes: dto.estimatedMinutes,
      source: dto.source,
      status: dto.status,
      enabled: dto.enabled,
      startedAt: dto.startedAt,
      completedAt: dto.completedAt,
      steps: dto.steps.map<LearningRoadmapStepModel>((stepDto) {
        return LearningRoadmapStepModel(
          id: stepDto.id,
          title: stepDto.title,
          description: stepDto.description,
          completed: stepDto.completed,
          estimatedMinutes: stepDto.estimatedMinutes,
          orderIndex: stepDto.orderIndex,
          completedAt: stepDto.completedAt,
        );
      }).toList(),
      progress: dto.progressPercent / 100.0,
    );
  }

  /// Legacy: kept for compatibility but no longer used for roadmaps
  Future<LearningRoadmapModel> updateRoadmap(LearningRoadmapModel roadmap) async {
    throw UnimplementedError('Use API-backed methods instead');
  }

  /// Suggest roadmap templates based on preferences
  Future<List<RoadmapSuggestionDto>> suggestRoadmaps({
    required String learningGoal,
    String? category,
    String? difficulty,
    int? maxDuration,
  }) async {
    try {
      final request = SuggestRoadmapsRequestDto(
        learningGoal: learningGoal,
        category: category,
        difficulty: difficulty,
        maxDuration: maxDuration,
      );
      return await _roadmapApiService.suggestRoadmaps(request);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to suggest roadmaps: $e');
    }
  }

  /// Create roadmap from template
  Future<LearningRoadmapModel> createRoadmapFromTemplate({
    required String templateId,
    required String learningGoal,
    String? category,
    String? difficulty,
    int? maxDuration,
  }) async {
    try {
      final request = CreateRoadmapFromTemplateRequestDto(
        templateId: templateId,
        source: 'template',
        learningGoal: learningGoal,
        category: category,
        difficulty: difficulty,
        maxDuration: maxDuration,
      );
      final dto = await _roadmapApiService.createRoadmapFromTemplate(request);
      return _convertRoadmapDtoToModel(dto);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to create roadmap from template: $e');
    }
  }

  /// Generate roadmap with AI
  Future<GenerateLearningRoadmapResult> generateRoadmap({
    required String learningGoal,
    String? category,
    String? difficulty,
    int? maxDuration,
  }) async {
    try {
      final request = GenerateLearningRoadmapRequestDto(
        learningGoal: learningGoal,
        category: category,
        difficulty: difficulty,
        maxDuration: maxDuration,
      );
      return await _roadmapApiService.generateRoadmap(request);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to generate roadmap: $e');
    }
  }

  static const Duration roadmapGenerationPollInterval = Duration(seconds: 10);
  static const int roadmapGenerationMaxAttempts = 10;

  /// Poll roadmap generation status
  Future<LearningRoadmapModel?> pollRoadmapGeneration({
    required String jobId,
    required bool Function() isCancelled,
  }) async {
    int attempt = 0;
    
    while (attempt < roadmapGenerationMaxAttempts) {
      attempt++;
      
      await Future.delayed(roadmapGenerationPollInterval);
      
      if (isCancelled()) {
        return null;
      }
      
      try {
        final statusDto = await _roadmapApiService.getGenerateRoadmapStatus(jobId);
        
        if (statusDto.isCompleted) {
          if (statusDto.item != null) {
            final roadmapDto = LearningRoadmapDto.fromJson(statusDto.item!);
            return _convertRoadmapDtoToModel(roadmapDto);
          }
          throw Exception('Generation completed but no roadmap item found');
        }
        
        if (statusDto.isFailed) {
          final errorMsg = statusDto.error?.message ?? 'Generation failed';
          throw Exception(errorMsg);
        }
        
        // Still running, continue polling
      } on ApiException {
        rethrow;
      } catch (e) {
        throw Exception('Failed to check generation status: $e');
      }
    }
    
    // Max attempts reached
    return null;
  }

  /// Delete learning roadmap
  Future<void> deleteRoadmap(String roadmapId) async {
    try {
      await _roadmapApiService.deleteRoadmap(roadmapId);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to delete roadmap: $e');
    }
  }
}
