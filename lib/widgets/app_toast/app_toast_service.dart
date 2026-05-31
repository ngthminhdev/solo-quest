import 'package:flutter/material.dart';

import 'app_toast.dart';

class AppToastService {
  static void show(
    BuildContext context,
    String message, {
    AppToastType type = AppToastType.info,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 80 + MediaQuery.of(context).padding.bottom,
        left: 20,
        right: 20,
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 300),
            onEnd: () {
              Future.delayed(const Duration(seconds: 2), () {
                if (entry.mounted) entry.remove();
              });
            },
            builder: (_, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            ),
            child: AppToast(message: message, type: type),
          ),
        ),
      ),
    );
    overlay.insert(entry);
  }

  static void success(BuildContext context, String message) {
    show(context, message, type: AppToastType.success);
  }

  static void error(BuildContext context, String message) {
    show(context, message, type: AppToastType.error);
  }

  static void warning(BuildContext context, String message) {
    show(context, message, type: AppToastType.warning);
  }

  static void info(BuildContext context, String message) {
    show(context, message, type: AppToastType.info);
  }
}
