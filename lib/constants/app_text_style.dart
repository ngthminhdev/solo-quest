import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTextStyle {
  static const String _font = 'Exo2';

  // Display / Hero text
  static const TextStyle display = TextStyle(
    fontFamily: _font,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColor.fg,
  );

  // Headings
  static const TextStyle h1 = TextStyle(
    fontFamily: _font,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
    color: AppColor.fg,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColor.fg,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColor.fg,
  );

  static const TextStyle heading = h3; // Alias for backward compatibility

  // Body text
  static const TextStyle body = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColor.fg,
  );

  static const TextStyle bodyBold = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColor.fg,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColor.fgSecondary,
  );

  // Caption / Helper text
  static const TextStyle caption = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColor.fgSecondary,
  );

  static const TextStyle captionBold = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColor.fgSecondary,
  );

  // Labels / Tags
  static const TextStyle label = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.3,
    color: AppColor.fgMuted,
  );

  static const TextStyle labelUppercase = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
    height: 1.3,
    color: AppColor.fgMuted,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    height: 1.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.2,
  );

  // Mono / Code style
  static const TextStyle mono = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColor.fg,
  );

  static const TextStyle monoLarge = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    height: 1.2,
    color: AppColor.fg,
  );

  static const TextStyle monoLabel = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    height: 1.3,
    color: AppColor.fgMuted,
  );

  // Section headers
  static const TextStyle sectionLabel = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    height: 1.3,
    color: AppColor.fgMuted,
  );
}
