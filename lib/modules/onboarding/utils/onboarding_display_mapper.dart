import 'package:flutter/widgets.dart';

import '../../../generated/l10n/app_localizations.dart';
import '../constants/onboarding_codes.dart';

/// Maps canonical onboarding codes to localized display strings.
///
/// Supports legacy Vietnamese / old English display labels as backward-
/// compatibility fallback. Unknown values return the code itself rather
/// than throwing.
class OnboardingDisplayMapper {
  OnboardingDisplayMapper._();

  // ── Helpers ───────────────────────────────────────────────────────

  // ── Main activity ─────────────────────────────────────────────────

  static String localizedMainActivity(BuildContext context, String code) =>
      localizedMainActivityWithL10n(context.l10nOrNull, code);

  static String localizedMainActivityWithL10n(
    AppLocalizations? l10n,
    String code,
  ) {
    final norm = _normalizeMainActivity(code);
    switch (norm) {
      case OnboardingCodes.mainActivitySoftwareEngineer:
        return l10n?.onboardingStep2ActivityDeveloper ?? norm;
      case OnboardingCodes.mainActivityStudent:
        return l10n?.onboardingStep2ActivityStudent ?? norm;
      case OnboardingCodes.mainActivityOfficeWorker:
        return l10n?.onboardingStep2ActivityOffice ?? norm;
      case OnboardingCodes.mainActivityFreelancer:
        return l10n?.onboardingStep2ActivityFreelancer ?? norm;
      case OnboardingCodes.mainActivityOther:
        return l10n?.onboardingStep2ActivityOther ?? norm;
      default:
        return norm;
    }
  }

  static String _normalizeMainActivity(String value) {
    switch (value.trim()) {
      case 'Software Engineer':
      case 'Lập trình viên':
        return OnboardingCodes.mainActivitySoftwareEngineer;
      case 'Student':
      case 'Sinh Viên':
        return OnboardingCodes.mainActivityStudent;
      case 'Office Worker':
      case 'Nhân Viên Văn Phòng':
        return OnboardingCodes.mainActivityOfficeWorker;
      case 'Freelancer':
        return OnboardingCodes.mainActivityFreelancer;
      case 'Other':
      case 'Khác':
        return OnboardingCodes.mainActivityOther;
      default:
        return value.trim();
    }
  }

  // ── Goals ─────────────────────────────────────────────────────────

  static String localizedGoal(BuildContext context, String code) =>
      localizedGoalWithL10n(context.l10nOrNull, code);

  static String localizedGoalWithL10n(AppLocalizations? l10n, String code) {
    final norm = _normalizeGoal(code);
    switch (norm) {
      case OnboardingCodes.goalHealth:
        return l10n?.onboardingGoalHealth ?? norm;
      case OnboardingCodes.goalMovement:
        return l10n?.onboardingGoalFitness ?? norm;
      case OnboardingCodes.goalLearning:
        return l10n?.onboardingGoalLearning ?? norm;
      case OnboardingCodes.goalMindfulness:
        return l10n?.onboardingGoalMindfulness ?? norm;
      case OnboardingCodes.goalSleep:
        return l10n?.onboardingGoalSleep ?? norm;
      case OnboardingCodes.goalProductivity:
        return l10n?.onboardingGoalFocus ?? norm;
      case OnboardingCodes.goalWeightLoss:
        return l10n?.onboardingGoalWeight ?? norm;
      default:
        return norm;
    }
  }

  static String localizedGoals(BuildContext context, List<String> codes) =>
      localizedGoalsWithL10n(context.l10nOrNull, codes);

  static String localizedGoalsWithL10n(
    AppLocalizations? l10n,
    List<String> codes,
  ) {
    if (codes.isEmpty) return '—';
    return codes.map((c) => localizedGoalWithL10n(l10n, c)).join(' · ');
  }

