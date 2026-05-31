import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import '../../models/learning_roadmap_model.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import 'learning_roadmap_page_model.dart';
import 'constants/learning_roadmap_constants.dart';
import 'widgets/learning_roadmap_header.dart';
import 'widgets/roadmap_summary_card.dart';
import 'widgets/roadmap_list_section.dart';
import 'widgets/roadmap_detail_sheet.dart';

class LearningRoadmapPage
    extends BasePage<LearningRoadmapPageModel, LearningRoadmapPageState> {
  LearningRoadmapPage({super.key})
      : super(provider: learningRoadmapPageProvider);

  @override
  ConsumerState<LearningRoadmapPage> createState() =>
      _LearningRoadmapPageState();
}

class _LearningRoadmapPageState extends BasePageConsumerState<
    LearningRoadmapPage, LearningRoadmapPageModel, LearningRoadmapPageState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.loadRoadmaps();
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    if (state.loadState == AppLoadState.loading && !state.hasRoadmaps) {
      return Scaffold(
        backgroundColor: AppColor.bg,
        appBar: _buildAppBar(),
        body: const AppLoading(
          message: LearningRoadmapConstants.loadingMessage,
        ),
      );
    }

    if (state.loadState == AppLoadState.error && !state.hasRoadmaps) {
      return Scaffold(
        backgroundColor: AppColor.bg,
        appBar: _buildAppBar(),
        body: AppErrorState(
          message: state.errorMessage ?? LearningRoadmapConstants.errorLoadFailed,
          onRetry: pageModel.loadRoadmaps,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: AppColor.cyan,
        backgroundColor: AppColor.bgRaised,
        onRefresh: pageModel.refreshRoadmaps,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s16),

              // Header
              const LearningRoadmapHeader(),

              const SizedBox(height: AppSpacing.s16),

              // Summary card
              if (state.hasRoadmaps)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                  child: RoadmapSummaryCard(
                    totalRoadmaps: state.totalRoadmaps,
                    completedRoadmaps: state.completedRoadmaps,
                    totalSteps: state.totalSteps,
                    completedSteps: state.completedSteps,
                    averageProgress: state.averageProgress,
                  ),
                ),

              const SizedBox(height: AppSpacing.s16),

              // Roadmap list
              RoadmapListSection(
                roadmaps: state.roadmaps,
                onOpenRoadmap: _handleOpenRoadmap,
              ),

              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.bgRaised,
      elevation: 0,
      title: const Text(
        LearningRoadmapConstants.pageTitle,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColor.fg,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColor.fg),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _handleOpenRoadmap(LearningRoadmapModel roadmap) async {
    await RoadmapDetailSheet.show(
      context,
      roadmap: roadmap,
      onToggleStep: (step, completed) async {
        await _handleToggleStep(
          roadmap: roadmap,
          step: step,
          completed: completed,
        );
      },
    );
  }

  Future<void> _handleToggleStep({
    required LearningRoadmapModel roadmap,
    required LearningRoadmapStepModel step,
    required bool completed,
  }) async {
    final success = await pageModel.toggleStep(
      roadmapId: roadmap.id,
      stepId: step.id,
      completed: completed,
    );

    if (mounted) {
      if (success) {
        AppToastService.success(
          context,
          completed
              ? LearningRoadmapConstants.toastStepCompleted
              : LearningRoadmapConstants.toastStepUpdated,
        );
      } else {
        AppToastService.error(
          context,
          LearningRoadmapConstants.toastToggleError,
        );
      }
    }
  }
}
