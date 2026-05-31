import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../widgets/app_card/app_glow_card.dart';

class ReminderSummaryCard extends StatelessWidget {
  final int totalSettings;
  final int enabledCount;
  final int disabledCount;

  const ReminderSummaryCard({
    super.key,
    required this.totalSettings,
    required this.enabledCount,
    required this.disabledCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlowCard(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      glowColor: AppColor.cyan,
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              icon: RemixIcons.notification_3_line,
              label: 'Tổng nhắc nhở',
              value: totalSettings.toString(),
              color: AppColor.cyan,
            ),
          ),
          Expanded(
            child: _SummaryMetric(
              icon: RemixIcons.checkbox_circle_line,
              label: 'Đang bật',
              value: enabledCount.toString(),
              color: AppColor.success,
            ),
          ),
          Expanded(
            child: _SummaryMetric(
              icon: RemixIcons.close_circle_line,
              label: 'Đang tắt',
              value: disabledCount.toString(),
              color: AppColor.fgMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: AppSpacing.s6),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Exo2',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColor.fg,
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: AppColor.fgMuted),
        ),
      ],
    );
  }
}
