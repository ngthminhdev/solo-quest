import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remixicon/remixicon.dart';

import '../../constants/app_color.dart';
import '../../extensions/localization_extension.dart';

enum AppTab { home, logs, progress, rewards, profile }

class AppBottomNav extends StatelessWidget {
  final AppTab currentTab;
  final ValueChanged<AppTab> onTap;

  const AppBottomNav({
    super.key,
    required this.currentTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.bgRaised,
        border: Border(top: BorderSide(color: AppColor.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: AppTab.values.map((tab) {
              final index = AppTab.values.indexOf(tab);
              final isActive = tab == currentTab;
              return Expanded(
                child: _NavItem(
                  icon: _icon(tab),
                  label: _label(tab, context),
                  isActive: isActive,
                  index: index,
                  itemCount: AppTab.values.length,
                  onTap: () => onTap(tab),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  IconData _icon(AppTab tab) {
    switch (tab) {
      case AppTab.home:
        return currentTab == tab ? RemixIcons.home_3_fill : RemixIcons.home_3_line;
      case AppTab.logs:
        return currentTab == tab ? RemixIcons.file_text_fill : RemixIcons.file_text_line;
      case AppTab.progress:
        return currentTab == tab ? RemixIcons.bar_chart_2_fill : RemixIcons.bar_chart_2_line;
      case AppTab.rewards:
        return currentTab == tab ? RemixIcons.star_fill : RemixIcons.star_line;
      case AppTab.profile:
        return currentTab == tab ? RemixIcons.user_3_fill : RemixIcons.user_3_line;
    }
  }

  String _label(AppTab tab, BuildContext context) {
    final l10n = context.l10n;
    switch (tab) {
      case AppTab.home:
        return l10n.bottomNavHome;
      case AppTab.logs:
        return l10n.bottomNavLogs;
      case AppTab.progress:
        return l10n.bottomNavProgress;
      case AppTab.rewards:
        return l10n.bottomNavRewards;
      case AppTab.profile:
        return l10n.bottomNavProfile;
    }
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final int index;
  final int itemCount;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.index,
    required this.itemCount,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    if (widget.isActive) {
      _slideController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _rippleController.forward(from: 0.0);
        _slideController.forward(from: 0.0);
      } else {
        _slideController.reverse(from: 1.0);
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final itemWidth = deviceWidth / widget.itemCount;

    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([_slideController, _scaleController, _rippleController]),
        builder: (context, child) {
          final scale = Tween<double>(begin: 1.0, end: 0.92)
              .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut))
              .value;

          return Transform.scale(
            scale: scale,
            child: ClipRect(
              child: SizedBox(
                width: itemWidth,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    // Background
                    Container(
                      color: AppColor.bgRaised,
                      width: itemWidth,
                    ),

                    // Ripple effect on tap
                    if (widget.isActive && _rippleController.isAnimating)
                      _buildRipple(),

                    // Sliding card background
                    if (widget.isActive)
                      _buildSlidingCard(itemWidth),

                    // Icon with slide animation
                    _buildIcon(),

                    // Label with slide animation
                    _buildLabel(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRipple() {
    final size = Tween<double>(begin: 8.0, end: 56.0)
        .animate(CurvedAnimation(
          parent: _rippleController,
          curve: const Interval(0.0, 0.3),
        ))
        .value;

    final strokeWidth = Tween<double>(begin: 24.0, end: 0.0)
        .animate(CurvedAnimation(
          parent: _rippleController,
          curve: const Interval(0.1, 0.3),
        ))
        .value;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RipplePainter(
          color: AppColor.cyan.withOpacity(0.3),
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }

  Widget _buildSlidingCard(double itemWidth) {
    final slideOffset = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: const Offset(0, -0.5),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.3, 1.0),
    )).value;

    return ClipRect(
      child: SlideTransition(
        position: AlwaysStoppedAnimation(slideOffset),
        child: Container(
          width: itemWidth,
          height: 60,
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final iconSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.2),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.3, 1.0),
    )).value;

    return ClipRect(
      child: SlideTransition(
        position: AlwaysStoppedAnimation(iconSlide),
        child: Icon(
          widget.icon,
          size: 22,
          color: widget.isActive ? AppColor.cyan : AppColor.fgMuted,
        ),
      ),
    );
  }

  Widget _buildLabel() {
    final labelSlide = Tween<Offset>(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.3, 1.0),
    )).value;

    return ClipRect(
      child: SlideTransition(
        position: AlwaysStoppedAnimation(labelSlide),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
              color: widget.isActive ? AppColor.cyan : AppColor.fgMuted,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _RipplePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

