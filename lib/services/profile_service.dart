import '../core/api/dto/user_dto.dart';
import '../core/api/services/user_api_service.dart';
import '../models/user_profile_model.dart';

class ProfileService {
  final UserApiService _apiService;

  ProfileService({UserApiService? apiService})
      : _apiService = apiService ?? UserApiService();

  /// Convert UserProfileDto to UserProfileModel
  UserProfileModel _dtoToModel(UserProfileDto dto) {
    return UserProfileModel(
      id: dto.id,
      name: dto.name,
      avatarUrl: dto.avatarUrl,
      level: dto.level,
      currentLevelExp: dto.currentLevelExp,
      nextLevelExp: dto.nextLevelExp,
      totalExp: dto.totalExp,
      rewardPoints: dto.rewardPoints,
      streakDays: dto.streakDays,
      totalCompletedQuests: dto.totalCompletedQuests,
      mainGoals: dto.mainGoals,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  Future<UserProfileModel?> getProfile() async {
    try {
      final dto = await _apiService.getMe();
      final profile = _dtoToModel(dto);
      return profile;
    } catch (e) {
      return null;
    }
  }

  @Deprecated('Use backend onboarding endpoint instead')
  Future<UserProfileModel> createOrUpdateProfile({
    required String name,
    List<String>? mainGoals,
  }) async {
    // Backend handles profile updates through onboarding
    // Just refresh from backend
    final profile = await getProfile();
    if (profile == null) {
      throw Exception('Profile not found');
    }
    return profile;
  }

  @Deprecated('Use backend API to update profile')
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    // Backend is source of truth
    // Just refresh from backend
    final updated = await getProfile();
    if (updated == null) {
      throw Exception('Profile not found');
    }
    return updated;
  }

  Future<void> clearProfile() async {
    // Profile is managed by backend
    // This is a no-op now
  }
}
