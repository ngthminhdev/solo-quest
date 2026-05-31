# SoloQuest QA Checklist

## Compile
- [x] `fvm flutter pub get` — passes
- [x] `fvm flutter analyze` — 0 errors, 0 warnings (43 info deprecation notices)
- [x] `fvm flutter test` — passes (1 test)
- [x] `fvm flutter run` — builds successfully

## Initial flow
- [x] First launch → Splash → Login (unauthenticated)
- [x] Logged in + no onboarding → Onboarding
- [x] Logged in + onboarding done + no check-in → Morning Check-in
- [x] Logged in + onboarding done + checked-in → Home
- [x] Splash checks auth → onboarding → check-in in correct order

## Onboarding 9 steps
- [x] Step 0 — Welcome (Thiết Lập Hành Trình)
- [x] Step 1 — Basic Info (Thông Tin Cá Nhân): tên, tuổi, giới tính, chiều cao, cân nặng
- [x] Step 2 — Work & Study (Công Việc & Học Tập): đang làm gì, giờ bắt đầu/kết thúc, thời gian rảnh
- [x] Step 3 — Health & Activity (Sức Khỏe & Vận Động): mức vận động, lần cuối tập, giới hạn sức khỏe
- [x] Step 4 — Goals (Đặt Mục Tiêu): mục tiêu chính
- [x] Step 5 — Schedule (Lịch Sinh Hoạt): giờ thức dậy, giờ ngủ, thời gian rảnh từ/đến, khung học, khung vận động
- [x] Step 6 — Reminders (Cài Đặt Nhắc Nhở): Break Quest, Water Quest, Không Nhắc Sau
- [x] Step 7 — Rewards (Phần Thưởng): phần thưởng muốn dùng
- [x] Step 8 — Complete (Hồ Sơ Đã Sẵn Sàng): CTA Bắt đầu check-in hôm nay
- [x] Complete onboarding → save profile → set hasCompletedOnboarding → add log → navigate Morning Check-in

## Quest flow
- [x] Home → Quest Detail (with id argument)
- [x] Quest Detail handles empty/null questId gracefully
- [x] Start quest
- [x] Complete quest → adds EXP + rewardPoints
- [x] Snooze quest
- [x] Skip quest
- [x] Home reloads data after quest actions

## EXP vs Points separation
- [x] `ProgressModel` fields: `currentLevelExp`, `nextLevelExp`, `totalExp`, `rewardPoints`
- [x] Complete quest → increases `currentLevelExp`, `totalExp`, `rewardPoints`
- [x] Claim reward → `spendRewardPoints()` only decreases `rewardPoints`
- [x] Claim reward → does NOT decrease `currentLevelExp` / `totalExp` / `level`
- [x] Rewards UI uses "Điểm thưởng hiện có" not "EXP hiện có"
- [x] Progress UI uses "Level EXP" / "Tổng EXP"
- [x] Logs: "Quest completed: +EXP và +điểm" / "Reward claimed: -điểm"

## Main tabs (Bottom nav)
- [x] Home — /home
- [x] Logs — /logs
- [x] Progress — /progress
- [x] Rewards — /rewards
- [x] Profile — /profile
- [x] Tab debounce prevents duplicate navigation
- [x] Tab switch via PageView (no route push for tabs)

## Profile shortcuts
- [x] Morning Check-in → /morning-checkin
- [x] Daily Review → /daily-review
- [x] Weekly Summary → /weekly-summary
- [x] Schedule Editor → /schedule-editor
- [x] Learning Goals → /learning-goals
- [x] Learning Roadmap → /learning-roadmap
- [x] Reminder Settings → /reminder-settings
- [x] Quest Rules → /quest-rules

## Daily Review (real page)
- [x] Header, Summary card, Mood selector, Difficulty, Helpful/Annoying quests, Tomorrow adjustments, Note, Insight card, Submit bar
- [x] Mood required for submit
- [x] Save to DailyReviewService
- [x] Add log dailyReview
- [x] Navigate Home after submit

## Weekly Summary (real page)
- [x] Header + week range, Score card, Stats grid, Completion chart, Quest ranking, Insights, Suggestions, Schedule preview, Protection card
- [x] "Chỉnh luật quest" → /quest-rules
- [x] "Cài đặt nhắc nhở" → /reminder-settings
- [x] Links to /logs, /schedule-editor

