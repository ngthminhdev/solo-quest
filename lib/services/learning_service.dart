import '../models/learning_goal_model.dart';
import '../models/learning_roadmap_model.dart';
import '../core/api/services/learning_roadmap_api_service.dart';
import '../core/api/dto/roadmap_suggestion_dto.dart';
import '../core/network/api_exception.dart';

class LearningService {
  final LearningRoadmapApiService _roadmapApiService;

  LearningService({LearningRoadmapApiService? roadmapApiService})
      : _roadmapApiService = roadmapApiService ?? LearningRoadmapApiService();
  static final List<LearningGoalModel> _goals = [
    LearningGoalModel(
      id: '1',
      title: 'Học Flutter Architecture',
      description: 'Nắm vững MVVM, Clean Architecture và State Management',
      category: 'Flutter',
      targetMinutesPerDay: 30,
      deadline: DateTime.now().add(const Duration(days: 60)),
      progress: 0.45,
      isActive: true,
    ),
    LearningGoalModel(
      id: '2',
      title: 'Ôn Dart Async/Await',
      description: 'Hiểu rõ Future, Stream, async/await patterns',
      category: 'Dart',
      targetMinutesPerDay: 20,
      deadline: DateTime.now().add(const Duration(days: 30)),
      progress: 0.7,
      isActive: true,
    ),
    LearningGoalModel(
      id: '3',
      title: 'Xây app SoloQuest MVP',
      description: 'Hoàn thành MVP với đầy đủ tính năng core',
      category: 'Project',
      targetMinutesPerDay: 45,
      deadline: DateTime.now().add(const Duration(days: 90)),
      progress: 0.25,
      isActive: true,
    ),
    LearningGoalModel(
      id: '4',
      title: 'Học UI/UX Design',
      description: 'Nắm vững design principles và Figma',
      category: 'Design',
      targetMinutesPerDay: 25,
      progress: 0.15,
      isActive: true,
    ),
    LearningGoalModel(
      id: '5',
      title: 'Cải thiện English Speaking',
      description: 'Luyện nói tiếng Anh mỗi ngày',
      category: 'English',
      targetMinutesPerDay: 15,
      deadline: DateTime.now().add(const Duration(days: 180)),
      progress: 0.9,
      isActive: true,
    ),
  ];

  Future<List<LearningGoalModel>> getLearningGoals() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_goals);
  }

  Future<LearningGoalModel> addLearningGoal(LearningGoalModel goal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newGoal = goal.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _goals.add(newGoal);
    return newGoal;
  }

  Future<LearningGoalModel> updateLearningGoal(LearningGoalModel goal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      return goal;
    }
    throw Exception('Goal not found');
  }

  Future<void> deleteLearningGoal(String goalId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _goals.removeWhere((g) => g.id == goalId);
  }

  Future<LearningGoalModel> updateGoalProgress(
    String goalId,
    double progress,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final clampedProgress = progress.clamp(0.0, 1.0);
      final updatedGoal = _goals[index].copyWith(progress: clampedProgress);
      _goals[index] = updatedGoal;
      return updatedGoal;
    }
    throw Exception('Goal not found');
  }

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
}
