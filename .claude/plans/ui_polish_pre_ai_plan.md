# UI Polish Pre-AI Implementation Plan

## Overview
This plan addresses UI polish, UX cleanup, component consistency, and removal of goal-related terminology before AI integration. The work is focused on the Learning Path/Roadmap feature while keeping Goals intentionally out of scope.

---

## Phase 1: Terminology Replacement (Goal → Learning Path)

### 1.1 Localization Updates (Priority: CRITICAL)
**Files to modify:**
- `lib/l10n/app_en.arb`
- `lib/l10n/app_vi.arb`

**Changes (41 localization keys):**

| Current Key | Current Value | New Value |
|-------------|---------------|-----------|
| `loginTagline` | "Turn your personal goals..." | "Turn your learning paths into small daily quests." |
| `profileLearningGoalsTileTitle` | "Learning Goals" | "Learning Roadmap" |
| `profileLearningGoalsTileSubtitle` | "Manage personal learning goals" | "Track learning progress and roadmaps" |
| `profileGoalSectionTitle` | "Main Goals" | "Active Learning Path" |
| `profileGoalEmpty` | "You haven't set any main goals yet." | "You haven't started a learning path yet." |
| `profileGoalSetupButton` | "Set up goals" | "Browse learning paths" |
| `profileGoalPursuing` | "Pursuing" | "Learning" |
| `profileGoalFromProfile` | "Goals set in your profile" | "Learning paths from profile" |
| `profileGoalFromLearning` | "From active learning goals" | "From active roadmaps" |
| `homeQuestReasonDefault` | "...schedule and goals today." | "...schedule and learning paths today." |
| `learningGoalDeleteConfirm` | "Delete this goal?" | "Delete this learning path?" |
| `learningGoalDeleteMessage` | "...delete this learning goal?" | "...delete this learning path?" |
| All `lg*` keys (25+) | Various "goal" references | Replace with "learning path" or "roadmap" |

**Action:** Update both English and Vietnamese .arb files, then run code generator.

---

### 1.2 Widget & Class Renaming (Priority: HIGH)

**Files to refactor:**

| Current File/Class | New Name | Impact |
|-------------------|----------|--------|
| `profile_goal_section.dart` / `ProfileGoalSection` | `ProfileLearningPathSection` | Profile display |
| `active_goal_card.dart` / `ActiveGoalCard` | `ActiveLearningPathCard` | Learning goals page |
| `learning_goal_card.dart` / `LearningGoalCard` | `LearningPathCard` | Learning goals page |
| `learning_goal_form_sheet.dart` | `learning_path_form_sheet.dart` | Form component |
| `learning_goal_list_section.dart` | `learning_path_list_section.dart` | List component |
| `learning_goal_summary_card.dart` | `learning_path_summary_card.dart` | Summary component |

**Property/Parameter Renaming:**
- `learningGoalFallback` → `learningPathFallback`
- `activeGoals` → `activeLearningPaths`
- `mainGoals` display text → "Active Learning Paths" (DO NOT rename backend property)

**DO NOT CHANGE:**
- `mainGoals` property in models/DTOs (backend contract)
- `LearningGoalModel` class name (internal model, low priority)

---

### 1.3 Onboarding Module Updates (Priority: MEDIUM)

**File:** `lib/modules/onboarding/widgets/onboarding_goals_step.dart`

**Changes:**
- Rename class: `OnboardingGoalsStep` → `OnboardingLearningPathStep`
- Rename inner class: `_GoalOption` → `_LearningPathOption`
- Update text references to use new localization keys
- Consider whether this step is still needed if Goals are removed

**Decision Point:** Should onboarding still ask about "learning paths" or focus on schedule/preferences only?

---

## Phase 2: Learning Path UX Polish

### 2.1 Empty State Fix (Priority: CRITICAL)

**File:** `lib/modules/learning_roadmap/widgets/learning_roadmap_empty_view.dart`

**Current Issue:** Empty state CTA routes to Learning Goals (wrong module)

**Fix:**
```dart
// Remove dependency on Goals
// Add CTA: "Browse Learning Paths" or "Create Roadmap"
// Route to roadmap creation flow or template selection
```

**Implementation:**
- Remove Learning Goals button
- Add "Create Learning Path" button that opens `CreateRoadmapBottomSheet` directly
- OR add "Browse Templates" button if templates exist
- Update copy to remove goal references

---

### 2.2 Roadmap Detail Sheet UX (Priority: HIGH)

**File:** `lib/modules/learning_roadmap/widgets/roadmap_detail_sheet.dart`

**Current Issue:** Sheet closes after each step toggle, breaking multi-step workflows

