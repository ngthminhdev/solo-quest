import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';

class AppProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: LinearProgressIndicator(
          value: clampedProgress,
          backgroundColor: AppColor.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(
            progressColor ?? AppColor.cyan,
          ),
        ),
      ),
    );
  }
}
