import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';

class HomePageState extends BasePageState {
  final AppLoadState loadState;
  final int currentIndex;

  HomePageState({
    this.loadState = AppLoadState.idle,
    this.currentIndex = 0,
    super.isLockedPage,
  });

  @override
  HomePageState updateState({
    AppLoadState? loadState,
    int? currentIndex,
    bool? isLockedPage,
  }) {
    return HomePageState(
      loadState: loadState ?? this.loadState,
      currentIndex: currentIndex ?? this.currentIndex,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }
}

class HomePageModel extends BasePageModel<HomePageState> {
  HomePageModel() : super(HomePageState(loadState: AppLoadState.idle));

  void changeTab(int index) {
    state = state.updateState(currentIndex: index);
  }
}

final homePageProvider = StateNotifierProvider<HomePageModel, HomePageState>(
  (ref) => HomePageModel(),
);

class HomePage extends BasePage<HomePageModel, HomePageState> {
  const HomePage({super.key}) : super(provider: homePageProvider);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageConsumerState<HomePageModel, HomePageState> {
  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    return Scaffold(
      appBar: AppBar(title: const Text('Solo Quest')),
      body: IndexedStack(
        index: state.currentIndex,
        children: const [
          Center(child: Text('Home Tab')),
          Center(child: Text('Profile Tab')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.currentIndex,
        onTap: pageModel.changeTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
