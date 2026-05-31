import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/enums/log_enums.dart';
import '../constants/logs_constants.dart';

class LogsFilterBar extends StatelessWidget {
  final DateTime selectedDate;
  final LogEntryType? selectedType;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<LogEntryType?> onTypeChanged;
  final VoidCallback onClearFilter;

  const LogsFilterBar({
    super.key,
    required this.selectedDate,
    this.selectedType,
    required this.onDateChanged,
    required this.onTypeChanged,
    required this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date selector row
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s8,
          ),
          child: Row(
            children: [
              _buildDateButton(
                label: LogsConstants.yesterdayLabel,
                date: now.subtract(const Duration(days: 1)),
              ),
              const SizedBox(width: AppSpacing.s8),
              _buildDateButton(
                label: LogsConstants.todayLabel,
                date: now,
              ),
              const SizedBox(width: AppSpacing.s8),
              GestureDetector(
                onTap: () => _showSyncFusionDatePicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s12,
                    vertical: AppSpacing.s8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.border),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        RemixIcons.calendar_line,
                        size: 16,
                        color: AppColor.fgSecondary,
                      ),
                      SizedBox(width: AppSpacing.s4),
                      Text(
                        'Chọn ngày',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColor.fgSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (selectedType != null)
                GestureDetector(
                  onTap: onClearFilter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s8,
                      vertical: AppSpacing.s4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.cyanDim,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Xóa lọc',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColor.cyan,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Type filter chips
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            children: [
              _buildTypeChip(label: LogsConstants.filterAll, type: null),
              _buildTypeChip(
                label: LogsConstants.filterCompleted,
                type: LogEntryType.questCompleted,
              ),
              _buildTypeChip(
                label: LogsConstants.filterSkipped,
                type: LogEntryType.questSkipped,
              ),
              _buildTypeChip(
                label: LogsConstants.filterSnoozed,
                type: LogEntryType.questSnoozed,
              ),
              _buildTypeChip(
                label: LogsConstants.filterCheckin,
                type: LogEntryType.morningCheckin,
              ),
              _buildTypeChip(
                label: LogsConstants.filterReview,
                type: LogEntryType.dailyReview,
              ),
              _buildTypeChip(
                label: LogsConstants.filterReward,
                type: LogEntryType.rewardClaimed,
              ),
              _buildTypeChip(
                label: LogsConstants.filterLevelUp,
                type: LogEntryType.levelUp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSyncFusionDatePicker(BuildContext context) {
    DateTime? tempSelected = selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.55,
          decoration: const BoxDecoration(
            color: AppColor.bgRaised,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chọn ngày',
                      style: TextStyle(
                        fontFamily: 'Exo2',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.fg,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        RemixIcons.close_line,
                        size: 22,
                        color: AppColor.fgMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SfDateRangePicker(
                  initialSelectedDate: selectedDate,
                  minDate: DateTime(2024),
                  maxDate: DateTime.now(),
                  selectionMode: DateRangePickerSelectionMode.single,
                  backgroundColor: AppColor.bgRaised,
                  headerStyle: const DateRangePickerHeaderStyle(
                    backgroundColor: AppColor.bgRaised,
                    textStyle: TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColor.fg,
                    ),
                  ),
                  monthViewSettings: const DateRangePickerMonthViewSettings(
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(
                        fontFamily: 'Exo2',
                        fontSize: 12,
                        color: AppColor.fgMuted,
                      ),
                    ),
                  ),
                  monthCellStyle: const DateRangePickerMonthCellStyle(
                    textStyle: TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: 13,
                      color: AppColor.fg,
                    ),
                    todayTextStyle: TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColor.cyan,
                    ),
                    todayCellDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: AppColor.cyan, width: 1),
                      ),
                    ),
                  ),
                  selectionTextStyle: const TextStyle(
                    fontFamily: 'Exo2',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColor.bgDeep,
                  ),
                  selectionColor: AppColor.cyan,
                  onSelectionChanged: (args) {
                    tempSelected = args.value as DateTime?;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: GestureDetector(
                    onTap: () {
                      if (tempSelected != null) {
                        onDateChanged(tempSelected!);
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.cyan,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Xác nhận',
                        style: TextStyle(
                          fontFamily: 'Exo2',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColor.bgDeep,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateButton({
    required String label,
    required DateTime date,
  }) {
    final isSelected = _isSameDate(selectedDate, date);

    return GestureDetector(
      onTap: () => onDateChanged(date),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.cyanDim : AppColor.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColor.borderGlowCyan : AppColor.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColor.cyan : AppColor.fgSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip({
    required String label,
    required LogEntryType? type,
  }) {
    final isSelected = selectedType == type;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.s8),
      child: GestureDetector(
        onTap: () => onTypeChanged(type),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.cyanDim : AppColor.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColor.borderGlowCyan : AppColor.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColor.cyan : AppColor.fgSecondary,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
