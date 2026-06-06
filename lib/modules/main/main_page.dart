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

class MainPage extends BasePage<MainPageModel, MainPageState> {
  MainPage({super.key}) : super(provider: mainPageProvider);

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState
    extends BasePageConsumerState<MainPage, MainPageModel, MainPageState> {
  late final PageController _pageController;
  DateTime? _lastNavTime;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      titleStyle: selectedIndex == 2
          ? const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColor.white,
            )
          : null,
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
}
