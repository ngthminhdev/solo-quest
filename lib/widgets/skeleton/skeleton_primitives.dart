import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_color.dart';

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class SkeletonShimmer extends StatelessWidget {
  final Widget child;

  const SkeletonShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.surface,
      highlightColor: AppColor.surfaceHover,
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const SkeletonBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: _SkeletonBox(width: width, height: height, radius: radius),
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SkeletonShimmer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColor.surface,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final double height;
  final Widget child;
  final bool glowBorder;
  final double radius;

  const SkeletonCard({
    super.key,
    required this.height,
    required this.child,
    this.glowBorder = false,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: SkeletonShimmer(
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.surface,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: glowBorder ? AppColor.borderGlowCyan : AppColor.border,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class SkeletonLine extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonLine({
    super.key,
    this.width = double.infinity,
    this.height = 14,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(width: width, height: height, radius: 6);
  }
}

class SkeletonPageWrapper extends StatelessWidget {
  final List<Widget> children;

  const SkeletonPageWrapper({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class SkeletonSectionHeader extends StatelessWidget {
  const SkeletonSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColor.surface,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const SkeletonBox(width: 100, height: 11, radius: 4),
        ],
      ),
    );
  }
}
