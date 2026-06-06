import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import '../../extensions/localization_extension.dart';
import '../../models/learning_roadmap_model.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/skeleton/skeleton_home_page.dart';
import 'learning_roadmap_page_model.dart';
import 'widgets/roadmap_detail_sheet.dart';
import 'widgets/roadmap_list_section.dart';
import 'widgets/roadmap_summary_card.dart';
import 'widgets/create_roadmap_fab.dart';
import 'widgets/roadmap_preference_sheet.dart';
import 'widgets/create_roadmap_bottom_sheet.dart';

class LearningRoadmapPage
    extends BasePage<LearningRoadmapPageModel, LearningRoadmapPageState> {
  final String? goalId;

  LearningRoadmapPage({super.key, this.goalId})
    : super(provider: learningRoadmapPageProvider);

  @override
  ConsumerState<LearningRoadmapPage> createState() =>
      _LearningRoadmapPageState();
}

class _LearningRoadmapPageState
    extends
        BasePageConsumerState<
          LearningRoadmapPage,
          LearningRoadmapPageModel,
          LearningRoadmapPageState
        > {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.loadRoadmaps();
    });
  }

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    // Show preference sheet (Step 1)
    if (state.showPreferenceSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        RoadmapPreferenceSheet.show(
          context,
          onSubmit: (preferences) {
            pageModel.onPreferencesSubmitted(preferences);
          },
        ).then((_) {
          // Close sheet on dismiss
          if (state.showPreferenceSheet) {
            pageModel.hideAllSheets();
          }
        });
      });
    }

    // Show suggestion sheet (Step 2)
    if (state.showSuggestionSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CreateRoadmapBottomSheet.show(
          context,
          onCreateRoadmap: (suggestionId) {
            pageModel.createRoadmapFromSuggestion(suggestionId);
          },
          suggestions: state.suggestions,
          isLoadingSuggestions: state.isLoadingSuggestions,
        ).then((_) {
          // Close sheet on dismiss
          if (state.showSuggestionSheet) {
            pageModel.hideAllSheets();
          }
        });
      });
    }

    return AppScaffold(
      showBottomNav: false,
      scroll: false,
      body: Stack(
        children: [
          _buildContent(state),
          // FAB positioned at bottom right
          Positioned(
            right: 16,
            bottom: 16,
            child: CreateRoadmapFab(
              onPressed: () => pageModel.showPreferenceSheet(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(LearningRoadmapPageState state) {
    final l10n = context.l10n;
    if (state.loadState == AppLoadState.loading && !state.hasRoadmaps) {
      return const SkeletonHomePage();
    }

    if (state.loadState == AppLoadState.error && !state.hasRoadmaps) {
      return AppErrorState(
        message: state.errorMessage ?? l10n.lrErrorLoadFailed,
        onRetry: pageModel.loadRoadmaps,
      );
    }

    return RefreshIndicator(
      backgroundColor: AppColor.surface,
      color: AppColor.cyan,
      onRefresh: pageModel.refreshRoadmaps,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: AppSpacing.s16,
          bottom: AppSpacing.s16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const LearningRoadmapHeader(),
            // const SizedBox(height: AppSpacing.s16),
            if (state.hasRoadmaps) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                child: RoadmapSummaryCard(
                  totalRoadmaps: state.totalRoadmaps,
                  completedRoadmaps: state.completedRoadmaps,
                  totalSteps: state.totalSteps,
                  completedSteps: state.completedSteps,
                  averageProgress: state.averageProgress,
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],

            RoadmapListSection(
              roadmaps: state.roadmaps,
              onOpenRoadmap: (roadmap) => _handleOpenRoadmap(roadmap),
              onCreateRoadmap: () => pageModel.showPreferenceSheet(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleOpenRoadmap(LearningRoadmapModel roadmap) {
    RoadmapDetailSheet.show(
      context,
      roadmap: roadmap,
      onToggleStep: (step, completed) async {
        return pageModel.toggleStep(
          roadmapId: roadmap.id,
          stepId: step.id,
          completed: completed,
        );
      },
    );
  }
}