  static String _normalizeGoal(String value) {
    switch (value.trim()) {
      case OnboardingCodes.goalHealth: return OnboardingCodes.goalHealth;
      case OnboardingCodes.goalMovement: return OnboardingCodes.goalMovement;
      case OnboardingCodes.goalLearning: return OnboardingCodes.goalLearning;
      case OnboardingCodes.goalMindfulness: return OnboardingCodes.goalMindfulness;
      case OnboardingCodes.goalSleep: return OnboardingCodes.goalSleep;
      case OnboardingCodes.goalProductivity: return OnboardingCodes.goalProductivity;
      case OnboardingCodes.goalWeightLoss: return OnboardingCodes.goalWeightLoss;
      case 'Uống Nước': return OnboardingCodes.goalHealth;
      case 'Vận Động': return OnboardingCodes.goalMovement;
      case 'Học Tập': return OnboardingCodes.goalLearning;
      case 'Chánh Niệm': return OnboardingCodes.goalMindfulness;
      case 'Ngủ Tốt Hơn': return OnboardingCodes.goalSleep;
      case 'Tập Trung Tốt Hơn': return OnboardingCodes.goalProductivity;
      case 'Giảm Cân': return OnboardingCodes.goalWeightLoss;
      case 'Kỷ Luật Hơn': return OnboardingCodes.goalProductivity;
      case 'water': return OnboardingCodes.goalHealth;
      case 'focus': return OnboardingCodes.goalProductivity;
      case 'weight': return OnboardingCodes.goalWeightLoss;
      default: return value.trim();
    }
  }

  // ── Work schedule type ────────────────────────────────────────────

  static String localizedWorkScheduleType(BuildContext context, String code) =>
      localizedWorkScheduleTypeWithL10n(context.l10nOrNull, code);

  static String localizedWorkScheduleTypeWithL10n(
    AppLocalizations? l10n,
    String code,
  ) {
    final norm = _normalizeWorkScheduleType(code);
    switch (norm) {
      case OnboardingCodes.scheduleWeekdays:
        return l10n?.onboardingStep2ScheduleWeekday ?? norm;
      case OnboardingCodes.scheduleMondayToSaturday:
        return l10n?.onboardingStep2ScheduleMonSat ?? norm;
      case OnboardingCodes.scheduleFullWeek:
        return l10n?.onboardingStep2ScheduleFullWeek ?? norm;
      case OnboardingCodes.scheduleFlexible:
        return l10n?.onboardingStep2ScheduleFlexible ?? norm;
      case OnboardingCodes.scheduleNightShift:
        return l10n?.onboardingStep2ScheduleNight ?? norm;
      default:
        return norm;
    }
  }

  static String _normalizeWorkScheduleType(String value) {
    switch (value.trim()) {
      case 'weekdays': case 'Mon-Fri': case 'Mon–Fri':
      case 'Thứ 2-6': case 'Thứ 2–6': case 'Thứ 2 - Thứ 6': case 'Thứ 2 – Thứ 6':
        return OnboardingCodes.scheduleWeekdays;
      case 'monday_to_saturday': case 'Mon-Sat': case 'Mon–Sat':
      case 'Thứ 2-7': case 'Thứ 2–7':
        return OnboardingCodes.scheduleMondayToSaturday;
      case 'full_week': return OnboardingCodes.scheduleFullWeek;
      case 'flexible': case 'Flexible': case 'Linh hoạt':
        return OnboardingCodes.scheduleFlexible;
      case 'night_shift': case 'Night Shift': case 'Ca đêm':
        return OnboardingCodes.scheduleNightShift;
      default: return value.trim();
    }
  }

  // ── Free time / Time preference ───────────────────────────────────

  static String localizedFreeTime(BuildContext context, String code) =>
      localizedFreeTimeWithL10n(context.l10nOrNull, code);

  static String localizedFreeTimeWithL10n(
    AppLocalizations? l10n,
    String code,
  ) {
    final norm = _normalizeTimePreference(code);
    switch (norm) {
      case OnboardingCodes.timeEarlyMorning:
        return l10n?.onboardingStep2FreeTimeEarlyMorning ?? norm;
      case OnboardingCodes.timeLunch:
        return l10n?.onboardingStep2FreeTimeNoon ?? norm;
      case OnboardingCodes.timeAfterWork:
        return l10n?.onboardingStep2FreeTimeAfterWork ?? norm;
      case OnboardingCodes.timeEvening:
        return l10n?.onboardingStep2FreeTimeEvening ?? norm;
      default:
        return norm;
    }
  }

