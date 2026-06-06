# SoloQuest FE AI Onboarding Context Audit Report

This report evaluates the current Frontend (FE) onboarding flow in the SoloQuest application to determine its readiness for integration with the backend AI quest generation endpoints (`POST /api/quests/generate-preview` and `POST /api/quests/generate-today`).

---

## Part 1 — Onboarding Flow Location

The onboarding flow is structured across the following key files in the codebase:

1. **Pages and UI Routing**:
   - [onboarding_page.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/onboarding_page.dart): The main page orchestrating step transition UI and progress.
   - [router.dart](file:///Users/qc-bright/Project/solo_quest/lib/routes/router.dart): Configures routing to `OnboardingPage` via `RoutesConfig.onboarding`.
2. **State and Business Logic**:
   - [onboarding_page_model.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/onboarding_page_model.dart): The Riverpod `StateNotifier` (`onboardingPageProvider`) holding validation rules, mappings, and payload formatting.
   - [onboarding_data.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/models/onboarding_data.dart): Immutable data model holding collected values across steps.
3. **Step Widgets (under `lib/modules/onboarding/widgets/`)**:
   - [onboarding_welcome_step.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/widgets/onboarding_welcome_step.dart): Step 0 — Welcome Screen.
   - [onboarding_basic_info_step.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/widgets/onboarding_basic_info_step.dart): Step 1 — Name, age, gender, height, weight.
   - [onboarding_work_study_step.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/widgets/onboarding_work_study_step.dart): Step 2 — MainActivity, work schedule, work hours, preferred free times.
   - [onboarding_health_activity_step.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/widgets/onboarding_health_activity_step.dart): Step 3 — Activity level, last workout, health limitations.
   - [onboarding_goals_step.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/widgets/onboarding_goals_step.dart): Step 4 — Main goals selection.
   - [onboarding_schedule_step.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/widgets/onboarding_schedule_step.dart): Step 5 — Wake up, sleep time, free time range, preferred learning & movement times.
   - [onboarding_complete_step.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/widgets/onboarding_complete_step.dart): Step 6 — Summary and preview before completing.
   - *Omitted/Unused steps*:
     - [onboarding_reminders_step.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/widgets/onboarding_reminders_step.dart) (Defines Step 6 reminders, but omitted from `onboarding_page.dart`).
     - [onboarding_rewards_step.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/widgets/onboarding_rewards_step.dart) (Defines Step 7 rewards, but omitted from `onboarding_page.dart`).
4. **Data Transmission**:
   - [user_api_service.dart](file:///Users/qc-bright/Project/solo_quest/lib/core/api/services/user_api_service.dart): Performs `POST /api/onboarding` via `saveOnboarding(payload)`.
   - [user_dto.dart](file:///Users/qc-bright/Project/solo_quest/lib/core/api/dto/user_dto.dart): Maps `/api/users/me` and onboarding completion status responses.
5. **Localization & Time Helpers**:
   - [app_vi.arb](file:///Users/qc-bright/Project/solo_quest/lib/l10n/app_vi.arb) & [app_en.arb](file:///Users/qc-bright/Project/solo_quest/lib/l10n/app_en.arb): Contains UI display labels.
   - [time_helper.dart](file:///Users/qc-bright/Project/solo_quest/lib/helpers/time_helper.dart): Defines canonical `TimeSlot` hours and time ranges.

---

## Part 2 — Onboarding Fields Audit

The table below lists every onboarding field defined in the `OnboardingData` model, details how it is collected and mapped, and assesses its usefulness for the AI.

| FE State Property | UI Label (VI / EN) | API Payload Key | Data Type | Example Value | Req/Opt | AI Usefulness / Purpose |
|---|---|---|---|---|---|---|
| `displayName` | Họ tên / Full Name | `display_name` | String | `"Minh"` | Required | Personalizing push notification messages and AI text. |
| `age` | Tuổi / Age | `age` | int? | `25` | Required | Contextualizing exercise difficulty & health recommendations. |
| `gender` | Giới tính / Gender | `gender` | String | `"male"` | Required | Health limitation contexts and localized pronouns. |
| `heightCm` | Chiều cao (cm) / Height (cm) | `height_cm` | double? | `170.0` | Optional | Calculating BMR, BMI, and customized weight-loss recommendations. |
| `weightKg` | Cân nặng (kg) / Weight (kg) | `weight_kg` | double? | `65.0` | Optional | Calculating BMR, BMI, and customized weight-loss recommendations. |
| `mainActivity` | Công việc chính / Main Activity | `main_activity` | String | `"software_engineer"` | Required | Identifying desk job/stress patterns (e.g. eye strain, sedentary work). |
| `workScheduleType` | Lịch trình làm việc / Work Schedule | `work_schedule_type` | String | `"weekdays"` | Required | Knowing when user is busy (weekdays, full week, flexible, night shift). |
| `workStartTime` | Giờ bắt đầu / Work Start Time | `work_start_time` | String | `"08:30"` | Required | Defining the bounds of work hours to inject desk stretch/eye break quests. |
| `workEndTime` | Giờ kết thúc / Work End Time | `work_end_time` | String | `"17:30"` | Required | Defining the bounds of work hours to inject desk stretch/eye break quests. |
| `freeTimePreference` | Thời gian rảnh rỗi / Preferred Free Times | `free_time_preference` | String | `"evening"` | Required | Fallback singular field representing joined preferred free times. |
| `preferredFreeTimes` | Thời gian rảnh rỗi / Preferred Free Times | `preferred_free_times` | List\<String\> | `["early_morning", "evening"]` | Required | Array of preferred broad periods (early_morning, lunch, after_work, evening). |
| `activityLevel` | Mức độ hoạt động / Activity Level | `activity_level` | String | `"very_little"` | Required | Adjusting duration/intensity of fitness quests (very_little, occasional, regular). |
| `lastWorkout` | Lần vận động gần nhất / Last Workout | `last_workout` | String | `"longer_ago"` | Required | Prioritizing fitness quests (today, this_week, longer_ago). |
| `healthLimitations` | Hạn chế sức khỏe / Health Limitations | `health_limitations` | List\<String\> | `["back_pain"]` | Required | Filtering out harmful movements (e.g. back pain -> no heavy squats). |
| `mainGoals` | Mục tiêu chính / Main Goals | `main_goals` | List\<String\> | `["Uống Nước", "Vận Động"]` | Required | **CRITICAL BUG**: Sent as literal Vietnamese strings. Determines enabled quest types. |
| `wakeUpTime` | Giờ thức dậy / Wake Up Time | `wake_up_time` | String | `"07:00"` | Required | Anchoring morning check-in and scheduling early-morning water quests. |
| `targetSleepTime` | Giờ đi ngủ / Target Sleep Time | `target_sleep_time` | String | `"23:00"` | Required | Anchoring sleep preparation quests and evening quiet hours. |
| `freeTimeStart` | Từ / Free Time Start | `free_time_start` | String | `"20:00"` | Required | Setting the starting boundary for learning/mindfulness quests. |
| `free_time_end` | Đến / Free Time End | `free_time_end` | String | `"22:00"` | Required | Setting the ending boundary for learning/mindfulness quests. |
| `learningTimePreference` | Thời gian học tập / Learning Preference | `learning_time_preference` | String | `"evening"` | Required | Singular fallback value representing the first preferred learning slot. |
| `learningTimePreferences` | Thời gian học tập / Learning Preference | `learning_time_preferences` | List\<String\> | `["evening"]` | Required | Array of preferred learning slots (morning, lunch, evening). |
| `movementTimePreference` | Thời gian vận động / Movement Preference | `movement_time_preference` | String | `"evening"` | Required | Singular fallback value representing joined preferred movement slots. |
| `movementTimePreferences` | Thời gian vận động / Movement Preference | `movement_time_preferences` | List\<String\> | `["evening"]` | Required | Array of preferred movement slots (morning, lunch, evening). |
| `breakReminderInterval` | Nhịp nhắc nhở nghỉ ngơi / Break Interval | `break_reminder_interval` | int | `90` | **BUG** | Hardcoded to `90` in payload. The UI step collects it but it is ignored. |
| `breakDuration` | Thời gian nghỉ ngơi / Break Duration | `break_duration` | String | `"5"` | **BUG** | Hardcoded to `"5"` in payload. The UI step collects it but it is ignored. |
| `waterReminderMode` | Chế độ nhắc nước / Water Reminder Mode | `water_reminder_mode` | String | `"optimal"` | **BUG** | Defaults to `"optimal"`. UI step collects it but is bypassed. |
| `quietAfterTime` | Khung giờ yên tĩnh / Quiet After Time | `quiet_after_time` | String | `"22:00"` | **BUG** | Defaults to `"22:00"`. UI step collects it but is bypassed. |
| `preferredRewards` | Phần thưởng mong muốn / Preferred Rewards | `preferred_rewards` | List\<String\> | `[]` | **BUG** | Hardcoded to `[]`. UI step collects it but is bypassed. |

---

## Part 3 — Singular vs Plural Fields Audit

### 1. Plural Fields Support
The frontend successfully stores time preferences as arrays in state and sends them as plural arrays in the JSON payload:
- `learning_time_preferences`: `["evening"]`
- `movement_time_preferences`: `["morning", "evening"]`
- `preferred_free_times`: `["early_morning", "evening"]`

The UI chip selectors support multi-select toggles (via Riverpod state copy-with modifications), and the payload correctly supports fallback mapping:
- If a plural array is empty, the fallback code splits the singular fallback string by a comma (e.g. `fallbackPreference.split(',')`) and normalizes it.

### 2. Payload Key Case
The backend expects snake_case (`display_name`, `target_sleep_time`), and the frontend correctly constructs the keys in snake_case format inside `OnboardingPageModel._buildOnboardingPayload()`.

### 3. Critical Mismatches

#### Mismatch A: `main_goals` Sent as Vietnamese Strings
The frontend saves selected goals as Vietnamese display strings (e.g. `"Uống Nước"`, `"Vận Động"`, `"Học Tập"`, `"Chánh Niệm"`, `"Ngủ Tốt Hơn"`, `"Tập Trung Tốt Hơn"`, `"Giảm Cân"`, `"Kỷ Luật Hơn"`).
- **Payload output**: `"main_goals": ["Uống Nước", "Vận Động"]`
- **Backend/AI Expectation**: The backend expects stable, language-independent canonical keys like `["water", "movement", "learning", "mindfulness", "sleep", "focus", "weight", "discipline"]`. Sending Vietnamese text risks AI interpretation errors or setting rules for unrecognized categories.

#### Mismatch B: Skipped Onboarding Steps Bypassing User Choices
`onboarding_page.dart` implements a shortened 7-step onboarding flow. Steps 6 (`OnboardingRemindersStep`) and 7 (`OnboardingRewardsStep`) are defined in the project but **omitted** from the active flow. As a result:
- The user is never prompted for water reminder modes, break reminder intervals, break durations, quiet times, or reward preferences.
- The payload builder bypasses the local state variables and **hardcodes** these values:
  - `break_reminder_interval`: Hardcoded to `90`.
  - `break_duration`: Hardcoded to `"5"`.
  - `preferred_rewards`: Hardcoded to `[]`.
  - `water_reminder_mode`: Defaulted to `"optimal"`.
  - `quiet_after_time`: Defaulted to `"22:00"`.

---

## Part 4 — Time Preference Values & Range Mapping

The frontend collects abstract preferences (e.g. `morning`, `lunch`, `evening`) and transmits only the string codes. It does not send explicit time ranges for these preferences.

### 1. Current Frontend Mappings
- **Free Times Options** (Step 2): `early_morning`, `lunch`, `after_work`, `evening` (normalized from Vietnamese chip labels).
- **Learning & Movement Preference Options** (Step 5): `morning`, `lunch`, `evening`.
  - Note: `_normalizeTimePreferences` filters learning/movement slots strictly to `morning`, `lunch`, or `evening`. If the user has other codes in state, they are ignored.

### 2. Recommended Canonical Time Range Mapping
To enable the backend AI to target correct time ranges within the user's daily schedule, the following stable canonical mapping is proposed:

| Abstract Code | Recommended Time Range | Vietnamese Display Label | English Display Label |
|---|---|---|---|
| `early_morning` | `05:30 - 08:00` | Sáng sớm | Early Morning |
| `morning` | `08:00 - 11:30` | Sáng | Morning |
| `lunch` | `11:30 - 13:30` | Nghỉ trưa | Lunch Break |
| `afternoon` | `13:30 - 17:30` | Chiều | Afternoon |
| `after_work` | `17:30 - 19:30` | Sau giờ làm | After Work |
| `evening` | `19:30 - 22:00` | Tối | Evening |
| `night` | `22:00 - 23:30` | Đêm | Night |
| `flexible` | *No fixed range* | Linh hoạt | Flexible |

### 3. Product Rules & AI Guidelines
- **Soft Preferences**: These ranges are intended as **soft preferences** for the AI when selecting the `reminder_time` for specific daily quests.
- **Hard Constraints**: The AI must respect the hard constraints defined in the active rules (e.g. `quest_settings.rules.active_time_range`). The soft preferences must fall *inside* the rule active range.
- **Vietnamese Label Risks**: Since the frontend normalizes chip selections using a dictionary mapping before sending, it currently avoids sending raw Vietnamese text for time preferences. However, if any new page or configuration skips this dictionary, sending Vietnamese labels instead of canonical codes will cause backend parser exceptions.

---

## Part 5 — Configuration Conflicts Caused by Onboarding

Because onboarding settings are saved separate from the default quest rules in the database, several severe configuration conflicts arise during onboarding completion:

### 1. Work Shift vs Break Rule Conflict
- **Onboarding Setup**: User configures night shift work hours (e.g., `14:00 - 22:00`).
- **Default Break Rule**: `rule_break_time` has a fixed active time range of `09:00 - 18:00`.
- **Conflict**: The user will be scheduled for work eye breaks between `09:00` and `14:00` (while sleeping/at rest) and receive no break reminders during their actual shift (`18:00 - 22:00`).

### 2. Learning/Movement Preference vs Category Rule Range Conflict
- **Onboarding Setup**: User selects `morning` (Sáng, `08:00 - 11:30`) for learning preferences.
- **Default Learning Rule**: `rule_learning` has a fixed active range of `19:00 - 22:00`.
- **Conflict**: The soft preference (`morning`) and hard rule range (`evening`) have zero overlap. The AI must either break the rule constraint or ignore the user's onboarding preference.

### 3. Target Sleep / Quiet Time Conflict
- **Onboarding Setup**: User configures wake up at `05:30` and target sleep at `21:30`.
- **Default Sleep Rule**: `rule_sleep` has a fixed active range of `22:00 - 23:30`.
- **Conflict**: The sleep preparation quest will be suggested at `22:00` onwards, which is 30 minutes after the user is already asleep.

### 4. Enabled Category vs Rule Status
- During onboarding, if a user enables the "Học Tập" (Learning) goal, it is saved under user profile `main_goals`. However, if the rule `rule_learning` in `QuestSettings` is disabled by the backend, no quests can be generated. The mismatch is confusing to users who explicitly set this as a goal.

### 5. Health Limitations vs Movement Rule Intensity
- A user selecting `back_pain` or `low_energy` still retains the default `rule_movement` with `medium` difficulty. The system does not automatically scale down the default rule intensity or update the rule difficulty.

---

## Part 6 — AI Usefulness of Onboarding Data

We evaluated whether current onboarding collects sufficient information to enable high-quality AI quest generation across the six quest categories:

| Quest Category | Readiness Rating | Missing Important Data / Fix Required |
|---|---|---|
| **water** | **Partially Ready** | Collects `wake_up_time`, `quiet_after_time` (defaults to 22:00), and `target_sleep_time`. Bypasses user customization of the water reminder mode (defaults to optimal). |
| **breakTime** | **Partially Ready** | Collects `work_start_time` and `work_end_time`. Bypasses user customization of break interval (hardcoded to 90 min) and duration (hardcoded to 5 min). |
| **movement** | **Partially Ready** | Collects `activity_level`, `last_workout`, `health_limitations`, and preferred slots. Mismatches exist between user's preferred slot (e.g. morning) and the static rule range (`10:00 - 20:00`). |
| **learning** | **Partially Ready** | Collects preferred slot and free time range. **Fails** because `main_goals` is sent as raw Vietnamese text instead of `"learning"`. Also lacks learning topic, level, or details. |
| **sleep** | **Partially Ready** | Collects `target_sleep_time` and `wake_up_time`. Quiet time is hardcoded to 22:00. Sleep rule active ranges (`22:00-23:30`) conflict with early sleepers. |
| **review** | **Partially Ready** | No preferred review time is collected during onboarding; default rules force the review window to `21:00 - 23:00` regardless of bedtime. |

---

## Part 7 — Missing But Valuable Fields

To ensure a seamless AI quest generation experience, we identify the following missing fields, categorized by urgency:

### 1. Must Have Before AI Home Integration
- **`preferred_review_time`**: Highly personal quest. Forcing daily review to `21:00 - 23:00` conflicts with early sleepers (e.g. sleep at 21:00). Needs onboarding selection or default calculation (e.g., 1 hour before `target_sleep_time`).
- **Normalized Goal Keys**: `main_goals` must be converted from Vietnamese text (`"Học Tập"`) to canonical codes (`"learning"`).

### 2. Nice to Have Later (Post-Integration)
- **`work_days` / `weekdays`**: Useful for shift workers or people working Saturdays. Currently, work schedule type is a broad enum (`weekdays`, `full_week`).
- **`movement_intensity_preference`**: Customizing whether movement quests should be easy (stretching) or high-intensity.
- **`avoided_activities`**: Excluding specific exercises (e.g., no jumping jacks due to knee injury).

### 3. Better Handled by Learning Path Phase
- **`learning_topics`** (e.g., Coding, English).
- **`learning_level`** (e.g., Beginner, Advanced).
- **`learning_goal_detail`** (e.g., "Pass IELTS exam").

---

## Part 8 — Onboarding Payload Sample

### 1. Current Actual FE Payload Sent
This is the payload shape constructed by `_buildOnboardingPayload()` today:

```json
{
  "display_name": "Nguyen Van A",
  "age": 25,
  "gender": "male",
  "height_cm": 170.0,
  "weight_kg": 65.0,
  "main_activity": "software_engineer",
  "work_schedule_type": "weekdays",
  "work_start_time": "08:30",
  "work_end_time": "17:30",
  "free_time_preference": "evening",
  "preferred_free_times": ["evening"],
  "activity_level": "very_little",
  "last_workout": "longer_ago",
  "health_limitations": ["back_pain"],
  "main_goals": ["Học Tập", "Vận Động", "Uống Nước"], 
  "wake_up_time": "07:00",
  "target_sleep_time": "23:00",
  "free_time_start": "20:00",
  "free_time_end": "22:00",
  "learning_time_preference": "evening",
  "learning_time_preferences": ["evening"],
  "movement_time_preference": "evening",
  "movement_time_preferences": ["evening"],
  "break_reminder_interval": 90,
  "break_duration": "5",
  "water_reminder_mode": "optimal",
  "quiet_after_time": "22:00",
  "preferred_rewards": [],
  "completed": true
}
```

### 2. Expected Backend-Friendly Payload (Corrected)
The payload below corrects the Vietnamese goals to canonical codes, restores the user-selected reminder settings, and supplies the missing review time anchor.

```json
{
  "display_name": "Nguyen Van A",
  "age": 25,
  "gender": "male",
  "height_cm": 170.0,
  "weight_kg": 65.0,
  "main_activity": "software_engineer",
  "work_schedule_type": "weekdays",
  "work_start_time": "08:30",
  "work_end_time": "17:30",
  "free_time_preference": "evening",
  "preferred_free_times": ["evening"],
  "activity_level": "very_little",
  "last_workout": "longer_ago",
  "health_limitations": ["back_pain"],
  "main_goals": ["learning", "movement", "water"],
  "wake_up_time": "07:00",
  "target_sleep_time": "23:00",
  "free_time_start": "20:00",
  "free_time_end": "22:00",
  "learning_time_preference": "evening",
  "learning_time_preferences": ["evening"],
  "movement_time_preference": "evening",
  "movement_time_preferences": ["evening"],
  "break_reminder_interval": 90,
  "break_duration": "5",
  "water_reminder_mode": "optimal",
  "quiet_after_time": "22:00",
  "preferred_rewards": [],
  "preferred_review_time": "21:30",
  "completed": true
}
```

### 3. Discrepancy Diff List
- `main_goals`: `["Học Tập", "Vận Động", "Uống Nước"]` vs. `["learning", "movement", "water"]` (VI display text instead of canonical codes).
- `break_reminder_interval`: Hardcoded to `90` bypassing the user's local selection.
- `break_duration`: Hardcoded to `"5"` bypassing the user's local selection.
- `water_reminder_mode`: Defaulted to `"optimal"` (UI step skipped).
- `quiet_after_time`: Defaulted to `"22:00"` (UI step skipped).
- `preferred_rewards`: Hardcoded to `[]` (UI step skipped).
- `preferred_review_time`: Omitted completely (no field exists).

---

## Part 9 — Final Recommendations & Next Step Implementation

### 1. What is Good Enough
- The onboarding navigation, Riverpod page state machine, layout widgets, and time picker components are stable and fully functioning.
- The standard user info (`displayName`, `age`, `height`, `weight`), work schedule times, free time range, and activity level options map cleanly to correct types and codes.

### 2. Blockers to Resolve Before AI Integration
The following fixes are required before wiring AI generation:
1. **Fix `main_goals` Mapping**: Normalize Vietnamese goal strings to canonical codes in the payload builder.
2. **Handle Omitted Steps**:
   - Option A: Re-enable steps 6 & 7 in `onboarding_page.dart` (increasing total steps to 9) to let users customize reminders and rewards.
   - Option B: If the product decision is to keep onboarding short, remove the reminders/rewards state from onboarding completely, and read/save these configurations through a dedicated settings editor later.
3. **Harmonize Quest Rules with Onboarding Schedule**:
   - The onboarding completion function should dynamically update the default quest rule active ranges (e.g. `rule_break_time.activeTimeRange` = `work_start_time` - `work_end_time`).
4. **Determine `preferred_review_time`**: Calculate a default review time based on target sleep time (e.g., 1 hour prior) or add it to the schedule step.

### 3. Suggested Next Prompt for Implementation Phase
You can copy this prompt to launch the implementation phase:

```text
Implement the onboarding data alignment fixes for AI quest generation readiness:

1. Normalize 'main_goals' in lib/modules/onboarding/onboarding_page_model.dart before sending to POST /api/onboarding. Map:
   - 'Uống Nước' -> 'water'
   - 'Vận Động' -> 'movement'
   - 'Học Tập' -> 'learning'
   - 'Chánh Niệm' -> 'mindfulness'
   - 'Ngủ Tốt Hơn' -> 'sleep'
   - 'Tập Trung Tốt Hơn' -> 'focus'
   - 'Giảm Cân' -> 'weight'
   - 'Kỷ Luật Hơn' -> 'discipline'

2. Correct the payload values for 'break_reminder_interval' and 'break_duration' to use the state variables (state.data.breakReminderInterval, state.data.breakDuration) instead of hardcoding 90 and '5'.

3. In completeOnboarding(), when saving onboarding details, dynamically align the default Quest Settings rules active ranges to prevent schedule conflicts:
   - rule_break_time: set activeTimeRange to work_start_time - work_end_time.
   - rule_learning: if user prefers learning in the morning/lunch, adjust activeTimeRange to match those slots; otherwise, align with free_time_start - free_time_end.
   - rule_movement: align with movement_time_preferences.
   - rule_sleep: align to end at target_sleep_time (e.g. 1.5 hours before target_sleep_time).
   - rule_review: set activeTimeRange to 1 hour before target_sleep_time.

4. Run fvm flutter analyze and fvm flutter test to ensure all changes are compile-safe and pass all test suites.
```

---

## Part 10 — Test Results Summary

- **Static Analysis (`fvm flutter analyze`)**: Passed with 22 info/warning messages (unrelated deprecated usages and duplicate imports in other modules). No compiler blockers found.
- **Unit & Widget Tests (`fvm flutter test`)**: All 477 tests passed successfully.