## Settings/Tools modules
- [x] Schedule Editor: add/edit/delete blocks, data persists via static list
- [x] Learning Goals: add/edit/delete goals, update progress, data persists via static list
- [x] Learning Roadmap: detail sheet, toggle step, progress update, data persists via static list
- [x] Reminder Settings: toggle reminder, edit frequency/time/interval, data persists via static list
- [x] Quest Rules: toggle rule, edit rule, daily quest limit, reset default, data persists via static

## Mock data persistence
- [x] `QuestService` — static-like list (instance field, but singleton provider)
- [x] `LogService` — instance field, singleton provider
- [x] `ProgressService` — instance field with copyWith mutations
- [x] `RewardService` — instance field, singleton provider
- [x] `ScheduleService` — static list
- [x] `LearningService` — static list
- [x] `ReminderService` — static list
- [x] `QuestRuleService` — static list
- [x] `DailyCheckinService` — static field
- [x] `DailyReviewService` — static field
- [x] `ProfileService` — static field

## Remix Icon consistency
- [x] Splash page: `RemixIcons.star_fill` (was `Icons.star`)
- [x] Progress links: `RemixIcons.calendar_line`, `RemixIcons.file_text_line`, `RemixIcons.list_settings_line` (were Material Icons)
- [x] Weekly Summary empty: `RemixIcons.bar_chart_2_line` (was `Icons.bar_chart`)
- [x] Schedule Editor time picker: `RemixIcons.arrow_right_s_line` (was `Icons.arrow_forward`)
- [x] Bottom nav, header, all widgets use Remix Icons

## Architecture
- [x] MVVM: Page → PageModel → Service
- [x] `BasePage` / `BasePageModel` / `BasePageState` used consistently
- [x] Service layer separate from UI
- [x] No service calls from widgets directly
- [x] No hardcoded business data in UI (mock data in service layer)
- [x] `ProviderScope` wraps `MyApp`
- [x] `AppSession.navigatorKey` used in MaterialApp

## Architecture
- [x] MVVM: Page → PageModel → Service
- [x] `BasePage` / `BasePageModel` / `BasePageState` used consistently
- [x] Service layer separate from UI
- [x] No service calls from widgets directly
- [x] No hardcoded business data in UI (mock data in service layer)
- [x] `ProviderScope` wraps `MyApp`
- [x] `AppSession.navigatorKey` used in MaterialApp
- [x] AuthUserModel — no UI imports
- [x] AuthService — depends only on LocalStorageService
- [x] LoginPage uses BasePage pattern
- [x] LoginPageModel calls AuthService (not widget)
- [x] ProfilePageModel injects AuthService
- [x] ProfileAccountCard receives data + callbacks
- [x] All icons use Remix Icon (no emoji)

## Routes
- [x] 18 routes defined in `RoutesConfig` (including `/login`)
- [x] All routes mapped in `AppRouter.generateRoute`
- [x] Quest Detail extracts `id` from arguments with null safety
- [x] No `design/` or `designs/` paths in Flutter routes
- [x] Default route shows "Route not found" page

## Files modified during QA
1. `lib/modules/progress/constants/progress_constants.dart` — removed unused import
2. `lib/modules/progress/widgets/streak_safety_card.dart` — removed unused import
3. `lib/modules/splash/splash_page.dart` — Remix Icon + auth check in flow
4. `lib/modules/progress/progress_page.dart` — Material → Remix Icons
5. `lib/modules/weekly_summary/widgets/weekly_summary_empty_view.dart` — Material → Remix Icon
6. `lib/modules/schedule_editor/widgets/time_range_picker_row.dart` — Material → Remix Icon
7. `test/widget_test.dart` — replaced counter smoke test with RoutesConfig unit test

## Files created for Auth feature
1. `lib/models/auth_user_model.dart` — Auth user model
2. `lib/services/auth_service.dart` — Mock Google auth service
3. `lib/modules/login/login_page.dart` — Login page
4. `lib/modules/login/login_page_model.dart` — Login page model + state
5. `lib/modules/login/constants/login_constants.dart` — Login text constants
6. `lib/modules/login/widgets/login_logo_section.dart` — Logo + app name
7. `lib/modules/login/widgets/google_sign_in_button.dart` — Google button with loading
8. `lib/modules/login/widgets/login_error_banner.dart` — Error banner
9. `lib/modules/login/widgets/login_footer_note.dart` — Privacy/terms/prototype note
10. `lib/modules/profile/widgets/profile_account_card.dart` — Account section card
