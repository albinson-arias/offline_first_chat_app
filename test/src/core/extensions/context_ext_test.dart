import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/src/core/extensions/context_ext.dart';

void main() {
  group('ContextExt', () {
    testWidgets('theme extension returns correct ThemeData',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: const Color(0xff2196f3)),
          home: Builder(
            builder: (context) {
              final theme = context.theme; // Using the extension

              return Scaffold(
                body: Center(
                  child: Text('Primary color: ${theme.primaryColor}'),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the primary color from ThemeData is correct
      expect(
        find.text('Primary color: Color(0xff2196f3)'),
        findsOneWidget,
      ); // Colors.blue
    });

    testWidgets('textTheme extension returns correct TextTheme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.red)),
          ),
          home: Builder(
            builder: (context) {
              final textTheme = context.textTheme; // Using the extension

              return Scaffold(
                body: Center(
                  child: Text(
                    'Test Text',
                    style: textTheme.bodyLarge,
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the text is displayed with the
      // correct style from the TextTheme
      final text = tester.widget<Text>(find.text('Test Text'));
      expect(text.style?.color, equals(Colors.red));
    });
  });
}
