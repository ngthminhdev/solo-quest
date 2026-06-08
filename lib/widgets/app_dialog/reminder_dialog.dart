import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import '../../core/notifications/fcm_notification_payload.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/timer/countdown_timer_service.dart';
import '../../core/timer/countdown_session.dart';
import '../../routes/routes_config.dart';

class ReminderDialog extends StatelessWidget {
  final String title;
  final String body;
  final String confirmLabel;
  final VoidCallback? onConfirm;
  final String cancelLabel;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const ReminderDialog({
    super.key,
    required this.title,
    required this.body,
    required this.confirmLabel,
    this.onConfirm,
    required this.cancelLabel,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  static void showReminderPrompt(
    BuildContext context,
    FcmNotificationPayload payload,
    dynamic ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final String title;
    final String body;
    final String confirmLabel;
    final VoidCallback? onConfirm;
    final IconData icon;
    final Color iconColor;
    final Color iconBgColor;

    final type = payload.reminderType ?? '';
    final action = payload.action ?? '';

    if (type == 'water' || action == 'water_reminder') {
      title = l10n.reminderWaterTitle;
      body = l10n.reminderWaterBody;
      confirmLabel = l10n.reminderWaterBtn;
      onConfirm = null;
      icon = RemixIcons.drop_line;
      iconColor = AppColor.cyan;
      iconBgColor = AppColor.cyanDim;
    } else if (type == 'break_time' || action == 'start_break_timer') {
      title = l10n.reminderBreakTitle;
      final minutes = payload.countdownMinutes > 0 ? payload.countdownMinutes : 5;
      body = l10n.reminderBreakBody;
      confirmLabel = l10n.reminderBreakBtn(minutes);
      onConfirm = () {
        _startBreakTimer(context, minutes, ref);
      };
      icon = RemixIcons.time_line;
      iconColor = AppColor.warn;
      iconBgColor = AppColor.warnDim;
    } else if (type == 'movement' || action == 'movement_reminder') {
      title = l10n.reminderMovementTitle;
      body = l10n.reminderMovementBody;
      confirmLabel = l10n.commonClose;
      onConfirm = null;
      icon = RemixIcons.heart_line;
      iconColor = AppColor.success;
      iconBgColor = AppColor.successDim;
    } else if (type == 'learning' || action == 'learning_reminder') {
      title = l10n.reminderLearningTitle;
      body = l10n.reminderLearningBody;
      confirmLabel = l10n.commonClose;
      onConfirm = null;
      icon = RemixIcons.book_open_line;
      iconColor = AppColor.cyan;
      iconBgColor = AppColor.cyanDim;
    } else if (type == 'sleep' || action == 'sleep_reminder') {
      title = l10n.reminderSleepTitle;
      body = l10n.reminderSleepBody;
      confirmLabel = l10n.commonClose;
      onConfirm = null;
      icon = RemixIcons.moon_line;
      iconColor = AppColor.violet;
      iconBgColor = AppColor.violetDim;
    } else if (type == 'daily_review' || action == 'daily_review_reminder') {
      title = l10n.reminderDailyReviewTitle;
      body = l10n.reminderDailyReviewBody;
      confirmLabel = l10n.reminderDailyReviewBtn;
      onConfirm = () {
        Navigator.of(context).pushNamed(RoutesConfig.dailyReview);
      };
      icon = RemixIcons.file_text_line;
      iconColor = AppColor.warn;
      iconBgColor = AppColor.warnDim;
    } else {
      return;
    }

    ReminderDialog.show(
      context: context,
      title: title,
      body: body,
      confirmLabel: confirmLabel,
      onConfirm: onConfirm,
      cancelLabel: l10n.commonClose,
      icon: icon,
      iconColor: iconColor,
      iconBgColor: iconBgColor,
    );
  }

  static void _startBreakTimer(BuildContext context, int minutes, dynamic ref) {
    final l10n = AppLocalizations.of(context);
    final timerService = ref.read(countdownTimerServiceProvider.notifier);
    final activeSession = ref.read(countdownTimerServiceProvider);

    if (activeSession != null && activeSession.status == CountdownStatus.running) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.timerTimeUp),
          content: Text(l10n.timerConfirmReplace),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.commonCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await timerService.cancelSession();
                await timerService.startReminderSession(
                  title: l10n.reminderBreakTitle,
                  durationMinutes: minutes,
                  source: 'reminder_setting',
                  reminderType: 'break_time',
                );
              },
              child: Text(l10n.commonConfirm),
            ),
          ],
        ),
      );
    } else {
      timerService.startReminderSession(
        title: l10n.reminderBreakTitle,
        durationMinutes: minutes,
        source: 'reminder_setting',
        reminderType: 'break_time',
      );
    }
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String body,
    required String confirmLabel,
    VoidCallback? onConfirm,
    required String cancelLabel,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ReminderDialog(
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        cancelLabel: cancelLabel,
        icon: icon,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColor.bgRaised,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColor.borderGlowCyan),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBgColor,
                border: Border.all(color: iconColor, width: 2),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColor.fg,
              ),
            ),
            const SizedBox(height: 8),

            // Body message
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.fgSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            if (onConfirm != null) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm!();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.cyan,
                  foregroundColor: AppColor.bgDeep,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  confirmLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                foregroundColor: AppColor.fgSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(
                onConfirm == null ? confirmLabel : cancelLabel,
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
