import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:offline_first_chat_app/features/auth/presentation/views/login_screen.dart';
import 'package:offline_first_chat_app/features/auth/presentation/widgets/password_field.dart';
import 'package:record_result/record_result.dart';

import 'mocks.dart';

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
  });

  tearDown(() {
    mockAuthCubit.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthCubit>(
        create: (_) => mockAuthCubit,
        child: const LoginScreen(),
      ),
    );
  }

  final emailField = find.byKey(const Key('LoginScreen-email_field'));
  final passwordField = find.byType(PasswordField);
  final loginButton = find.text('Login');

  group('LoginScreen Widget Tests', () {
    testWidgets('displays validation errors if email or password are invalid',
        (WidgetTester tester) async {
      when(
        () => mockAuthCubit.state,
      ).thenReturn(
        AuthInitial(),
      );
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(loginButton);
      await tester.pump();

      // Expect validation error for both fields
      expect(find.text('Required'), findsNWidgets(2)); // Email and password
    });

    testWidgets('displays error for invalid email',
        (WidgetTester tester) async {
      when(
        () => mockAuthCubit.state,
      ).thenReturn(
        AuthInitial(),
      );
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter invalid email
      await tester.enterText(
        emailField,
        'invalid-email',
      );
      await tester.tap(loginButton);
      await tester.pump();

      // Expect email validation error
      expect(find.text('The email is not valid'), findsOneWidget);
    });

    testWidgets('calls signIn on AuthCubit when form is valid',
        (WidgetTester tester) async {
      when(
        () => mockAuthCubit.state,
      ).thenReturn(
        AuthInitial(),
      );
      when(
        () => mockAuthCubit.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid values
      await tester.enterText(
        emailField,
        'test@example.com',
      ); // email
      await tester.enterText(
        passwordField,
        'Password123',
      ); // password

      // Submit the form
      await tester.tap(loginButton);
      await tester.pump();

      // Verify that signIn was called with correct arguments
      verify(
        () => mockAuthCubit.signIn(
          email: 'test@example.com',
          password: 'Password123',
        ),
      ).called(1);
    });

    testWidgets('displays error message on AuthError state',
        (WidgetTester tester) async {
      whenListen(
        mockAuthCubit,
        Stream.fromIterable([
          AuthError(
            ServerFailure(message: 'Sign-up failed', statusCode: '500'),
          ),
        ]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify snackbar with error message appears
      expect(find.text('500: Sign-up failed'), findsOneWidget);
    });

    testWidgets('displays CircularProgressIndicator when in AuthLoading state',
        (WidgetTester tester) async {
      when(
        () => mockAuthCubit.state,
      ).thenReturn(
        AuthLoading(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Expect CircularProgressIndicator
      // to be displayed inside the login button
      expect(
        find.byKey(const Key('LoginScreen-loading_button')),
        findsOneWidget,
      );
    });

    testWidgets('triggers signIn when password field is submitted via keyboard',
        (WidgetTester tester) async {
      when(
        () => mockAuthCubit.state,
      ).thenReturn(
        AuthInitial(),
      );
      when(
        () => mockAuthCubit.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid email and password
      await tester.enterText(
        emailField,
        'test@example.com',
      ); // email
      await tester.enterText(
        passwordField,
        'Password123',
      ); // password

      // Submit the password field via keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Verify that signIn was called
      verify(
        () => mockAuthCubit.signIn(
          email: 'test@example.com',
          password: 'Password123',
        ),
      ).called(1);
    });
  });
}
