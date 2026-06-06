import 'package:flutter/material.dart';

import '../models/enums/quest_enums.dart';

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
  // ── Background layers (deep → raised) ──
  static const Color bgDeep = Color(0xFF060A14);
  static const Color bg = Color(0xFF0A0E1A);
  static const Color bgRaised = Color(0xFF0F1629);
  static const Color surface = Color(0xFF141B2D);
  static const Color surfaceHover = Color(0xFF1A2340);
  static const Color surfaceActive = Color(0xFF1F2A4A);

  // ── Base neutrals ──
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // ── Text ──
  static const Color fg = Color(0xFFE8ECF4);
  static const Color fgSecondary = Color(0xFF8B95A8);
  static const Color fgMuted = Color(0xFF4A5568);

  // ── Semantic base aliases ──
  static const Color background = bgDeep;
  static const Color surfaceElevated = bgRaised;
  static const Color card = surface;
  static const Color cardMuted = surfaceHover;
  static const Color divider = borderSubtle;
  static const Color textPrimary = fg;
  static const Color textSecondary = fgSecondary;
  static const Color textMuted = fgMuted;
  static const Color textDisabled = fgMuted;
  static const Color textOnAccent = bgDeep;

  // ── Primary accents ──
  static const Color cyan = Color(0xFF00F0FF);
  static const Color cyanDim = Color(0x2600F0FF);
  static const Color cyanGlow = Color(0x4D00F0FF);
  static const Color cyanBright = Color(0xFF00C4FF);

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
  static const Color expGold = Color(0xFFFFD700);
  static const Color expGoldDim = Color(0x26FFD700);

  // ── Borders ──
  static const Color border = Color(0x0FFFFFFF);
  static const Color borderSubtle = Color(0x08FFFFFF);
  static const Color borderGlowCyan = Color(0x3300F0FF);
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
  static const Color locked = fgMuted;
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
  static final Color primaryBorder = cyan.withValues(alpha: 0.3);
  static final Color primaryStrongBorder = cyan.withValues(alpha: 0.7);
  static final Color primarySubtleOverlay = cyan.withValues(alpha: 0.08);
  static final Color primaryHoverOverlay = cyan.withValues(alpha: 0.2);
  static final Color primaryShadow = cyan.withValues(alpha: 0.3);
  static final Color primarySoftShadow = cyan.withValues(alpha: 0.2);
  static final Color secondarySubtleOverlay = violet.withValues(alpha: 0.12);
  static final Color secondaryBorder = violet.withValues(alpha: 0.3);
  static final Color secondarySoftBorder = violet.withValues(alpha: 0.35);
  static final Color secondaryStrongBorder = violet.withValues(alpha: 0.4);
  static final Color secondaryShadow = violet.withValues(alpha: 0.15);
  static final Color successDisabledBackground = successDim.withValues(alpha: 0.3);
  static final Color successBorder = success.withValues(alpha: 0.3);
  static final Color successStrongBorder = success.withValues(alpha: 0.4);
  static final Color successStrongOverlay = success.withValues(alpha: 0.7);
  static final Color successOverlay = success.withValues(alpha: 0.08);
  static final Color warningDisabledBackground = warnDim.withValues(alpha: 0.3);
  static final Color warningBorder = warn.withValues(alpha: 0.3);
  static final Color warningSoftBorder = warn.withValues(alpha: 0.2);
  static final Color warningOverlay = warn.withValues(alpha: 0.15);
  static final Color warningStrongOverlay = warn.withValues(alpha: 0.22);
  static final Color errorDisabledBackground = danger.withValues(alpha: 0.3);
  static final Color errorStrongBorder = danger.withValues(alpha: 0.3);
  static final Color errorBorder = danger.withValues(alpha: 0.24);
  static final Color accentBorder = expGold.withValues(alpha: 0.4);
  static final Color mutedOverlay = fgMuted.withValues(alpha: 0.3);
  static final Color mutedStrongOverlay = fgMuted.withValues(alpha: 0.6);

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
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bg, bgDeep],
    stops: [0.0, 0.7],
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

  static final LinearGradient dailyReviewCtaGradient = LinearGradient(
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

  static final LinearGradient insightCardGradient = LinearGradient(
    colors: [
      cyan.withValues(alpha: 0.05),
      violet.withValues(alpha: 0.04),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient successCardGradient = LinearGradient(
    colors: [
      success.withValues(alpha: 0.06),
      cyan.withValues(alpha: 0.04),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient heroCardGradient = LinearGradient(
    colors: [
      cyan.withValues(alpha: 0.06),
      violet.withValues(alpha: 0.04),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient roadmapOverviewGradient = LinearGradient(
    colors: [
      violet.withValues(alpha: 0.08),
      cyan.withValues(alpha: 0.06),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient activeQuestGradient = LinearGradient(
    colors: [
      success.withValues(alpha: 0.08),
      surface,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient questCyanGradient = LinearGradient(
    colors: [
      cyan.withValues(alpha: 0.05),
      surface,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient activeQuestReadableGradient = LinearGradient(
    colors: [
      cyan.withValues(alpha: 0.16),
      bgRaised,
      surface,
    ],
    stops: const [0.0, 0.55, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient todayLearningPlanGradient = LinearGradient(
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

  static final LinearGradient weeklyScoreGradient = _weeklyScoreGradient();

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
