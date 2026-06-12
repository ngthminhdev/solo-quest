import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/enums/quest_enums.dart';

enum AppThemeMode { dark, light, midnight, sunset, ocean, forest }

class AppTheme {
  final AppThemeMode mode;
  final Color bgDeep;
  final Color bg;
  final Color bgRaised;
  final Color surface;
  final Color surfaceHover;
  final Color surfaceActive;
  final Color fg;
  final Color fgSecondary;
  final Color fgMuted;
  final Color border;
  final Color borderSubtle;

  const AppTheme({
    required this.mode,
    required this.bgDeep,
    required this.bg,
    required this.bgRaised,
    required this.surface,
    required this.surfaceHover,
    required this.surfaceActive,
    required this.fg,
    required this.fgSecondary,
    required this.fgMuted,
    required this.border,
    required this.borderSubtle,
  });

  static const dark = AppTheme(
    mode: AppThemeMode.dark,
    bgDeep: Color(0xFF060A14),
    bg: Color(0xFF0A0E1A),
    bgRaised: Color(0xFF0F1629),
    surface: Color(0xFF141B2D),
    surfaceHover: Color(0xFF1A2340),
    surfaceActive: Color(0xFF1F2A4A),
    fg: Color(0xFFE8ECF4),
    fgSecondary: Color(0xFF8B95A8),
    fgMuted: Color(0xFF4A5568),
    border: Color(0x0FFFFFFF),
    borderSubtle: Color(0x08FFFFFF),
  );

  static const light = AppTheme(
    mode: AppThemeMode.light,
    bgDeep: Color(0xFFFFFFFF),
    bg: Color(0xFFF8F9FA),
    bgRaised: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceHover: Color(0xFFF1F3F5),
    surfaceActive: Color(0xFFE9ECEF),
    fg: Color(0xFF1A1D29),
    fgSecondary: Color(0xFF495057),
    fgMuted: Color(0xFF868E96),
    border: Color(0x1F000000),
    borderSubtle: Color(0x0A000000),
  );

  static const midnight = AppTheme(
    mode: AppThemeMode.midnight,
    bgDeep: Color(0xFF05070D),
    bg: Color(0xFF0A0D15),
    bgRaised: Color(0xFF111521),
    surface: Color(0xFF181D2B),
    surfaceHover: Color(0xFF202637),
    surfaceActive: Color(0xFF283044),
    fg: Color(0xFFE0E0E8),
    fgSecondary: Color(0xFF9090A0),
    fgMuted: Color(0xFF505060),
    border: Color(0x12FFFFFF),
    borderSubtle: Color(0x08FFFFFF),
  );

  static const sunset = AppTheme(
    mode: AppThemeMode.sunset,
    bgDeep: Color(0xFF1A0F0A),
    bg: Color(0xFF2A1810),
    bgRaised: Color(0xFF3A2218),
    surface: Color(0xFF4A2D20),
    surfaceHover: Color(0xFF5A3828),
    surfaceActive: Color(0xFF6A4330),
    fg: Color(0xFFFFE8D6),
    fgSecondary: Color(0xFFD4A88A),
    fgMuted: Color(0xFF8A6850),
    border: Color(0x1AFFB380),
    borderSubtle: Color(0x0AFFB380),
  );

  static const ocean = AppTheme(
    mode: AppThemeMode.ocean,
    bgDeep: Color(0xFF0A1420),
    bg: Color(0xFF0F1D2E),
    bgRaised: Color(0xFF15283C),
    surface: Color(0xFF1B334A),
    surfaceHover: Color(0xFF213E58),
    surfaceActive: Color(0xFF274966),
    fg: Color(0xFFE0F0FF),
    fgSecondary: Color(0xFF8AB4D4),
    fgMuted: Color(0xFF4A6A84),
    border: Color(0x1A4A9FD4),
    borderSubtle: Color(0x0A4A9FD4),
  );

  static const forest = AppTheme(
    mode: AppThemeMode.forest,
    bgDeep: Color(0xFF0A1410),
    bg: Color(0xFF0F1E18),
    bgRaised: Color(0xFF152822),
    surface: Color(0xFF1B332C),
    surfaceHover: Color(0xFF213E36),
    surfaceActive: Color(0xFF274940),
    fg: Color(0xFFE0FFE8),
    fgSecondary: Color(0xFF8AD4A0),
    fgMuted: Color(0xFF4A8460),
    border: Color(0x1A4AD484),
    borderSubtle: Color(0x0A4AD484),
  );
}

