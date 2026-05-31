import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../routes/routes_config.dart';

class HomeEmptyQuestView extends StatelessWidget {
  const HomeEmptyQuestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              RemixIcons.task_line,
              size: 64,
              color: AppColor.fgMuted,
            ),
            const SizedBox(height: AppSpacing.s16),
            const Text(
              'Chưa có quest hôm nay',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.fgSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s8),
            const Text(
              'Hãy check-in buổi sáng để hệ thống tạo nhiệm vụ phù hợp.',
              style: TextStyle(
                fontSize: 14,
                color: AppColor.fgMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s24),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(RoutesConfig.morningCheckin);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColor.cyan,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Text(
                  'Check-in ngay',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColor.bgDeep,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
