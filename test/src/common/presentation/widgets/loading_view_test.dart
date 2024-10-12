import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/src/common/presentation/widgets/loading_view.dart';

void main() {
  group('LoadingView Widget Tests', () {
    testWidgets('should display a CircularProgressIndicator',
        (WidgetTester tester) async {
      // Arrange: Pump the LoadingView widget into the widget tree.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingView(),
          ),
        ),
      );

      // Act & Assert: Check if CircularProgressIndicator is displayed.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should center the CircularProgressIndicator',
        (WidgetTester tester) async {
      // Arrange: Pump the LoadingView widget into the widget tree.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingView(),
          ),
        ),
      );

      // Act & Assert: Check if the CircularProgressIndicator is
      // wrapped in a Center widget.
      expect(find.byType(Center), findsOneWidget);
    });
  });
}
