import 'package:flutter/material.dart';

import 'app_color.dart';

class AppShadow {
  static List<BoxShadow> get glowCyan => [
    const BoxShadow(color: AppColor.cyanGlow, blurRadius: 20, spreadRadius: 0),
    BoxShadow(color: AppColor.cyanGlow.withOpacity(0.15), blurRadius: 40, spreadRadius: 0),
  ];

  static List<BoxShadow> get glowViolet => [
    const BoxShadow(color: AppColor.violetGlow, blurRadius: 20, spreadRadius: 0),
    BoxShadow(color: AppColor.violetGlow.withOpacity(0.15), blurRadius: 40, spreadRadius: 0),
  ];

  static List<BoxShadow> get card => [
    BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> get elevated => [
    BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 32, offset: const Offset(0, 8)),
  ];
}
