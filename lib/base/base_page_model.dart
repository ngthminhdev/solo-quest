import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base_page_state.dart';

abstract class BasePageModel<S extends BasePageState> extends StateNotifier<S> {
  BasePageModel(super.state);

  S get readState => state;
}
