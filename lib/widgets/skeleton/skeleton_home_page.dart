import 'package:flutter/material.dart';

import 'skeleton_primitives.dart';

class SkeletonHomePage extends StatelessWidget {
  const SkeletonHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonPageWrapper(
      children: [
        const SizedBox(height: 14),
        _buildDailyProgressSkeleton(),
        _buildInsightSkeleton(),
        const SkeletonSectionHeader(),
        _buildQuestCards(3),
        const SkeletonSectionHeader(),
        _buildQuestCards(2),
        const SkeletonSectionHeader(),
        _buildQuestCards(2),
        const SkeletonSectionHeader(),
        _buildQuestCards(2),
        _buildCtaSkeleton(),
        _buildSummaryFooter(),
      ],
    );
  }

  Widget _buildDailyProgressSkeleton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: SkeletonCard(
        height: 155,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SkeletonBox(width: 120, height: 18, radius: 6),
                  const Spacer(),
                  const SkeletonBox(width: 60, height: 14, radius: 5),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: List.generate(
                  4,
                  (_) => const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: 32, height: 20, radius: 5),
                        SizedBox(height: 6),
                        SkeletonBox(width: 40, height: 11, radius: 4),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SkeletonBox(height: 8, radius: 4),
              const SizedBox(height: 10),
              const SkeletonBox(width: 140, height: 11, radius: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightSkeleton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: SkeletonCard(
        height: 60,
        radius: 20,
        glowBorder: true,
        child: const Padding(
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              SkeletonCircle(size: 32),
              SizedBox(width: 12),
              Expanded(child: SkeletonBox(height: 14, radius: 6)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestCards(int count) {
    return Column(
      children: List.generate(
        count,
        (_) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: SkeletonCard(
            height: 72,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const SkeletonCircle(size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SkeletonBox(width: 140, height: 13, radius: 5),
                        SizedBox(height: 6),
                        SkeletonBox(width: 90, height: 10, radius: 4),
                      ],
                    ),
                  ),
                  const SkeletonBox(width: 48, height: 28, radius: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCtaSkeleton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SkeletonCard(
        height: 72,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SkeletonCircle(size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SkeletonBox(width: 160, height: 13, radius: 5),
                    SizedBox(height: 6),
                    SkeletonBox(width: 110, height: 10, radius: 4),
                  ],
                ),
              ),
              const SkeletonBox(width: 80, height: 28, radius: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryFooter() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonBox(width: 80, height: 12, radius: 4),
          SizedBox(width: 6),
          SkeletonCircle(size: 4),
          SizedBox(width: 6),
          SkeletonBox(width: 80, height: 12, radius: 4),
        ],
      ),
    );
  }
}
