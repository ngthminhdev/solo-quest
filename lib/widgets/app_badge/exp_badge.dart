import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';

class ExpBadge extends StatelessWidget {
  final int exp;
  final bool showPrefix;

  const ExpBadge({
    super.key,
    required this.exp,
    this.showPrefix = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColor.expGoldDim,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        showPrefix ? '+$exp EXP' : '$exp EXP',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColor.expGold,
        ),
      ),
    );
  }
}
