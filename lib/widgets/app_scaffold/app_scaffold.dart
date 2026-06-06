import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final bool showBottomNav;
  final Widget? bottomNav;
  final List<Widget>? actions;
  final Widget? bottom;
  final bool scroll;
  final bool extendBody;
  final bool useGradientBackground;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.showBottomNav = false,
    this.bottomNav,
    this.actions,
    this.bottom,
    this.scroll = true,
    this.extendBody = false,
    this.useGradientBackground = true,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      extendBody: extendBody,
      extendBodyBehindAppBar: title != null,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              backgroundColor: AppColor.transparent,
              elevation: 0,
              centerTitle: false,
              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: onBack ?? () => Navigator.of(context).pop(),
                    )
                  : null,
              actions: actions,
            )
          : null,
      body: Container(
        decoration: useGradientBackground
            ? const BoxDecoration(
                gradient: AppColor.backgroundGradient,
              )
            : null,
        child: SafeArea(
          child: scroll
              ? SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: body,
                )
              : body,
        ),
      ),
      bottomNavigationBar: showBottomNav ? bottomNav : null,
      bottomSheet: bottom,
    );
  }
}
