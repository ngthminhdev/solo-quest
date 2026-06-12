import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTextStyle {
  static const String _font = 'Exo2';

  // Display / Hero text
  static final TextStyle display = TextStyle(
    fontFamily: _font,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColor.fg,
  );

  // Headings
  static final TextStyle h1 = TextStyle(
    fontFamily: _font,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
    color: AppColor.fg,
  );

  static final TextStyle h2 = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColor.fg,
  );

  static final TextStyle h3 = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColor.fg,
  );

  static TextStyle get heading => h3; // Alias for backward compatibility

  // Body text
  static final TextStyle body = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColor.fg,
  );

  static final TextStyle bodyBold = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColor.fg,
  );

  static final TextStyle bodySmall = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColor.fgSecondary,
  );

  // Caption / Helper text
  static final TextStyle caption = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColor.fgSecondary,
  );

  static final TextStyle captionBold = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColor.fgSecondary,
  );

  // Labels / Tags
  static final TextStyle label = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.3,
    color: AppColor.fgMuted,
  );

  static final TextStyle labelUppercase = TextStyle(
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
  static final TextStyle mono = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColor.fg,
  );

  static final TextStyle monoLarge = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    height: 1.2,
    color: AppColor.fg,
  );

  static final TextStyle monoLabel = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    height: 1.3,
    color: AppColor.fgMuted,
  );

  // Section headers
  static final TextStyle sectionLabel = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    height: 1.3,
    color: AppColor.fgMuted,
  );
}
