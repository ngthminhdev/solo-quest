import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';

class AppProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final String? label;
  final String? valueText;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.height = 6,
    this.label,
    this.valueText,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || valueText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11,
                      color: AppColor.fgMuted,
                    ),
                  ),
                if (valueText != null)
                  Text(
                    valueText!,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      color: AppColor.fgSecondary,
                    ),
                  ),
              ],
            ),
          ),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColor.bgRaised,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: clampedProgress,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColor.levelGradient,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