class ThemeNotifier extends StateNotifier<AppTheme> {
  static const _prefsKey = 'app_theme_mode';
  static bool _initialized = false;

  ThemeNotifier() : super(AppTheme.dark) {
    _loadTheme();
  }

  AppTheme _themeForMode(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.dark => AppTheme.dark,
      AppThemeMode.light => AppTheme.light,
      AppThemeMode.midnight => AppTheme.midnight,
      AppThemeMode.sunset => AppTheme.sunset,
      AppThemeMode.ocean => AppTheme.ocean,
      AppThemeMode.forest => AppTheme.forest,
    };
  }

  Future<void> _loadTheme() async {
    if (_initialized) return;
    _initialized = true;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_prefsKey);
      if (savedMode != null) {
        final mode = AppThemeMode.values.firstWhere(
          (m) => m.name == savedMode,
          orElse: () => AppThemeMode.dark,
        );
        state = _themeForMode(mode);
        AppColor.setTheme(state);
      }
    } catch (_) {
      // Fallback to default dark theme
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = _themeForMode(mode);
    AppColor.setTheme(state);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, mode.name);
    } catch (_) {
      // Silently fail - theme still works without persistence
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) {
    String channelToHex(double channel) {
      return ((channel * 255).round() & 0xff).toRadixString(16).padLeft(2, '0');
    }

    return '${leadingHashSign ? '#' : ''}'
        '${channelToHex(a)}'
        '${channelToHex(r)}'
        '${channelToHex(g)}'
        '${channelToHex(b)}';
  }
}

class AppColor {
  static AppTheme? _currentTheme;

  static void setTheme(AppTheme theme) {
    _currentTheme = theme;
  }

  // ── Background layers (deep → raised) ──
  static Color get bgDeep => _currentTheme?.bgDeep ?? AppTheme.dark.bgDeep;
  static Color get bg => _currentTheme?.bg ?? AppTheme.dark.bg;
  static Color get bgRaised => _currentTheme?.bgRaised ?? AppTheme.dark.bgRaised;
  static Color get surface => _currentTheme?.surface ?? AppTheme.dark.surface;
  static Color get surfaceHover => _currentTheme?.surfaceHover ?? AppTheme.dark.surfaceHover;
  static Color get surfaceActive => _currentTheme?.surfaceActive ?? AppTheme.dark.surfaceActive;

  // ── Base neutrals ──
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // ── Text ──
  static Color get fg => _currentTheme?.fg ?? AppTheme.dark.fg;
  static Color get fgSecondary => _currentTheme?.fgSecondary ?? AppTheme.dark.fgSecondary;
  static Color get fgMuted => _currentTheme?.fgMuted ?? AppTheme.dark.fgMuted;

  // ── Semantic base aliases ──
  static Color get background => bgDeep;
  static Color get surfaceElevated => bgRaised;
  static Color get card => surface;
  static Color get cardMuted => surfaceHover;
  static Color get divider => borderSubtle;
  static Color get textPrimary => fg;
  static Color get textSecondary => fgSecondary;
  static Color get textMuted => fgMuted;
  static Color get textDisabled => fgMuted;
  static Color get textOnAccent => bgDeep;

  // ── Primary accents ──
  static const Color cyan = Color(0xFF67DDEB);
  static const Color cyanDim = Color(0x2667DDEB);
  static const Color cyanGlow = Color(0x3D67DDEB);
  static const Color cyanBright = Color(0xFF84ECF5);

  static const Color violet = Color(0xFFA855F7);
  static const Color violetDim = Color(0x26A855F7);
  static const Color violetGlow = Color(0x4DA855F7);

  static const Color primary = cyan;
  static const Color primarySoft = cyanDim;
  static const Color primaryMuted = borderGlowCyan;
  static const Color secondary = violet;
  static const Color secondarySoft = violetDim;
  static const Color accent = expGold;
  static const Color accentSoft = expGoldDim;

  // ── Status ──
  static const Color success = Color(0xFF22C55E);
  static const Color successDim = Color(0x2622C55E);
  static const Color successBackground = successDim;

  static const Color warn = Color(0xFFF59E0B);
  static const Color warnDim = Color(0x26F59E0B);
  static const Color warnGlow = Color(0x33F59E0B);
  static const Color warning = warn;
  static const Color warningBackground = warnDim;

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerDim = Color(0x26EF4444);
  static const Color red = danger;
  static const Color error = danger;
  static const Color errorBackground = dangerDim;

