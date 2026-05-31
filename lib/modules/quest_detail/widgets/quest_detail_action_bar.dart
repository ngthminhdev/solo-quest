import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/quest_model.dart';
import '../../../models/enums/quest_enums.dart';

class QuestDetailActionBar extends StatelessWidget {
  final QuestModel quest;
  final bool isLoading;
  final VoidCallback? onStart;
  final VoidCallback? onComplete;
  final VoidCallback? onSnooze;
  final VoidCallback? onSkip;

  const QuestDetailActionBar({
    super.key,
    required this.quest,
    this.isLoading = false,
    this.onStart,
    this.onComplete,
    this.onSnooze,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s10,
        AppSpacing.s16,
        AppSpacing.s24 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColor.bgRaised,
        border: Border(
          top: BorderSide(color: AppColor.border),
        ),
      ),
      child: _buildActions(),
    );
  }

  Widget _buildActions() {
    switch (quest.status) {
      case QuestStatus.pending:
        return _buildPendingActions();
      case QuestStatus.active:
        return _buildActiveActions();
      case QuestStatus.completed:
        return _buildCompletedActions();
      case QuestStatus.skipped:
        return _buildSkippedActions();
      case QuestStatus.snoozed:
        return _buildSnoozedActions();
      case QuestStatus.expired:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPendingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary: Start button
        SizedBox(
          width: double.infinity,
          child: _buildButton(
            label: 'Bắt Đầu',
            onTap: isLoading ? null : onStart,
            bgColor: AppColor.cyan,
            textColor: AppColor.bgDeep,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        // Secondary actions
        Row(
          children: [
            Expanded(
              child: _buildButton(
                label: 'Hoãn',
                onTap: isLoading ? null : onSnooze,
                bgColor: AppColor.surface,
                textColor: AppColor.fgSecondary,
                border: Border.all(color: AppColor.border),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: _buildButton(
                label: 'Bỏ Qua',
                onTap: isLoading ? null : onSkip,
                bgColor: AppColor.surface,
                textColor: AppColor.fgMuted,
                border: Border.all(color: AppColor.border),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary: Complete button
        SizedBox(
          width: double.infinity,
          child: _buildButton(
            label: 'Hoàn Thành',
            onTap: isLoading ? null : onComplete,
            bgColor: AppColor.successDim,
            textColor: AppColor.success,
            border: Border.all(color: AppColor.success.withValues(alpha: 0.2)),
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        // Secondary actions
        Row(
          children: [
            Expanded(
              child: _buildButton(
                label: 'Hoãn',
                onTap: isLoading ? null : onSnooze,
                bgColor: AppColor.surface,
                textColor: AppColor.fgSecondary,
                border: Border.all(color: AppColor.border),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: _buildButton(
                label: 'Bỏ Qua',
                onTap: isLoading ? null : onSkip,
                bgColor: AppColor.surface,
                textColor: AppColor.fgMuted,
                border: Border.all(color: AppColor.border),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompletedActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.successDim,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.success.withValues(alpha: 0.2)),
      ),
      child: const Center(
        child: Text(
          '✓ Đã hoàn thành',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColor.success,
          ),
        ),
      ),
    );
  }

  Widget _buildSkippedActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: const Center(
        child: Text(
          '— Đã bỏ qua',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColor.fgMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildSnoozedActions() {
    return Row(
      children: [
        // Start button
        Expanded(
          child: _buildButton(
            label: 'Bắt Đầu',
            onTap: isLoading ? null : onStart,
            bgColor: AppColor.cyan,
            textColor: AppColor.bgDeep,
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    VoidCallback? onTap,
    required Color bgColor,
    required Color textColor,
    Border? border,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s14,
        ),
        decoration: BoxDecoration(
          color: onTap == null ? bgColor.withValues(alpha: 0.5) : bgColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: border,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: textColor,
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: onTap == null ? textColor.withValues(alpha: 0.5) : textColor,
                  ),
                ),
        ),
      ),
    );
  }
}
