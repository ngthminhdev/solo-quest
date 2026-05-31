import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../models/reward_model.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../constants/rewards_constants.dart';
import 'reward_card.dart';

class RewardsGridSection extends StatelessWidget {
  final List<RewardModel> rewards;
  final int availablePoints;
  final bool Function(RewardModel) canClaim;
  final ValueChanged<RewardModel> onClaim;

  const RewardsGridSection({
    super.key,
    required this.rewards,
    required this.availablePoints,
    required this.canClaim,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: RewardsConstants.sectionTitle,
          count: '${rewards.length}',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth < 380 ? 1 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: AppSpacing.s10,
                  crossAxisSpacing: AppSpacing.s10,
                  childAspectRatio: crossAxisCount == 1 ? 2.8 : 1.6,
                ),
                itemCount: rewards.length,
                itemBuilder: (context, index) {
                  final reward = rewards[index];
                  return RewardCard(
                    reward: reward,
                    canClaim: canClaim(reward),
                    onClaim: () => onClaim(reward),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
