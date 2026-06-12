import 'package:flutter/material.dart';

import 'app_color.dart';

class AppShadow {
  static List<BoxShadow> get glowCyan => [
    BoxShadow(color: AppColor.cyanGlow, blurRadius: 20, spreadRadius: 0),
    BoxShadow(color: AppColor.cyanGlow.withValues(alpha:0.15), blurRadius: 40, spreadRadius: 0),
  ];

  static List<BoxShadow> get glowViolet => [
    BoxShadow(color: AppColor.violetGlow, blurRadius: 20, spreadRadius: 0),
    BoxShadow(color: AppColor.violetGlow.withValues(alpha:0.15), blurRadius: 40, spreadRadius: 0),
  ];

  static List<BoxShadow> get card => [
    BoxShadow(color: AppColor.shadowMedium, blurRadius: 24, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get elevated => [
    BoxShadow(color: AppColor.shadowHeavy, blurRadius: 32, offset: const Offset(0, 8)),
  ];
}
