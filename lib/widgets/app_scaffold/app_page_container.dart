import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';

class AppPageContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const AppPageContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s12,
          ),
      child: child,
    );
  }
}
