import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../home/home_page.dart';
import '../logs/logs_page.dart';
import '../progress/progress_page.dart';
import '../learning_roadmap/learning_roadmap_page.dart';
import '../profile/profile_page.dart';

class MainPageState extends BasePageState {
  final List<Widget> listOfPages;
  final int selectedIndex;
  final int settledIndex;

  MainPageState({
    required this.listOfPages,
    required this.selectedIndex,
    this.settledIndex = 0,
    super.isLockedPage,
  });

  @override
  MainPageState updateState({
    List<Widget>? listOfPages,
    int? selectedIndex,
    int? settledIndex,
    bool? isLockedPage,
  }) {
    return MainPageState(
      listOfPages: listOfPages ?? this.listOfPages,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      settledIndex: settledIndex ?? this.settledIndex,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }
}

class MainPageModel extends BasePageModel<MainPageState> {
  Timer? _settleTimer;
  PageController? _pageController;

  MainPageModel()
      : super(MainPageState(
          listOfPages: [
            HomePage(),
            LogsPage(),
            ProgressPage(),
            LearningRoadmapPage(),
            ProfilePage(),
          ],
          selectedIndex: 0,
          settledIndex: 0,
        ));

  int get settledIndex => state.settledIndex;

  void setPageController(PageController controller) {
    _pageController = controller;
  }

  void clearPageController(PageController controller) {
    if (_pageController == controller) {
      _pageController = null;
    }
  }

  void goToTab(int index, {bool animate = true}) {
    _settleTimer?.cancel();

    state = state.updateState(selectedIndex: index, settledIndex: -1);

    final controller = _pageController;
    if (controller != null && controller.hasClients) {
      if (animate) {
        controller.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        controller.jumpToPage(index);
      }
    }

    _settleTimer = Timer(const Duration(milliseconds: 350), () {
      state = state.updateState(settledIndex: index);
    });
  }

  void onNavbarChange(int index, PageController pageController) {
    goToTab(index, animate: true);
  }

  @override
  void dispose() {
    _settleTimer?.cancel();
    _pageController = null;
    super.dispose();
  }
}

final mainPageProvider = StateNotifierProvider<MainPageModel, MainPageState>(
  (ref) => MainPageModel(),
);