  static const Color info = Color(0xFF3B82F6);
  static const Color infoDim = Color(0x263B82F6);
  static const Color infoBackground = infoDim;

  // ── EXP / Gamification ──
  static const Color expGold = Color(0xFFF3C969);
  static const Color expGoldDim = Color(0x26F3C969);

  // ── Borders ──
  static Color get border => _currentTheme?.border ?? AppTheme.dark.border;
  static Color get borderSubtle => _currentTheme?.borderSubtle ?? AppTheme.dark.borderSubtle;
  static const Color borderGlowCyan = Color(0x3367DDEB);
  static const Color borderGlowViolet = Color(0x33A855F7);

  // ── Chip colors (Quest Types) ──
  static const Color chipWaterBg = Color(0x263B82F6);
  static const Color chipWaterText = Color(0xFF60A5FA);
  static const Color chipBreakBg = Color(0x26A855F7);
  static const Color chipBreakText = Color(0xFFC084FC);
  static const Color chipMovementBg = Color(0x2622C55E);
  static const Color chipMovementText = Color(0xFF4ADE80);
  static const Color chipLearningBg = Color(0x26F59E0B);
  static const Color chipLearningText = Color(0xFFFBBF24);
  static const Color chipSleepBg = Color(0x266366F1);
  static const Color chipSleepText = Color(0xFF818CF8);
  static const Color chipFitnessBg = Color(0x26EF4444);
  static const Color chipFitnessText = Color(0xFFF87171);

  // ── Quest / feature colors ──
  static const Color learning = chipLearningText;
  static const Color water = chipWaterText;
  static const Color breakTime = chipBreakText;
  static const Color movement = chipMovementText;
  static const Color sleep = chipSleepText;
  static const Color reflection = violet;
  static const Color review = cyanBright;
  static const Color fitness = chipFitnessText;

  // ── Status semantic colors ──
  static const Color completed = success;
  static const Color active = cyan;
  static Color get locked => fgMuted;
  static const Color paused = warn;
  static const Color snoozed = warn;

  // ── Misc UI ──
  static const Color darkSlate = Color(0xFF1F2937);

  // ── Shadows ──
  static final Color shadowHeavy = black.withValues(alpha: 0.6);
  static final Color shadowMedium = black.withValues(alpha: 0.4);
  static final Color shadow = shadowMedium;
  static final Color overlay = black.withValues(alpha: 0.5);
  static final Color glassOverlay = white.withValues(alpha: 0.05);
  static const Color highlight = cyanDim;

  // ── Common alpha tokens ──
  static Color get primaryBorder => cyan.withValues(alpha: 0.3);
  static Color get primaryStrongBorder => cyan.withValues(alpha: 0.7);
  static Color get primarySubtleOverlay => cyan.withValues(alpha: 0.08);
  static Color get primaryHoverOverlay => cyan.withValues(alpha: 0.2);
  static Color get primaryShadow => cyan.withValues(alpha: 0.3);
  static Color get primarySoftShadow => cyan.withValues(alpha: 0.2);
  static Color get secondarySubtleOverlay => violet.withValues(alpha: 0.12);
  static Color get secondaryBorder => violet.withValues(alpha: 0.3);
  static Color get secondarySoftBorder => violet.withValues(alpha: 0.35);
  static Color get secondaryStrongBorder => violet.withValues(alpha: 0.4);
  static Color get secondaryShadow => violet.withValues(alpha: 0.15);
  static Color get successDisabledBackground => successDim.withValues(alpha: 0.3);
  static Color get successBorder => success.withValues(alpha: 0.3);
  static Color get successStrongBorder => success.withValues(alpha: 0.4);
  static Color get successStrongOverlay => success.withValues(alpha: 0.7);
  static Color get successOverlay => success.withValues(alpha: 0.08);
  static Color get warningDisabledBackground => warnDim.withValues(alpha: 0.3);
  static Color get warningBorder => warn.withValues(alpha: 0.3);
  static Color get warningSoftBorder => warn.withValues(alpha: 0.2);
  static Color get warningOverlay => warn.withValues(alpha: 0.15);
  static Color get warningStrongOverlay => warn.withValues(alpha: 0.22);
  static Color get errorDisabledBackground => danger.withValues(alpha: 0.3);
  static Color get errorStrongBorder => danger.withValues(alpha: 0.3);
  static Color get errorBorder => danger.withValues(alpha: 0.24);
  static Color get accentBorder => expGold.withValues(alpha: 0.4);
  static Color get mutedOverlay => fgMuted.withValues(alpha: 0.3);
  static Color get mutedStrongOverlay => fgMuted.withValues(alpha: 0.6);

