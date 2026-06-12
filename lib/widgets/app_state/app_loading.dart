import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';

class AppLoading extends StatelessWidget {
  final String? message;

  const AppLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight.isFinite && constraints.maxHeight > 0
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height * 0.7;
        return SizedBox(
          height: height,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 260),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s20,
                vertical: AppSpacing.s16,
              ),
              decoration: BoxDecoration(
                color: AppColor.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColor.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadowMedium.withValues(alpha: 0.22),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingAnimationWidget.threeRotatingDots(
                    color: AppColor.cyan,
                    size: 30,
                  ),
                  if (message != null) ...[
                    const SizedBox(height: AppSpacing.s14),
                    Text(
                      message!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.fgSecondary,
                        height: 1.35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PageLockOverlay extends StatelessWidget {
  final bool isLocked;
  final Widget child;

  const PageLockOverlay({
    super.key,
    required this.isLocked,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLocked)
          Positioned.fill(
            child: Container(
              color: AppColor.bgDeep.withValues(alpha: 0.72),
              child: const Center(
                child: AppLoading(),
              ),
            ),
          ),
      ],
    );
  }
}