  static String localizedTimePreferences(
    BuildContext context,
    List<String> codes,
  ) => localizedTimePreferencesWithL10n(context.l10nOrNull, codes);

  static String localizedTimePreferencesWithL10n(
    AppLocalizations? l10n,
    List<String> codes,
  ) {
    if (codes.isEmpty) return '—';
    return codes.map((c) {
      final n = _normalizeTimePreference(c);
      switch (n) {
        case OnboardingCodes.timeEarlyMorning:
          return l10n?.onboardingTimeEarlyMorning ?? n;
        case OnboardingCodes.timeLunch:
          return l10n?.onboardingTimeNoon ?? n;
        case OnboardingCodes.timeAfterWork:
          return l10n?.onboardingTimeAfterWork ?? n;
        case OnboardingCodes.timeEvening:
          return l10n?.onboardingTimeEveningGeneral ?? n;
        default:
          return n;
      }
    }).join(' · ');
  }

  static String _normalizeTimePreference(String value) {
    switch (value.trim()) {
      case 'early_morning': case 'Early Morning': case 'Early Morning (5-7 AM)':
      case 'Early Morning (5–7 AM)': case 'morning':
      case 'Sáng': case 'Sáng sớm': case 'Sáng sớm (5-7h)':
      case 'Sáng sớm (5–7h)':
        return OnboardingCodes.timeEarlyMorning;
      case 'lunch': case 'Lunch Break': case 'Nghỉ trưa':
        return OnboardingCodes.timeLunch;
      case 'after_work': case 'After Work': case 'Sau giờ làm':
        return OnboardingCodes.timeAfterWork;
      case 'evening': case 'Evening': case 'Evening (8-11 PM)':
      case 'Evening (8–11 PM)': case 'before_sleep': case 'Before Sleep':
      case 'Tối': case 'Tối (20-23h)': case 'Tối (20–23h)':
      case 'Tối (20-22h)': case 'Tối (20–22h)': case 'Trước khi ngủ':
        return OnboardingCodes.timeEvening;
      default: return value.trim();
    }
  }

  // ── Activity level ────────────────────────────────────────────────

  static String localizedActivityLevel(BuildContext context, String code) =>
      localizedActivityLevelWithL10n(context.l10nOrNull, code);

  static String localizedActivityLevelWithL10n(
    AppLocalizations? l10n,
    String code,
  ) {
    final norm = _normalizeActivityLevel(code);
    switch (norm) {
      case OnboardingCodes.activitySedentary:
        return l10n?.onboardingStep3ActivityLevelLittle ?? norm;
      case OnboardingCodes.activityLight:
        return l10n?.onboardingStep3ActivityLevelOccasional ?? norm;
      case OnboardingCodes.activityActive:
        return l10n?.onboardingStep3ActivityLevelRegular ?? norm;
      default:
        return norm;
    }
  }

  static String _normalizeActivityLevel(String value) {
    switch (value.trim()) {
      case 'sedentary': case 'very_little':
      case 'Rất ít': case 'Ít vận động':
        return OnboardingCodes.activitySedentary;
      case 'light': case 'occasional':
      case 'Thỉnh thoảng':
        return OnboardingCodes.activityLight;
      case 'active': case 'regular':
      case 'Đều đặn':
        return OnboardingCodes.activityActive;
      default: return value.trim();
    }
  }

  // ── Last workout ──────────────────────────────────────────────────

  static String localizedLastWorkout(BuildContext context, String code) =>
      localizedLastWorkoutWithL10n(context.l10nOrNull, code);

