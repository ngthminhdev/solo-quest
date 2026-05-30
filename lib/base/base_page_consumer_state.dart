import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base_page.dart';
import 'base_page_model.dart';
import 'base_page_state.dart';

abstract class BasePageConsumerState<T extends BasePageModel<S>, S extends BasePageState>
    extends ConsumerState<BasePage<T, S>> with AutomaticKeepAliveClientMixin {
  T get pageModel => ref.read(widget.provider.notifier);
  S get read => ref.read(widget.provider);

  void listen(void Function(S? previous, S next) listener) {
    ref.listen(widget.provider, listener);
  }

  Widget renderPage(BuildContext context);

  void onBuild() {}

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    onBuild();
    return renderPage(context);
  }
}
