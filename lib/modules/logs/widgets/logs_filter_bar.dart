import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/enums/log_enums.dart';
import '../../../extensions/localization_extension.dart';

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
                label: context.l10n.logsYesterday,
                date: now.subtract(const Duration(days: 1)),
              ),
              const SizedBox(width: AppSpacing.s8),
              _buildDateButton(
                label: context.l10n.logsToday,
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        RemixIcons.calendar_line,
                        size: 16,
                        color: AppColor.fgSecondary,
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      Text(
                        context.l10n.logsSelectDate,
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
                    child: Text(
                      context.l10n.logsClearFilter,
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
              _buildTypeChip(label: context.l10n.logsFilterAll, type: null),
              _buildTypeChip(
                label: context.l10n.logsFilterCompleted,
                type: LogEntryType.questCompleted,
              ),
              _buildTypeChip(
                label: context.l10n.logsFilterSkipped,
                type: LogEntryType.questSkipped,
              ),
              _buildTypeChip(
                label: context.l10n.logsFilterSnoozed,
                type: LogEntryType.questSnoozed,
              ),
              _buildTypeChip(
                label: context.l10n.logsFilterCheckin,
                type: LogEntryType.morningCheckin,
              ),
              _buildTypeChip(
                label: context.l10n.logsFilterReview,
                type: LogEntryType.dailyReview,
              ),
              _buildTypeChip(
                label: context.l10n.logsFilterReward,
                type: LogEntryType.rewardClaimed,
              ),
              _buildTypeChip(
                label: context.l10n.logsFilterLevelUp,
                type: LogEntryType.levelUp,
              ),
              _buildTypeChip(
                label: context.l10n.logsFilterRoadmap,
                type: LogEntryType.learningRoadmapCreated,
              ),
              _buildTypeChip(
                label: context.l10n.logsFilterRoadmapStep,
                type: LogEntryType.learningRoadmapStepCompleted,
              ),
              _buildTypeChip(
                label: context.l10n.logsFilterRoadmapCompleted,
                type: LogEntryType.learningRoadmapCompleted,
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
      backgroundColor: AppColor.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.55,
          decoration: BoxDecoration(
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
                    Text(
                      context.l10n.logsSelectDate,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.fg,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
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
                  headerStyle: DateRangePickerHeaderStyle(
                    backgroundColor: AppColor.bgRaised,
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColor.fg,
                    ),
                  ),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(
                        fontSize: 12,
                        color: AppColor.fgMuted,
                      ),
                    ),
                  ),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    textStyle: TextStyle(
                      fontSize: 13,
                      color: AppColor.fg,
                    ),
                    todayTextStyle: TextStyle(
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
                  selectionTextStyle: TextStyle(
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
                      child: Text(
                        context.l10n.commonConfirm,
                        style: TextStyle(
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
