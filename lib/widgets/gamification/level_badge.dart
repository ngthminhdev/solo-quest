import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';

class LevelBadge extends StatelessWidget {
  final int level;
  final double? fontSize;

  const LevelBadge({
    super.key,
    required this.level,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        gradient: AppColor.levelGradient,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            RemixIcons.star_fill,
            size: 12,
            color: AppColor.bgDeep,
          ),
          const SizedBox(width: AppSpacing.s4),
          Text(
            'Lv $level',
            style: TextStyle(
              fontSize: fontSize ?? 12,
              fontWeight: FontWeight.w700,
              color: AppColor.bgDeep,
            ),
          ),
        ],
      ),
    );
  }
}
