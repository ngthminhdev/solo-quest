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

  void onNavbarChange(int index, PageController pageController) {
    // Cancel any pending settle timer
    _settleTimer?.cancel();

    // Mark as unsettled during animation — prevents intermediate pages from loading
    state = state.updateState(selectedIndex: index, settledIndex: -1);

    // Always animate for smooth scroll experience
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // After animation completes, mark the target page as settled so its API fires
    _settleTimer = Timer(const Duration(milliseconds: 350), () {
      state = state.updateState(settledIndex: index);
    });
  }

  @override
  void dispose() {
    _settleTimer?.cancel();
    super.dispose();
  }
}

final mainPageProvider = StateNotifierProvider<MainPageModel, MainPageState>(
  (ref) => MainPageModel(),
);
