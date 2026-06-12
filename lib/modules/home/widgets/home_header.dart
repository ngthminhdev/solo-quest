import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_text_style.dart';
import '../../../models/progress_model.dart';

class HomeHeader extends StatelessWidget {
  final ProgressModel? progress;
  final String? userName;

  const HomeHeader({
    super.key,
    this.progress,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);
    final dateStr = '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/${now.year}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, ${userName ?? 'bạn'}',
                  style: AppTextStyle.display.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sẵn sàng hoàn thành vài quest nhỏ hôm nay?',
                  style: AppTextStyle.caption,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dateStr,
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 11,
                  color: AppColor.fgMuted,
                ),
              ),
              if (progress != null) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(RemixIcons.fire_fill, size: 14, color: AppColor.warn),
                    const SizedBox(width: 4),
                    Text(
                      '${progress!.streakDays} ngày',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColor.warn,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) return 'Chào buổi sáng';
    if (hour < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }
}