  // ── Category palette ──
  static const List<Color> categoryPalette = [
    Color(0xFFFF6B6B),
    Color(0xFFFF9F43),
    Color(0xFFFFD166),
    Color(0xFF2ECC71),
    Color(0xFF06D6A0),
    Color(0xFF00C8F8),
    Color(0xFF7C9DFF),
    Color(0xFFB57DEE),
    Color(0xFFF15BB5),
    Color(0xFF2EC4B6),
  ];

  // ── Gradient presets ──
  static LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.lerp(bg, cyan, 0.035)!,
      bg,
      Color.lerp(bgDeep, violet, 0.025)!,
    ],
    stops: const [0.0, 0.42, 1.0],
  );

  static Color get scaffoldBackground => bgDeep;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [cyan, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryToPrimaryGradient = LinearGradient(
    colors: [violet, cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warn, expGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [danger, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get dailyReviewCtaGradient => LinearGradient(
    colors: [
      violet.withValues(alpha: 0.08),
      cyan.withValues(alpha: 0.05),
    ],
  );

  static const LinearGradient levelGradient = LinearGradient(
    colors: [cyan, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get insightCardGradient => LinearGradient(
    colors: [
      cyan.withValues(alpha: 0.05),
      violet.withValues(alpha: 0.04),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get successCardGradient => LinearGradient(
    colors: [
      success.withValues(alpha: 0.06),
      cyan.withValues(alpha: 0.04),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get heroCardGradient => LinearGradient(
    colors: [
      cyan.withValues(alpha: 0.06),
      violet.withValues(alpha: 0.04),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get roadmapOverviewGradient => LinearGradient(
    colors: [
      violet.withValues(alpha: 0.08),
      cyan.withValues(alpha: 0.06),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get activeQuestGradient => LinearGradient(
    colors: [
      success.withValues(alpha: 0.08),
      surface,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get questCyanGradient => LinearGradient(
    colors: [
      cyan.withValues(alpha: 0.05),
      surface,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get activeQuestReadableGradient => LinearGradient(
    colors: [
      cyan.withValues(alpha: 0.16),
      bgRaised,
      surface,
    ],
    stops: const [0.0, 0.55, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get todayLearningPlanGradient => LinearGradient(
    colors: [
      violet.withValues(alpha: 0.10),
      cyan.withValues(alpha: 0.08),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient weeklyChartGradient = LinearGradient(
    colors: [cyan, cyanBright],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get weeklyScoreGradient => _weeklyScoreGradient();

  static LinearGradient _weeklyScoreGradient() {
    return LinearGradient(
      colors: [
        cyan.withValues(alpha: 0.10),
        cyan.withValues(alpha: 0.0),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  static Color withAlphaPercent(Color color, double alpha) {
    return color.withValues(alpha: alpha.clamp(0.0, 1.0));
  }

  static Color categoryColorFor(String key) {
    if (key.isEmpty) return categoryPalette.first;

    var hash = 0;
    for (final codeUnit in key.codeUnits) {
      hash = 0x1fffffff & (hash + codeUnit);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash ^= hash >> 11;
    hash = 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
    return categoryPalette[hash.abs() % categoryPalette.length];
  }

  static Color questColorFor(QuestType type) {
    switch (type) {
      case QuestType.water:
        return water;
      case QuestType.breakTime:
        return breakTime;
      case QuestType.movement:
        return movement;
      case QuestType.learning:
        return learning;
      case QuestType.sleep:
        return sleep;
      case QuestType.fitness:
        return fitness;
      case QuestType.mindfulness:
        return reflection;
      case QuestType.review:
        return review;
      case QuestType.custom:
        return primary;
    }
  }

  static Color questBackgroundFor(QuestType type) {
    return questColorFor(type).withValues(alpha: 0.15);
  }

  static Color statusColorFor(QuestStatus status) {
    switch (status) {
      case QuestStatus.completed:
        return completed;
      case QuestStatus.active:
        return active;
      case QuestStatus.snoozed:
        return snoozed;
      case QuestStatus.skipped:
        return paused;
      case QuestStatus.pending:
        return textMuted;
      case QuestStatus.expired:
        return error;
    }
  }
}
