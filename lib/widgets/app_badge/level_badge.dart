import 'package:flutter/material.dart';

import '../../constants/app_color.dart';

class LevelBadge extends StatelessWidget {
  final int level;
  final double size;

  const LevelBadge({
    super.key,
    required this.level,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColor.levelGradient,
      ),
      child: Center(
        child: Text(
          '$level',
          style: TextStyle(
            fontFamily: 'Exo2',
            fontSize: size * 0.44,
            fontWeight: FontWeight.w800,
            color: AppColor.bgDeep,
          ),
        ),
      ),
    );
  }
}
