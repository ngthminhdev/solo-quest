import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import '../../extensions/localization_extension.dart';

class TimerCompletionDialog extends StatefulWidget {
  final String questId;
  final String questTitle;
  final Future<void> Function() onComplete;
  final VoidCallback? onCancel;

  const TimerCompletionDialog({
    super.key,
    required this.questId,
    required this.questTitle,
    required this.onComplete,
    this.onCancel,
  });

  static Future<void> show({
    required BuildContext context,
    required String questId,
    required String questTitle,
    required Future<void> Function() onComplete,
    VoidCallback? onCancel,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TimerCompletionDialog(
        questId: questId,
        questTitle: questTitle,
        onComplete: onComplete,
        onCancel: onCancel,
      ),
    );
  }

  @override
  State<TimerCompletionDialog> createState() => _TimerCompletionDialogState();
}

class _TimerCompletionDialogState extends State<TimerCompletionDialog> {
  bool _isLoading = false;

  Future<void> _handleComplete() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await widget.onComplete();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Dialog(
      backgroundColor: AppColor.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColor.bgRaised,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColor.borderGlowCyan),
          boxShadow: const [
            BoxShadow(
              color: AppColor.cyanGlow,
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon section
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.warnDim,
                border: Border.all(color: AppColor.warn, width: 2),
              ),
              child: const Icon(
                RemixIcons.time_line,
                color: AppColor.warn,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              l10n.timerTimeUp,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColor.fg,
              ),
            ),
            const SizedBox(height: 8),

            // Message
            Text(
              '${widget.questTitle} ${l10n.timerQuestEnded.toLowerCase()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.fgSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            ElevatedButton(
              onPressed: _isLoading ? null : _handleComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.cyan,
                foregroundColor: AppColor.bgDeep,
                disabledBackgroundColor: AppColor.cyan.withValues(alpha: 0.3),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.bgDeep),
                      ),
                    )
                  : Text(
                      l10n.timerCompleteQuest,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      widget.onCancel?.call();
                    },
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                foregroundColor: AppColor.fgSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(
                l10n.timerStop,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
