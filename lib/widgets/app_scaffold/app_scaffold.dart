import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import '../app_state/app_loading.dart';

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
  final Widget? floatingActionButton;
  final bool isLocked;

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
    this.floatingActionButton,
    this.isLocked = false,
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
                      icon: const Icon(RemixIcons.arrow_left_s_line),
                      onPressed: onBack ?? () => Navigator.of(context).pop(),
                    )
                  : null,
              actions: actions,
            )
          : null,
      body: isLocked
          ? PageLockOverlay(
              isLocked: true,
              child: _buildBody(),
            )
          : _buildBody(),
      bottomNavigationBar: showBottomNav ? bottomNav : null,
      bottomSheet: bottom,
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: useGradientBackground
          ? BoxDecoration(
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
    );
  }
}
