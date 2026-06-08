import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In vi, this message translates to:
  /// **'SoloQuest'**
  String get appName;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cải thiện cuộc sống mỗi ngày thông qua các nhiệm vụ cá nhân hóa'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeSystemMessage.
  ///
  /// In vi, this message translates to:
  /// **'[ HỆ THỐNG ]\nĐang khởi động...\nTrạng thái: SẴN SÀNG\nBắt đầu hành trình cải thiện bản thân?'**
  String get welcomeSystemMessage;

  /// No description provided for @welcomeStartButton.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu thiết lập cá nhân'**
  String get welcomeStartButton;

  /// No description provided for @welcomeSkipLink.
  ///
  /// In vi, this message translates to:
  /// **'Đã thiết lập? Bỏ qua'**
  String get welcomeSkipLink;

  /// No description provided for @welcomeVersionTag.
  ///
  /// In vi, this message translates to:
  /// **'v1.0.0 — Hệ Thống Trực Tuyến'**
  String get welcomeVersionTag;

  /// No description provided for @welcomeFeature1Title.
  ///
  /// In vi, this message translates to:
  /// **'Quest cá nhân hóa'**
  String get welcomeFeature1Title;

  /// No description provided for @welcomeFeature1Desc.
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ nhỏ phù hợp với thói quen của bạn'**
  String get welcomeFeature1Desc;

  /// No description provided for @welcomeFeature2Title.
  ///
  /// In vi, this message translates to:
  /// **'Logs để hiểu bản thân'**
  String get welcomeFeature2Title;

  /// No description provided for @welcomeFeature2Desc.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi hoạt động và phát hiện pattern'**
  String get welcomeFeature2Desc;

  /// No description provided for @welcomeFeature3Title.
  ///
  /// In vi, this message translates to:
  /// **'EXP, Level, Streak'**
  String get welcomeFeature3Title;

  /// No description provided for @welcomeFeature3Desc.
  ///
  /// In vi, this message translates to:
  /// **'Gamification giúp duy trì động lực'**
  String get welcomeFeature3Desc;

  /// No description provided for @welcomeFeature4Title.
  ///
  /// In vi, this message translates to:
  /// **'Reminder thông minh'**
  String get welcomeFeature4Title;

  /// No description provided for @welcomeFeature4Desc.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc đúng lúc, không làm phiền'**
  String get welcomeFeature4Desc;

  /// No description provided for @commonCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get commonConfirm;

  /// No description provided for @commonSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get commonSave;

  /// No description provided for @commonRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get commonRetry;

  /// No description provided for @commonBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo'**
  String get commonNext;

  /// No description provided for @commonDone.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất'**
  String get commonDone;

  /// No description provided for @commonLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải…'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra'**
  String get commonError;

  /// No description provided for @commonEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu'**
  String get commonEmpty;

  /// No description provided for @commonDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get commonClose;

  /// No description provided for @bottomNavHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang Chủ'**
  String get bottomNavHome;

  /// No description provided for @bottomNavLogs.
  ///
  /// In vi, this message translates to:
  /// **'Nhật Ký'**
  String get bottomNavLogs;

  /// No description provided for @bottomNavProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến Trình'**
  String get bottomNavProgress;

  /// No description provided for @bottomNavLearning.
  ///
  /// In vi, this message translates to:
  /// **'Lộ Trình'**
  String get bottomNavLearning;

  /// No description provided for @bottomNavRewards.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng'**
  String get bottomNavRewards;

  /// No description provided for @bottomNavProfile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ Sơ'**
  String get bottomNavProfile;

  /// No description provided for @headerHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang Chủ'**
  String get headerHome;

  /// No description provided for @headerLogs.
  ///
  /// In vi, this message translates to:
  /// **'Nhật Ký'**
  String get headerLogs;

  /// No description provided for @headerProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến Trình'**
  String get headerProgress;

  /// No description provided for @headerLearning.
  ///
  /// In vi, this message translates to:
  /// **'Lộ Trình Học'**
  String get headerLearning;

  /// No description provided for @headerRewards.
  ///
  /// In vi, this message translates to:
  /// **'Tự thưởng'**
  String get headerRewards;

  /// No description provided for @headerProfile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ Sơ'**
  String get headerProfile;

  /// No description provided for @loginTagline.
  ///
  /// In vi, this message translates to:
  /// **'Biến lộ trình học tập thành quest nhỏ mỗi ngày.'**
  String get loginTagline;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu hành trình của bạn'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng Google để đồng bộ quest, logs, tiến trình và tự thưởng trên mọi thiết bị.'**
  String get loginSubtitle;

  /// No description provided for @loginGoogleButton.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Google'**
  String get loginGoogleButton;

  /// No description provided for @loginGoogleLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang kết nối Google…'**
  String get loginGoogleLoading;

  /// No description provided for @loginError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đăng nhập bằng Google. Vui lòng thử lại.'**
  String get loginError;

  /// No description provided for @loginNote.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi chỉ dùng tài khoản Google để xác thực và đồng bộ dữ liệu SoloQuest của bạn.'**
  String get loginNote;

  /// No description provided for @loginTerms.
  ///
  /// In vi, this message translates to:
  /// **'Bằng cách tiếp tục, bạn đồng ý với Điều khoản sử dụng và Chính sách quyền riêng tư.'**
  String get loginTerms;

  /// No description provided for @loginPrototypeNote.
  ///
  /// In vi, this message translates to:
  /// **'[ Nền tảng Google auth — dev fallback chỉ ở debug ]'**
  String get loginPrototypeNote;

  /// No description provided for @profileAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tài Khoản'**
  String get profileAccount;

  /// No description provided for @profileAccountEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông tin tài khoản'**
  String get profileAccountEmpty;

  /// No description provided for @profileSignOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get profileSignOut;

  /// No description provided for @profileSignOutTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất?'**
  String get profileSignOutTitle;

  /// No description provided for @profileSignOutMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn sẽ cần đăng nhập lại để đồng bộ dữ liệu SoloQuest.'**
  String get profileSignOutMessage;

  /// No description provided for @profileSignOutSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã đăng xuất'**
  String get profileSignOutSuccess;

  /// No description provided for @profileSignOutError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đăng xuất. Vui lòng thử lại.'**
  String get profileSignOutError;

  /// No description provided for @profileLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải hồ sơ...'**
  String get profileLoading;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài Đặt & Công Cụ'**
  String get profileSettingsTitle;

  /// No description provided for @profileScheduleTileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sinh hoạt'**
  String get profileScheduleTileTitle;

  /// No description provided for @profileScheduleTileSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh thời gian làm việc, học tập và nghỉ ngơi'**
  String get profileScheduleTileSubtitle;

  /// No description provided for @profileLearningGoalsTileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình học'**
  String get profileLearningGoalsTileTitle;

  /// No description provided for @profileLearningGoalsTileSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi tiến độ và roadmap học tập'**
  String get profileLearningGoalsTileSubtitle;

  /// No description provided for @profileLearningRoadmapTileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình học'**
  String get profileLearningRoadmapTileTitle;

  /// No description provided for @profileLearningRoadmapTileSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi roadmap và tiến độ học'**
  String get profileLearningRoadmapTileSubtitle;

  /// No description provided for @profileReminderSettingsTileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt nhắc nhở'**
  String get profileReminderSettingsTileTitle;

  /// No description provided for @profileReminderSettingsTileSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh tần suất và thời điểm nhắc'**
  String get profileReminderSettingsTileSubtitle;

  /// No description provided for @profileQuestRulesTileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luật tạo quest'**
  String get profileQuestRulesTileTitle;

  /// No description provided for @profileQuestRulesTileSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Điều chỉnh độ khó, loại quest và giới hạn mỗi ngày'**
  String get profileQuestRulesTileSubtitle;

  /// No description provided for @profileGoalSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lộ Trình Đang Học'**
  String get profileGoalSectionTitle;

  /// No description provided for @profileGoalEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa bắt đầu lộ trình học nào.'**
  String get profileGoalEmpty;

  /// No description provided for @profileGoalSetupButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem lộ trình học'**
  String get profileGoalSetupButton;

  /// No description provided for @profileGoalPursuing.
  ///
  /// In vi, this message translates to:
  /// **'Đang học'**
  String get profileGoalPursuing;

  /// No description provided for @profileGoalFromProfile.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình học từ hồ sơ'**
  String get profileGoalFromProfile;

  /// No description provided for @profileGoalFromLearning.
  ///
  /// In vi, this message translates to:
  /// **'Từ roadmap đang hoạt động'**
  String get profileGoalFromLearning;

  /// No description provided for @progressLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải tiến trình...'**
  String get progressLoading;

  /// No description provided for @progressError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải tiến trình'**
  String get progressError;

  /// No description provided for @progressWeeklySummary.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo tuần'**
  String get progressWeeklySummary;

  /// No description provided for @progressWeeklySummaryDesc.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại tiến bộ, quest hiệu quả và đề xuất tuần sau'**
  String get progressWeeklySummaryDesc;

  /// No description provided for @progressQuestRules.
  ///
  /// In vi, this message translates to:
  /// **'Luật điều chỉnh Quest'**
  String get progressQuestRules;

  /// No description provided for @progressQuestRulesDesc.
  ///
  /// In vi, this message translates to:
  /// **'Xem cách SoloQuest dùng dữ liệu để tạo quest phù hợp'**
  String get progressQuestRulesDesc;

  /// No description provided for @progressLinksTitle.
  ///
  /// In vi, this message translates to:
  /// **'XEM THÊM'**
  String get progressLinksTitle;

  /// No description provided for @progressHabitTitle.
  ///
  /// In vi, this message translates to:
  /// **'THÓI QUEN THEO NHÓM'**
  String get progressHabitTitle;

  /// No description provided for @progressPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiến Trình'**
  String get progressPageTitle;

  /// No description provided for @progressHeaderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiến Trình'**
  String get progressHeaderTitle;

  /// No description provided for @progressHeaderSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi level, streak, EXP và mức độ ổn định của các thói quen theo thời gian.'**
  String get progressHeaderSubtitle;

  /// No description provided for @progressEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tiến trình'**
  String get progressEmptyTitle;

  /// No description provided for @progressEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành quest đầu tiên để bắt đầu ghi nhận EXP, level và streak.'**
  String get progressEmptyMessage;

  /// No description provided for @progressEmptyAction.
  ///
  /// In vi, this message translates to:
  /// **'Về Home'**
  String get progressEmptyAction;

  /// No description provided for @progressExpExplainTitle.
  ///
  /// In vi, this message translates to:
  /// **'EXP dùng để làm gì?'**
  String get progressExpExplainTitle;

  /// No description provided for @progressExpExplainText.
  ///
  /// In vi, this message translates to:
  /// **'EXP thể hiện mức độ duy trì nỗ lực hằng ngày. Khi đủ EXP, bạn sẽ lên cấp và mở khóa badge, theme hoặc reward cá nhân. EXP không phải điểm phạt — chỉ dùng để ghi nhận tiến bộ. Bạn nhận EXP khi hoàn thành quest, check-in, viết log hoặc review cuối ngày.'**
  String get progressExpExplainText;

  /// No description provided for @progressStreakSafetyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Streak an toàn'**
  String get progressStreakSafetyTitle;

  /// No description provided for @progressStreakSafetyNote.
  ///
  /// In vi, this message translates to:
  /// **'Streak Shield bảo vệ chuỗi khi bạn bận, mệt hoặc cần nghỉ. Dùng \"ngày nhẹ\" để giữ nhịp mà không cần hoàn thành nhiều quest. Không phạt nặng nếu bỏ qua quest do stress hoặc lịch bận.'**
  String get progressStreakSafetyNote;

  /// No description provided for @progressWeeklyChartTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này'**
  String get progressWeeklyChartTitle;

  /// No description provided for @progressWeeklyChartSection.
  ///
  /// In vi, this message translates to:
  /// **'HOÀN THÀNH THEO TUẦN'**
  String get progressWeeklyChartSection;

  /// No description provided for @progressHabitSection.
  ///
  /// In vi, this message translates to:
  /// **'Thói quen theo nhóm'**
  String get progressHabitSection;

  /// No description provided for @progressExpBreakdownSection.
  ///
  /// In vi, this message translates to:
  /// **'EXP THEO LOẠI QUEST'**
  String get progressExpBreakdownSection;

  /// No description provided for @progressExpItemLearning.
  ///
  /// In vi, this message translates to:
  /// **'Learning Quest'**
  String get progressExpItemLearning;

  /// No description provided for @progressExpItemLearningNote.
  ///
  /// In vi, this message translates to:
  /// **'Quest khó nhất, EXP cao nhất'**
  String get progressExpItemLearningNote;

  /// No description provided for @progressExpItemSleep.
  ///
  /// In vi, this message translates to:
  /// **'Sleep Quest'**
  String get progressExpItemSleep;

  /// No description provided for @progressExpItemSleepNote.
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn bị giấc ngủ tốt'**
  String get progressExpItemSleepNote;

  /// No description provided for @progressExpItemMovement.
  ///
  /// In vi, this message translates to:
  /// **'Movement Quest'**
  String get progressExpItemMovement;

  /// No description provided for @progressExpItemMovementNote.
  ///
  /// In vi, this message translates to:
  /// **'Vận động cơ thể'**
  String get progressExpItemMovementNote;

  /// No description provided for @progressExpItemBreak.
  ///
  /// In vi, this message translates to:
  /// **'Break Quest'**
  String get progressExpItemBreak;

  /// No description provided for @progressExpItemBreakNote.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ mắt, thư giãn'**
  String get progressExpItemBreakNote;

  /// No description provided for @progressExpItemWater.
  ///
  /// In vi, this message translates to:
  /// **'Water Quest'**
  String get progressExpItemWater;

  /// No description provided for @progressExpItemWaterNote.
  ///
  /// In vi, this message translates to:
  /// **'Thói quen nhỏ, lặp lại nhiều'**
  String get progressExpItemWaterNote;

  /// No description provided for @progressExpItemReview.
  ///
  /// In vi, this message translates to:
  /// **'Daily Review'**
  String get progressExpItemReview;

  /// No description provided for @progressExpItemReviewNote.
  ///
  /// In vi, this message translates to:
  /// **'Phản hồi cuối ngày'**
  String get progressExpItemReviewNote;

  /// No description provided for @progressXPHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'LỊCH SỬ EXP'**
  String get progressXPHistoryTitle;

  /// No description provided for @progressXPHistoryRecent.
  ///
  /// In vi, this message translates to:
  /// **'Gần đây'**
  String get progressXPHistoryRecent;

  /// No description provided for @progressStreakDaysLabel.
  ///
  /// In vi, this message translates to:
  /// **'Streak {days} ngày'**
  String progressStreakDaysLabel(Object days);

  /// No description provided for @progressStreakDaysSuffix.
  ///
  /// In vi, this message translates to:
  /// **' ngày'**
  String get progressStreakDaysSuffix;

  /// No description provided for @progressStreakShieldRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Shield còn lại'**
  String get progressStreakShieldRemaining;

  /// No description provided for @progressStreakLightDaysUsed.
  ///
  /// In vi, this message translates to:
  /// **'Ngày nhẹ đã dùng'**
  String get progressStreakLightDaysUsed;

  /// No description provided for @progressStreakMax.
  ///
  /// In vi, this message translates to:
  /// **'Streak cao nhất'**
  String get progressStreakMax;

  /// No description provided for @progressStreakShield.
  ///
  /// In vi, this message translates to:
  /// **'Streak Shield'**
  String get progressStreakShield;

  /// No description provided for @progressStreakShieldNote.
  ///
  /// In vi, this message translates to:
  /// **' bảo vệ chuỗi khi bạn bận, mệt hoặc cần nghỉ. Dùng \"ngày nhẹ\" để giữ nhịp mà không cần hoàn thành nhiều quest.'**
  String get progressStreakShieldNote;

  /// No description provided for @progressCurrentLevel.
  ///
  /// In vi, this message translates to:
  /// **'Cấp độ hiện tại'**
  String get progressCurrentLevel;

  /// No description provided for @progressWeeklyQuest.
  ///
  /// In vi, this message translates to:
  /// **'Quest tuần'**
  String get progressWeeklyQuest;

  /// No description provided for @progressStreakLabel.
  ///
  /// In vi, this message translates to:
  /// **'Streak'**
  String get progressStreakLabel;

  /// No description provided for @progressCompletedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get progressCompletedLabel;

  /// No description provided for @progressWeeklyChartAverage.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ trung bình: {rate}%'**
  String progressWeeklyChartAverage(Object rate);

  /// No description provided for @progressWeeklyChartTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng: {completed}/{planned}'**
  String progressWeeklyChartTotal(Object completed, Object planned);

  /// No description provided for @progressAchievementSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thành tựu'**
  String get progressAchievementSectionTitle;

  /// No description provided for @progressAchievementStarter.
  ///
  /// In vi, this message translates to:
  /// **'Người khởi động'**
  String get progressAchievementStarter;

  /// No description provided for @progressAchievementStarterDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành 5 quest đầu tiên'**
  String get progressAchievementStarterDesc;

  /// No description provided for @progressAchievementKeeper.
  ///
  /// In vi, this message translates to:
  /// **'Giữ lửa'**
  String get progressAchievementKeeper;

  /// No description provided for @progressAchievementKeeperDesc.
  ///
  /// In vi, this message translates to:
  /// **'Duy trì streak 3 ngày'**
  String get progressAchievementKeeperDesc;

  /// No description provided for @progressAchievementLearner.
  ///
  /// In vi, this message translates to:
  /// **'Học đều'**
  String get progressAchievementLearner;

  /// No description provided for @progressAchievementLearnerDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành 5 quest học tập'**
  String get progressAchievementLearnerDesc;

  /// No description provided for @progressAchievementUnlocked.
  ///
  /// In vi, this message translates to:
  /// **'Đạt được'**
  String get progressAchievementUnlocked;

  /// No description provided for @progressStreakMotivationStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu streak hôm nay'**
  String get progressStreakMotivationStart;

  /// No description provided for @progressStreakMotivationGood.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang khởi động rất tốt'**
  String get progressStreakMotivationGood;

  /// No description provided for @progressStreakMotivationForming.
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi ngày đang hình thành'**
  String get progressStreakMotivationForming;

  /// No description provided for @progressStreakMotivationStable.
  ///
  /// In vi, this message translates to:
  /// **'Thói quen của bạn đang rất ổn định'**
  String get progressStreakMotivationStable;

  /// No description provided for @progressWeeklyCompletionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ hoàn thành tuần'**
  String get progressWeeklyCompletionTitle;

  /// No description provided for @progressWeeklyCompletionLow.
  ///
  /// In vi, this message translates to:
  /// **'Cần giảm độ khó hoặc chia nhỏ quest để tăng tỷ lệ hoàn thành.'**
  String get progressWeeklyCompletionLow;

  /// No description provided for @progressWeeklyCompletionMedium.
  ///
  /// In vi, this message translates to:
  /// **'Đang ổn, cần đều hơn để duy trì thói quen.'**
  String get progressWeeklyCompletionMedium;

  /// No description provided for @progressWeeklyCompletionHigh.
  ///
  /// In vi, this message translates to:
  /// **'Rất tốt! Bạn đang hoàn thành rất đều đặn.'**
  String get progressWeeklyCompletionHigh;

  /// No description provided for @progressStatsTotalEXP.
  ///
  /// In vi, this message translates to:
  /// **'Tổng EXP'**
  String get progressStatsTotalEXP;

  /// No description provided for @progressStatsCompletedQuests.
  ///
  /// In vi, this message translates to:
  /// **'Quest hoàn thành'**
  String get progressStatsCompletedQuests;

  /// No description provided for @progressStatsSkippedQuests.
  ///
  /// In vi, this message translates to:
  /// **'Quest bỏ qua'**
  String get progressStatsSkippedQuests;

  /// No description provided for @progressStatsStreakDays.
  ///
  /// In vi, this message translates to:
  /// **'ngày'**
  String get progressStatsStreakDays;

  /// No description provided for @progressQuestTypeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo loại quest'**
  String get progressQuestTypeTitle;

  /// No description provided for @progressQuestTypeEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu phân loại.'**
  String get progressQuestTypeEmpty;

  /// No description provided for @progressLevelCurrentLevel.
  ///
  /// In vi, this message translates to:
  /// **'Cấp độ hiện tại'**
  String get progressLevelCurrentLevel;

  /// No description provided for @progressLevelTotalEXP.
  ///
  /// In vi, this message translates to:
  /// **'Tổng EXP'**
  String get progressLevelTotalEXP;

  /// No description provided for @progressLevelEXPToNext.
  ///
  /// In vi, this message translates to:
  /// **'Còn {exp} EXP để lên level tiếp theo'**
  String progressLevelEXPToNext(Object exp);

  /// No description provided for @questTypeWater.
  ///
  /// In vi, this message translates to:
  /// **'Uống nước'**
  String get questTypeWater;

  /// No description provided for @questTypeBreak.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ giải lao'**
  String get questTypeBreak;

  /// No description provided for @questTypeMovement.
  ///
  /// In vi, this message translates to:
  /// **'Vận động'**
  String get questTypeMovement;

  /// No description provided for @questTypeLearning.
  ///
  /// In vi, this message translates to:
  /// **'Học tập'**
  String get questTypeLearning;

  /// No description provided for @questTypeSleep.
  ///
  /// In vi, this message translates to:
  /// **'Ngủ nghỉ'**
  String get questTypeSleep;

  /// No description provided for @questTypeFitness.
  ///
  /// In vi, this message translates to:
  /// **'Thể chất'**
  String get questTypeFitness;

  /// No description provided for @questTypeMindfulness.
  ///
  /// In vi, this message translates to:
  /// **'Tĩnh tâm'**
  String get questTypeMindfulness;

  /// No description provided for @questTypeReview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng kết'**
  String get questTypeReview;

  /// No description provided for @questTypeCustom.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh'**
  String get questTypeCustom;

  /// No description provided for @difficultyEasy.
  ///
  /// In vi, this message translates to:
  /// **'Dễ'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In vi, this message translates to:
  /// **'Vừa'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In vi, this message translates to:
  /// **'Khó'**
  String get difficultyHard;

  /// No description provided for @difficultyEasyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Quest nhỏ, dễ hoàn thành.'**
  String get difficultyEasyDesc;

  /// No description provided for @difficultyMediumDesc.
  ///
  /// In vi, this message translates to:
  /// **'Cần tập trung hoặc vận động nhẹ.'**
  String get difficultyMediumDesc;

  /// No description provided for @difficultyHardDesc.
  ///
  /// In vi, this message translates to:
  /// **'Cần nhiều năng lượng/thời gian hơn.'**
  String get difficultyHardDesc;

  /// No description provided for @priorityHighest.
  ///
  /// In vi, this message translates to:
  /// **'Cao nhất'**
  String get priorityHighest;

  /// No description provided for @priorityHigh.
  ///
  /// In vi, this message translates to:
  /// **'Cao'**
  String get priorityHigh;

  /// No description provided for @priorityMedium.
  ///
  /// In vi, this message translates to:
  /// **'Vừa'**
  String get priorityMedium;

  /// No description provided for @priorityLow.
  ///
  /// In vi, this message translates to:
  /// **'Thấp'**
  String get priorityLow;

  /// No description provided for @priorityLowest.
  ///
  /// In vi, this message translates to:
  /// **'Thấp nhất'**
  String get priorityLowest;

  /// No description provided for @statusPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ'**
  String get statusPending;

  /// No description provided for @statusActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang làm'**
  String get statusActive;

  /// No description provided for @statusCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get statusCompleted;

  /// No description provided for @statusSkipped.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get statusSkipped;

  /// No description provided for @statusSnoozed.
  ///
  /// In vi, this message translates to:
  /// **'Hoãn'**
  String get statusSnoozed;

  /// No description provided for @statusExpired.
  ///
  /// In vi, this message translates to:
  /// **'Hết hạn'**
  String get statusExpired;

  /// No description provided for @rewardsLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải tự thưởng...'**
  String get rewardsLoading;

  /// No description provided for @rewardsError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải gợi ý tự thưởng'**
  String get rewardsError;

  /// No description provided for @rewardsNotEnough.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đạt đủ điểm thành tích để mở gợi ý này.'**
  String get rewardsNotEnough;

  /// No description provided for @rewardsClaimed.
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi nhận tự thưởng!'**
  String get rewardsClaimed;

  /// No description provided for @rewardsClaimFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể ghi nhận tự thưởng'**
  String get rewardsClaimFailed;

  /// No description provided for @questRulesPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luật tạo nhiệm vụ'**
  String get questRulesPageTitle;

  /// No description provided for @questRulesPageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Điều chỉnh cách SoloQuest tạo nhiệm vụ phù hợp với năng lượng, lịch và mục tiêu của bạn.'**
  String get questRulesPageSubtitle;

  /// No description provided for @questRulesSummaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bộ luật tạo nhiệm vụ'**
  String get questRulesSummaryTitle;

  /// No description provided for @questRulesDailyLimitTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giới hạn n/vụ mỗi ngày'**
  String get questRulesDailyLimitTitle;

  /// No description provided for @questRulesDailyLimitSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Giúp app không tạo quá nhiều nhiệm vụ gây quá tải.'**
  String get questRulesDailyLimitSubtitle;

  /// No description provided for @questRulesPriorityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Loại nhiệm vụ ưu tiên'**
  String get questRulesPriorityTitle;

  /// No description provided for @questRulesListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Luật nhiệm vụ hiện có'**
  String get questRulesListTitle;

  /// No description provided for @questRulesFormTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa luật'**
  String get questRulesFormTitle;

  /// No description provided for @questRulesEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có luật nào'**
  String get questRulesEmptyTitle;

  /// No description provided for @questRulesEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'SoloQuest cần luật để tạo nhiệm vụ đúng nhịp và không làm bạn quá tải.'**
  String get questRulesEmptyMessage;

  /// No description provided for @questRulesToastToggleOn.
  ///
  /// In vi, this message translates to:
  /// **'Đã bật luật'**
  String get questRulesToastToggleOn;

  /// No description provided for @questRulesToastToggleOff.
  ///
  /// In vi, this message translates to:
  /// **'Đã tắt luật'**
  String get questRulesToastToggleOff;

  /// No description provided for @questRulesToastToggleFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật trạng thái'**
  String get questRulesToastToggleFailed;

  /// No description provided for @questRulesToastUpdateSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật luật thành công'**
  String get questRulesToastUpdateSuccess;

  /// No description provided for @questRulesToastUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật luật'**
  String get questRulesToastUpdateFailed;

  /// No description provided for @questRulesToastDailyLimitSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật giới hạn nhiệm vụ/ngày'**
  String get questRulesToastDailyLimitSuccess;

  /// No description provided for @questRulesToastDailyLimitFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật giới hạn'**
  String get questRulesToastDailyLimitFailed;

  /// No description provided for @questRulesToastResetSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã khôi phục luật mặc định'**
  String get questRulesToastResetSuccess;

  /// No description provided for @questRulesToastResetFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể khôi phục luật mặc định'**
  String get questRulesToastResetFailed;

  /// No description provided for @questRulesMetricTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng luật'**
  String get questRulesMetricTotal;

  /// No description provided for @questRulesMetricEnabled.
  ///
  /// In vi, this message translates to:
  /// **'Đang bật'**
  String get questRulesMetricEnabled;

  /// No description provided for @questRulesMetricDisabled.
  ///
  /// In vi, this message translates to:
  /// **'Đang tắt'**
  String get questRulesMetricDisabled;

  /// No description provided for @questRulesMetricDailyLimit.
  ///
  /// In vi, this message translates to:
  /// **'Giới hạn/ngày'**
  String get questRulesMetricDailyLimit;

  /// No description provided for @questRulesFormTitleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề'**
  String get questRulesFormTitleLabel;

  /// No description provided for @questRulesFormTitlePlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Tên luật quest'**
  String get questRulesFormTitlePlaceholder;

  /// No description provided for @questRulesFormDescLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get questRulesFormDescLabel;

  /// No description provided for @questRulesFormDescPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả cách luật này hoạt động'**
  String get questRulesFormDescPlaceholder;

  /// No description provided for @questRulesFormIntervalLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng cách tối thiểu'**
  String get questRulesFormIntervalLabel;

  /// No description provided for @questRulesFormMaxPerDayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa mỗi ngày'**
  String get questRulesFormMaxPerDayLabel;

  /// No description provided for @questRulesFormPriorityLabel.
  ///
  /// In vi, this message translates to:
  /// **'Độ ưu tiên'**
  String get questRulesFormPriorityLabel;

  /// No description provided for @questRulesFormTimeRangeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khung giờ hoạt động'**
  String get questRulesFormTimeRangeLabel;

  /// No description provided for @questRulesFormTimeRangeStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get questRulesFormTimeRangeStart;

  /// No description provided for @questRulesFormTimeRangeEnd.
  ///
  /// In vi, this message translates to:
  /// **'Kết thúc'**
  String get questRulesFormTimeRangeEnd;

  /// No description provided for @questRulesFormActiveDaysLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày hoạt động'**
  String get questRulesFormActiveDaysLabel;

  /// No description provided for @questRulesFormAdaptEnergy.
  ///
  /// In vi, this message translates to:
  /// **'Thích ứng năng lượng'**
  String get questRulesFormAdaptEnergy;

  /// No description provided for @questRulesFormAdaptEnergySub.
  ///
  /// In vi, this message translates to:
  /// **'Điều chỉnh quest theo mức năng lượng.'**
  String get questRulesFormAdaptEnergySub;

  /// No description provided for @questRulesFormAdaptStress.
  ///
  /// In vi, this message translates to:
  /// **'Thích ứng stress'**
  String get questRulesFormAdaptStress;

  /// No description provided for @questRulesFormAdaptStressSub.
  ///
  /// In vi, this message translates to:
  /// **'Giảm độ nặng khi stress cao.'**
  String get questRulesFormAdaptStressSub;

  /// No description provided for @questRulesFormAdaptSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Thích ứng lịch bận'**
  String get questRulesFormAdaptSchedule;

  /// No description provided for @questRulesFormAdaptScheduleSub.
  ///
  /// In vi, this message translates to:
  /// **'Tránh tạo quest trùng lịch bận.'**
  String get questRulesFormAdaptScheduleSub;

  /// No description provided for @questRulesFormSaveButton.
  ///
  /// In vi, this message translates to:
  /// **'Lưu luật quest'**
  String get questRulesFormSaveButton;

  /// No description provided for @questRulesFormTitleRequired.
  ///
  /// In vi, this message translates to:
  /// **'Title không được rỗng'**
  String get questRulesFormTitleRequired;

  /// No description provided for @questRulesFormIntervalMin.
  ///
  /// In vi, this message translates to:
  /// **'Min interval phải lớn hơn 0'**
  String get questRulesFormIntervalMin;

  /// No description provided for @questRulesFormMaxPerDayMin.
  ///
  /// In vi, this message translates to:
  /// **'Max per day phải lớn hơn 0'**
  String get questRulesFormMaxPerDayMin;

  /// No description provided for @questRulesFormSelectActiveDays.
  ///
  /// In vi, this message translates to:
  /// **'Cần chọn ít nhất một ngày hoạt động'**
  String get questRulesFormSelectActiveDays;

  /// No description provided for @questRulesPrioritySelectTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn độ ưu tiên'**
  String get questRulesPrioritySelectTitle;

  /// No description provided for @questRulesGeneralSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt chung'**
  String get questRulesGeneralSettings;

  /// No description provided for @questRulesGeneralDifficulty.
  ///
  /// In vi, this message translates to:
  /// **'Độ khó mặc định'**
  String get questRulesGeneralDifficulty;

  /// No description provided for @questRulesGeneralDuration.
  ///
  /// In vi, this message translates to:
  /// **'Thời lượng quest'**
  String get questRulesGeneralDuration;

  /// No description provided for @questRulesGeneralAutoAdjust.
  ///
  /// In vi, this message translates to:
  /// **'Tự động điều chỉnh quest'**
  String get questRulesGeneralAutoAdjust;

  /// No description provided for @questRulesGeneralAutoAdjustSub.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống tự điều chỉnh độ khó và số lượng quest dựa trên dữ liệu tuần.'**
  String get questRulesGeneralAutoAdjustSub;

  /// No description provided for @questRulesGeneralRestDay.
  ///
  /// In vi, this message translates to:
  /// **'Ngày nghỉ linh hoạt'**
  String get questRulesGeneralRestDay;

  /// No description provided for @questRulesGeneralRestDaySub.
  ///
  /// In vi, this message translates to:
  /// **'Cho phép có ngày không tạo quest để nghỉ ngơi.'**
  String get questRulesGeneralRestDaySub;

  /// No description provided for @questRulesGeneralDurationShort.
  ///
  /// In vi, this message translates to:
  /// **'Ngắn'**
  String get questRulesGeneralDurationShort;

  /// No description provided for @questRulesGeneralDurationMedium.
  ///
  /// In vi, this message translates to:
  /// **'Vừa'**
  String get questRulesGeneralDurationMedium;

  /// No description provided for @questRulesGeneralDurationLong.
  ///
  /// In vi, this message translates to:
  /// **'Dài'**
  String get questRulesGeneralDurationLong;

  /// No description provided for @questRulesRuleCardInterval.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi {minutes} phút'**
  String questRulesRuleCardInterval(Object minutes);

  /// No description provided for @questRulesRuleCardMaxPerDay.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa {max} lần/ngày'**
  String questRulesRuleCardMaxPerDay(Object max);

  /// No description provided for @questRulesRuleCardPriority.
  ///
  /// In vi, this message translates to:
  /// **'Ưu tiên {priority}'**
  String questRulesRuleCardPriority(Object priority);

  /// No description provided for @questRulesRuleCardEditButton.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get questRulesRuleCardEditButton;

  /// No description provided for @questRulesResetConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục luật mặc định?'**
  String get questRulesResetConfirmTitle;

  /// No description provided for @questRulesResetConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Các tuỳ chỉnh hiện tại sẽ được thay bằng bộ luật mặc định của SoloQuest.'**
  String get questRulesResetConfirmMessage;

  /// No description provided for @questRulesResetConfirmButton.
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục'**
  String get questRulesResetConfirmButton;

  /// No description provided for @questRulesResetDefault.
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục mặc định'**
  String get questRulesResetDefault;

  /// No description provided for @questRulesGeneralDifficultySelectorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn độ khó'**
  String get questRulesGeneralDifficultySelectorTitle;

  /// No description provided for @questRulesLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải cài đặt quest...'**
  String get questRulesLoading;

  /// No description provided for @questRulesError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải cài đặt quest'**
  String get questRulesError;

  /// No description provided for @questRulesToastDifficultyFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật độ khó'**
  String get questRulesToastDifficultyFailed;

  /// No description provided for @questRulesToastAutoAdjustFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật tự động điều chỉnh'**
  String get questRulesToastAutoAdjustFailed;

  /// No description provided for @questRulesToastRestDayFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật ngày nghỉ'**
  String get questRulesToastRestDayFailed;

  /// No description provided for @questRulesToastDurationFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật thời lượng'**
  String get questRulesToastDurationFailed;

  /// No description provided for @questRulesFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get questRulesFilterAll;

  /// No description provided for @questRulesLogToggleOn.
  ///
  /// In vi, this message translates to:
  /// **'Bật luật quest'**
  String get questRulesLogToggleOn;

  /// No description provided for @questRulesLogToggleOff.
  ///
  /// In vi, this message translates to:
  /// **'Tắt luật quest'**
  String get questRulesLogToggleOff;

  /// No description provided for @questRulesLogUpdate.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật luật quest'**
  String get questRulesLogUpdate;

  /// No description provided for @questRulesLogDailyLimit.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật giới hạn quest/ngày'**
  String get questRulesLogDailyLimit;

  /// No description provided for @questRulesLogReset.
  ///
  /// In vi, this message translates to:
  /// **'Khôi phục luật mặc định'**
  String get questRulesLogReset;

  /// No description provided for @questRulesLogResetDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bộ luật tạo quest'**
  String get questRulesLogResetDesc;

  /// No description provided for @questRulesPriorityValue.
  ///
  /// In vi, this message translates to:
  /// **'Ưu tiên {priority}'**
  String questRulesPriorityValue(Object priority);

  /// No description provided for @morningCheckinLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải...'**
  String get morningCheckinLoading;

  /// No description provided for @morningCheckinError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải dữ liệu'**
  String get morningCheckinError;

  /// No description provided for @morningCheckinMissing.
  ///
  /// In vi, this message translates to:
  /// **'Hãy hoàn thành thông tin cần thiết trước khi tiếp tục.'**
  String get morningCheckinMissing;

  /// No description provided for @morningCheckinSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Check-in thành công!'**
  String get morningCheckinSuccess;

  /// No description provided for @morningCheckinFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu check-in. Vui lòng thử lại.'**
  String get morningCheckinFailed;

  /// No description provided for @morningCheckinPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Check-in hôm nay'**
  String get morningCheckinPageTitle;

  /// No description provided for @morningCheckinHeaderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi sáng'**
  String get morningCheckinHeaderTitle;

  /// No description provided for @morningCheckinHeaderSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hãy dành 15 giây để app hiểu hôm nay của bạn.'**
  String get morningCheckinHeaderSubtitle;

  /// No description provided for @morningCheckinStepTitle.
  ///
  /// In vi, this message translates to:
  /// **'Check-in hôm nay'**
  String get morningCheckinStepTitle;

  /// No description provided for @morningCheckinCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn tất'**
  String get morningCheckinCompleted;

  /// No description provided for @morningCheckinMoodLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn cảm thấy thế nào?'**
  String get morningCheckinMoodLabel;

  /// No description provided for @morningCheckinEnergyLabel.
  ///
  /// In vi, this message translates to:
  /// **'Năng lượng hôm nay của bạn?'**
  String get morningCheckinEnergyLabel;

  /// No description provided for @morningCheckinAvailabilityLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn có nhiều thời gian không?'**
  String get morningCheckinAvailabilityLabel;

  /// No description provided for @morningCheckinPriorityLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn muốn ưu tiên gì?'**
  String get morningCheckinPriorityLabel;

  /// No description provided for @morningCheckinSubmitText.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành check-in'**
  String get morningCheckinSubmitText;

  /// No description provided for @morningCheckinUpdateText.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật check-in'**
  String get morningCheckinUpdateText;

  /// No description provided for @morningCheckinToastMissing.
  ///
  /// In vi, this message translates to:
  /// **'Hãy chọn tất cả 4 mục trước khi hoàn thành.'**
  String get morningCheckinToastMissing;

  /// No description provided for @morningCheckinToastSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Check-in hoàn tất!'**
  String get morningCheckinToastSuccess;

  /// No description provided for @morningCheckinToastFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu check-in'**
  String get morningCheckinToastFailed;

  /// No description provided for @availabilityBusy.
  ///
  /// In vi, this message translates to:
  /// **'Bận'**
  String get availabilityBusy;

  /// No description provided for @availabilityNormal.
  ///
  /// In vi, this message translates to:
  /// **'Vừa phải'**
  String get availabilityNormal;

  /// No description provided for @availabilityFree.
  ///
  /// In vi, this message translates to:
  /// **'Rảnh'**
  String get availabilityFree;

  /// No description provided for @dailyReviewLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải dữ liệu hôm nay...'**
  String get dailyReviewLoading;

  /// No description provided for @dailyReviewError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải dữ liệu'**
  String get dailyReviewError;

  /// No description provided for @dailyReviewMissing.
  ///
  /// In vi, this message translates to:
  /// **'Hãy hoàn thành thông tin cần thiết trước khi tiếp tục.'**
  String get dailyReviewMissing;

  /// No description provided for @dailyReviewSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu review hôm nay!'**
  String get dailyReviewSuccess;

  /// No description provided for @dailyReviewFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu review. Vui lòng thử lại.'**
  String get dailyReviewFailed;

  /// No description provided for @dailyReviewPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá cuối ngày'**
  String get dailyReviewPageTitle;

  /// No description provided for @dailyReviewHeaderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá cuối ngày'**
  String get dailyReviewHeaderTitle;

  /// No description provided for @dailyReviewHeaderSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhìn lại hôm nay trong vài giây để AI điều chỉnh quest ngày mai.'**
  String get dailyReviewHeaderSubtitle;

  /// No description provided for @dailyReviewSummaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay của bạn'**
  String get dailyReviewSummaryTitle;

  /// No description provided for @dailyReviewMoodLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cuối ngày bạn cảm thấy thế nào?'**
  String get dailyReviewMoodLabel;

  /// No description provided for @dailyReviewEnergyLabel.
  ///
  /// In vi, this message translates to:
  /// **'Năng lượng còn lại của bạn?'**
  String get dailyReviewEnergyLabel;

  /// No description provided for @dailyReviewSatisfactionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bạn hài lòng với hôm nay mức nào?'**
  String get dailyReviewSatisfactionLabel;

  /// No description provided for @dailyReviewReflectionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay có gì đáng nhớ?'**
  String get dailyReviewReflectionLabel;

  /// No description provided for @dailyReviewPriorityLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày mai bạn muốn ưu tiên gì?'**
  String get dailyReviewPriorityLabel;

  /// No description provided for @dailyReviewReflectionHint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Hôm nay mình học ổn hơn, nhưng hơi thiếu tập trung…'**
  String get dailyReviewReflectionHint;

  /// No description provided for @dailyReviewSubmitText.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành review'**
  String get dailyReviewSubmitText;

  /// No description provided for @dailyReviewUpdateText.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật review'**
  String get dailyReviewUpdateText;

  /// No description provided for @dailyReviewToastMissing.
  ///
  /// In vi, this message translates to:
  /// **'Hãy chọn tâm trạng, năng lượng, mức hài lòng và ưu tiên ngày mai.'**
  String get dailyReviewToastMissing;

  /// No description provided for @dailyReviewToastSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá đã được lưu!'**
  String get dailyReviewToastSuccess;

  /// No description provided for @dailyReviewToastFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu đánh giá. Vui lòng thử lại.'**
  String get dailyReviewToastFailed;

  /// No description provided for @dailyReviewLinkToWeekly.
  ///
  /// In vi, this message translates to:
  /// **'Xem Báo Cáo Tuần'**
  String get dailyReviewLinkToWeekly;

  /// No description provided for @dailyReviewSatisVeryLow.
  ///
  /// In vi, this message translates to:
  /// **'Rất không hài lòng'**
  String get dailyReviewSatisVeryLow;

  /// No description provided for @dailyReviewSatisLow.
  ///
  /// In vi, this message translates to:
  /// **'Không hài lòng'**
  String get dailyReviewSatisLow;

  /// No description provided for @dailyReviewSatisNormal.
  ///
  /// In vi, this message translates to:
  /// **'Bình thường'**
  String get dailyReviewSatisNormal;

  /// No description provided for @dailyReviewSatisHigh.
  ///
  /// In vi, this message translates to:
  /// **'Hài lòng'**
  String get dailyReviewSatisHigh;

  /// No description provided for @dailyReviewSatisVeryHigh.
  ///
  /// In vi, this message translates to:
  /// **'Rất hài lòng'**
  String get dailyReviewSatisVeryHigh;

  /// No description provided for @dailyReviewSummaryCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get dailyReviewSummaryCompleted;

  /// No description provided for @dailyReviewSummaryRate.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ'**
  String get dailyReviewSummaryRate;

  /// No description provided for @dailyReviewSummarySkipped.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get dailyReviewSummarySkipped;

  /// No description provided for @moodVeryBad.
  ///
  /// In vi, this message translates to:
  /// **'Rất tệ'**
  String get moodVeryBad;

  /// No description provided for @moodBad.
  ///
  /// In vi, this message translates to:
  /// **'Tệ'**
  String get moodBad;

  /// No description provided for @moodNormal.
  ///
  /// In vi, this message translates to:
  /// **'Bình thường'**
  String get moodNormal;

  /// No description provided for @moodGood.
  ///
  /// In vi, this message translates to:
  /// **'Tốt'**
  String get moodGood;

  /// No description provided for @moodVeryGood.
  ///
  /// In vi, this message translates to:
  /// **'Rất tốt'**
  String get moodVeryGood;

  /// No description provided for @energyLow.
  ///
  /// In vi, this message translates to:
  /// **'Thấp'**
  String get energyLow;

  /// No description provided for @energyMedium.
  ///
  /// In vi, this message translates to:
  /// **'Vừa'**
  String get energyMedium;

  /// No description provided for @energyHigh.
  ///
  /// In vi, this message translates to:
  /// **'Cao'**
  String get energyHigh;

  /// No description provided for @priorityLearning.
  ///
  /// In vi, this message translates to:
  /// **'Học tập'**
  String get priorityLearning;

  /// No description provided for @priorityHealth.
  ///
  /// In vi, this message translates to:
  /// **'Sức khỏe'**
  String get priorityHealth;

  /// No description provided for @priorityWork.
  ///
  /// In vi, this message translates to:
  /// **'Công việc'**
  String get priorityWork;

  /// No description provided for @priorityHabit.
  ///
  /// In vi, this message translates to:
  /// **'Thói quen'**
  String get priorityHabit;

  /// No description provided for @priorityRest.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ ngơi'**
  String get priorityRest;

  /// No description provided for @weeklySummaryLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải dữ liệu tuần...'**
  String get weeklySummaryLoading;

  /// No description provided for @weeklySummaryError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải dữ liệu'**
  String get weeklySummaryError;

  /// No description provided for @weeklySummaryNoData.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu'**
  String get weeklySummaryNoData;

  /// No description provided for @weeklySummaryPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tổng Kết Tuần'**
  String get weeklySummaryPageTitle;

  /// No description provided for @weeklySummaryHeaderLabel.
  ///
  /// In vi, this message translates to:
  /// **'◆ BÁO CÁO TUẦN'**
  String get weeklySummaryHeaderLabel;

  /// No description provided for @weeklySummaryHeaderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tổng Kết Tuần'**
  String get weeklySummaryHeaderTitle;

  /// No description provided for @weeklySummaryHeaderDesc.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại dữ liệu tuần này và chọn những điều chỉnh bạn muốn áp dụng cho tuần sau.'**
  String get weeklySummaryHeaderDesc;

  /// No description provided for @weeklySummaryStatsCompletion.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get weeklySummaryStatsCompletion;

  /// No description provided for @weeklySummaryStatsExp.
  ///
  /// In vi, this message translates to:
  /// **'EXP tuần'**
  String get weeklySummaryStatsExp;

  /// No description provided for @weeklySummaryStatsStreak.
  ///
  /// In vi, this message translates to:
  /// **'Streak'**
  String get weeklySummaryStatsStreak;

  /// No description provided for @weeklySummaryStatsSnoozed.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoãn'**
  String get weeklySummaryStatsSnoozed;

  /// No description provided for @weeklySummaryStatsSkipped.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get weeklySummaryStatsSkipped;

  /// No description provided for @weeklySummaryStatsDailyReview.
  ///
  /// In vi, this message translates to:
  /// **'Daily Review'**
  String get weeklySummaryStatsDailyReview;

  /// No description provided for @weeklySummaryChartTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ hoàn thành theo ngày'**
  String get weeklySummaryChartTitle;

  /// No description provided for @weeklySummarySectionCompare.
  ///
  /// In vi, this message translates to:
  /// **'So sánh tuần trước'**
  String get weeklySummarySectionCompare;

  /// No description provided for @weeklySummarySectionInsights.
  ///
  /// In vi, this message translates to:
  /// **'Điểm nổi bật tuần này'**
  String get weeklySummarySectionInsights;

  /// No description provided for @weeklySummarySectionTopQuests.
  ///
  /// In vi, this message translates to:
  /// **'Quest hiệu quả nhất'**
  String get weeklySummarySectionTopQuests;

  /// No description provided for @weeklySummarySectionAdjust.
  ///
  /// In vi, this message translates to:
  /// **'Quest cần điều chỉnh'**
  String get weeklySummarySectionAdjust;

  /// No description provided for @weeklySummarySectionSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Đề xuất cho tuần sau'**
  String get weeklySummarySectionSuggestions;

  /// No description provided for @weeklySummarySectionSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Mẫu tuần sau'**
  String get weeklySummarySectionSchedule;

  /// No description provided for @weeklySummaryScheduleTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nếu áp dụng đề xuất, SoloQuest sẽ ưu tiên:'**
  String get weeklySummaryScheduleTitle;

  /// No description provided for @weeklySummaryScheduleWeekday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 2 – Thứ 6'**
  String get weeklySummaryScheduleWeekday;

  /// No description provided for @weeklySummaryScheduleWeekend.
  ///
  /// In vi, this message translates to:
  /// **'Cuối tuần'**
  String get weeklySummaryScheduleWeekend;

  /// No description provided for @weeklySummaryProtectionText.
  ///
  /// In vi, this message translates to:
  /// **'SoloQuest chỉ đề xuất điều chỉnh. Bạn luôn có thể bật/tắt, chỉnh thủ công hoặc không áp dụng đề xuất nào.'**
  String get weeklySummaryProtectionText;

  /// No description provided for @weeklySummaryCtaApply.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng đề xuất đã chọn'**
  String get weeklySummaryCtaApply;

  /// No description provided for @weeklySummaryCtaManual.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh thủ công'**
  String get weeklySummaryCtaManual;

  /// No description provided for @weeklySummaryCtaApplied.
  ///
  /// In vi, this message translates to:
  /// **'✓ Đã áp dụng'**
  String get weeklySummaryCtaApplied;

  /// No description provided for @weeklySummaryLinkLogs.
  ///
  /// In vi, this message translates to:
  /// **'Xem Nhật ký chi tiết'**
  String get weeklySummaryLinkLogs;

  /// No description provided for @weeklySummaryLinkRules.
  ///
  /// In vi, this message translates to:
  /// **'Luật điều chỉnh'**
  String get weeklySummaryLinkRules;

  /// No description provided for @weeklySummaryLinkReminders.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh nhắc nhở'**
  String get weeklySummaryLinkReminders;

  /// No description provided for @weeklySummaryToastApplied.
  ///
  /// In vi, this message translates to:
  /// **'Đã áp dụng đề xuất thành công.'**
  String get weeklySummaryToastApplied;

  /// No description provided for @questDetailLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải nhiệm vụ...'**
  String get questDetailLoading;

  /// No description provided for @questDetailError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải nhiệm vụ'**
  String get questDetailError;

  /// No description provided for @questDetailNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy nhiệm vụ'**
  String get questDetailNotFound;

  /// No description provided for @logsLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải nhật ký...'**
  String get logsLoading;

  /// No description provided for @logsError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải nhật ký'**
  String get logsError;

  /// No description provided for @logsPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhật ký'**
  String get logsPageTitle;

  /// No description provided for @logsSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Timeline'**
  String get logsSectionTitle;

  /// No description provided for @logsEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nhật ký cho ngày này'**
  String get logsEmptyTitle;

  /// No description provided for @logsEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành quest hoặc check-in để bắt đầu ghi lại hành trình của bạn.'**
  String get logsEmptyMessage;

  /// No description provided for @logsHomeButton.
  ///
  /// In vi, this message translates to:
  /// **'Về Home'**
  String get logsHomeButton;

  /// No description provided for @logsDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết nhật ký'**
  String get logsDetailTitle;

  /// No description provided for @logsViewQuest.
  ///
  /// In vi, this message translates to:
  /// **'Xem nhiệm vụ'**
  String get logsViewQuest;

  /// No description provided for @logsFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get logsFilterAll;

  /// No description provided for @logsFilterCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get logsFilterCompleted;

  /// No description provided for @logsFilterSkipped.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get logsFilterSkipped;

  /// No description provided for @logsFilterSnoozed.
  ///
  /// In vi, this message translates to:
  /// **'Hoãn'**
  String get logsFilterSnoozed;

  /// No description provided for @logsFilterCheckin.
  ///
  /// In vi, this message translates to:
  /// **'Check-in'**
  String get logsFilterCheckin;

  /// No description provided for @logsFilterReview.
  ///
  /// In vi, this message translates to:
  /// **'Review'**
  String get logsFilterReview;

  /// No description provided for @logsFilterReward.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng'**
  String get logsFilterReward;

  /// No description provided for @logsFilterLevelUp.
  ///
  /// In vi, this message translates to:
  /// **'Tăng cấp'**
  String get logsFilterLevelUp;

  /// No description provided for @logsFilterRoadmap.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình'**
  String get logsFilterRoadmap;

  /// No description provided for @logsFilterRoadmapStep.
  ///
  /// In vi, this message translates to:
  /// **'Bước lộ trình'**
  String get logsFilterRoadmapStep;

  /// No description provided for @logsFilterRoadmapCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình xong'**
  String get logsFilterRoadmapCompleted;

  /// No description provided for @logsToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get logsToday;

  /// No description provided for @logsYesterday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get logsYesterday;

  /// No description provided for @logsSummaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động hôm nay'**
  String get logsSummaryTitle;

  /// No description provided for @logsSelectDate.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày'**
  String get logsSelectDate;

  /// No description provided for @logsClearFilter.
  ///
  /// In vi, this message translates to:
  /// **'Xóa lọc'**
  String get logsClearFilter;

  /// No description provided for @logsSummaryActivities.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động'**
  String get logsSummaryActivities;

  /// No description provided for @logsSummaryCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get logsSummaryCompleted;

  /// No description provided for @logsSummarySkipped.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get logsSummarySkipped;

  /// No description provided for @logsTimelineCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} hoạt động'**
  String logsTimelineCount(Object count);

  /// No description provided for @logsHeaderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhật ký cá nhân'**
  String get logsHeaderTitle;

  /// No description provided for @logsHeaderSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi hành vi, quest và cảm xúc của bạn'**
  String get logsHeaderSubtitle;

  /// No description provided for @logsDetailTypeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Loại'**
  String get logsDetailTypeLabel;

  /// No description provided for @logsDetailDescLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get logsDetailDescLabel;

  /// No description provided for @logsDetailPointsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Điểm thưởng'**
  String get logsDetailPointsLabel;

  /// No description provided for @logsDetailPointsValue.
  ///
  /// In vi, this message translates to:
  /// **'{points} điểm'**
  String logsDetailPointsValue(Object points);

  /// No description provided for @logsDetailMoodLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cảm xúc'**
  String get logsDetailMoodLabel;

  /// No description provided for @homeLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải dữ liệu...'**
  String get homeLoading;

  /// No description provided for @homeError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải dữ liệu hôm nay'**
  String get homeError;

  /// No description provided for @homeQuestStarted.
  ///
  /// In vi, this message translates to:
  /// **'Đã bắt đầu'**
  String get homeQuestStarted;

  /// No description provided for @homeQuestCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành nhiệm vụ'**
  String get homeQuestCompleted;

  /// No description provided for @homeQuestSnoozed.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoãn nhiệm vụ'**
  String get homeQuestSnoozed;

  /// No description provided for @homeQuestSkipped.
  ///
  /// In vi, this message translates to:
  /// **'Đã bỏ qua nhiệm vụ'**
  String get homeQuestSkipped;

  /// No description provided for @homeQuestStartError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể bắt đầu nhiệm vụ'**
  String get homeQuestStartError;

  /// No description provided for @homeQuestCompleteError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể hoàn thành nhiệm vụ'**
  String get homeQuestCompleteError;

  /// No description provided for @homeQuestSnoozeError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể hoãn nhiệm vụ'**
  String get homeQuestSnoozeError;

  /// No description provided for @homeQuestSkipError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể bỏ qua nhiệm vụ'**
  String get homeQuestSkipError;

  /// No description provided for @homeQuestReasonTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vì sao có nhiệm vụ này?'**
  String get homeQuestReasonTitle;

  /// No description provided for @homeQuestReasonDefault.
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ này được đề xuất dựa trên lịch sinh hoạt và lộ trình học hôm nay của bạn.'**
  String get homeQuestReasonDefault;

  /// No description provided for @onboardingValidation.
  ///
  /// In vi, this message translates to:
  /// **'Hãy hoàn thành thông tin cần thiết trước khi tiếp tục.'**
  String get onboardingValidation;

  /// No description provided for @onboardingComplete.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu ngày đầu tiên với SoloQuest.'**
  String get onboardingComplete;

  /// No description provided for @onboardingCompleteError.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng thử lại.'**
  String get onboardingCompleteError;

  /// No description provided for @onboardingGeneratingQuestsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang cá nhân hóa quest hôm nay...'**
  String get onboardingGeneratingQuestsTitle;

  /// No description provided for @onboardingGeneratingQuestsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'SoloQuest đang dựa trên mục tiêu và lịch sinh hoạt của bạn để chuẩn bị nhiệm vụ đầu tiên.'**
  String get onboardingGeneratingQuestsSubtitle;

  /// No description provided for @onboardingGenerateQuestsFallbackMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu hồ sơ. Quest hôm nay sẽ được tạo lại sau.'**
  String get onboardingGenerateQuestsFallbackMessage;

  /// No description provided for @onboardingProgressLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bước'**
  String get onboardingProgressLabel;

  /// No description provided for @onboardingBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get onboardingBack;

  /// No description provided for @onboardingNext.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo'**
  String get onboardingNext;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thiết Lập Hành Trình'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'SoloQuest sẽ tạo nhiệm vụ cá nhân hóa dựa trên thông tin thiết yếu của bạn. Quy trình gồm 5 phần thiết lập.'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingWelcomeHint.
  ///
  /// In vi, this message translates to:
  /// **'Mất khoảng 2 phút. Bạn có thể chỉnh lại sau.'**
  String get onboardingWelcomeHint;

  /// No description provided for @onboardingWelcomeStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu thiết lập'**
  String get onboardingWelcomeStart;

  /// No description provided for @onboardingWelcomeGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Chào, {name}'**
  String onboardingWelcomeGreeting(String name);

  /// No description provided for @onboardingWelcomeStep1.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân'**
  String get onboardingWelcomeStep1;

  /// No description provided for @onboardingWelcomeStep2.
  ///
  /// In vi, this message translates to:
  /// **'Công việc & lịch trình'**
  String get onboardingWelcomeStep2;

  /// No description provided for @onboardingWelcomeStep3.
  ///
  /// In vi, this message translates to:
  /// **'Sức khỏe & thể chất'**
  String get onboardingWelcomeStep3;

  /// No description provided for @onboardingWelcomeStep4.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu cá nhân'**
  String get onboardingWelcomeStep4;

  /// No description provided for @onboardingWelcomeStep5.
  ///
  /// In vi, this message translates to:
  /// **'Lịch trình hàng ngày'**
  String get onboardingWelcomeStep5;

  /// No description provided for @onboardingWelcomeStep6.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở'**
  String get onboardingWelcomeStep6;

  /// No description provided for @onboardingWelcomeStep7.
  ///
  /// In vi, this message translates to:
  /// **'Phần thưởng'**
  String get onboardingWelcomeStep7;

  /// No description provided for @onboardingStep1Title.
  ///
  /// In vi, this message translates to:
  /// **'Thông Tin Cá Nhân'**
  String get onboardingStep1Title;

  /// No description provided for @onboardingStep1Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống cần dữ liệu cơ bản để tính toán nhiệm vụ phù hợp'**
  String get onboardingStep1Subtitle;

  /// No description provided for @onboardingStep1NameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên Hiển Thị'**
  String get onboardingStep1NameLabel;

  /// No description provided for @onboardingStep1NameHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên của bạn'**
  String get onboardingStep1NameHint;

  /// No description provided for @onboardingStep1AgeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tuổi'**
  String get onboardingStep1AgeLabel;

  /// No description provided for @onboardingStep1AgeHint.
  ///
  /// In vi, this message translates to:
  /// **'25'**
  String get onboardingStep1AgeHint;

  /// No description provided for @onboardingStep1AgeSuffix.
  ///
  /// In vi, this message translates to:
  /// **' tuổi'**
  String get onboardingStep1AgeSuffix;

  /// No description provided for @onboardingStep1GenderLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giới Tính'**
  String get onboardingStep1GenderLabel;

  /// No description provided for @onboardingStep1GenderMale.
  ///
  /// In vi, this message translates to:
  /// **'Nam'**
  String get onboardingStep1GenderMale;

  /// No description provided for @onboardingStep1GenderFemale.
  ///
  /// In vi, this message translates to:
  /// **'Nữ'**
  String get onboardingStep1GenderFemale;

  /// No description provided for @onboardingStep1GenderOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get onboardingStep1GenderOther;

  /// No description provided for @onboardingStep1HeightLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chiều Cao'**
  String get onboardingStep1HeightLabel;

  /// No description provided for @onboardingStep1HeightHint.
  ///
  /// In vi, this message translates to:
  /// **'170'**
  String get onboardingStep1HeightHint;

  /// No description provided for @onboardingStep1HeightSuffix.
  ///
  /// In vi, this message translates to:
  /// **' cm'**
  String get onboardingStep1HeightSuffix;

  /// No description provided for @onboardingStep1WeightLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cân Nặng'**
  String get onboardingStep1WeightLabel;

  /// No description provided for @onboardingStep1WeightHint.
  ///
  /// In vi, this message translates to:
  /// **'70'**
  String get onboardingStep1WeightHint;

  /// No description provided for @onboardingStep1WeightSuffix.
  ///
  /// In vi, this message translates to:
  /// **' kg'**
  String get onboardingStep1WeightSuffix;

  /// No description provided for @onboardingStep1SystemNote.
  ///
  /// In vi, this message translates to:
  /// **'[ HỆ THỐNG ] Dữ liệu hồ sơ được mã hóa. Chỉ dùng để tối ưu hóa nhiệm vụ.'**
  String get onboardingStep1SystemNote;

  /// No description provided for @onboardingStep2Title.
  ///
  /// In vi, this message translates to:
  /// **'Lịch làm việc'**
  String get onboardingStep2Title;

  /// No description provided for @onboardingStep2Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống cần biết lịch làm việc để sắp xếp quest vào giờ phù hợp'**
  String get onboardingStep2Subtitle;

  /// No description provided for @onboardingStep2MainActivityLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bạn Đang Làm Gì?'**
  String get onboardingStep2MainActivityLabel;

  /// No description provided for @onboardingStep2WorkScheduleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lịch Làm Việc / Học'**
  String get onboardingStep2WorkScheduleLabel;

  /// No description provided for @onboardingStep2WorkStartTimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giờ bắt đầu'**
  String get onboardingStep2WorkStartTimeLabel;

  /// No description provided for @onboardingStep2WorkEndTimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giờ kết thúc'**
  String get onboardingStep2WorkEndTimeLabel;

  /// No description provided for @onboardingStep2FreeTimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời Gian Rảnh'**
  String get onboardingStep2FreeTimeLabel;

  /// No description provided for @onboardingStep2SystemNote.
  ///
  /// In vi, this message translates to:
  /// **'[ HỆ THỐNG ] Quest sẽ không xếp vào giờ làm việc của bạn'**
  String get onboardingStep2SystemNote;

  /// No description provided for @onboardingStep2ActivityDeveloper.
  ///
  /// In vi, this message translates to:
  /// **'Software Engineer'**
  String get onboardingStep2ActivityDeveloper;

  /// No description provided for @onboardingStep2ActivityStudent.
  ///
  /// In vi, this message translates to:
  /// **'Sinh Viên'**
  String get onboardingStep2ActivityStudent;

  /// No description provided for @onboardingStep2ActivityOffice.
  ///
  /// In vi, this message translates to:
  /// **'Nhân Viên Văn Phòng'**
  String get onboardingStep2ActivityOffice;

  /// No description provided for @onboardingStep2ActivityFreelancer.
  ///
  /// In vi, this message translates to:
  /// **'Freelancer'**
  String get onboardingStep2ActivityFreelancer;

  /// No description provided for @onboardingStep2ActivityOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get onboardingStep2ActivityOther;

  /// No description provided for @onboardingStep2ScheduleWeekday.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 2–6'**
  String get onboardingStep2ScheduleWeekday;

  /// No description provided for @onboardingStep2ScheduleMonSat.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 2–7'**
  String get onboardingStep2ScheduleMonSat;

  /// No description provided for @onboardingStep2ScheduleFullWeek.
  ///
  /// In vi, this message translates to:
  /// **'Cả tuần'**
  String get onboardingStep2ScheduleFullWeek;

  /// No description provided for @onboardingStep2ScheduleFlexible.
  ///
  /// In vi, this message translates to:
  /// **'Linh hoạt'**
  String get onboardingStep2ScheduleFlexible;

  /// No description provided for @onboardingStep2ScheduleNight.
  ///
  /// In vi, this message translates to:
  /// **'Ca đêm'**
  String get onboardingStep2ScheduleNight;

  /// No description provided for @onboardingStep2ScheduleHelper.
  ///
  /// In vi, this message translates to:
  /// **'Đây chỉ là lịch khởi tạo ban đầu. Bạn có thể chỉnh chi tiết lại sau trong phần Lịch sinh hoạt.'**
  String get onboardingStep2ScheduleHelper;

  /// No description provided for @onboardingStep2FreeTimeEarlyMorning.
  ///
  /// In vi, this message translates to:
  /// **'Sáng sớm (5–7h)'**
  String get onboardingStep2FreeTimeEarlyMorning;

  /// No description provided for @onboardingStep2FreeTimeNoon.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ trưa'**
  String get onboardingStep2FreeTimeNoon;

  /// No description provided for @onboardingStep2FreeTimeAfterWork.
  ///
  /// In vi, this message translates to:
  /// **'Sau giờ làm'**
  String get onboardingStep2FreeTimeAfterWork;

  /// No description provided for @onboardingStep2FreeTimeEvening.
  ///
  /// In vi, this message translates to:
  /// **'Tối (20–23h)'**
  String get onboardingStep2FreeTimeEvening;

  /// No description provided for @onboardingStep3Title.
  ///
  /// In vi, this message translates to:
  /// **'Sức Khỏe & Vận Động'**
  String get onboardingStep3Title;

  /// No description provided for @onboardingStep3Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống cần đánh giá thể trạng để tạo nhiệm vụ vừa sức'**
  String get onboardingStep3Subtitle;

  /// No description provided for @onboardingStep3ActivityLevelLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mức Độ Vận Động Hiện Tại'**
  String get onboardingStep3ActivityLevelLabel;

  /// No description provided for @onboardingStep3LastWorkoutLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lần Cuối Tập Luyện'**
  String get onboardingStep3LastWorkoutLabel;

  /// No description provided for @onboardingStep3HealthLimitationsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Có Giới Hạn Nào Không?'**
  String get onboardingStep3HealthLimitationsLabel;

  /// No description provided for @onboardingStep3SystemNote.
  ///
  /// In vi, this message translates to:
  /// **'[ HỆ THỐNG ] Quest vận động sẽ bắt đầu từ mức phù hợp với bạn'**
  String get onboardingStep3SystemNote;

  /// No description provided for @onboardingStep3ActivityLevelLittle.
  ///
  /// In vi, this message translates to:
  /// **'Rất ít'**
  String get onboardingStep3ActivityLevelLittle;

  /// No description provided for @onboardingStep3ActivityLevelLittleDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hầu như không vận động, ngồi nhiều'**
  String get onboardingStep3ActivityLevelLittleDesc;

  /// No description provided for @onboardingStep3ActivityLevelOccasional.
  ///
  /// In vi, this message translates to:
  /// **'Thỉnh thoảng'**
  String get onboardingStep3ActivityLevelOccasional;

  /// No description provided for @onboardingStep3ActivityLevelOccasionalDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đi bộ nhẹ, vận động 1–2 lần/tuần'**
  String get onboardingStep3ActivityLevelOccasionalDesc;

  /// No description provided for @onboardingStep3ActivityLevelRegular.
  ///
  /// In vi, this message translates to:
  /// **'Đều đặn'**
  String get onboardingStep3ActivityLevelRegular;

  /// No description provided for @onboardingStep3ActivityLevelRegularDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tập luyện 3–5 lần/tuần'**
  String get onboardingStep3ActivityLevelRegularDesc;

  /// No description provided for @onboardingStep3LastWorkoutToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get onboardingStep3LastWorkoutToday;

  /// No description provided for @onboardingStep3LastWorkoutWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này'**
  String get onboardingStep3LastWorkoutWeek;

  /// No description provided for @onboardingStep3LastWorkoutMonth.
  ///
  /// In vi, this message translates to:
  /// **'1 tháng trước'**
  String get onboardingStep3LastWorkoutMonth;

  /// No description provided for @onboardingStep3LastWorkoutLonger.
  ///
  /// In vi, this message translates to:
  /// **'Lâu hơn'**
  String get onboardingStep3LastWorkoutLonger;

  /// No description provided for @onboardingStep3LimitationBackPain.
  ///
  /// In vi, this message translates to:
  /// **'Đau lưng'**
  String get onboardingStep3LimitationBackPain;

  /// No description provided for @onboardingStep3LimitationEyeStrain.
  ///
  /// In vi, this message translates to:
  /// **'Mỏi mắt'**
  String get onboardingStep3LimitationEyeStrain;

  /// No description provided for @onboardingStep3LimitationLowEnergy.
  ///
  /// In vi, this message translates to:
  /// **'Ít năng lượng'**
  String get onboardingStep3LimitationLowEnergy;

  /// No description provided for @onboardingStep3LimitationBusy.
  ///
  /// In vi, this message translates to:
  /// **'Bận rộn'**
  String get onboardingStep3LimitationBusy;

  /// No description provided for @onboardingStep3LimitationNone.
  ///
  /// In vi, this message translates to:
  /// **'Không có'**
  String get onboardingStep3LimitationNone;

  /// No description provided for @onboardingStep4Title.
  ///
  /// In vi, this message translates to:
  /// **'Đặt Mục Tiêu'**
  String get onboardingStep4Title;

  /// No description provided for @onboardingStep4Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn lĩnh vực bạn muốn cải thiện. Hệ thống sẽ ưu tiên trong nhiệm vụ hàng ngày.'**
  String get onboardingStep4Subtitle;

  /// No description provided for @onboardingStep4MainGoalsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mục Tiêu Chính'**
  String get onboardingStep4MainGoalsLabel;

  /// No description provided for @onboardingStep4SystemNote.
  ///
  /// In vi, this message translates to:
  /// **'[ HỆ THỐNG ] Mục tiêu có thể điều chỉnh bất cứ lúc nào từ cài đặt'**
  String get onboardingStep4SystemNote;

  /// No description provided for @onboardingStep4LearningTopicLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn học gì trước?'**
  String get onboardingStep4LearningTopicLabel;

  /// No description provided for @onboardingStep4LearningTopicHint.
  ///
  /// In vi, this message translates to:
  /// **'Flutter, tiếng Anh, AI, công việc...'**
  String get onboardingStep4LearningTopicHint;

  /// No description provided for @onboardingGoalWater.
  ///
  /// In vi, this message translates to:
  /// **'Uống Nước'**
  String get onboardingGoalWater;

  /// No description provided for @onboardingGoalWaterDesc.
  ///
  /// In vi, this message translates to:
  /// **'Xây dựng thói quen uống nước đều đặn'**
  String get onboardingGoalWaterDesc;

  /// No description provided for @onboardingGoalHealth.
  ///
  /// In vi, this message translates to:
  /// **'Sức Khỏe'**
  String get onboardingGoalHealth;

  /// No description provided for @onboardingGoalHealthDesc.
  ///
  /// In vi, this message translates to:
  /// **'Xây dựng thói quen lành mạnh mỗi ngày'**
  String get onboardingGoalHealthDesc;

  /// No description provided for @onboardingGoalFitness.
  ///
  /// In vi, this message translates to:
  /// **'Vận Động'**
  String get onboardingGoalFitness;

  /// No description provided for @onboardingGoalFitnessDesc.
  ///
  /// In vi, this message translates to:
  /// **'Vận động và tập thể dục hàng ngày'**
  String get onboardingGoalFitnessDesc;

  /// No description provided for @onboardingGoalLearning.
  ///
  /// In vi, this message translates to:
  /// **'Học Tập'**
  String get onboardingGoalLearning;

  /// No description provided for @onboardingGoalLearningDesc.
  ///
  /// In vi, this message translates to:
  /// **'Dành thời gian học và xây dựng kỹ năng'**
  String get onboardingGoalLearningDesc;

  /// No description provided for @onboardingGoalMindfulness.
  ///
  /// In vi, this message translates to:
  /// **'Chánh Niệm'**
  String get onboardingGoalMindfulness;

  /// No description provided for @onboardingGoalMindfulnessDesc.
  ///
  /// In vi, this message translates to:
  /// **'Thiền và quản lý căng thẳng'**
  String get onboardingGoalMindfulnessDesc;

  /// No description provided for @onboardingGoalSleep.
  ///
  /// In vi, this message translates to:
  /// **'Ngủ Tốt Hơn'**
  String get onboardingGoalSleep;

  /// No description provided for @onboardingGoalSleepDesc.
  ///
  /// In vi, this message translates to:
  /// **'Thói quen ngủ tốt hơn'**
  String get onboardingGoalSleepDesc;

  /// No description provided for @onboardingGoalFocus.
  ///
  /// In vi, this message translates to:
  /// **'Tập Trung Tốt Hơn'**
  String get onboardingGoalFocus;

  /// No description provided for @onboardingGoalFocusDesc.
  ///
  /// In vi, this message translates to:
  /// **'Giảm phân tâm, tăng hiệu suất'**
  String get onboardingGoalFocusDesc;

  /// No description provided for @onboardingGoalWeight.
  ///
  /// In vi, this message translates to:
  /// **'Giảm Cân'**
  String get onboardingGoalWeight;

  /// No description provided for @onboardingGoalWeightDesc.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm soát cân nặng lành mạnh'**
  String get onboardingGoalWeightDesc;

  /// No description provided for @onboardingGoalDiscipline.
  ///
  /// In vi, this message translates to:
  /// **'Kỷ Luật Hơn'**
  String get onboardingGoalDiscipline;

  /// No description provided for @onboardingGoalDisciplineDesc.
  ///
  /// In vi, this message translates to:
  /// **'Xây dựng thói quen và nề nếp'**
  String get onboardingGoalDisciplineDesc;

  /// No description provided for @onboardingStep5Title.
  ///
  /// In vi, this message translates to:
  /// **'Lịch Sinh Hoạt'**
  String get onboardingStep5Title;

  /// No description provided for @onboardingStep5Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống cần biết nhịp sinh hoạt để xếp quest đúng giờ'**
  String get onboardingStep5Subtitle;

  /// No description provided for @onboardingStep5ScheduleHint.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể chỉnh lịch sinh hoạt chi tiết sau trong Cài đặt.'**
  String get onboardingStep5ScheduleHint;

  /// No description provided for @onboardingStep5WakeUpLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giờ Thức Dậy'**
  String get onboardingStep5WakeUpLabel;

  /// No description provided for @onboardingStep5TargetSleepLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giờ Ngủ Mục Tiêu'**
  String get onboardingStep5TargetSleepLabel;

  /// No description provided for @onboardingStep5FreeTimeRangeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời Gian Rảnh Trong Ngày'**
  String get onboardingStep5FreeTimeRangeLabel;

  /// No description provided for @onboardingStep5FromLabel.
  ///
  /// In vi, this message translates to:
  /// **'Từ'**
  String get onboardingStep5FromLabel;

  /// No description provided for @onboardingStep5ToLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đến'**
  String get onboardingStep5ToLabel;

  /// No description provided for @onboardingStep5LearningTimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khung Giờ Muốn Học'**
  String get onboardingStep5LearningTimeLabel;

  /// No description provided for @onboardingStep5MovementTimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khung Giờ Muốn Vận Động'**
  String get onboardingStep5MovementTimeLabel;

  /// No description provided for @onboardingStep5SystemNote.
  ///
  /// In vi, this message translates to:
  /// **'[ HỆ THỐNG ] Quest sẽ được xếp trong khoảng thời gian bạn chọn'**
  String get onboardingStep5SystemNote;

  /// No description provided for @onboardingTimeEarlyMorning.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get onboardingTimeEarlyMorning;

  /// No description provided for @onboardingTimeNoon.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ trưa'**
  String get onboardingTimeNoon;

  /// No description provided for @onboardingTimeEvening.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get onboardingTimeEvening;

  /// No description provided for @onboardingTimeBeforeSleep.
  ///
  /// In vi, this message translates to:
  /// **'Trước khi ngủ'**
  String get onboardingTimeBeforeSleep;

  /// No description provided for @onboardingTimeAfterWork.
  ///
  /// In vi, this message translates to:
  /// **'Sau giờ làm'**
  String get onboardingTimeAfterWork;

  /// No description provided for @onboardingTimeEveningGeneral.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get onboardingTimeEveningGeneral;

  /// No description provided for @onboardingStep6Title.
  ///
  /// In vi, this message translates to:
  /// **'Cài Đặt Nhắc Nhở'**
  String get onboardingStep6Title;

  /// No description provided for @onboardingStep6Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh tần suất nhắc nhở để hệ thống hoạt động phù hợp với bạn'**
  String get onboardingStep6Subtitle;

  /// No description provided for @onboardingStep6BreakQuestLabel.
  ///
  /// In vi, this message translates to:
  /// **'Break Quest — Nghỉ Giải Lao'**
  String get onboardingStep6BreakQuestLabel;

  /// No description provided for @onboardingStep6BreakQuestDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc rời khỏi màn hình sau mỗi khoảng thời gian'**
  String get onboardingStep6BreakQuestDesc;

  /// No description provided for @onboardingStep6BreakIntervalOpt.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi {interval} phút'**
  String onboardingStep6BreakIntervalOpt(Object interval);

  /// No description provided for @onboardingStep6BreakDurationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời Gian Nghỉ'**
  String get onboardingStep6BreakDurationLabel;

  /// No description provided for @onboardingStep6DurationOpt.
  ///
  /// In vi, this message translates to:
  /// **'{duration} phút'**
  String onboardingStep6DurationOpt(Object duration);

  /// No description provided for @onboardingStep6WaterQuestLabel.
  ///
  /// In vi, this message translates to:
  /// **'Water Quest — Uống Nước'**
  String get onboardingStep6WaterQuestLabel;

  /// No description provided for @onboardingStep6WaterQuestDesc.
  ///
  /// In vi, this message translates to:
  /// **'Kiểu nhắc uống nước trong ngày'**
  String get onboardingStep6WaterQuestDesc;

  /// No description provided for @onboardingStep6WaterQuestNote.
  ///
  /// In vi, this message translates to:
  /// **'Ngẫu nhiên: nhắc mỗi 60–120 phút trong giờ hoạt động'**
  String get onboardingStep6WaterQuestNote;

  /// No description provided for @onboardingStep6QuietAfterLabel.
  ///
  /// In vi, this message translates to:
  /// **'Không Nhắc Sau'**
  String get onboardingStep6QuietAfterLabel;

  /// No description provided for @onboardingStep6QuietAfterNote.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống sẽ không gửi thông báo sau giờ này'**
  String get onboardingStep6QuietAfterNote;

  /// No description provided for @onboardingStep6SystemNote.
  ///
  /// In vi, this message translates to:
  /// **'[ HỆ THỐNG ] Bạn có thể thay đổi bất cứ lúc nào trong cài đặt'**
  String get onboardingStep6SystemNote;

  /// No description provided for @onboardingStep6WaterModeFixed.
  ///
  /// In vi, this message translates to:
  /// **'Cố định'**
  String get onboardingStep6WaterModeFixed;

  /// No description provided for @onboardingStep6WaterModeRandom.
  ///
  /// In vi, this message translates to:
  /// **'Ngẫu nhiên'**
  String get onboardingStep6WaterModeRandom;

  /// No description provided for @onboardingStep7Title.
  ///
  /// In vi, this message translates to:
  /// **'Phần Thưởng'**
  String get onboardingStep7Title;

  /// No description provided for @onboardingStep7Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn phần thưởng bạn muốn nhận khi hoàn thành nhiệm vụ'**
  String get onboardingStep7Subtitle;

  /// No description provided for @onboardingStep7RewardsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn dùng phần thưởng nào?'**
  String get onboardingStep7RewardsLabel;

  /// No description provided for @onboardingStep7SystemNote.
  ///
  /// In vi, this message translates to:
  /// **'[ HỆ THỐNG ] Phần thưởng sẽ mở khóa khi bạn đạt đủ EXP trong ngày'**
  String get onboardingStep7SystemNote;

  /// No description provided for @onboardingRewardGame.
  ///
  /// In vi, this message translates to:
  /// **'Chơi game 45 phút'**
  String get onboardingRewardGame;

  /// No description provided for @onboardingRewardGameDesc.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa thời gian chơi game'**
  String get onboardingRewardGameDesc;

  /// No description provided for @onboardingRewardMovie.
  ///
  /// In vi, this message translates to:
  /// **'Xem phim 1 tập'**
  String get onboardingRewardMovie;

  /// No description provided for @onboardingRewardMovieDesc.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa thời gian giải trí'**
  String get onboardingRewardMovieDesc;

  /// No description provided for @onboardingRewardRest.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ ngơi 30 phút'**
  String get onboardingRewardRest;

  /// No description provided for @onboardingRewardRestDesc.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian thư giãn không làm gì'**
  String get onboardingRewardRestDesc;

  /// No description provided for @onboardingRewardSocial.
  ///
  /// In vi, this message translates to:
  /// **'Mạng xã hội 20 phút'**
  String get onboardingRewardSocial;

  /// No description provided for @onboardingRewardSocialDesc.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa thời gian lướt MXH'**
  String get onboardingRewardSocialDesc;

  /// No description provided for @onboardingRewardFood.
  ///
  /// In vi, this message translates to:
  /// **'Ăn món yêu thích'**
  String get onboardingRewardFood;

  /// No description provided for @onboardingRewardFoodDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tự thưởng một bữa ngon'**
  String get onboardingRewardFoodDesc;

  /// No description provided for @onboardingRewardCustom.
  ///
  /// In vi, this message translates to:
  /// **'Tự tạo reward'**
  String get onboardingRewardCustom;

  /// No description provided for @onboardingRewardCustomDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh phần thưởng riêng'**
  String get onboardingRewardCustomDesc;

  /// No description provided for @onboardingStep8Title.
  ///
  /// In vi, this message translates to:
  /// **'Hồ Sơ Đã Sẵn Sàng'**
  String get onboardingStep8Title;

  /// No description provided for @onboardingStep8Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống đã ghi nhận dữ liệu. Nhiệm vụ đầu tiên sẽ được tạo ngay.'**
  String get onboardingStep8Subtitle;

  /// No description provided for @onboardingStep8StartCheckin.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu check-in hôm nay'**
  String get onboardingStep8StartCheckin;

  /// No description provided for @onboardingStep8SummaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tóm Tắt Hồ Sơ'**
  String get onboardingStep8SummaryTitle;

  /// No description provided for @onboardingStep8PreviewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch Nhiệm Vụ Mẫu'**
  String get onboardingStep8PreviewTitle;

  /// No description provided for @onboardingStep8LabelName.
  ///
  /// In vi, this message translates to:
  /// **'Tên hiển thị'**
  String get onboardingStep8LabelName;

  /// No description provided for @onboardingStep8LabelWork.
  ///
  /// In vi, this message translates to:
  /// **'Công việc'**
  String get onboardingStep8LabelWork;

  /// No description provided for @onboardingStep8LabelSchedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch làm'**
  String get onboardingStep8LabelSchedule;

  /// No description provided for @onboardingStep8LabelGoals.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu'**
  String get onboardingStep8LabelGoals;

  /// No description provided for @onboardingStep8LabelSleep.
  ///
  /// In vi, this message translates to:
  /// **'Giờ ngủ'**
  String get onboardingStep8LabelSleep;

  /// No description provided for @onboardingStep8LabelBreak.
  ///
  /// In vi, this message translates to:
  /// **'Break'**
  String get onboardingStep8LabelBreak;

  /// No description provided for @onboardingStep8LabelRewards.
  ///
  /// In vi, this message translates to:
  /// **'Phần thưởng'**
  String get onboardingStep8LabelRewards;

  /// No description provided for @onboardingStep8QuestWater.
  ///
  /// In vi, this message translates to:
  /// **'Uống 250ml nước'**
  String get onboardingStep8QuestWater;

  /// No description provided for @onboardingStep8QuestBreak.
  ///
  /// In vi, this message translates to:
  /// **'Rời khỏi màn hình 5 phút'**
  String get onboardingStep8QuestBreak;

  /// No description provided for @onboardingStep8QuestWalk.
  ///
  /// In vi, this message translates to:
  /// **'Đi bộ 15 phút'**
  String get onboardingStep8QuestWalk;

  /// No description provided for @onboardingStep8QuestStudy.
  ///
  /// In vi, this message translates to:
  /// **'Học Docker cơ bản 20 phút'**
  String get onboardingStep8QuestStudy;

  /// No description provided for @onboardingStep8QuestSleep.
  ///
  /// In vi, this message translates to:
  /// **'Đặt điện thoại xuống 15 phút'**
  String get onboardingStep8QuestSleep;

  /// No description provided for @scheduleEditorDeleteConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xóa khối thời gian này?'**
  String get scheduleEditorDeleteConfirm;

  /// No description provided for @scheduleEditorDeleteMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa?'**
  String get scheduleEditorDeleteMessage;

  /// No description provided for @scheduleEditorPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sinh hoạt'**
  String get scheduleEditorPageTitle;

  /// No description provided for @scheduleEditorPageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cho SoloQuest biết khi nào bạn làm việc, học tập và nghỉ ngơi.'**
  String get scheduleEditorPageSubtitle;

  /// No description provided for @scheduleEditorSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Các khung thời gian'**
  String get scheduleEditorSectionTitle;

  /// No description provided for @scheduleEditorAddBlockButton.
  ///
  /// In vi, this message translates to:
  /// **'Thêm khung giờ'**
  String get scheduleEditorAddBlockButton;

  /// No description provided for @scheduleEditorEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch sinh hoạt'**
  String get scheduleEditorEmptyTitle;

  /// No description provided for @scheduleEditorEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất onboarding hoặc thêm khung giờ để SoloQuest biết khi nào bạn bận.'**
  String get scheduleEditorEmptyMessage;

  /// No description provided for @scheduleEditorFormTitleAdd.
  ///
  /// In vi, this message translates to:
  /// **'Thêm khung thời gian'**
  String get scheduleEditorFormTitleAdd;

  /// No description provided for @scheduleEditorFormTitleCreate.
  ///
  /// In vi, this message translates to:
  /// **'Thêm khung thời gian'**
  String get scheduleEditorFormTitleCreate;

  /// No description provided for @scheduleEditorFormTitleEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa khung thời gian'**
  String get scheduleEditorFormTitleEdit;

  /// No description provided for @scheduleEditorLabelTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề'**
  String get scheduleEditorLabelTitle;

  /// No description provided for @scheduleEditorTitlePlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Làm việc, Học Flutter...'**
  String get scheduleEditorTitlePlaceholder;

  /// No description provided for @scheduleEditorLabelType.
  ///
  /// In vi, this message translates to:
  /// **'Loại lịch'**
  String get scheduleEditorLabelType;

  /// No description provided for @scheduleEditorLabelTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian'**
  String get scheduleEditorLabelTime;

  /// No description provided for @scheduleEditorLabelStartTime.
  ///
  /// In vi, this message translates to:
  /// **'Giờ bắt đầu'**
  String get scheduleEditorLabelStartTime;

  /// No description provided for @scheduleEditorLabelEndTime.
  ///
  /// In vi, this message translates to:
  /// **'Giờ kết thúc'**
  String get scheduleEditorLabelEndTime;

  /// No description provided for @scheduleEditorLabelDays.
  ///
  /// In vi, this message translates to:
  /// **'Ngày áp dụng'**
  String get scheduleEditorLabelDays;

  /// No description provided for @scheduleEditorLabelStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái'**
  String get scheduleEditorLabelStatus;

  /// No description provided for @scheduleEditorLabelWeekdays.
  ///
  /// In vi, this message translates to:
  /// **'Ngày áp dụng'**
  String get scheduleEditorLabelWeekdays;

  /// No description provided for @scheduleEditorLabelFlexible.
  ///
  /// In vi, this message translates to:
  /// **'Linh hoạt'**
  String get scheduleEditorLabelFlexible;

  /// No description provided for @scheduleEditorBadgeBusy.
  ///
  /// In vi, this message translates to:
  /// **'Bận'**
  String get scheduleEditorBadgeBusy;

  /// No description provided for @scheduleEditorBadgeFree.
  ///
  /// In vi, this message translates to:
  /// **'Rảnh'**
  String get scheduleEditorBadgeFree;

  /// No description provided for @scheduleEditorBadgeFixed.
  ///
  /// In vi, this message translates to:
  /// **'Cố định'**
  String get scheduleEditorBadgeFixed;

  /// No description provided for @scheduleEditorBadgeFlexible.
  ///
  /// In vi, this message translates to:
  /// **'Linh hoạt'**
  String get scheduleEditorBadgeFlexible;

  /// No description provided for @scheduleEditorSummaryTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng khung giờ'**
  String get scheduleEditorSummaryTotal;

  /// No description provided for @scheduleEditorBusyDescription.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu khung giờ bận, SoloQuest sẽ tránh tạo quest lúc này.'**
  String get scheduleEditorBusyDescription;

  /// No description provided for @scheduleEditorFlexibleDescription.
  ///
  /// In vi, this message translates to:
  /// **'Có thể điều chỉnh thời gian linh hoạt.'**
  String get scheduleEditorFlexibleDescription;

  /// No description provided for @scheduleEditorButtonSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get scheduleEditorButtonSave;

  /// No description provided for @scheduleEditorButtonCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get scheduleEditorButtonCancel;

  /// No description provided for @scheduleEditorButtonDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get scheduleEditorButtonDelete;

  /// No description provided for @scheduleEditorDeleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa khung thời gian?'**
  String get scheduleEditorDeleteTitle;

  /// No description provided for @scheduleEditorDeleteMsg.
  ///
  /// In vi, this message translates to:
  /// **'Khung thời gian này sẽ bị xóa khỏi lịch sinh hoạt của bạn.'**
  String get scheduleEditorDeleteMsg;

  /// No description provided for @scheduleEditorDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa khung thời gian?'**
  String get scheduleEditorDeleteConfirmTitle;

  /// No description provided for @scheduleEditorDeleteConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Khung thời gian này sẽ bị xóa khỏi lịch sinh hoạt của bạn.'**
  String get scheduleEditorDeleteConfirmMessage;

  /// No description provided for @scheduleEditorDeleteConfirmAction.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get scheduleEditorDeleteConfirmAction;

  /// No description provided for @scheduleEditorToastAddSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm khung thời gian'**
  String get scheduleEditorToastAddSuccess;

  /// No description provided for @scheduleEditorToastAddFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể thêm khung thời gian'**
  String get scheduleEditorToastAddFailed;

  /// No description provided for @scheduleEditorToastUpdateSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật khung thời gian'**
  String get scheduleEditorToastUpdateSuccess;

  /// No description provided for @scheduleEditorToastUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật khung thời gian'**
  String get scheduleEditorToastUpdateFailed;

  /// No description provided for @scheduleEditorToastDeleteSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa khung thời gian'**
  String get scheduleEditorToastDeleteSuccess;

  /// No description provided for @scheduleEditorToastDeleteFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xóa khung thời gian'**
  String get scheduleEditorToastDeleteFailed;

  /// No description provided for @scheduleEditorErrorTitleRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tiêu đề'**
  String get scheduleEditorErrorTitleRequired;

  /// No description provided for @scheduleEditorErrorTimeRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn giờ'**
  String get scheduleEditorErrorTimeRequired;

  /// No description provided for @scheduleEditorErrorWeekdaysRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ít nhất 1 ngày'**
  String get scheduleEditorErrorWeekdaysRequired;

  /// No description provided for @scheduleEditorTypeSchool.
  ///
  /// In vi, this message translates to:
  /// **'Đi học'**
  String get scheduleEditorTypeSchool;

  /// No description provided for @scheduleEditorTypeWork.
  ///
  /// In vi, this message translates to:
  /// **'Đi làm'**
  String get scheduleEditorTypeWork;

  /// No description provided for @scheduleEditorTypeCommute.
  ///
  /// In vi, this message translates to:
  /// **'Di chuyển'**
  String get scheduleEditorTypeCommute;

  /// No description provided for @scheduleEditorTypeMeal.
  ///
  /// In vi, this message translates to:
  /// **'Ăn uống'**
  String get scheduleEditorTypeMeal;

  /// No description provided for @scheduleEditorTypeSleep.
  ///
  /// In vi, this message translates to:
  /// **'Ngủ'**
  String get scheduleEditorTypeSleep;

  /// No description provided for @scheduleEditorTypeStudy.
  ///
  /// In vi, this message translates to:
  /// **'Tự học'**
  String get scheduleEditorTypeStudy;

  /// No description provided for @scheduleEditorTypePersonal.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get scheduleEditorTypePersonal;

  /// No description provided for @scheduleEditorTypeBusy.
  ///
  /// In vi, this message translates to:
  /// **'Bận'**
  String get scheduleEditorTypeBusy;

  /// No description provided for @scheduleEditorTypeFree.
  ///
  /// In vi, this message translates to:
  /// **'Rảnh'**
  String get scheduleEditorTypeFree;

  /// No description provided for @scheduleEditorTypeOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get scheduleEditorTypeOther;

  /// No description provided for @scheduleEditorWeekdayMon.
  ///
  /// In vi, this message translates to:
  /// **'T2'**
  String get scheduleEditorWeekdayMon;

  /// No description provided for @scheduleEditorWeekdayTue.
  ///
  /// In vi, this message translates to:
  /// **'T3'**
  String get scheduleEditorWeekdayTue;

  /// No description provided for @scheduleEditorWeekdayWed.
  ///
  /// In vi, this message translates to:
  /// **'T4'**
  String get scheduleEditorWeekdayWed;

  /// No description provided for @scheduleEditorWeekdayThu.
  ///
  /// In vi, this message translates to:
  /// **'T5'**
  String get scheduleEditorWeekdayThu;

  /// No description provided for @scheduleEditorWeekdayFri.
  ///
  /// In vi, this message translates to:
  /// **'T6'**
  String get scheduleEditorWeekdayFri;

  /// No description provided for @scheduleEditorWeekdaySat.
  ///
  /// In vi, this message translates to:
  /// **'T7'**
  String get scheduleEditorWeekdaySat;

  /// No description provided for @scheduleEditorWeekdaySun.
  ///
  /// In vi, this message translates to:
  /// **'CN'**
  String get scheduleEditorWeekdaySun;

  /// No description provided for @scheduleEditorLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải lịch sinh hoạt...'**
  String get scheduleEditorLoading;

  /// No description provided for @scheduleEditorError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải lịch sinh hoạt'**
  String get scheduleEditorError;

  /// No description provided for @learningGoalDeleteConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xóa lộ trình học này?'**
  String get learningGoalDeleteConfirm;

  /// No description provided for @learningGoalDeleteMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa lộ trình học này?'**
  String get learningGoalDeleteMessage;

  /// No description provided for @questRuleResetConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại luật mặc định?'**
  String get questRuleResetConfirm;

  /// No description provided for @questRuleResetMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả luật sẽ quay về mặc định.'**
  String get questRuleResetMessage;

  /// No description provided for @lgPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình học'**
  String get lgPageTitle;

  /// No description provided for @lgPageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn kỹ năng bạn muốn cải thiện. Hệ thống sẽ tạo nhiệm vụ học tập nhỏ mỗi ngày từ lộ trình của bạn.'**
  String get lgPageSubtitle;

  /// No description provided for @lgSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình học tập'**
  String get lgSectionTitle;

  /// No description provided for @lgAddGoalButton.
  ///
  /// In vi, this message translates to:
  /// **'Thêm lộ trình'**
  String get lgAddGoalButton;

  /// No description provided for @lgEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lộ trình học'**
  String get lgEmptyTitle;

  /// No description provided for @lgEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tạo lộ trình đầu tiên để SoloQuest biến nó thành quest nhỏ mỗi ngày.'**
  String get lgEmptyMessage;

  /// No description provided for @lgFormTitleAdd.
  ///
  /// In vi, this message translates to:
  /// **'Thêm lộ trình'**
  String get lgFormTitleAdd;

  /// No description provided for @lgFormTitleEdit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa lộ trình'**
  String get lgFormTitleEdit;

  /// No description provided for @lgLabelTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tên lộ trình'**
  String get lgLabelTitle;

  /// No description provided for @lgLabelDescription.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get lgLabelDescription;

  /// No description provided for @lgLabelCategory.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get lgLabelCategory;

  /// No description provided for @lgLabelTargetMinutes.
  ///
  /// In vi, this message translates to:
  /// **'Số phút học mỗi ngày'**
  String get lgLabelTargetMinutes;

  /// No description provided for @lgLabelDeadline.
  ///
  /// In vi, this message translates to:
  /// **'Deadline'**
  String get lgLabelDeadline;

  /// No description provided for @lgLabelActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get lgLabelActive;

  /// No description provided for @lgProgressSheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật tiến độ'**
  String get lgProgressSheetTitle;

  /// No description provided for @lgProgressSheetButton.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get lgProgressSheetButton;

  /// No description provided for @lgFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get lgFilterAll;

  /// No description provided for @lgStatusActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get lgStatusActive;

  /// No description provided for @lgStatusCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get lgStatusCompleted;

  /// No description provided for @lgStatusInactive.
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng'**
  String get lgStatusInactive;

  /// No description provided for @lgDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa lộ trình học?'**
  String get lgDeleteConfirmTitle;

  /// No description provided for @lgDeleteConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa lộ trình này không?'**
  String get lgDeleteConfirmMessage;

  /// No description provided for @lgToastAddSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm lộ trình'**
  String get lgToastAddSuccess;

  /// No description provided for @lgToastAddFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể thêm lộ trình'**
  String get lgToastAddFailed;

  /// No description provided for @lgToastUpdateSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật lộ trình'**
  String get lgToastUpdateSuccess;

  /// No description provided for @lgToastUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật lộ trình'**
  String get lgToastUpdateFailed;

  /// No description provided for @lgToastDeleteSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa lộ trình'**
  String get lgToastDeleteSuccess;

  /// No description provided for @lgToastDeleteFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xóa lộ trình'**
  String get lgToastDeleteFailed;

  /// No description provided for @lgToastProgressSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật tiến độ'**
  String get lgToastProgressSuccess;

  /// No description provided for @lgToastProgressFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật tiến độ'**
  String get lgToastProgressFailed;

  /// No description provided for @lgErrorTitleRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên lộ trình'**
  String get lgErrorTitleRequired;

  /// No description provided for @lgErrorCategoryRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn danh mục'**
  String get lgErrorCategoryRequired;

  /// No description provided for @lgErrorTargetMinutesInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Số phút phải lớn hơn 0'**
  String get lgErrorTargetMinutesInvalid;

  /// No description provided for @lgErrorLoadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải lộ trình học'**
  String get lgErrorLoadFailed;

  /// No description provided for @lgSummaryTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng'**
  String get lgSummaryTotal;

  /// No description provided for @lgSummaryActive.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động'**
  String get lgSummaryActive;

  /// No description provided for @lgSummaryCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get lgSummaryCompleted;

  /// No description provided for @lgSummaryAvgProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ trung bình'**
  String get lgSummaryAvgProgress;

  /// No description provided for @lgCardProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ'**
  String get lgCardProgress;

  /// No description provided for @lgCardEdit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get lgCardEdit;

  /// No description provided for @lgCardDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get lgCardDelete;

  /// No description provided for @lgCardMinutesPerDay.
  ///
  /// In vi, this message translates to:
  /// **'phút/ngày'**
  String get lgCardMinutesPerDay;

  /// No description provided for @lgCardFormTitlePlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Học Flutter Architecture'**
  String get lgCardFormTitlePlaceholder;

  /// No description provided for @lgCardFormDescPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả chi tiết lộ trình...'**
  String get lgCardFormDescPlaceholder;

  /// No description provided for @lgCardFormCategoryPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Flutter, Dart, English...'**
  String get lgCardFormCategoryPlaceholder;

  /// No description provided for @lgCardFormNoDeadline.
  ///
  /// In vi, this message translates to:
  /// **'Không có deadline'**
  String get lgCardFormNoDeadline;

  /// No description provided for @lgCardFormSubmitAdd.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get lgCardFormSubmitAdd;

  /// No description provided for @lgCardFormSubmitUpdate.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get lgCardFormSubmitUpdate;

  /// No description provided for @lgActiveMainBadge.
  ///
  /// In vi, this message translates to:
  /// **'Đang học'**
  String get lgActiveMainBadge;

  /// No description provided for @lgActiveWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần {week}'**
  String lgActiveWeek(Object week);

  /// No description provided for @lgActiveSynced.
  ///
  /// In vi, this message translates to:
  /// **'Đang đồng bộ vào Nhiệm vụ hôm nay'**
  String get lgActiveSynced;

  /// No description provided for @lgActiveWeeklyProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ tuần này'**
  String get lgActiveWeeklyProgress;

  /// No description provided for @lgActiveViewRoadmap.
  ///
  /// In vi, this message translates to:
  /// **'Xem lộ trình'**
  String get lgActiveViewRoadmap;

  /// No description provided for @lgActiveSync.
  ///
  /// In vi, this message translates to:
  /// **'Đồng bộ'**
  String get lgActiveSync;

  /// No description provided for @lgActivePause.
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng'**
  String get lgActivePause;

  /// No description provided for @aiTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa biết nên học gì?'**
  String get aiTitle;

  /// No description provided for @aiDescription.
  ///
  /// In vi, this message translates to:
  /// **'Dựa trên hồ sơ, công việc và lộ trình học của bạn, hệ thống có thể đề xuất kỹ năng phù hợp.'**
  String get aiDescription;

  /// No description provided for @aiLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang phân tích hồ sơ...'**
  String get aiLoading;

  /// No description provided for @aiButton.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý dựa trên hồ sơ'**
  String get aiButton;

  /// No description provided for @aiSkillSelected.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn'**
  String get aiSkillSelected;

  /// No description provided for @aiSkillSelect.
  ///
  /// In vi, this message translates to:
  /// **'Chọn lộ trình'**
  String get aiSkillSelect;

  /// No description provided for @aiSkillDifficultyEasy.
  ///
  /// In vi, this message translates to:
  /// **'Dễ'**
  String get aiSkillDifficultyEasy;

  /// No description provided for @aiSkillDifficultyMedium.
  ///
  /// In vi, this message translates to:
  /// **'Vừa'**
  String get aiSkillDifficultyMedium;

  /// No description provided for @aiSkillDifficultyHard.
  ///
  /// In vi, this message translates to:
  /// **'Khó'**
  String get aiSkillDifficultyHard;

  /// No description provided for @syncSheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đồng bộ vào nhiệm vụ hằng ngày?'**
  String get syncSheetTitle;

  /// No description provided for @syncSheetDescription.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống sẽ tự động lấy bài học tiếp theo trong lộ trình để tạo Learning Quest mỗi ngày.'**
  String get syncSheetDescription;

  /// No description provided for @syncFrequency.
  ///
  /// In vi, this message translates to:
  /// **'Tần suất'**
  String get syncFrequency;

  /// No description provided for @syncFrequencyDaily.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi ngày'**
  String get syncFrequencyDaily;

  /// No description provided for @syncFrequencyMonWedFri.
  ///
  /// In vi, this message translates to:
  /// **'T2, 4, 6'**
  String get syncFrequencyMonWedFri;

  /// No description provided for @syncFrequencyWeekend.
  ///
  /// In vi, this message translates to:
  /// **'Cuối tuần'**
  String get syncFrequencyWeekend;

  /// No description provided for @syncFrequencyCustom.
  ///
  /// In vi, this message translates to:
  /// **'Tự chọn'**
  String get syncFrequencyCustom;

  /// No description provided for @syncDuration.
  ///
  /// In vi, this message translates to:
  /// **'Thời lượng'**
  String get syncDuration;

  /// No description provided for @syncDuration10.
  ///
  /// In vi, this message translates to:
  /// **'10 phút'**
  String get syncDuration10;

  /// No description provided for @syncDuration15.
  ///
  /// In vi, this message translates to:
  /// **'15 phút'**
  String get syncDuration15;

  /// No description provided for @syncDuration20.
  ///
  /// In vi, this message translates to:
  /// **'20 phút'**
  String get syncDuration20;

  /// No description provided for @syncDuration30.
  ///
  /// In vi, this message translates to:
  /// **'30 phút'**
  String get syncDuration30;

  /// No description provided for @syncTimeSlot.
  ///
  /// In vi, this message translates to:
  /// **'Khung giờ'**
  String get syncTimeSlot;

  /// No description provided for @syncTimeSlotMorning.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get syncTimeSlotMorning;

  /// No description provided for @syncTimeSlotNoon.
  ///
  /// In vi, this message translates to:
  /// **'Trưa'**
  String get syncTimeSlotNoon;

  /// No description provided for @syncTimeSlotEvening.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get syncTimeSlotEvening;

  /// No description provided for @syncTimeSlotCustom.
  ///
  /// In vi, this message translates to:
  /// **'Tự chọn'**
  String get syncTimeSlotCustom;

  /// No description provided for @syncAutoToggle.
  ///
  /// In vi, this message translates to:
  /// **'Tự động thêm vào Nhiệm vụ hôm nay'**
  String get syncAutoToggle;

  /// No description provided for @syncAutoToggleSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Learning Quest sẽ xuất hiện mỗi ngày'**
  String get syncAutoToggleSubtitle;

  /// No description provided for @syncConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Đồng bộ vào nhiệm vụ hằng ngày'**
  String get syncConfirm;

  /// No description provided for @syncCancel.
  ///
  /// In vi, this message translates to:
  /// **'Để sau'**
  String get syncCancel;

  /// No description provided for @lrPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình học'**
  String get lrPageTitle;

  /// No description provided for @lrPageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi từng bước nhỏ để hoàn thành mục tiêu lớn.'**
  String get lrPageSubtitle;

  /// No description provided for @lrSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình mẫu'**
  String get lrSectionTitle;

  /// No description provided for @lrSummaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get lrSummaryTitle;

  /// No description provided for @lrSummaryTotalRoadmaps.
  ///
  /// In vi, this message translates to:
  /// **'Tổng lộ trình'**
  String get lrSummaryTotalRoadmaps;

  /// No description provided for @lrSummaryCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get lrSummaryCompleted;

  /// No description provided for @lrSummarySteps.
  ///
  /// In vi, this message translates to:
  /// **'Bước'**
  String get lrSummarySteps;

  /// No description provided for @lrSummaryAvgProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ TB'**
  String get lrSummaryAvgProgress;

  /// No description provided for @lrStatusLearning.
  ///
  /// In vi, this message translates to:
  /// **'Đang theo dõi'**
  String get lrStatusLearning;

  /// No description provided for @lrStatusCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get lrStatusCompleted;

  /// No description provided for @lrViewRoadmapButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem lộ trình'**
  String get lrViewRoadmapButton;

  /// No description provided for @lrDetailSheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết lộ trình'**
  String get lrDetailSheetTitle;

  /// No description provided for @lrDetailProgressLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ'**
  String get lrDetailProgressLabel;

  /// No description provided for @lrDetailStepsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bước học'**
  String get lrDetailStepsLabel;

  /// No description provided for @lrStepEstimatedSuffix.
  ///
  /// In vi, this message translates to:
  /// **'phút'**
  String get lrStepEstimatedSuffix;

  /// No description provided for @lrStepCompletedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu đã học'**
  String get lrStepCompletedLabel;

  /// No description provided for @lrStepUnmarkLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ đánh dấu'**
  String get lrStepUnmarkLabel;

  /// No description provided for @lrEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lộ trình học'**
  String get lrEmptyTitle;

  /// No description provided for @lrEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể chọn một lộ trình mẫu để bắt đầu theo dõi từng bước học.'**
  String get lrEmptyMessage;

  /// No description provided for @lrEmptyButton.
  ///
  /// In vi, this message translates to:
  /// **'Chọn lộ trình mẫu'**
  String get lrEmptyButton;

  /// No description provided for @lrToastStepCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành bước học tập'**
  String get lrToastStepCompleted;

  /// No description provided for @lrToastStepUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật bước học tập'**
  String get lrToastStepUpdated;

  /// No description provided for @lrToastToggleError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật bước học tập'**
  String get lrToastToggleError;

  /// No description provided for @lrErrorLoadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải lộ trình học'**
  String get lrErrorLoadFailed;

  /// No description provided for @lrLoadingMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải lộ trình học...'**
  String get lrLoadingMessage;

  /// No description provided for @lrDetailCloseButton.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get lrDetailCloseButton;

  /// No description provided for @lrCardSteps.
  ///
  /// In vi, this message translates to:
  /// **'{completed}/{total} bước'**
  String lrCardSteps(Object completed, Object total);

  /// No description provided for @lrCardMinutes.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút'**
  String lrCardMinutes(Object minutes);

  /// No description provided for @lrDetailSteps.
  ///
  /// In vi, this message translates to:
  /// **'bước'**
  String get lrDetailSteps;

  /// No description provided for @lrStepEstimated.
  ///
  /// In vi, this message translates to:
  /// **'{minutes}p'**
  String lrStepEstimated(Object minutes);

  /// No description provided for @lrLocalProgressHint.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản thử nghiệm: tiến độ lộ trình chỉ lưu tạm trên thiết bị.'**
  String get lrLocalProgressHint;

  /// No description provided for @lrOverviewTopics.
  ///
  /// In vi, this message translates to:
  /// **'Chủ đề'**
  String get lrOverviewTopics;

  /// No description provided for @lrOverviewDone.
  ///
  /// In vi, this message translates to:
  /// **'Đã xong'**
  String get lrOverviewDone;

  /// No description provided for @lrOverviewRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn lại'**
  String get lrOverviewRemaining;

  /// No description provided for @lrOverviewTotalProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ tổng'**
  String get lrOverviewTotalProgress;

  /// No description provided for @lrOverviewProgressCount.
  ///
  /// In vi, this message translates to:
  /// **'{completed}/{total} chủ đề'**
  String lrOverviewProgressCount(Object completed, Object total);

  /// No description provided for @lrModuleFoundation.
  ///
  /// In vi, this message translates to:
  /// **'Nền tảng'**
  String get lrModuleFoundation;

  /// No description provided for @lrModulePractice.
  ///
  /// In vi, this message translates to:
  /// **'Thực hành'**
  String get lrModulePractice;

  /// No description provided for @lrModuleApplication.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng'**
  String get lrModuleApplication;

  /// No description provided for @lrModuleAdvanced.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cao'**
  String get lrModuleAdvanced;

  /// No description provided for @lrModuleProject.
  ///
  /// In vi, this message translates to:
  /// **'Dự án thực tế'**
  String get lrModuleProject;

  /// No description provided for @lrModuleFallback.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm chủ đề {index}'**
  String lrModuleFallback(Object index);

  /// No description provided for @lrTodayPlanTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kế hoạch học hôm nay'**
  String get lrTodayPlanTitle;

  /// No description provided for @lrTodayPlanDone.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành kế hoạch hôm nay!'**
  String get lrTodayPlanDone;

  /// No description provided for @lrTodayPlanStats.
  ///
  /// In vi, this message translates to:
  /// **'{completed} bài · {minutes} phút'**
  String lrTodayPlanStats(Object completed, Object minutes);

  /// No description provided for @lrTodayPlanStudyMore.
  ///
  /// In vi, this message translates to:
  /// **'Học thêm hôm nay'**
  String get lrTodayPlanStudyMore;

  /// No description provided for @lrTodayPlanNextLesson.
  ///
  /// In vi, this message translates to:
  /// **'Bài tiếp theo · {minutes} phút'**
  String lrTodayPlanNextLesson(Object minutes);

  /// No description provided for @lrTodayPlanStartLearning.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu học'**
  String get lrTodayPlanStartLearning;

  /// No description provided for @lrTodayPlanMinutesToday.
  ///
  /// In vi, this message translates to:
  /// **'{minutes}p hôm nay'**
  String lrTodayPlanMinutesToday(Object minutes);

  /// No description provided for @lrTodayPlanCompletedCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} bài đã xong'**
  String lrTodayPlanCompletedCount(Object count);

  /// No description provided for @lrStudyMoreTitle.
  ///
  /// In vi, this message translates to:
  /// **'Học thêm hôm nay'**
  String get lrStudyMoreTitle;

  /// No description provided for @lrStudyMoreDescription.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thời gian học thêm. Bạn có thể học nhiều hơn kế hoạch hàng ngày.'**
  String get lrStudyMoreDescription;

  /// No description provided for @lrStudyMoreDuration15.
  ///
  /// In vi, this message translates to:
  /// **'15 phút'**
  String get lrStudyMoreDuration15;

  /// No description provided for @lrStudyMoreDuration25.
  ///
  /// In vi, this message translates to:
  /// **'25 phút'**
  String get lrStudyMoreDuration25;

  /// No description provided for @lrStudyMoreDuration45.
  ///
  /// In vi, this message translates to:
  /// **'45 phút'**
  String get lrStudyMoreDuration45;

  /// No description provided for @lrStudyMoreDuration60.
  ///
  /// In vi, this message translates to:
  /// **'60 phút'**
  String get lrStudyMoreDuration60;

  /// No description provided for @lrStudyMoreButton.
  ///
  /// In vi, this message translates to:
  /// **'Học thêm {duration}'**
  String lrStudyMoreButton(Object duration);

  /// No description provided for @lrStudyMoreViewProgress.
  ///
  /// In vi, this message translates to:
  /// **'Xem tiến độ'**
  String get lrStudyMoreViewProgress;

  /// No description provided for @lrModuleLessonDone.
  ///
  /// In vi, this message translates to:
  /// **'Đã xong'**
  String get lrModuleLessonDone;

  /// No description provided for @lrModuleLessonSelected.
  ///
  /// In vi, this message translates to:
  /// **'Đang chọn'**
  String get lrModuleLessonSelected;

  /// No description provided for @lrModuleLessonNotStarted.
  ///
  /// In vi, this message translates to:
  /// **'Chưa học'**
  String get lrModuleLessonNotStarted;

  /// No description provided for @lsCompleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành bài học!'**
  String get lsCompleteTitle;

  /// No description provided for @lsCompleteStats.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay: {completed} bài · {minutes} phút'**
  String lsCompleteStats(Object completed, Object minutes);

  /// No description provided for @lsCompleteNextLesson.
  ///
  /// In vi, this message translates to:
  /// **'Học bài tiếp theo'**
  String get lsCompleteNextLesson;

  /// No description provided for @lsCompleteStop.
  ///
  /// In vi, this message translates to:
  /// **'Dừng tại đây'**
  String get lsCompleteStop;

  /// No description provided for @lsCompleteExtra.
  ///
  /// In vi, this message translates to:
  /// **'Học thêm 15 phút'**
  String get lsCompleteExtra;

  /// No description provided for @lsWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần {week}'**
  String lsWeek(Object week);

  /// No description provided for @lsMinutes.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút'**
  String lsMinutes(Object minutes);

  /// No description provided for @lsCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành'**
  String get lsCompleted;

  /// No description provided for @lsLocked.
  ///
  /// In vi, this message translates to:
  /// **'Bị khóa'**
  String get lsLocked;

  /// No description provided for @lsLockedInfo.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành bài trước để mở khóa bài này.'**
  String get lsLockedInfo;

  /// No description provided for @lsCompletedInfo.
  ///
  /// In vi, this message translates to:
  /// **'Bài học này đã được hoàn thành.'**
  String get lsCompletedInfo;

  /// No description provided for @lsExtraInfo.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã hoàn thành kế hoạch hôm nay. Học thêm để tiến xa hơn!'**
  String get lsExtraInfo;

  /// No description provided for @lsReadyInfo.
  ///
  /// In vi, this message translates to:
  /// **'Sẵn sàng để bắt đầu bài học này.'**
  String get lsReadyInfo;

  /// No description provided for @lsClose.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get lsClose;

  /// No description provided for @lsStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu học'**
  String get lsStart;

  /// No description provided for @lsStudyMore.
  ///
  /// In vi, this message translates to:
  /// **'Học thêm bài này'**
  String get lsStudyMore;

  /// No description provided for @lsMarkDone.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu xong'**
  String get lsMarkDone;

  /// No description provided for @lsLater.
  ///
  /// In vi, this message translates to:
  /// **'Để sau'**
  String get lsLater;

  /// No description provided for @lqCompletedToday.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành học tập hôm nay'**
  String get lqCompletedToday;

  /// No description provided for @lqChooseMoreTopics.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thêm chủ đề'**
  String get lqChooseMoreTopics;

  /// No description provided for @lqTopicsCount.
  ///
  /// In vi, this message translates to:
  /// **'{completed}/{total} chủ đề'**
  String lqTopicsCount(Object completed, Object total);

  /// No description provided for @createRoadmapFab.
  ///
  /// In vi, this message translates to:
  /// **'Tạo lộ trình mới'**
  String get createRoadmapFab;

  /// No description provided for @createRoadmapTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo lộ trình học mới'**
  String get createRoadmapTitle;

  /// No description provided for @createRoadmapSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cho AI biết bạn muốn học gì'**
  String get createRoadmapSubtitle;

  /// No description provided for @createRoadmapSubtitleSuggestion.
  ///
  /// In vi, this message translates to:
  /// **'AI gợi ý lộ trình phù hợp với bạn'**
  String get createRoadmapSubtitleSuggestion;

  /// No description provided for @roadmapPrefGoalLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn học gì?'**
  String get roadmapPrefGoalLabel;

  /// No description provided for @roadmapPrefGoalHint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: State Management, Testing, Performance...'**
  String get roadmapPrefGoalHint;

  /// No description provided for @roadmapPrefCategoryLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chủ đề'**
  String get roadmapPrefCategoryLabel;

  /// No description provided for @roadmapPrefDifficultyLabel.
  ///
  /// In vi, this message translates to:
  /// **'Độ khó'**
  String get roadmapPrefDifficultyLabel;

  /// No description provided for @roadmapPrefDurationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời lượng tối đa'**
  String get roadmapPrefDurationLabel;

  /// No description provided for @roadmapPrefSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Tạo gợi ý cho tôi'**
  String get roadmapPrefSubmit;

  /// No description provided for @roadmapDiffAny.
  ///
  /// In vi, this message translates to:
  /// **'Bất kỳ'**
  String get roadmapDiffAny;

  /// No description provided for @roadmapDiffAnyDesc.
  ///
  /// In vi, this message translates to:
  /// **'AI sẽ chọn độ khó phù hợp với bạn'**
  String get roadmapDiffAnyDesc;

  /// No description provided for @roadmapDiffBeginner.
  ///
  /// In vi, this message translates to:
  /// **'Cơ bản'**
  String get roadmapDiffBeginner;

  /// No description provided for @roadmapDiffBeginnerDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu từ nền tảng'**
  String get roadmapDiffBeginnerDesc;

  /// No description provided for @roadmapDiffIntermediate.
  ///
  /// In vi, this message translates to:
  /// **'Trung bình'**
  String get roadmapDiffIntermediate;

  /// No description provided for @roadmapDiffIntermediateDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đã có kiến thức cơ bản'**
  String get roadmapDiffIntermediateDesc;

  /// No description provided for @roadmapDiffAdvanced.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cao'**
  String get roadmapDiffAdvanced;

  /// No description provided for @roadmapDiffAdvancedDesc.
  ///
  /// In vi, this message translates to:
  /// **'Thử thách nâng cao kỹ năng'**
  String get roadmapDiffAdvancedDesc;

  /// No description provided for @roadmapDurationAny.
  ///
  /// In vi, this message translates to:
  /// **'Bất kỳ'**
  String get roadmapDurationAny;

  /// No description provided for @roadmapDurationHour.
  ///
  /// In vi, this message translates to:
  /// **'{hours}h'**
  String roadmapDurationHour(Object hours);

  /// No description provided for @roadmapSuggestionLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang phân tích profile của bạn...'**
  String get roadmapSuggestionLoading;

  /// No description provided for @roadmapSuggestionEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có gợi ý'**
  String get roadmapSuggestionEmpty;

  /// No description provided for @roadmapSuggestionEmptyDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống chưa có lộ trình phù hợp.\nVui lòng thử lại sau.'**
  String get roadmapSuggestionEmptyDesc;

  /// No description provided for @roadmapSuggestionCreate.
  ///
  /// In vi, this message translates to:
  /// **'Tạo lộ trình này'**
  String get roadmapSuggestionCreate;

  /// No description provided for @roadmapSuggestionSelected.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn'**
  String get roadmapSuggestionSelected;

  /// No description provided for @roadmapCardSteps.
  ///
  /// In vi, this message translates to:
  /// **'{steps} bước'**
  String roadmapCardSteps(Object steps);

  /// No description provided for @roadmapCardMinutes.
  ///
  /// In vi, this message translates to:
  /// **'~{minutes} phút'**
  String roadmapCardMinutes(Object minutes);

  /// No description provided for @reminderSettingsPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt nhắc nhở'**
  String get reminderSettingsPageTitle;

  /// No description provided for @reminderSettingsPageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Điều chỉnh thời điểm SoloQuest nhắc bạn uống nước, nghỉ ngơi và học tập.'**
  String get reminderSettingsPageSubtitle;

  /// No description provided for @reminderSettingsSummaryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan nhắc nhở'**
  String get reminderSettingsSummaryTitle;

  /// No description provided for @reminderSettingsListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách nhắc nhở'**
  String get reminderSettingsListTitle;

  /// No description provided for @reminderSettingsFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get reminderSettingsFilterAll;

  /// No description provided for @reminderSettingsFormTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh nhắc nhở'**
  String get reminderSettingsFormTitle;

  /// No description provided for @reminderSettingsToastUpdateSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật nhắc nhở'**
  String get reminderSettingsToastUpdateSuccess;

  /// No description provided for @reminderSettingsToastUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật nhắc nhở'**
  String get reminderSettingsToastUpdateFailed;

  /// No description provided for @reminderSettingsToastToggleOn.
  ///
  /// In vi, this message translates to:
  /// **'Đã bật nhắc nhở'**
  String get reminderSettingsToastToggleOn;

  /// No description provided for @reminderSettingsToastToggleOff.
  ///
  /// In vi, this message translates to:
  /// **'Đã tắt nhắc nhở'**
  String get reminderSettingsToastToggleOff;

  /// No description provided for @reminderSettingsToastToggleFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đổi trạng thái nhắc nhở'**
  String get reminderSettingsToastToggleFailed;

  /// No description provided for @reminderSettingsLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải cài đặt nhắc nhở...'**
  String get reminderSettingsLoading;

  /// No description provided for @reminderSettingsError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải cài đặt nhắc nhở'**
  String get reminderSettingsError;

  /// No description provided for @reminderSettingsTimeStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get reminderSettingsTimeStart;

  /// No description provided for @reminderSettingsTimeEnd.
  ///
  /// In vi, this message translates to:
  /// **'Kết thúc'**
  String get reminderSettingsTimeEnd;

  /// No description provided for @reminderSettingsLogToggleOn.
  ///
  /// In vi, this message translates to:
  /// **'Bật nhắc nhở'**
  String get reminderSettingsLogToggleOn;

  /// No description provided for @reminderSettingsLogToggleOff.
  ///
  /// In vi, this message translates to:
  /// **'Tắt nhắc nhở'**
  String get reminderSettingsLogToggleOff;

  /// No description provided for @reminderSettingsLogUpdate.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật nhắc nhở'**
  String get reminderSettingsLogUpdate;

  /// No description provided for @reminderTypeWater.
  ///
  /// In vi, this message translates to:
  /// **'Uống nước'**
  String get reminderTypeWater;

  /// No description provided for @reminderTypeBreak.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ giải lao'**
  String get reminderTypeBreak;

  /// No description provided for @reminderTypeMovement.
  ///
  /// In vi, this message translates to:
  /// **'Vận động'**
  String get reminderTypeMovement;

  /// No description provided for @reminderTypeLearning.
  ///
  /// In vi, this message translates to:
  /// **'Học tập'**
  String get reminderTypeLearning;

  /// No description provided for @reminderTypeSleep.
  ///
  /// In vi, this message translates to:
  /// **'Ngủ nghỉ'**
  String get reminderTypeSleep;

  /// No description provided for @reminderTypeDailyReview.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá ngày'**
  String get reminderTypeDailyReview;

  /// No description provided for @reminderTypeCustom.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh'**
  String get reminderTypeCustom;

  /// No description provided for @reminderFrequencyFixed.
  ///
  /// In vi, this message translates to:
  /// **'Cố định'**
  String get reminderFrequencyFixed;

  /// No description provided for @reminderFrequencyInterval.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng cách'**
  String get reminderFrequencyInterval;

  /// No description provided for @reminderFrequencyRandom.
  ///
  /// In vi, this message translates to:
  /// **'Ngẫu nhiên'**
  String get reminderFrequencyRandom;

  /// No description provided for @reminderFrequencySmart.
  ///
  /// In vi, this message translates to:
  /// **'Thông minh'**
  String get reminderFrequencySmart;

  /// No description provided for @reminderFrequencyFixedDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc vào một thời điểm cố định.'**
  String get reminderFrequencyFixedDesc;

  /// No description provided for @reminderFrequencyIntervalDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc lặp lại sau mỗi khoảng thời gian.'**
  String get reminderFrequencyIntervalDesc;

  /// No description provided for @reminderFrequencyRandomDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc ngẫu nhiên trong khung giờ đã chọn.'**
  String get reminderFrequencyRandomDesc;

  /// No description provided for @reminderFrequencySmartDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tự điều chỉnh theo lịch và trạng thái của bạn.'**
  String get reminderFrequencySmartDesc;

  /// No description provided for @reminderStatusEnabled.
  ///
  /// In vi, this message translates to:
  /// **'Đang bật'**
  String get reminderStatusEnabled;

  /// No description provided for @reminderStatusDisabled.
  ///
  /// In vi, this message translates to:
  /// **'Đang tắt'**
  String get reminderStatusDisabled;

  /// No description provided for @reminderFormFrequency.
  ///
  /// In vi, this message translates to:
  /// **'Tần suất'**
  String get reminderFormFrequency;

  /// No description provided for @reminderFormTimeWindow.
  ///
  /// In vi, this message translates to:
  /// **'Khung giờ'**
  String get reminderFormTimeWindow;

  /// No description provided for @reminderFormMinIntervalLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng cách tối thiểu giữa các nhắc (phút)'**
  String get reminderFormMinIntervalLabel;

  /// No description provided for @reminderFormMinIntervalPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: 90'**
  String get reminderFormMinIntervalPlaceholder;

  /// No description provided for @reminderFormMaxPerDayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số nhắc tối đa mỗi ngày'**
  String get reminderFormMaxPerDayLabel;

  /// No description provided for @reminderFormMaxPerDayPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: 8'**
  String get reminderFormMaxPerDayPlaceholder;

  /// No description provided for @reminderFormSmartTitle.
  ///
  /// In vi, this message translates to:
  /// **'AI nhắc thông minh'**
  String get reminderFormSmartTitle;

  /// No description provided for @reminderFormSmartSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cho phép SoloQuest tự điều chỉnh theo lịch và trạng thái.'**
  String get reminderFormSmartSubtitle;

  /// No description provided for @reminderFormSaveButton.
  ///
  /// In vi, this message translates to:
  /// **'Lưu cài đặt'**
  String get reminderFormSaveButton;

  /// No description provided for @reminderFormErrorFixedTimeRequired.
  ///
  /// In vi, this message translates to:
  /// **'Cần chọn thời điểm nhắc cố định'**
  String get reminderFormErrorFixedTimeRequired;

  /// No description provided for @reminderFormErrorTimeRangeRequired.
  ///
  /// In vi, this message translates to:
  /// **'Cần chọn đầy đủ khung giờ nhắc'**
  String get reminderFormErrorTimeRangeRequired;

  /// No description provided for @reminderFormErrorIntervalInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Interval minutes phải lớn hơn 0'**
  String get reminderFormErrorIntervalInvalid;

  /// No description provided for @reminderFormErrorRandomRangeRequired.
  ///
  /// In vi, this message translates to:
  /// **'Cần chọn đầy đủ khung giờ ngẫu nhiên'**
  String get reminderFormErrorRandomRangeRequired;

  /// No description provided for @reminderFormErrorMaxPerDayInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Max per day phải lớn hơn 0'**
  String get reminderFormErrorMaxPerDayInvalid;

  /// No description provided for @reminderFormErrorSmartRequired.
  ///
  /// In vi, this message translates to:
  /// **'Smart reminder cần được bật'**
  String get reminderFormErrorSmartRequired;

  /// No description provided for @reminderTitleWater.
  ///
  /// In vi, this message translates to:
  /// **'Uống nước'**
  String get reminderTitleWater;

  /// No description provided for @reminderDescWater.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc uống nước nhỏ giọt thay vì mục tiêu lớn.'**
  String get reminderDescWater;

  /// No description provided for @reminderTitleBreak.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ mắt & nghỉ giải lao'**
  String get reminderTitleBreak;

  /// No description provided for @reminderDescBreak.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nghỉ sau thời gian tập trung.'**
  String get reminderDescBreak;

  /// No description provided for @reminderTitleMovement.
  ///
  /// In vi, this message translates to:
  /// **'Vận động'**
  String get reminderTitleMovement;

  /// No description provided for @reminderDescMovement.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc đứng dậy vận động nhẹ sau khi ngồi lâu.'**
  String get reminderDescMovement;

  /// No description provided for @reminderTitleLearning.
  ///
  /// In vi, this message translates to:
  /// **'Học tập'**
  String get reminderTitleLearning;

  /// No description provided for @reminderDescLearning.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc bạn dành thời gian học vào buổi tối.'**
  String get reminderDescLearning;

  /// No description provided for @reminderTitleSleep.
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn bị ngủ'**
  String get reminderTitleSleep;

  /// No description provided for @reminderDescSleep.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc wind-down trước giờ ngủ mục tiêu.'**
  String get reminderDescSleep;

  /// No description provided for @reminderTitleReview.
  ///
  /// In vi, this message translates to:
  /// **'Daily Review'**
  String get reminderTitleReview;

  /// No description provided for @reminderDescReview.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc tổng kết ngày và ghi nhận tiến độ.'**
  String get reminderDescReview;

  /// No description provided for @reminderTitleCustom.
  ///
  /// In vi, this message translates to:
  /// **'Custom reminder'**
  String get reminderTitleCustom;

  /// No description provided for @reminderDescCustom.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc việc cá nhân theo khung giờ tự chọn.'**
  String get reminderDescCustom;

  /// No description provided for @reminderCardInterval.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi {minutes} phút'**
  String reminderCardInterval(Object minutes);

  /// No description provided for @reminderCardMaxPerDay.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa {max} lần/ngày'**
  String reminderCardMaxPerDay(Object max);

  /// No description provided for @reminderCardEditButton.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get reminderCardEditButton;

  /// No description provided for @reminderCardSmartReminder.
  ///
  /// In vi, this message translates to:
  /// **'Smart reminder'**
  String get reminderCardSmartReminder;

  /// No description provided for @reminderMetricTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng nhắc nhở'**
  String get reminderMetricTotal;

  /// No description provided for @reminderMetricEnabled.
  ///
  /// In vi, this message translates to:
  /// **'Đang bật'**
  String get reminderMetricEnabled;

  /// No description provided for @reminderMetricDisabled.
  ///
  /// In vi, this message translates to:
  /// **'Đang tắt'**
  String get reminderMetricDisabled;

  /// No description provided for @reminderEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nhắc nhở'**
  String get reminderEmptyTitle;

  /// No description provided for @reminderEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'SoloQuest sẽ dùng cài đặt nhắc nhở để giúp bạn duy trì nhịp sinh hoạt.'**
  String get reminderEmptyMessage;

  /// No description provided for @rewardsPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thành tích & Tự thưởng'**
  String get rewardsPageTitle;

  /// No description provided for @rewardsHeaderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tự thưởng'**
  String get rewardsHeaderTitle;

  /// No description provided for @rewardsHeaderSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tích lũy điểm thành tích từ quest để mở khóa gợi ý tự thưởng.'**
  String get rewardsHeaderSubtitle;

  /// No description provided for @rewardsEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có gợi ý tự thưởng'**
  String get rewardsEmptyTitle;

  /// No description provided for @rewardsEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hãy thêm gợi ý tự thưởng để tạo động lực cho bản thân.'**
  String get rewardsEmptyMessage;

  /// No description provided for @rewardsEmptyAction.
  ///
  /// In vi, this message translates to:
  /// **'Thêm gợi ý tự thưởng'**
  String get rewardsEmptyAction;

  /// No description provided for @rewardsBalanceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Điểm thành tích'**
  String get rewardsBalanceTitle;

  /// No description provided for @rewardsPointsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tích lũy từ quest đã hoàn thành'**
  String get rewardsPointsSubtitle;

  /// No description provided for @rewardsAvailableLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã mở khóa'**
  String get rewardsAvailableLabel;

  /// No description provided for @rewardsClaimedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi nhận'**
  String get rewardsClaimedLabel;

  /// No description provided for @rewardsSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý tự thưởng'**
  String get rewardsSectionTitle;

  /// No description provided for @rewardsBadgeSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Badge thành tích'**
  String get rewardsBadgeSectionTitle;

  /// No description provided for @rewardsHistorySectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử tự thưởng'**
  String get rewardsHistorySectionTitle;

  /// No description provided for @rewardsCreateSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo gợi ý tự thưởng'**
  String get rewardsCreateSectionTitle;

  /// No description provided for @rewardsFilterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get rewardsFilterAll;

  /// No description provided for @rewardsClaimDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhận tự thưởng?'**
  String get rewardsClaimDialogTitle;

  /// No description provided for @rewardsClaimDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã đạt mốc để tự thưởng: {name}. Hãy tận hưởng phần thưởng này như một cách ghi nhận nỗ lực của bạn.'**
  String rewardsClaimDialogMessage(Object name);

  /// No description provided for @rewardsClaimDialogUnlockCost.
  ///
  /// In vi, this message translates to:
  /// **'Mốc mở khóa'**
  String get rewardsClaimDialogUnlockCost;

  /// No description provided for @rewardsClaimDialogCurrentPoints.
  ///
  /// In vi, this message translates to:
  /// **'Điểm thành tích hiện tại'**
  String get rewardsClaimDialogCurrentPoints;

  /// No description provided for @rewardsClaimDialogDuration.
  ///
  /// In vi, this message translates to:
  /// **'Thời lượng'**
  String get rewardsClaimDialogDuration;

  /// No description provided for @rewardsClaimDialogType.
  ///
  /// In vi, this message translates to:
  /// **'Loại'**
  String get rewardsClaimDialogType;

  /// No description provided for @rewardsClaimDialogPoints.
  ///
  /// In vi, this message translates to:
  /// **'điểm'**
  String get rewardsClaimDialogPoints;

  /// No description provided for @rewardsClaimDialogMinutes.
  ///
  /// In vi, this message translates to:
  /// **'phút'**
  String get rewardsClaimDialogMinutes;

  /// No description provided for @rewardsClaimDialogConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhận'**
  String get rewardsClaimDialogConfirm;

  /// No description provided for @rewardsClaimDialogCancel.
  ///
  /// In vi, this message translates to:
  /// **'Để sau'**
  String get rewardsClaimDialogCancel;

  /// No description provided for @rewardsToastClaimed.
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi nhận tự thưởng!'**
  String get rewardsToastClaimed;

  /// No description provided for @rewardsToastNotEnough.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đạt đủ điểm thành tích để mở gợi ý này.'**
  String get rewardsToastNotEnough;

  /// No description provided for @rewardsToastFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể ghi nhận tự thưởng'**
  String get rewardsToastFailed;

  /// No description provided for @rewardsToastCreated.
  ///
  /// In vi, this message translates to:
  /// **'Đã tạo gợi ý tự thưởng mới!'**
  String get rewardsToastCreated;

  /// No description provided for @rewardsProtectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tự thưởng bền vững. '**
  String get rewardsProtectionTitle;

  /// No description provided for @rewardsProtectionDesc.
  ///
  /// In vi, this message translates to:
  /// **'Không mất hết tiến trình khi có ngày bận. Có Streak Shield và ngày nhẹ. Tạm dừng quest không bị phạt.'**
  String get rewardsProtectionDesc;

  /// No description provided for @rewardsLinkProgressLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tiến trình'**
  String get rewardsLinkProgressLabel;

  /// No description provided for @rewardsLinkLogsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhật ký'**
  String get rewardsLinkLogsLabel;

  /// No description provided for @rewardsLinkProfileLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get rewardsLinkProfileLabel;

  /// No description provided for @rewardsBadgeUnlocked.
  ///
  /// In vi, this message translates to:
  /// **'Đã mở'**
  String get rewardsBadgeUnlocked;

  /// No description provided for @rewardsBadgeNightLearner.
  ///
  /// In vi, this message translates to:
  /// **'5 buổi tối'**
  String get rewardsBadgeNightLearner;

  /// No description provided for @rewardsBadgeComeback.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get rewardsBadgeComeback;

  /// No description provided for @rewardsBadgeWeeklyReview.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get rewardsBadgeWeeklyReview;

  /// No description provided for @rewardsBadgeMovementPro.
  ///
  /// In vi, this message translates to:
  /// **'7 ngày'**
  String get rewardsBadgeMovementPro;

  /// No description provided for @rewardsHistoryClaimTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhận tự thưởng \"{name}\"'**
  String rewardsHistoryClaimTitle(Object name);

  /// No description provided for @rewardsHistoryUnlockTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa \"{name}\"'**
  String rewardsHistoryUnlockTitle(Object name);

  /// No description provided for @rewardsHistoryYesterday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get rewardsHistoryYesterday;

  /// No description provided for @rewardsHistoryWeekAgo.
  ///
  /// In vi, this message translates to:
  /// **'Tuần trước'**
  String get rewardsHistoryWeekAgo;

  /// No description provided for @rewardsHistoryMilestone.
  ///
  /// In vi, this message translates to:
  /// **'Đạt mốc {points} điểm'**
  String rewardsHistoryMilestone(Object points);

  /// No description provided for @timerStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu đếm giờ'**
  String get timerStart;

  /// No description provided for @timerDuration.
  ///
  /// In vi, this message translates to:
  /// **'Thời lượng'**
  String get timerDuration;

  /// No description provided for @timerRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn lại'**
  String get timerRemaining;

  /// No description provided for @timerComplete.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get timerComplete;

  /// No description provided for @timerStop.
  ///
  /// In vi, this message translates to:
  /// **'Dừng'**
  String get timerStop;

  /// No description provided for @timerTimeUp.
  ///
  /// In vi, this message translates to:
  /// **'Hết giờ'**
  String get timerTimeUp;

  /// No description provided for @timerTimeout.
  ///
  /// In vi, this message translates to:
  /// **'Đã hết thời gian'**
  String get timerTimeout;

  /// No description provided for @timerQuestEnded.
  ///
  /// In vi, this message translates to:
  /// **'Nhiệm vụ đã kết thúc'**
  String get timerQuestEnded;

  /// No description provided for @timerCompleteQuest.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành nhiệm vụ'**
  String get timerCompleteQuest;

  /// No description provided for @timerConfirmReplace.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang có một bộ đếm đang chạy. Dừng bộ đếm hiện tại để bắt đầu bộ đếm mới?'**
  String get timerConfirmReplace;

  /// No description provided for @timerWaterNoTimer.
  ///
  /// In vi, this message translates to:
  /// **'Uống nước không cần đếm giờ'**
  String get timerWaterNoTimer;

  /// No description provided for @timerOpen.
  ///
  /// In vi, this message translates to:
  /// **'Mở'**
  String get timerOpen;

  /// No description provided for @reminderWaterTitle.
  ///
  /// In vi, this message translates to:
  /// **'Uống nước'**
  String get reminderWaterTitle;

  /// No description provided for @reminderWaterBody.
  ///
  /// In vi, this message translates to:
  /// **'Đến giờ uống một ngụm nước rồi.'**
  String get reminderWaterBody;

  /// No description provided for @reminderWaterBtn.
  ///
  /// In vi, this message translates to:
  /// **'Đã uống'**
  String get reminderWaterBtn;

  /// No description provided for @reminderBreakTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ mắt một chút'**
  String get reminderBreakTitle;

  /// No description provided for @reminderBreakBody.
  ///
  /// In vi, this message translates to:
  /// **'Hãy rời mắt khỏi màn hình và nghỉ nhẹ vài phút.'**
  String get reminderBreakBody;

  /// No description provided for @reminderBreakBtn.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu nghỉ {minutes} phút'**
  String reminderBreakBtn(Object minutes);

  /// No description provided for @reminderMovementTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vận động nhẹ'**
  String get reminderMovementTitle;

  /// No description provided for @reminderMovementBody.
  ///
  /// In vi, this message translates to:
  /// **'Hãy đứng dậy và vận động nhẹ một chút.'**
  String get reminderMovementBody;

  /// No description provided for @reminderLearningTitle.
  ///
  /// In vi, this message translates to:
  /// **'Học tập'**
  String get reminderLearningTitle;

  /// No description provided for @reminderLearningBody.
  ///
  /// In vi, this message translates to:
  /// **'Đến giờ dành một chút thời gian để học.'**
  String get reminderLearningBody;

  /// No description provided for @reminderSleepTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn bị đi ngủ'**
  String get reminderSleepTitle;

  /// No description provided for @reminderSleepBody.
  ///
  /// In vi, this message translates to:
  /// **'Đến giờ thư giãn và chuẩn bị cho giấc ngủ.'**
  String get reminderSleepBody;

  /// No description provided for @reminderDailyReviewTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tổng kết ngày'**
  String get reminderDailyReviewTitle;

  /// No description provided for @reminderDailyReviewBody.
  ///
  /// In vi, this message translates to:
  /// **'Dành vài phút nhìn lại ngày hôm nay.'**
  String get reminderDailyReviewBody;

  /// No description provided for @reminderDailyReviewBtn.
  ///
  /// In vi, this message translates to:
  /// **'Mở tổng kết'**
  String get reminderDailyReviewBtn;

  /// No description provided for @reminderWaterPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Đến giờ uống nước rồi.'**
  String get reminderWaterPrompt;

  /// No description provided for @reminderDailyReviewPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Đến giờ tổng kết ngày.'**
  String get reminderDailyReviewPrompt;

  /// No description provided for @reminderBreakFinished.
  ///
  /// In vi, this message translates to:
  /// **'Đã hết thời gian nghỉ'**
  String get reminderBreakFinished;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