  static String localizedLastWorkoutWithL10n(
    AppLocalizations? l10n,
    String code,
  ) {
    final norm = _normalizeLastWorkout(code);
    switch (norm) {
      case OnboardingCodes.workoutRecently:
        return l10n?.onboardingStep3LastWorkoutToday ?? norm;
      case OnboardingCodes.workoutThisWeek:
        return l10n?.onboardingStep3LastWorkoutWeek ?? norm;
      case OnboardingCodes.workoutThisMonth:
        return l10n?.onboardingStep3LastWorkoutMonth ?? norm;
      case OnboardingCodes.workoutLongAgo:
        return l10n?.onboardingStep3LastWorkoutLonger ?? norm;
      default:
        return norm;
    }
  }

  static String _normalizeLastWorkout(String value) {
    switch (value.trim()) {
      case 'recently': case 'today':
      case 'Hôm nay':
        return OnboardingCodes.workoutRecently;
      case 'this_week':
      case 'Tuần này':
        return OnboardingCodes.workoutThisWeek;
      case 'this_month':
      case '1 tháng trước':
        return OnboardingCodes.workoutThisMonth;
      case 'long_ago': case 'longer_ago':
      case 'Lâu hơn':
        return OnboardingCodes.workoutLongAgo;
      default: return value.trim();
    }
  }

  // ── Health limitation ─────────────────────────────────────────────

  static String localizedHealthLimitation(BuildContext context, String code) =>
      localizedHealthLimitationWithL10n(context.l10nOrNull, code);

  static String localizedHealthLimitationWithL10n(
    AppLocalizations? l10n,
    String code,
  ) {
    final norm = _normalizeHealthLimitation(code);
    switch (norm) {
      case OnboardingCodes.limitationBackPain:
        return l10n?.onboardingStep3LimitationBackPain ?? norm;
      case OnboardingCodes.limitationLowEnergy:
        return l10n?.onboardingStep3LimitationLowEnergy ?? norm;
      case OnboardingCodes.limitationNone:
        return l10n?.onboardingStep3LimitationNone ?? norm;
      default:
        return norm;
    }
  }

  static String localizedHealthLimitations(
    BuildContext context,
    List<String> codes,
  ) => localizedHealthLimitationsWithL10n(context.l10nOrNull, codes);

  static String localizedHealthLimitationsWithL10n(
    AppLocalizations? l10n,
    List<String> codes,
  ) {
    if (codes.isEmpty) return '—';
    return codes.map((c) => localizedHealthLimitationWithL10n(l10n, c)).join(' · ');
  }

  static String _normalizeHealthLimitation(String value) {
    switch (value.trim()) {
      case 'none':
      case 'Không có':
        return OnboardingCodes.limitationNone;
      case 'back_pain':
      case 'Đau lưng':
        return OnboardingCodes.limitationBackPain;
      case 'knee_pain': return OnboardingCodes.limitationKneePain;
      case 'low_energy':
      case 'Ít năng lượng':
        return OnboardingCodes.limitationLowEnergy;
      case 'limited_mobility': return OnboardingCodes.limitationLimitedMobility;
      case 'injury_recovery': return OnboardingCodes.limitationInjuryRecovery;
      case 'eye_strain': case 'Mỏi mắt':
      case 'busy': case 'Bận rộn':
      case 'other':
        return OnboardingCodes.limitationOther;
      default: return value.trim();
    }
  }

  // ── Gender ────────────────────────────────────────────────────────

  static String localizedGender(BuildContext context, String code) =>
      localizedGenderWithL10n(context.l10nOrNull, code);

  static String localizedGenderWithL10n(AppLocalizations? l10n, String code) {
    switch (code.trim().toLowerCase()) {
      case OnboardingCodes.genderMale:
        return l10n?.onboardingStep1GenderMale ?? code;
      case OnboardingCodes.genderFemale:
        return l10n?.onboardingStep1GenderFemale ?? code;
      case OnboardingCodes.genderOther:
        return l10n?.onboardingStep1GenderOther ?? code;
      default:
        return code.trim();
    }
  }
}

extension _OnboardingDisplayMapperContextExt on BuildContext {
  AppLocalizations? get l10nOrNull {
    try {
      return AppLocalizations.of(this);
    } catch (_) {
      return null;
    }
  }
}
