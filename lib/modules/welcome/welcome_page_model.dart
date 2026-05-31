import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';

class WelcomePageState extends BasePageState {
  final AppLoadState loadState;

  WelcomePageState({
    this.loadState = AppLoadState.idle,
    super.isLockedPage,
  });

  @override
  WelcomePageState updateState({
    AppLoadState? loadState,
    bool? isLockedPage,
  }) {
    return WelcomePageState(
      loadState: loadState ?? this.loadState,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }
}

class WelcomePageModel extends BasePageModel<WelcomePageState> {
  WelcomePageModel() : super(WelcomePageState());
}

final welcomePageProvider =
    StateNotifierProvider<WelcomePageModel, WelcomePageState>((ref) {
  return WelcomePageModel();
});
