import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';

import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../extensions/localization_extension.dart';
import '../../constants/app_color.dart';
import '../../widgets/app_bottom_nav/app_bottom_nav.dart';
import '../../widgets/page_header/page_header.dart';
import 'main_page_model.dart';
import '../../core/timer/countdown_session.dart';
import '../../core/timer/countdown_timer_service.dart';
import '../../widgets/app_dialog/timer_completion_dialog.dart';
import '../../widgets/app_dialog/reminder_dialog.dart';
import '../../core/notifications/fcm_notification_payload.dart';
import '../../services/service_providers.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import '../../routes/routes_config.dart';

class MainPage extends BasePage<MainPageModel, MainPageState> {
  MainPage({super.key}) : super(provider: mainPageProvider);

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState
    extends BasePageConsumerState<MainPage, MainPageModel, MainPageState> {
  late final PageController _pageController;
  DateTime? _lastNavTime;
  bool _pendingReminderScheduled = false;

  @override
  void initState() {
    super.initState();
    final initialTab = ref.read(mainPageProvider).selectedIndex;
    _pageController = PageController(initialPage: initialTab);
    ref.read(mainPageProvider.notifier).setPageController(_pageController);
  }

  @override
  void dispose() {
    try {
      ref.read(mainPageProvider.notifier).clearPageController(_pageController);
    } catch (_) {
      // Ignore if ref/container is already disposed
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  void onBuild() {
    super.onBuild();
    
    // Check initial pending reminder — guard with flag to avoid duplicate dialogs on rebuild
    final initialPending = ref.read(pendingReminderProvider);
    if (initialPending != null && !_pendingReminderScheduled) {
      _pendingReminderScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pendingReminderScheduled = false;
        if (mounted) {
          _showReminderPrompt(context, initialPending);
          ref.read(pendingReminderProvider.notifier).state = null;
        }
      });
    }

    // Listen to pending reminder prompts
    ref.listen<FcmNotificationPayload?>(
      pendingReminderProvider,
      (previous, next) {
        if (next != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showReminderPrompt(context, next);
              ref.read(pendingReminderProvider.notifier).state = null;
            }
          });
        }
      },
    );

    ref.listen<CountdownSession?>(countdownTimerServiceProvider, (previous, next) {
      if (next != null && next.status == CountdownStatus.expired && previous?.status != CountdownStatus.expired) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showTimerCompletionDialog(next);
        });
      }
    });
  }

  void _showTimerCompletionDialog(CountdownSession session) {
    final l10n = context.l10n;
    if (session.questId == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.reminderBreakFinished),
          content: Text(session.title),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(ctx, rootNavigator: true).pop();
                await ref.read(countdownTimerServiceProvider.notifier).completeSession();
              },
              child: Text(l10n.commonClose),
            ),
          ],
        ),
      );
      return;
    }

    TimerCompletionDialog.show(
      context: context,
      questId: session.questId!,
      questTitle: session.title,
      onComplete: () async {
        await ref.read(countdownTimerServiceProvider.notifier).completeSession();
      },
      onCancel: () {
        ref.read(countdownTimerServiceProvider.notifier).cancelSession();
      },
    );
  }

  Widget _buildActiveTimerBanner() {
    final countdownSession = ref.watch(countdownTimerServiceProvider);
    if (countdownSession == null || countdownSession.status != CountdownStatus.running) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final remaining = ref.read(countdownTimerServiceProvider.notifier).getRemainingTime();
    final minutesStr = remaining.inMinutes.toString().padLeft(2, '0');
    final secondsStr = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    final timeStr = '$minutesStr:$secondsStr';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s10),
      decoration: BoxDecoration(
        color: AppColor.bgRaised,
        border: const Border(
          top: BorderSide(color: AppColor.borderGlowCyan),
          bottom: BorderSide(color: AppColor.border),
        ),
      ),
      child: Row(
        children: [
          const Icon(RemixIcons.time_line, color: AppColor.cyan, size: 18),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  countdownSession.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.fg,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${l10n.timerRemaining}: $timeStr',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColor.cyan,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          // "Mở" button
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                RoutesConfig.questDetail,
                arguments: {'id': countdownSession.questId},
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColor.cyan,
              side: const BorderSide(color: AppColor.borderGlowCyan),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: 0),
              minimumSize: const Size(0, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            child: Text(
              l10n.timerOpen,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          // "Hoàn thành" button
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(countdownTimerServiceProvider.notifier).completeSession();
                if (mounted) {
                  AppToastService.success(context, l10n.statusCompleted);
                }
              } catch (_) {
                if (mounted) {
                  AppToastService.error(context, 'Không thể hoàn thành nhiệm vụ');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.success,
              foregroundColor: AppColor.bgDeep,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: 0),
              minimumSize: const Size(0, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              elevation: 0,
            ),
            child: Text(
              l10n.timerComplete,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget renderPage(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Fixed Header
          _buildHeader(),

          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                read.listOfPages.length,
                (index) => KeyedSubtree(
                  key: ValueKey('main-tab-$index'),
                  child: read.listOfPages[index],
                ),
              ),
            ),
          ),

          // Active Timer Banner (persists across all pages/tabs)
          _buildActiveTimerBanner(),
        ],
      ),
      bottomNavigationBar: _buildNavbar(),
    );
  }

  Widget _buildHeader() {
    final selectedIndex = read.selectedIndex;
    final l10n = context.l10n;

    IconData icon;
    String title;

    switch (selectedIndex) {
      case 0:
        icon = RemixIcons.home_3_line;
        title = l10n.headerHome;
        break;
      case 1:
        icon = RemixIcons.file_text_line;
        title = l10n.headerLogs;
        break;
      case 2:
        icon = RemixIcons.bar_chart_2_line;
        title = l10n.headerProgress;
        break;
      case 3:
        icon = RemixIcons.route_line;
        title = l10n.headerLearning;
        break;
      case 4:
        icon = RemixIcons.user_3_line;
        title = l10n.headerProfile;
        break;
      default:
        icon = RemixIcons.home_3_line;
        title = l10n.headerHome;
    }

    return PageHeader(
      icon: icon,
      title: title,
    );
  }

  Widget _buildNavbar() {
    return AppBottomNav(
      currentTab: AppTab.values[read.selectedIndex],
      onTap: (tab) {
        final now = DateTime.now();
        if (_lastNavTime != null &&
            now.difference(_lastNavTime!).inMilliseconds < 350) {
          return;
        }
        _lastNavTime = now;

        final index = AppTab.values.indexOf(tab);
        pageModel.onNavbarChange(index, _pageController);
      },
    );
  }

  void _showReminderPrompt(BuildContext context, FcmNotificationPayload payload) {
    ReminderDialog.showReminderPrompt(context, payload, ref);
  }
}

