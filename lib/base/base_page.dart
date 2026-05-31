import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base_page_model.dart';
import 'base_page_state.dart';

abstract class BasePage<T extends BasePageModel<S>, S extends BasePageState>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<T, S> provider;

  BasePage({super.key, required this.provider});

  BasePage.autoDispose({super.key, required AutoDisposeStateNotifierProvider<T, S> provider})
      : provider = StateNotifierProvider<T, S>((ref) {
          final notifier = ref.watch(provider.notifier);
          return notifier;
        });
}
