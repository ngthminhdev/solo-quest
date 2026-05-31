import '../models/learning_goal_model.dart';
import '../models/learning_roadmap_model.dart';

class LearningService {
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

  // ── Roadmap methods ──

  static final List<LearningRoadmapModel> _roadmaps = [
    LearningRoadmapModel(
      id: 'rm-1',
      title: 'Flutter App Architecture',
      description: 'Nắm vững MVVM, Riverpod và các pattern xây dựng Flutter app chuyên nghiệp.',
      steps: [
        const LearningRoadmapStepModel(
          id: 'rm-1-s1',
          title: 'Hiểu MVVM + Riverpod',
          description: 'Tìm hiểu kiến trúc MVVM và cách Riverpod quản lý state.',
          completed: true,
          estimatedMinutes: 30,
        ),
        const LearningRoadmapStepModel(
          id: 'rm-1-s2',
          title: 'Tạo BasePage / BasePageModel',
          description: 'Xây dựng base classes để tái sử dụng cho mọi feature module.',
          completed: true,
          estimatedMinutes: 45,
        ),
        const LearningRoadmapStepModel(
          id: 'rm-1-s3',
          title: 'Tạo service layer',
          description: 'Tách business logic ra service, học cách inject qua Riverpod.',
          completed: false,
          estimatedMinutes: 40,
        ),
        const LearningRoadmapStepModel(
          id: 'rm-1-s4',
          title: 'Build Home UI',
          description: 'Áp dụng kiến thức vào xây dựng màn hình Home thực tế.',
          completed: false,
          estimatedMinutes: 60,
        ),
        const LearningRoadmapStepModel(
          id: 'rm-1-s5',
          title: 'Refactor component system',
          description: 'Tái cấu trúc UI components để dùng lại hiệu quả.',
          completed: false,
          estimatedMinutes: 35,
        ),
      ],
    ),
    LearningRoadmapModel(
      id: 'rm-2',
      title: 'Dart Async Mastery',
      description: 'Làm chủ bất đồng bộ trong Dart: Future, Stream, error handling.',
      steps: [
        const LearningRoadmapStepModel(
          id: 'rm-2-s1',
          title: 'Future và async/await',
          description: 'Nắm vững cách sử dụng Future và async/await trong Dart.',
          completed: true,
          estimatedMinutes: 25,
        ),
        const LearningRoadmapStepModel(
          id: 'rm-2-s2',
          title: 'Error handling',
          description: 'Xử lý lỗitry/catch, custom exceptions và best practices.',
          completed: false,
          estimatedMinutes: 30,
        ),
        const LearningRoadmapStepModel(
          id: 'rm-2-s3',
          title: 'Streams basics',
          description: 'Hiểu Stream, StreamController và cách lắng nghe dữ liệu.',
          completed: false,
          estimatedMinutes: 35,
        ),
        const LearningRoadmapStepModel(
          id: 'rm-2-s4',
          title: 'Service abstraction',
          description: 'Tạo abstract service interface để dễ mock và test.',
          completed: false,
          estimatedMinutes: 20,
        ),
      ],
    ),
    LearningRoadmapModel(
      id: 'rm-3',
      title: 'SoloQuest MVP',
      description: 'Hoàn thành MVP của ứng dụng SoloQuest với đầy đủ tính năng core.',
      steps: [
        const LearningRoadmapStepModel(
          id: 'rm-3-s1',
          title: 'Quest data model',
          description: 'Thiết kế model cho quest, step, reward.',
          completed: true,
          estimatedMinutes: 30,
        ),
        const LearningRoadmapStepModel(
          id: 'rm-3-s2',
          title: 'Home quest flow',
          description: 'Xây dựng flow hiển thị và tương tác quest trên Home.',
          completed: true,
          estimatedMinutes: 45,
        ),
        const LearningRoadmapStepModel(
          id: 'rm-3-s3',
          title: 'Logs system',
          description: 'Xây dựng hệ thống ghi log hoạt động.',
          completed: false,
          estimatedMinutes: 30,
        ),
        const LearningRoadmapStepModel(
          id: 'rm-3-s4',
          title: 'Progress & rewards loop',
          description: 'Hoàn thành vòng lặp tiến độ và phần thưởng.',
          completed: false,
          estimatedMinutes: 40,
        ),
      ],
    ),
  ];

  Future<List<LearningRoadmapModel>> getRoadmaps() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_roadmaps);
  }

  Future<LearningRoadmapModel?> getRoadmapById(String roadmapId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _roadmaps.firstWhere((r) => r.id == roadmapId);
    } catch (_) {
      return null;
    }
  }

  Future<LearningRoadmapModel> updateRoadmap(LearningRoadmapModel roadmap) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _roadmaps.indexWhere((r) => r.id == roadmap.id);
    if (index != -1) {
      _roadmaps[index] = roadmap;
      return roadmap;
    }
    throw Exception('Roadmap not found');
  }

  Future<LearningRoadmapModel> toggleRoadmapStep({
    required String roadmapId,
    required String stepId,
    required bool completed,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final rmIndex = _roadmaps.indexWhere((r) => r.id == roadmapId);
    if (rmIndex == -1) throw Exception('Roadmap not found');

    final roadmap = _roadmaps[rmIndex];
    final stepIndex = roadmap.steps.indexWhere((s) => s.id == stepId);
    if (stepIndex == -1) throw Exception('Step not found');

    final updatedSteps = List<LearningRoadmapStepModel>.from(roadmap.steps);
    updatedSteps[stepIndex] = updatedSteps[stepIndex].copyWith(completed: completed);

    final updatedRoadmap = roadmap.copyWith(steps: updatedSteps);
    _roadmaps[rmIndex] = updatedRoadmap;
    return updatedRoadmap;
  }
}
