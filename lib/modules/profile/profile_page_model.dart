import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/auth_user_model.dart';
import '../../models/user_profile_model.dart';
import '../../models/progress_model.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../../services/progress_service.dart';
import '../../services/daily_checkin_service.dart';
import '../../services/daily_review_service.dart';
import '../../services/service_providers.dart';
import '../../core/notifications/fcm_service.dart';

class ProfilePageState extends BasePageState {
  final AppLoadState loadState;
  final UserProfileModel? profile;
  final ProgressModel? progress;
  final AuthUserModel? authUser;
  final bool hasCheckedInToday;
  final bool hasReviewedToday;
  final String? errorMessage;

  ProfilePageState({
    this.loadState = AppLoadState.loading,
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
    required this.profileService,
    required this.progressService,
    required this.dailyCheckinService,
    required this.dailyReviewService,
    required this.authService,
    required this.fcmService,
  }) : super(ProfilePageState());

  final ProfileService profileService;
  final ProgressService progressService;
  final DailyCheckinService dailyCheckinService;
  final DailyReviewService dailyReviewService;
  final AuthService authService;
  final FcmService fcmService;

  Future<void> loadProfile() async {
    state = state.updateState(loadState: AppLoadState.loading);

    try {
      final results = await Future.wait([
        profileService.getProfile(),
        progressService.getProgress(),
        authService.getCurrentUser(),
      ]);

      final profile = results[0] as UserProfileModel?;
      final progress = results[1] as ProgressModel;
      final authUser = results[2] as AuthUserModel?;

      if (profile == null) {
        throw Exception('Profile not found');
      }

      final [hasCheckedIn, hasReviewed ] = await Future.wait([
        dailyCheckinService.hasCheckedInToday(),
        dailyReviewService.hasReviewedToday(),
      ]);

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
      await fcmService.handleLogout();
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
    profileService: ref.read(profileServiceProvider),
    progressService: ref.read(progressServiceProvider),
    dailyCheckinService: ref.read(dailyCheckinServiceProvider),
    dailyReviewService: ref.read(dailyReviewServiceProvider),
    authService: ref.read(authServiceProvider),
    fcmService: ref.read(fcmServiceProvider),
  );
});
