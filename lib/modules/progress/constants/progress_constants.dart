import 'package:flutter/material.dart';

class HabitInsight {
  final String name;
  final String insight;
  final double rate;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const HabitInsight({
    required this.name,
    required this.insight,
    required this.rate,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}
