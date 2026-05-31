import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_text_style.dart';

class RewardsHeader extends StatelessWidget {
  const RewardsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(RemixIcons.gift_line, size: 24, color: AppColor.cyan),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phần thưởng',
                      style: AppTextStyle.heading,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dùng điểm thưởng để tự thưởng cho những nỗ lực nhỏ mỗi ngày.',
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
