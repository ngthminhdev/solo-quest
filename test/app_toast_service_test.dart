import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/widgets/app_toast/app_toast_service.dart';

void main() {
  testWidgets('AppToastService.show can find Overlay when using Navigator context', (WidgetTester tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        home: const Scaffold(
          body: Center(
            child: Text('Test'),
          ),
        ),
      ),
    );

    // Get the navigator context (which is the context of the Navigator widget itself)
    final navigatorContext = navigatorKey.currentContext!;

    // This should not throw "No Overlay widget found"
    AppToastService.success(navigatorContext, 'Success message');

    // Rebuild to let the toast animate and render
    await tester.pump();
    
    // Verify that the toast message is displayed
    expect(find.text('Success message'), findsOneWidget);
  });
}