**Fix:**
1. Keep sheet open after step toggle
2. Update UI in-place when step completes
3. Add toast confirmation: "Step marked as complete"
4. Add explanatory text: "Mark steps you've completed to track your progress"

**Implementation:**
```dart
// In RoadmapDetailSheet:
// 1. Add local state management for step completion
// 2. Update step list UI immediately on toggle
// 3. Call onToggleStep callback but DON'T close sheet
// 4. Show AppToast confirmation
// 5. Update progress bar in sheet header
```

---

### 2.3 Roadmap List Section Updates (Priority: MEDIUM)

**File:** `lib/modules/learning_roadmap/widgets/roadmap_list_section.dart`

**Changes:**
1. Update section header: "Roadmap của bạn" → "Lộ trình đang theo dõi" (Your tracked paths)
2. Add difficulty badge to each card (if data available)
3. Make "View Roadmap" button explicit/visual (not just text in card)

---

### 2.4 Hide/Disable AI Creation Flow (Priority: HIGH)

**Files:**
- `lib/modules/learning_roadmap/widgets/create_roadmap_fab.dart`
- `lib/modules/learning_roadmap/widgets/roadmap_preference_sheet.dart`
- `lib/modules/learning_roadmap/widgets/create_roadmap_bottom_sheet.dart`

**Changes:**
1. Add disclaimer to FAB or preference sheet: "Template Selection (AI coming soon)"
2. OR hide entire AI flow until backend integration
3. Update copy: "Tell AI..." → "Choose your learning preferences"
4. Remove misleading "AI suggests" language

**Recommendation:** Keep flow visible but add clear disclaimer that it's template-based, not personalized AI.

---

### 2.5 Profile Learning Path Summary (Priority: MEDIUM)

**File:** `lib/modules/profile/widgets/profile_goal_section.dart`

**Changes after renaming to `ProfileLearningPathSection`:**
1. Update section to show active roadmap summary instead of generic goals
2. Display: roadmap title, progress percentage, next step
3. CTA: "View Roadmap" → routes to Learning Roadmap page
4. Empty state: "No active learning path" → CTA: "Browse roadmaps"

---

### 2.6 Home Page Integration (Priority: LOW - Future Work)

**File:** `lib/modules/home/home_page.dart`

**Current State:** `LearningQuestCard` exists but unused

**Decision:**
- If Learning Quest integration is in scope: uncomment and wire to backend
- If not in scope: remove `LearningQuestCard` widget entirely to reduce maintenance burden

**Recommendation:** Remove for now, add back when backend supports learning quest integration.

---

## Phase 3: Component Extraction & Consistency

### 3.1 Create Missing Reusable Components (Priority: MEDIUM)

**New components to create:**

#### A. `AppMetricCard` (replaces duplicated stat card pattern)
**Location:** `lib/widgets/app_metric_card/app_metric_card.dart`

**Usage:** ProfileStatsGrid, DailyProgressCard, Progress page

**Props:**
```dart
final String label;
final String value;
final IconData? icon;
final Color? accentColor;
final VoidCallback? onTap;
```

---

#### B. `AppStatusChip` (replaces duplicated status badge pattern)
**Location:** `lib/widgets/app_chip/app_status_chip.dart`

**Usage:** Roadmap cards, Learning cards, Quest cards

**Props:**
```dart
final String label;
final Color backgroundColor;
final Color foregroundColor;
final IconData? icon;
```

---

#### C. `AppLinkButton` (text + icon button pattern)
**Location:** `lib/widgets/app_button/app_link_button.dart`

**Usage:** Roadmap cards "View Roadmap", various action links

**Props:**
```dart
final String label;
final IconData icon;
final VoidCallback? onPressed;
final Color? color;
```

---

### 3.2 Text Style Consolidation (Priority: HIGH)

**Files affected:** 40+ module files with 599 inline TextStyle declarations

**Strategy:**
1. Create additional `AppTextStyle` variants for missing sizes:
   - `AppTextStyle.metric` (20px, w700, mono, accent color) - for stat numbers
   - `AppTextStyle.bodySmall` (13px, w500, fg) - for secondary text
   - `AppTextStyle.labelSmall` (10px, w600, fgMuted) - for micro labels

2. Replace inline styles in high-priority files:
   - `lib/modules/profile/widgets/profile_stats_grid.dart`
   - `lib/modules/home/widgets/daily_progress_card.dart`
   - `lib/modules/profile/widgets/profile_goal_section.dart` (after rename)
   - `lib/modules/profile/widgets/profile_account_card.dart`

**Action:** Create utility script or manual refactor to replace inline `TextStyle()` with `AppTextStyle.*` references.

---

### 3.3 Spacing Standardization (Priority: MEDIUM)

**Files to update:** `lib/constants/app_spacing.dart`

