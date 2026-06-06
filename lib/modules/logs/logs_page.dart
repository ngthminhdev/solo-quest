import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/skeleton/skeleton_logs_page.dart';
import '../../extensions/localization_extension.dart';
import '../main/main_page_model.dart';
import 'logs_page_model.dart';
import 'widgets/logs_summary_card.dart';
import 'widgets/logs_filter_bar.dart';
import 'widgets/logs_timeline_section.dart';
import 'widgets/log_detail_bottom_sheet.dart';

class LogsPage extends BasePage<LogsPageModel, LogsPageState> {
  LogsPage({super.key}) : super(provider: logsPageProvider);

  @override
  ConsumerState<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState
    extends BasePageConsumerState<LogsPage, LogsPageModel, LogsPageState> {
  static const _tabIndex = 1;
  bool _settleListenerSet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryLoadIfSettled();
    });
  }

  void _tryLoadIfSettled() {
    final settled = ref.read(mainPageProvider.select((s) => s.settledIndex));
    if (settled == _tabIndex) {
      pageModel.loadLogs();
    }
  }

  @override
  void onBuild() {
    if (!_settleListenerSet) {
      _settleListenerSet = true;
      ref.listen(mainPageProvider.select((s) => s.settledIndex), (prev, next) {
        if (next == _tabIndex && prev != _tabIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pageModel.loadLogs();
          });
        }
      });
    }

    listen((previous, next) {
      if (previous?.loadState == AppLoadState.loading &&
          next.loadState == AppLoadState.error &&
          next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColor.danger,
          ),
        );
      }
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    if (state.loadState == AppLoadState.loading && !state.hasLogs) {
      return AppScaffold(
        showBottomNav: false,
        body: const SkeletonLogsPage(),
      );
    }

    if (state.loadState == AppLoadState.error && !state.hasLogs) {
      return AppScaffold(
        showBottomNav: false,
        body: AppErrorState(
          message: state.errorMessage ?? context.l10n.logsError,
          onRetry: pageModel.loadLogs,
        ),
      );
    }

    return AppScaffold(
      showBottomNav: false,
      scroll: false,
      body: RefreshIndicator(
        color: AppColor.cyan,
        backgroundColor: AppColor.bgRaised,
        onRefresh: pageModel.refreshLogs,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: LogsSummaryCard(
                totalLogs: state.totalLogCount,
                completedQuests: state.completedQuestCount,
                skippedQuests: state.skippedQuestCount,
                earnedExp: state.earnedExp,
              ),
            ),
            SliverToBoxAdapter(
              child: LogsFilterBar(
                selectedDate: state.selectedDate,
                selectedType: state.selectedType,
                onDateChanged: pageModel.selectDate,
                onTypeChanged: pageModel.selectType,
                onClearFilter: pageModel.clearFilter,
              ),
            ),
            SliverToBoxAdapter(
              child: LogsTimelineSection(
                logs: state.filteredLogs,
                onLogTap: _handleLogTap,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogTap(log) {
    LogDetailBottomSheet.show(context, log: log);
  }
}
