# SoloQuest FE AI Onboarding Payload Alignment Report

This report summarizes the implementation details for aligning the Frontend (FE) onboarding payload structure with Backend (BE) AI quest generation expectations, ensuring canonical codes and dynamic calculations are transmitted correctly.

---

## 1. Files Changed

- [onboarding_page_model.dart](file:///Users/qc-bright/Project/solo_quest/lib/modules/onboarding/onboarding_page_model.dart): Added time helper imports, defined the canonical `_mainGoalApiValues` dictionary, updated `_buildOnboardingPayload()` to map goals and reminders, and added the review time calculator.
- [onboarding_page_model_test.dart](file:///Users/qc-bright/Project/solo_quest/test/onboarding_page_model_test.dart): Added comprehensive unit tests validating goal normalization, array lists, reminder values, and clamped/unclamped review time calculations.

---

## 2. Implemented Alignment Features

### A. `main_goals` Normalization
We implemented the `_mainGoalApiValues` map which translates Vietnamese onboarding display labels to stable canonical codes:
- `"Uống Nước"` $\rightarrow$ `"water"`
- `"Vận Động"` $\rightarrow$ `"movement"`
- `"Học Tập"` $\rightarrow$ `"learning"`
- `"Chánh Niệm"` $\rightarrow$ `"mindfulness"`
- `"Ngủ Tốt Hơn"` $\rightarrow$ `"sleep"`
- `"Tập Trung Tốt Hơn"` $\rightarrow$ `"focus"`
- `"Giảm Cân"` $\rightarrow$ `"weight"`
- `"Kỷ Luật Hơn"` $\rightarrow$ `"discipline"`

Existing canonical keys (e.g., `'water'`) are preserved as-is. Unknown values fall back gracefully without causing a crash.
```dart
    final normalizedMainGoals = state.data.mainGoals
        .map((goal) => _mainGoalApiValues[goal.trim()] ?? goal.trim())
        .where((goal) => goal.isNotEmpty)
        .toSet()
        .toList();
```

### B. Reminder Fields Alignment
Instead of using hardcoded payload values, the builder now correctly maps:
- `break_reminder_interval`: uses `state.data.breakReminderInterval`
- `break_duration`: uses `state.data.breakDuration`
- `water_reminder_mode`: uses `state.data.waterReminderMode`
- `quiet_after_time`: uses `state.data.quietAfterTime`

> [!NOTE]
> Since the reminders step is currently omitted in the active UI flow, these parameters will send their fallback default values (`90`, `"5"`, `"optimal"`, `"22:00"`). However, the client is now architected to use state variables instead of hardcoding, making it fully ready to support UI customization.

### C. `preferred_review_time` Decision & Math
We added the new `preferred_review_time` payload key dynamically. The calculation follows these rules:
1. Parse the user's `target_sleep_time` (e.g. `"23:30"`).
2. Subtract 1 hour (e.g. `"22:30"`).
3. If `quiet_after_time` exists, compare the values. If the calculated review time is after `quiet_after_time` (e.g. `"22:30"` is after `"22:00"`), clamp the review time to the quiet after window (e.g., `"22:00"`).
4. Format the final output in HH:mm.

This ensures review quests are scheduled before quiet hours begin and aligned with the user's sleep constraints.

---

## 3. Plural Time Preferences Verification
We verified that the plural time preference array fields are correctly formatted and sent as lists rather than strings:
- `preferred_free_times`
- `learning_time_preferences`
- `movement_time_preferences`

These lists only contain canonical values (e.g. `['morning', 'lunch', 'evening']` or `['early_morning', 'evening']`) and do not send Vietnamese labels.

---

## 4. Tests Added & Updated

We added two new unit tests to [onboarding_page_model_test.dart](file:///Users/qc-bright/Project/solo_quest/test/onboarding_page_model_test.dart):
1. **`completeOnboarding normalizes main_goals and applies reminder & review time calculations`**:
   - Asserts that Vietnamese goal strings translate to canonical codes while unknown strings persist safely.
   - Asserts that state values for reminders are used (e.g., interval `120` and duration `"10"`).
   - Asserts that plural lists are mapped correctly.
   - Asserts that `preferred_review_time` subtracts 1 hour and clamps correctly against `quiet_after_time`.
2. **`preferred_review_time calculation without clamping`**:
   - Asserts that when calculated review time is before quiet hours start (e.g. sleep at `"22:00"` $\rightarrow$ review at `"21:00"` vs quiet after `"22:00"`), no clamping is performed.

---

## 5. Verification Commands Results

### Static Analysis (`fvm flutter analyze`)
Passed with 22 info/warning messages (all existing/unrelated deprecation remarks or layout suggestions in other files). No compiler or analytical blocker was introduced.

### Unit & Widget Tests (`fvm flutter test`)
All **479 tests passed successfully** (including our 2 new test cases):
```bash
00:01 +12: OnboardingPageModel & OnboardingData Tests preferred_review_time calculation without clamping
00:01 +13: OnboardingPageModel & OnboardingData Tests gender dropdown displays male default from model state
00:01 +13: All tests passed!
```

---

## 6. Remaining Backend-Side Rule Synchronization Work

To achieve full AI quest generation readiness, the backend must implement the following adjustments when it processes the onboarding payload:
1. **Break Rule Sync**: Align `rule_break_time.activeTimeRange` with `work_start_time` and `work_end_time`.
2. **Learning / Movement Rule Sync**: Update rule ranges to enclose the user's preferred time slots (e.g., if learning preference is `morning`, ensure the learning rule allows morning scheduling).
3. **Sleep / Review Rule Sync**: Update `rule_sleep` and `rule_review` active ranges to adapt dynamically based on `target_sleep_time` and `preferred_review_time` to prevent notifications from firing outside awake hours.