**Add missing constants:**
```dart
static const double s10 = 10.0;
static const double s14 = 14.0;
```

**Replace hardcoded values:**
- 71 hardcoded spacing values across 20+ files
- Focus on high-traffic files: Profile, Home, Learning Roadmap

**Tool:** Consider using regex search/replace for common patterns:
- `EdgeInsets.symmetric(horizontal: 16)` → `EdgeInsets.symmetric(horizontal: AppSpacing.s16)`

---

## Phase 4: State Handling Polish

### 4.1 Consistent Error States (Priority: LOW)

**Check and standardize:**
- All pages use `AppErrorState` with retry button
- Error messages use localization keys
- Retry logic properly reloads data

**Files:** Home, Profile, Learning Roadmap, Progress pages

---

### 4.2 Loading State Consistency (Priority: LOW)

**Check and standardize:**
- Use skeleton screens for initial load
- Use `AppLoading` or `CircularProgressIndicator` for inline loading
- Show loading state for async actions (button loading spinners)

---

### 4.3 Empty State Polish (Priority: MEDIUM)

**Ensure all modules have clear empty states:**
- Learning Roadmap: ✓ Exists (needs UX fix from Phase 2.1)
- Home: ✓ Exists (`HomeEmptyQuestView`)
- Profile: ✓ Exists (`ProfileEmptyView`)
- Progress: Check and verify
- Logs: Check and verify
- Rewards: Check and verify

---

## Phase 5: Color & Theme Cleanup

### 5.1 Semantic Color Usage (Priority: LOW)

**Current Issue:** Direct color usage (`AppColor.cyan`) instead of semantic aliases

**Refactor:**
- `AppColor.cyan` → `AppColor.primary` (where it represents primary brand action)
- Add semantic aliases in `app_color.dart` if missing:
  - `static const Color primaryAction = cyan;`
  - `static const Color success = AppColor.success;` (if not defined)

**Files:** Low priority, refactor during maintenance cycles

---

### 5.2 Gradient & Shadow Consistency (Priority: LOW)

**Check:** All cards use consistent shadow/glow from `AppShadow` constants

**Files with custom shadows:** Profile cards, Roadmap cards - verify they use constants

---

## Phase 6: Verification & Reporting

### 6.1 Run Static Analysis
```bash
fvm flutter analyze
```

**Expected:** Zero errors, zero warnings (or document acceptable warnings)

---

### 6.2 Run Tests
```bash
fvm flutter test
```

**Expected:** All tests pass (or document known failures)

---

### 6.3 Manual UI Testing Checklist

**Test scenarios:**
1. ✓ Learning Roadmap empty state shows correct CTA
2. ✓ Roadmap detail sheet stays open after toggling steps
3. ✓ Profile shows "Active Learning Path" instead of "Main Goals"
4. ✓ All "goal" references replaced in UI text
5. ✓ Loading states appear correctly on all pages
6. ✓ Error states show with retry button
7. ✓ Empty states have clear messaging and CTAs

---

### 6.4 Create Report

**File:** `FE_UI_POLISH_PRE_AI_REPORT.md`

**Contents:**
```markdown
# Frontend UI Polish Pre-AI Report

## Summary
Polished UI for Learning Path/Roadmap feature. Removed goal-related terminology, improved UX flow, extracted reusable components, and standardized styling.

## Files Changed
- Localization: 2 files (app_en.arb, app_vi.arb) - 41 keys updated
- Widgets renamed: 6 files
- UI components created: 3 new widgets (AppMetricCard, AppStatusChip, AppLinkButton)
- UX fixes: 5 files (empty state, detail sheet, list section, profile, FAB)
- Text style consolidation: 15+ high-priority files
- Spacing standardization: 10+ files

## Goal Terminology Removed/Replaced
- [List all files with before/after examples]
- Profile section renamed from "Main Goals" to "Active Learning Path"
- Learning Goals page → Learning Roadmap page
- All localization keys updated

## Learning Path Flow After Polish
### Empty State
- Shows "No learning paths yet" message
- CTA: "Browse Learning Paths" → opens roadmap creation/template selection
- Removed dependency on Learning Goals module

### Roadmap Detail
- Detail sheet stays open after step toggle
- Toast confirmation on step completion
- Clear progress updates in-place

### Profile Summary
- Shows active roadmap summary with progress
- CTA: "View Roadmap" → navigates to Learning Roadmap page
- Empty state routes to roadmap browsing

### Home Integration
- [Document if LearningQuestCard was removed or integrated]

## Reusable Components Added/Updated
### New Components
1. `AppMetricCard` - Stat display cards (used in Profile, Home)
2. `AppStatusChip` - Status indicators (used in Roadmap, Learning cards)
3. `AppLinkButton` - Text + icon link buttons

### Updated Components
- `AppTextStyle` - Added metric, bodySmall, labelSmall variants
- `AppSpacing` - Added s10, s14 constants

## Theme/Color Cleanup Summary
- Zero hardcoded Color(0x...) values found (already clean)
- Standardized spacing: 71 hardcoded values → AppSpacing constants
- Text styles: 599 inline TextStyle() → reduced to AppTextStyle references (in progress)

## Known Limitations
1. **Backend Integration Pending:**
   - AI roadmap creation is template-based mock
   - Step completion is local-only (not persisted to backend)
   - Learning Quest integration not yet connected

2. **Out of Scope (Intentional):**
   - Learning Goals module kept as-is (marked for future review)
   - Home Learning Quest card removed (add back when backend ready)

3. **Future Work:**
   - Complete text style consolidation (40+ files remaining)
   - Add search/filter to roadmap list
   - Add difficulty badges to roadmap cards (pending backend data)

## Verification Results

### fvm flutter analyze
[Paste output here]

### fvm flutter test
[Paste output here]

---

**Date:** [Date]
**Status:** ✅ Complete / ⚠️ Partial / ❌ Blocked
```

