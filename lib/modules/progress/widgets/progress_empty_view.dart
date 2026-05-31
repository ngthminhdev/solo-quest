import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../routes/routes_config.dart';
import '../../../widgets/app_state/app_empty_state.dart';

class ProgressEmptyView extends StatelessWidget {
  const ProgressEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: RemixIcons.bar_chart_2_line,
      title: 'Chưa có tiến trình',
      message:
          'Hoàn thành quest đầu tiên để bắt đầu ghi nhận EXP, level và streak.',
      action: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(RoutesConfig.home);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          decoration: BoxDecoration(
            color: AppColor.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.border),
          ),
          child: const Text(
            'Về Home',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.cyan,
            ),
          ),
        ),
      ),
    );
  }
}
