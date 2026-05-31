import '../models/user_profile_model.dart';

class ProfileService {
  static UserProfileModel? _profile;

  Future<UserProfileModel?> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _profile;
  }

  Future<UserProfileModel> createOrUpdateProfile({
    required String name,
    List<String>? mainGoals,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final now = DateTime.now();

    if (_profile != null) {
      _profile = _profile!.copyWith(
        name: name,
        mainGoals: mainGoals ?? _profile!.mainGoals,
        updatedAt: now,
      );
    } else {
      _profile = UserProfileModel(
        id: 'user_${now.millisecondsSinceEpoch}',
        name: name,
        mainGoals: mainGoals ?? [],
        createdAt: now,
        updatedAt: now,
      );
    }

    return _profile!;
  }

  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _profile = profile.copyWith(updatedAt: DateTime.now());
    return _profile!;
  }

  Future<void> clearProfile() async {
    _profile = null;
  }
}
