import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';

class SyncSettings {
  final String frequency;
  final int duration;
  final String timeSlot;
  final bool autoAdd;

  const SyncSettings({
    required this.frequency,
    required this.duration,
    required this.timeSlot,
    required this.autoAdd,
  });
}

class SyncBottomSheet extends StatefulWidget {
  final SyncSettings? initialSettings;

  const SyncBottomSheet({
    super.key,
    this.initialSettings,
  });

  static Future<SyncSettings?> show(
    BuildContext context, {
    SyncSettings? initialSettings,
  }) {
    return showModalBottomSheet<SyncSettings>(
      context: context,
      backgroundColor: AppColor.transparent,
      isScrollControlled: true,
      builder: (context) => SyncBottomSheet(
        initialSettings: initialSettings,
      ),
    );
  }

  @override
  State<SyncBottomSheet> createState() => _SyncBottomSheetState();
}

class _SyncBottomSheetState extends State<SyncBottomSheet> {
  late String _frequency;
  late int _duration;
  late String _timeSlot;
  late bool _autoAdd;

  @override
  void initState() {
    super.initState();
    _frequency = widget.initialSettings?.frequency ?? 'Mỗi ngày';
    _duration = widget.initialSettings?.duration ?? 15;
    _timeSlot = widget.initialSettings?.timeSlot ?? 'Tối';
    _autoAdd = widget.initialSettings?.autoAdd ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.bgRaised,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.s20,
        left: AppSpacing.s16,
        right: AppSpacing.s16,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.s24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            l10n.syncSheetTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColor.fg,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            l10n.syncSheetDescription,
            style: const TextStyle(
              fontSize: 12,
              color: AppColor.fgSecondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: AppSpacing.s16),

          // Frequency section
          _buildSection(
            label: l10n.syncFrequency,
            child: Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                _buildChip(l10n.syncFrequencyDaily, _frequency == 'Mỗi ngày', () {
                  setState(() => _frequency = 'Mỗi ngày');
                }),
                _buildChip(l10n.syncFrequencyMonWedFri, _frequency == 'T2, 4, 6', () {
                  setState(() => _frequency = 'T2, 4, 6');
                }),
                _buildChip(l10n.syncFrequencyWeekend, _frequency == 'Cuối tuần', () {
                  setState(() => _frequency = 'Cuối tuần');
                }),
                _buildChip(l10n.syncFrequencyCustom, _frequency == 'Tự chọn', () {
                  setState(() => _frequency = 'Tự chọn');
                }),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.s16),

          // Duration section
          _buildSection(
            label: l10n.syncDuration,
            child: Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                _buildChip(l10n.syncDuration10, _duration == 10, () {
                  setState(() => _duration = 10);
                }),
                _buildChip(l10n.syncDuration15, _duration == 15, () {
                  setState(() => _duration = 15);
                }),
                _buildChip(l10n.syncDuration20, _duration == 20, () {
                  setState(() => _duration = 20);
                }),
                _buildChip(l10n.syncDuration30, _duration == 30, () {
                  setState(() => _duration = 30);
                }),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.s16),

          // Time slot section
          _buildSection(
            label: l10n.syncTimeSlot,
            child: Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                _buildChip(l10n.syncTimeSlotMorning, _timeSlot == 'Sáng', () {
                  setState(() => _timeSlot = 'Sáng');
                }),
                _buildChip(l10n.syncTimeSlotNoon, _timeSlot == 'Trưa', () {
                  setState(() => _timeSlot = 'Trưa');
                }),
                _buildChip(l10n.syncTimeSlotEvening, _timeSlot == 'Tối', () {
                  setState(() => _timeSlot = 'Tối');
                }),
                _buildChip(l10n.syncTimeSlotCustom, _timeSlot == 'Tự chọn', () {
                  setState(() => _timeSlot = 'Tự chọn');
                }),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.s12),

          // Auto-add toggle
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColor.border),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.syncAutoToggle,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColor.fg,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s2),
                      Text(
                        l10n.syncAutoToggleSubtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColor.fgSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                _buildToggle(_autoAdd, (value) {
                  setState(() => _autoAdd = value);
                }),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.s8),

          // Action buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.cyan,
                    foregroundColor: AppColor.bgDeep,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.syncConfirm,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColor.fgSecondary,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.syncCancel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.fgSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        child,
      ],
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s14,
          vertical: AppSpacing.s8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.cyanDim : AppColor.surface,
          border: Border.all(
            color: isSelected ? AppColor.cyan : AppColor.border,
          ),
          borderRadius: BorderRadius.circular(AppRadius.pill),
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

  Widget _buildToggle(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 44,
        height: 26,
        decoration: BoxDecoration(
          color: value ? AppColor.cyan : AppColor.fgMuted,
          borderRadius: BorderRadius.circular(13),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: const BoxDecoration(
              color: AppColor.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  void _handleConfirm() {
    // TODO: Backend integration - Save sync settings to backend
    final settings = SyncSettings(
      frequency: _frequency,
      duration: _duration,
      timeSlot: _timeSlot,
      autoAdd: _autoAdd,
    );
    Navigator.of(context).pop(settings);
  }
}
