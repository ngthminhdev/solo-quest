import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import 'skeleton_primitives.dart';

class SkeletonLogsPage extends StatelessWidget {
  const SkeletonLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonPageWrapper(
      children: [
        _buildSummaryCard(),
        _buildFilterBar(),
        _buildTimelineItems(),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SkeletonCard(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            children: List.generate(
              4,
              (_) => const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonBox(width: 32, height: 20, radius: 5),
                    SizedBox(height: 8),
                    SkeletonBox(width: 40, height: 11, radius: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 200, height: 36, radius: 10),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              4,
              (_) => const Padding(
                padding: EdgeInsets.only(right: 8),
                child: SkeletonBox(width: 64, height: 28, radius: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItems() {
    return Column(
      children: List.generate(
        6,
        (index) => _buildTimelineItem(index),
      ),
    );
  }

  Widget _buildTimelineItem(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 4, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SkeletonCircle(size: 10),
              if (index < 5) const SizedBox(height: 4),
              if (index < 5)
                const SkeletonBox(width: 2, height: 40, radius: 1),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SkeletonCard(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const SkeletonCircle(size: 32),
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
                    const SkeletonBox(width: 48, height: 14, radius: 5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