---

## Implementation Order (Priority)

### Sprint 1 (Day 1-2): Critical Path
1. ✅ Phase 1.1: Update localization files (41 keys)
2. ✅ Phase 2.1: Fix Learning Roadmap empty state
3. ✅ Phase 2.2: Fix Roadmap detail sheet UX
4. ✅ Phase 2.4: Add AI disclaimer or hide flow

### Sprint 2 (Day 3-4): High Priority
5. ✅ Phase 1.2: Rename widget classes (6 files)
6. ✅ Phase 2.5: Update Profile learning path section
7. ✅ Phase 3.2: Add missing AppTextStyle variants
8. ✅ Phase 3.1: Create AppMetricCard, AppStatusChip

### Sprint 3 (Day 5): Medium Priority
9. ✅ Phase 2.3: Update Roadmap list section
10. ✅ Phase 3.3: Add missing spacing constants
11. ✅ Phase 4.3: Verify empty states across all pages

### Sprint 4 (Day 6): Polish & Verification
12. ✅ Phase 3.2: Text style consolidation (high-priority files)
13. ✅ Phase 6: Run verification (analyze, test, manual testing)
14. ✅ Phase 6.4: Create report

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Breaking localization generation | High | Test code generation after .arb changes |
| Widget rename breaks routes | Medium | Search for all imports and update |
| Text style refactor breaks layouts | Low | Test each page after style changes |
| Spacing changes break visual design | Low | Review changes with designer/screenshots |

---

## Out of Scope (Explicitly NOT Changed)

1. ❌ Backend models/DTOs (`mainGoals` property)
2. ❌ API endpoints or contracts
3. ❌ Learning Goals module functionality (kept for future decision)
4. ❌ Quest generation logic
5. ❌ Home page Learning Quest integration (removed for now)
6. ❌ AI roadmap generation (keep mock flow with disclaimer)
7. ❌ Complete text style consolidation (40+ files - too broad for this sprint)

---

## Success Criteria

### Must Have ✅
- [ ] All "goal" UI text replaced with "learning path" / "roadmap"
- [ ] Learning Roadmap empty state routes correctly (not to Goals)
- [ ] Roadmap detail sheet stays open after step toggle
- [ ] Profile shows learning path summary instead of goals
- [ ] `fvm flutter analyze` passes with zero errors
- [ ] `fvm flutter test` passes (or known failures documented)
- [ ] Report generated with all changes documented

### Should Have 🎯
- [ ] 3 new reusable components created
- [ ] High-priority files use AppTextStyle (not inline styles)
- [ ] Spacing constants added and used in high-priority files
- [ ] All empty states have clear CTAs

### Nice to Have 💡
- [ ] All inline TextStyle replaced (40+ files - stretch goal)
- [ ] All hardcoded spacing values replaced
- [ ] Semantic color usage refactored
- [ ] Difficulty badges added to roadmap cards

---

## Post-Implementation Next Steps

1. **Design Review:** Share screenshots of before/after for visual approval
2. **User Testing:** Test empty state flow, roadmap completion flow, profile navigation
3. **Backend Coordination:** Prepare for AI roadmap integration (API contracts)
4. **Documentation:** Update component library docs with new widgets
5. **Backlog:** Create tickets for remaining text style consolidation, semantic color refactor

---

**Plan Status:** READY FOR APPROVAL
**Estimated Effort:** 5-6 days
**Risk Level:** LOW (mostly UI refactoring, no backend changes)
