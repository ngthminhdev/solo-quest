import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import 'skeleton_primitives.dart';

class SkeletonProgressPage extends StatelessWidget {
  const SkeletonProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonPageWrapper(
      children: [
        _buildHeroCard(),
        _buildStreakSafetyCard(),
        _buildChartCard(),
        _buildXPHistoryItems(),
        _buildBreakdownCard(),
        _buildExplainCard(),
        _buildLinksSection(),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SkeletonCard(
        height: 185,
        radius: 24,
        glowBorder: true,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SkeletonCircle(size: 56),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SkeletonBox(width: 120, height: 18, radius: 6),
                        SizedBox(height: 8),
                        SkeletonBox(width: 80, height: 12, radius: 5),
                      ],
                    ),
                  ),
                  const SkeletonBox(width: 60, height: 28, radius: 14),
                ],
              ),
              const SizedBox(height: 16),
              const SkeletonBox(height: 8, radius: 4),
              const SizedBox(height: 12),
              Row(
                children: List.generate(
                  4,
                  (_) => const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: 36, height: 20, radius: 5),
                        SizedBox(height: 6),
                        SkeletonBox(width: 44, height: 11, radius: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakSafetyCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SkeletonCard(
        height: 90,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonBox(width: 100, height: 13, radius: 5),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SkeletonBox(width: 48, height: 22, radius: 6),
                  const SizedBox(width: 10),
                  const SkeletonBox(width: 60, height: 22, radius: 6),
                  const Spacer(),
                  const SkeletonBox(width: 80, height: 14, radius: 5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SkeletonCard(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SkeletonBox(width: 100, height: 13, radius: 5),
                  SkeletonBox(width: 60, height: 11, radius: 4),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                   children: List.generate(
                    7,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SkeletonShimmer(
                        child: Container(
                          width: 30,
                          height: 60.0 + ((i * 17) % 60).toDouble(),
                          decoration: BoxDecoration(
                            color: AppColor.surface,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  7,
                  (_) => const SkeletonBox(width: 24, height: 10, radius: 3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildXPHistoryItems() {
    return Column(
      children: List.generate(
        4,
        (_) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: SkeletonCard(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const SkeletonCircle(size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SkeletonBox(width: 120, height: 12, radius: 5),
                        SizedBox(height: 6),
                        SkeletonBox(width: 80, height: 10, radius: 4),
                      ],
                    ),
                  ),
                  const SkeletonBox(width: 48, height: 16, radius: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SkeletonCard(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            children: [
              const SkeletonCircle(size: 28),
              const SizedBox(width: 12),
              const SkeletonBox(width: 140, height: 13, radius: 5),
              const Spacer(),
              const SkeletonBox(width: 24, height: 24, radius: 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplainCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SkeletonCard(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            children: [
              const SkeletonCircle(size: 28),
              const SizedBox(width: 12),
              const SkeletonBox(width: 140, height: 13, radius: 5),
              const Spacer(),
              const SkeletonBox(width: 24, height: 24, radius: 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: SkeletonCard(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const SkeletonCircle(size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SkeletonBox(width: 140, height: 13, radius: 5),
                        SizedBox(height: 6),
                        SkeletonBox(width: 100, height: 10, radius: 4),
                      ],
                    ),
                  ),
                  const SkeletonBox(width: 24, height: 24, radius: 6),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SkeletonCard(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const SkeletonCircle(size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SkeletonBox(width: 140, height: 13, radius: 5),
                        SizedBox(height: 6),
                        SkeletonBox(width: 100, height: 10, radius: 4),
                      ],
                    ),
                  ),
                  const SkeletonBox(width: 24, height: 24, radius: 6),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
