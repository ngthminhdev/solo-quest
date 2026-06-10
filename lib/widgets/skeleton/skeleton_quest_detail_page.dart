import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import 'skeleton_primitives.dart';

class SkeletonQuestDetailPage extends StatelessWidget {
  const SkeletonQuestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SkeletonPageWrapper(
          children: [
            const SizedBox(height: AppSpacing.s20),
            _buildHeaderSkeleton(),
            const SizedBox(height: AppSpacing.s8),
            _buildStatusSkeleton(),
            const SizedBox(height: AppSpacing.s20),
            _buildTimerSkeleton(),
            const SizedBox(height: AppSpacing.s20),
            _buildContentCardSkeleton(lines: 3),
            const SizedBox(height: AppSpacing.s20),
            _buildContentCardSkeleton(lines: 2),
            const SizedBox(height: AppSpacing.s20),
            _buildHistorySkeleton(),
            const SizedBox(height: 116),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildActionBarSkeleton(),
        ),
      ],
    );
  }

  Widget _buildHeaderSkeleton() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SkeletonCircle(size: 52),
          SizedBox(height: AppSpacing.s12),
          SkeletonBox(width: 190, height: 18, radius: 6),
          SizedBox(height: AppSpacing.s8),
          SkeletonBox(width: 120, height: 13, radius: 5),
          SizedBox(height: AppSpacing.s10),
          SkeletonBox(width: 86, height: 26, radius: 999),
        ],
      ),
    );
  }

  Widget _buildStatusSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: SkeletonCard(
        height: 78,
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.s16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SkeletonBox(width: 82, height: 16, radius: 5),
              SizedBox(width: AppSpacing.s16),
              SkeletonBox(width: 72, height: 16, radius: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: SkeletonCard(
        height: 106,
        radius: 20,
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SkeletonBox(width: 132, height: 16, radius: 5),
                  Spacer(),
                  SkeletonBox(width: 28, height: 20, radius: 6),
                ],
              ),
              SizedBox(height: AppSpacing.s14),
              SkeletonBox(height: 8, radius: 999),
              SizedBox(height: AppSpacing.s14),
              SkeletonBox(width: 150, height: 12, radius: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentCardSkeleton({required int lines}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 72, height: 11, radius: 4),
          const SizedBox(height: AppSpacing.s8),
          SkeletonCard(
            height: lines == 3 ? 132 : 104,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  lines,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == lines - 1 ? 0 : AppSpacing.s10,
                    ),
                    child: SkeletonBox(
                      width: index == lines - 1 ? 190 : double.infinity,
                      height: 14,
                      radius: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 86, height: 11, radius: 4),
          const SizedBox(height: AppSpacing.s8),
          SkeletonCard(
            height: 74,
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.s16),
              child: Row(
                children: [
                  SkeletonCircle(size: 28),
                  SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SkeletonBox(width: 140, height: 13, radius: 5),
                        SizedBox(height: AppSpacing.s8),
                        SkeletonBox(width: 92, height: 10, radius: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBarSkeleton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s12,
        AppSpacing.s16,
        AppSpacing.s24,
      ),
      child: const Row(
        children: [
          Expanded(child: SkeletonBox(height: 48, radius: 14)),
          SizedBox(width: AppSpacing.s10),
          SkeletonBox(width: 48, height: 48, radius: 14),
          SizedBox(width: AppSpacing.s10),
          SkeletonBox(width: 48, height: 48, radius: 14),
        ],
      ),
    );
  }
}
