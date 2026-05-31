import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/auth_user_model.dart';
import '../../models/user_profile_model.dart';
import '../../models/progress_model.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../../services/daily_checkin_service.dart';
import '../../services/service_providers.dart';

class ProfilePageState extends BasePageState {
  final AppLoadState loadState;
  final UserProfileModel? profile;
  final ProgressModel? progress;
  final AuthUserModel? authUser;
  final bool hasCheckedInToday;
  final bool hasReviewedToday;
  final String? errorMessage;

  ProfilePageState({
    this.loadState = AppLoadState.idle,
    this.profile,
    this.progress,
    this.authUser,
    this.hasCheckedInToday = false,
    this.hasReviewedToday = false,
    this.errorMessage,
    super.isLockedPage,
  });

  @override
  ProfilePageState updateState({
    AppLoadState? loadState,
    UserProfileModel? profile,
    ProgressModel? progress,
    AuthUserModel? authUser,
    bool clearAuthUser = false,
    bool? hasCheckedInToday,
    bool? hasReviewedToday,
    String? errorMessage,
    bool? isLockedPage,
  }) {
    return ProfilePageState(
      loadState: loadState ?? this.loadState,
      profile: profile ?? this.profile,
      progress: progress ?? this.progress,
      authUser: clearAuthUser ? null : authUser ?? this.authUser,
      hasCheckedInToday: hasCheckedInToday ?? this.hasCheckedInToday,
      hasReviewedToday: hasReviewedToday ?? this.hasReviewedToday,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  bool get hasProfile => profile != null;
  bool get hasAuthUser => authUser != null;

  int get level => progress?.level ?? profile?.level ?? 1;

  int get currentLevelExp => progress?.currentLevelExp ?? profile?.currentLevelExp ?? 0;

  int get nextLevelExp => progress?.nextLevelExp ?? profile?.nextLevelExp ?? 100;

  int get streakDays => progress?.streakDays ?? profile?.streakDays ?? 0;

  int get totalCompletedQuests =>
      progress?.totalCompletedQuests ?? profile?.totalCompletedQuests ?? 0;

  double get levelProgress {
    final next = nextLevelExp;
    if (next <= 0) return 0;
    return (currentLevelExp / next).clamp(0.0, 1.0);
  }
}

class ProfilePageModel extends BasePageModel<ProfilePageState> {
  ProfilePageModel({
    required this.progressService,
    required this.dailyCheckinService,
    required this.authService,
  }) : super(ProfilePageState());

  final ProgressService progressService;
  final DailyCheckinService dailyCheckinService;
  final AuthService authService;

  Future<void> loadProfile() async {
    state = state.updateState(loadState: AppLoadState.loading);

    try {
      final results = await Future.wait([
        progressService.getProgress(),
        authService.getCurrentUser(),
      ]);

      final progress = results[0] as ProgressModel;
      final authUser = results[1] as AuthUserModel?;

      final hasCheckedIn = await dailyCheckinService.hasCheckedInToday();
      final hasReviewed = false;

      final now = DateTime.now();
      final profile = UserProfileModel(
        id: authUser?.id ?? 'user_1',
        name: authUser?.name ?? 'Minh',
        level: progress.level,
        currentLevelExp: progress.currentLevelExp,
        nextLevelExp: progress.nextLevelExp,
        totalExp: progress.totalExp,
        rewardPoints: progress.rewardPoints,
        streakDays: progress.streakDays,
        totalCompletedQuests: progress.totalCompletedQuests,
        mainGoals: [
          'Học Flutter đều hơn',
          'Uống nước và nghỉ mắt đúng giờ',
          'Tổng kết mỗi ngày',
        ],
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      );

      state = state.updateState(
        loadState: AppLoadState.ready,
        profile: profile,
        progress: progress,
        authUser: authUser,
        hasCheckedInToday: hasCheckedIn,
        hasReviewedToday: hasReviewed,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: 'Không thể tải hồ sơ: ${e.toString()}',
      );
    }
  }

  Future<bool> signOut() async {
    state = state.updateState(isLockedPage: true);
    try {
      await authService.signOut();
      state = state.updateState(
        isLockedPage: false,
        clearAuthUser: true,
      );
      return true;
    } catch (_) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: 'Không thể đăng xuất. Vui lòng thử lại.',
      );
      return false;
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }
}

final profilePageProvider =
    StateNotifierProvider<ProfilePageModel, ProfilePageState>((ref) {
  return ProfilePageModel(
    progressService: ref.read(progressServiceProvider),
    dailyCheckinService: ref.read(dailyCheckinServiceProvider),
    authService: ref.read(authServiceProvider),
  );
});
