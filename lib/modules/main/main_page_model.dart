import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../home/home_page.dart';
import '../logs/logs_page.dart';
import '../progress/progress_page.dart';
import '../rewards/rewards_page.dart';
import '../profile/profile_page.dart';

class MainPageState extends BasePageState {
  final List<Widget> listOfPages;
  final int selectedIndex;

  MainPageState({
    required this.listOfPages,
    required this.selectedIndex,
    super.isLockedPage,
  });

  @override
  MainPageState updateState({
    List<Widget>? listOfPages,
    int? selectedIndex,
    bool? isLockedPage,
  }) {
    return MainPageState(
      listOfPages: listOfPages ?? this.listOfPages,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }
}

class MainPageModel extends BasePageModel<MainPageState> {
  MainPageModel()
      : super(MainPageState(
          listOfPages: [
            HomePage(),
            LogsPage(),
            ProgressPage(),
            RewardsPage(),
            ProfilePage(),
          ],
          selectedIndex: 0,
        ));

  void onNavbarChange(int index, PageController pageController) {
    state = state.updateState(selectedIndex: index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

final mainPageProvider = StateNotifierProvider<MainPageModel, MainPageState>(
  (ref) => MainPageModel(),
);
