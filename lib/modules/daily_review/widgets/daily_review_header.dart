import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_text_style.dart';
import '../../../extensions/localization_extension.dart';

class DailyReviewHeader extends StatelessWidget {
  const DailyReviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(RemixIcons.moon_line, size: 24, color: AppColor.violet),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.dailyReviewHeaderTitle,
                      style: AppTextStyle.heading,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.dailyReviewHeaderSubtitle,
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.fgMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
