import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import 'skeleton_primitives.dart';

class SkeletonProfilePage extends StatelessWidget {
  const SkeletonProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonPageWrapper(
      children: [
        _buildHeaderCard(),
        const SizedBox(height: AppSpacing.s20),
        _buildStatsGrid(),
        const SizedBox(height: AppSpacing.s20),
        _buildQuickActions(),
        const SizedBox(height: AppSpacing.s20),
        _buildSettingsSection(),
        const SizedBox(height: AppSpacing.s20),
        _buildAccountCard(),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SkeletonCard(
        height: 170,
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
                  3,
                  (_) => const Padding(
                    padding: EdgeInsets.only(right: 24),
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

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Row(
        children: List.generate(
          4,
          (_) => Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SkeletonCard(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SkeletonBox(width: 28, height: 20, radius: 5),
                    SizedBox(height: 8),
                    SkeletonBox(width: 36, height: 10, radius: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        3,
        (index) => Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, index < 2 ? 8 : 0),
          child: SkeletonCard(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const SkeletonCircle(size: 28),
                  const SizedBox(width: 12),
                  const SkeletonBox(width: 120, height: 13, radius: 5),
                  const Spacer(),
                  const SkeletonBox(width: 24, height: 24, radius: 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        3,
        (index) => Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, index < 2 ? 8 : 0),
          child: SkeletonCard(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const SkeletonCircle(size: 28),
                  const SizedBox(width: 12),
                  const SkeletonBox(width: 100, height: 13, radius: 5),
                  const Spacer(),
                  const SkeletonBox(width: 24, height: 24, radius: 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SkeletonCard(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const SkeletonCircle(size: 28),
              const SizedBox(width: 12),
              const SkeletonBox(width: 100, height: 13, radius: 5),
              const Spacer(),
              const SkeletonBox(width: 24, height: 24, radius: 6),
            ],
          ),
        ),
      ),
    );
  }
}
