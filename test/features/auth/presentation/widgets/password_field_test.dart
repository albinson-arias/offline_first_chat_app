import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/features/auth/presentation/widgets/password_field.dart';

// Mocking external dependencies
final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

extension BoolToggle on bool {
  bool toggle() => !this;
}

void main() {
  group('PasswordField Widget Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    testWidgets('initially hides password', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PasswordField(
              passwordController: controller,
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
      );

      // Verify the visibility icon is initially displayed
      // (which means the password is hidden)
      final visibilityIconFinder = find.byIcon(Icons.visibility);
      expect(visibilityIconFinder, findsOneWidget);
    });

    testWidgets('toggles password visibility when icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PasswordField(
              passwordController: controller,
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
      );

      // Initially, the icon should be 'visibility'
      // indicating that the password is hidden
      final visibilityIconFinder = find.byIcon(Icons.visibility);
      expect(visibilityIconFinder, findsOneWidget);

      // Tap the visibility icon
      await tester.tap(visibilityIconFinder);
      await tester.pumpAndSettle();

      // Now the icon should be 'visibility_off'
      // indicating that the password is visible
      final visibilityOffIconFinder = find.byIcon(Icons.visibility_off);
      expect(visibilityOffIconFinder, findsOneWidget);
    });

    testWidgets('validator returns "Required" when input is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Form(
              child: PasswordField(
                passwordController: controller,
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
        ),
      );

      final formFieldFinder = find.byType(TextFormField);
      final formFieldState =
          tester.state<FormFieldState<String>>(formFieldFinder);
      expect(formFieldState.validate(), isFalse);
      expect(formFieldState.errorText, equals('Required'));
    });

    testWidgets('validator returns error when password does not match regex',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Form(
              child: PasswordField(
                passwordController: controller,
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
        ),
      );

      controller.text = 'short';
      await tester.pump();

      final formFieldFinder = find.byType(TextFormField);
      final formFieldState =
          tester.state<FormFieldState<String>>(formFieldFinder);
      expect(formFieldState.validate(), isFalse);
      expect(
        formFieldState.errorText,
        equals('Minimum of eight characters, one letter and one number'),
      );
    });

    testWidgets('validator passes when password is valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Form(
              child: PasswordField(
                passwordController: controller,
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
        ),
      );

      controller.text = 'Password123';
      await tester.pump();

      final formFieldFinder = find.byType(TextFormField);
      final formFieldState =
          tester.state<FormFieldState<String>>(formFieldFinder);
      expect(formFieldState.validate(), isTrue);
      expect(formFieldState.errorText, isNull);
    });

    testWidgets('calls onSubmitted when field is submitted',
        (WidgetTester tester) async {
      var onSubmittedCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: PasswordField(
              passwordController: controller,
              textInputAction: TextInputAction.done,
              onSubmitted: () {
                onSubmittedCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Password123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(onSubmittedCalled, isTrue);
    });
  });
}
