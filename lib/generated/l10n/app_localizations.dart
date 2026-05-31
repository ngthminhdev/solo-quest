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

  /// No description provided for @headerRewards.
  ///
  /// In vi, this message translates to:
  /// **'Thưởng'**
  String get headerRewards;

  /// No description provided for @headerProfile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ Sơ'**
  String get headerProfile;

  /// No description provided for @loginTagline.
  ///
  /// In vi, this message translates to:
  /// **'Biến mục tiêu cá nhân thành quest nhỏ mỗi ngày.'**
  String get loginTagline;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu hành trình của bạn'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng Google để đồng bộ quest, logs, tiến trình và phần thưởng trên mọi thiết bị.'**
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
  /// **'[ Prototype — mock auth ]'**
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

  /// No description provided for @rewardsLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải phần thưởng...'**
  String get rewardsLoading;

  /// No description provided for @rewardsError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải phần thưởng'**
  String get rewardsError;

  /// No description provided for @rewardsNotEnough.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đủ điểm thưởng để đổi phần thưởng này.'**
  String get rewardsNotEnough;

  /// No description provided for @rewardsClaimed.
  ///
  /// In vi, this message translates to:
  /// **'Đã đổi phần thưởng thành công!'**
  String get rewardsClaimed;

  /// No description provided for @rewardsClaimFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đổi phần thưởng'**
  String get rewardsClaimFailed;

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
  /// **'Nhiệm vụ này được đề xuất dựa trên lịch sinh hoạt và mục tiêu hôm nay của bạn.'**
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

  /// No description provided for @learningGoalDeleteConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xóa mục tiêu này?'**
  String get learningGoalDeleteConfirm;

  /// No description provided for @learningGoalDeleteMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa mục tiêu học tập này?'**
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
