import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../routes/routes_config.dart';

class SplashPageState extends BasePageState {
  final AppLoadState loadState;

  SplashPageState({
    this.loadState = AppLoadState.idle,
    super.isLockedPage,
  });

  @override
  SplashPageState updateState({
    AppLoadState? loadState,
    bool? isLockedPage,
  }) {
    return SplashPageState(
      loadState: loadState ?? this.loadState,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }
}

class SplashPageModel extends BasePageModel<SplashPageState> {
  SplashPageModel() : super(SplashPageState(loadState: AppLoadState.idle));

  Future<void> initialize() async {
    state = state.updateState(loadState: AppLoadState.loading);

    try {
      // TODO: Add initialization logic (check auth, load config, etc.)
      await Future.delayed(const Duration(seconds: 2));

      state = state.updateState(loadState: AppLoadState.ready);
    } catch (e) {
      state = state.updateState(loadState: AppLoadState.error);
    }
  }
}

final splashPageProvider = StateNotifierProvider<SplashPageModel, SplashPageState>(
  (ref) => SplashPageModel(),
);

class SplashPage extends BasePage<SplashPageModel, SplashPageState> {
  SplashPage({super.key}) : super(provider: splashPageProvider);

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends BasePageConsumerState<SplashPageModel, SplashPageState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.initialize();
    });
  }

  @override
  void onBuild() {
    listen((previous, next) {
      if (next.loadState == AppLoadState.ready) {
        Navigator.of(context).pushReplacementNamed(RoutesConfig.main);
      }
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Solo Quest', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
