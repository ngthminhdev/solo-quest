import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/weekly_summary_model.dart';
import '../constants/weekly_summary_constants.dart';

class WeeklySchedulePreview extends StatelessWidget {
  final WeeklySummaryModel? summary;

  const WeeklySchedulePreview({super.key, this.summary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s14),
        decoration: BoxDecoration(
          color: AppColor.surface,
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              WeeklySummaryConstants.scheduleTitle,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColor.fgSecondary,
                letterSpacing: 0.06,
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            _ScheduleGroup(
              label: WeeklySummaryConstants.scheduleWeekday,
              items: const [
                _ScheduleItem('09:30', 'Break Quest — nghỉ mắt 5 phút'),
                _ScheduleItem('11:00', 'Water Quest — uống nước'),
                _ScheduleItem('14:00', 'Movement Quest — vận động nhẹ 3 phút'),
                _ScheduleItem('20:00', 'Learning Quest — học 15 phút'),
                _ScheduleItem('22:30', 'Sleep Quest — chuẩn bị ngủ'),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            _ScheduleGroup(
              label: WeeklySummaryConstants.scheduleWeekend,
              items: const [
                _ScheduleItem('—', 'Quest nhẹ hơn, review tuần'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleGroup extends StatelessWidget {
  final String label;
  final List<_ScheduleItem> items;

  const _ScheduleGroup({required this.label, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColor.fgMuted,
            letterSpacing: 0.04,
          ),
        ),
        const SizedBox(height: AppSpacing.s6),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: Text(
                      item.time,
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColor.fg,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.fgSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _ScheduleItem {
  final String time;
  final String label;

  const _ScheduleItem(this.time, this.label);
}
