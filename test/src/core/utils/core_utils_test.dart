import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/src/core/utils/core_utils.dart';

void main() {
  testWidgets('showSnackBar displays a snackbar with the correct message',
      (WidgetTester tester) async {
    // Create a Scaffold to test showSnackBar, as it requires a Scaffold context
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () {
                  CoreUtils.showSnackBar(context, 'Test message');
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        ),
      ),
    );

    // Tap the button to trigger the snackbar
    await tester.tap(find.text('Show SnackBar'));
    await tester.pump(); // Trigger the snackbar animation

    // Verify if the snackbar appears with the correct message
    expect(find.text('Test message'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('showLoadingDialog displays a CircularProgressIndicator',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () {
                  CoreUtils.showLoadingDialog(context);
                },
                child: const Text('Show Loading Dialog'),
              ),
            ),
          ),
        ),
      ),
    );

    // Tap the button to show the loading dialog
    await tester.tap(find.text('Show Loading Dialog'));
    await tester.pump(); // Show the dialog

    // Verify that the dialog with CircularProgressIndicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
