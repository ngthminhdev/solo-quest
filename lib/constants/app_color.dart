import 'package:flutter/material.dart';

class AppColor {
  // Background layers (deep → raised)
  static const Color bgDeep = Color(0xFF060A14);
  static const Color bg = Color(0xFF0A0E1A);
  static const Color bgRaised = Color(0xFF0F1629);
  static const Color surface = Color(0xFF141B2D);
  static const Color surfaceHover = Color(0xFF1A2340);
  static const Color surfaceActive = Color(0xFF1F2A4A);

  // Text
  static const Color fg = Color(0xFFE8ECF4);
  static const Color fgSecondary = Color(0xFF8B95A8);
  static const Color fgMuted = Color(0xFF4A5568);

  // Accent
  static const Color cyan = Color(0xFF00F0FF);
  static const Color cyanDim = Color(0x2600F0FF);
  static const Color cyanGlow = Color(0x4D00F0FF);
  static const Color violet = Color(0xFFA855F7);
  static const Color violetDim = Color(0x26A855F7);
  static const Color violetGlow = Color(0x4DA855F7);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color successDim = Color(0x2622C55E);
  static const Color warn = Color(0xFFF59E0B);
  static const Color warnDim = Color(0x26F59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerDim = Color(0x26EF4444);
  static const Color red = danger; // Alias for danger
  static const Color info = Color(0xFF3B82F6);
  static const Color infoDim = Color(0x263B82F6);

  // EXP / Gamification
  static const Color expGold = Color(0xFFFFD700);
  static const Color expGoldDim = Color(0x26FFD700);
  static const LinearGradient levelGradient = LinearGradient(
    colors: [cyan, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Borders
  static const Color border = Color(0x0FFFFFFF);
  static const Color borderSubtle = Color(0x08FFFFFF);
  static const Color borderGlowCyan = Color(0x3300F0FF);
  static const Color borderGlowViolet = Color(0x33A855F7);

  // Chip colors (Quest Types)
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
}
