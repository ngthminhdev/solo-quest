import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_text_style.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  final Color? dotColor;
  final String? count;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
    this.dotColor,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          if (dotColor != null)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
                boxShadow: dotColor == AppColor.cyan
                    ? [BoxShadow(color: AppColor.cyanGlow, blurRadius: 8)]
                    : null,
              ),
            ),
          Text(
            title,
            style: AppTextStyle.sectionLabel.copyWith(
              color: AppColor.fgSecondary,
            ),
          ),
          if (count != null) ...[
            const Spacer(),
            Text(
              count!,
              style: const TextStyle(
                fontFamily: 'Exo2',
                fontSize: 10,
                color: AppColor.fgMuted,
              ),
            ),
          ],
          if (actionText != null) ...[
            const Spacer(),
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionText!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.cyan,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
