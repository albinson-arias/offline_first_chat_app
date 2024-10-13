import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:offline_first_chat_app/features/auth/presentation/views/register_screen.dart';
import 'package:offline_first_chat_app/features/auth/presentation/widgets/password_field.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';
import 'package:record_result/record_result.dart';

import '../../../../test_utils/common_mocks.dart';
import '../../../../test_utils/utils.dart';
import 'mocks.dart';

void main() {
  late MockAuthCubit mockAuthCubit;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    mockGoRouter = MockGoRouter();
  });

  tearDown(() {
    mockAuthCubit.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MockGoRouterProvider(
        goRouter: mockGoRouter,
        child: BlocProvider<AuthCubit>(
          create: (_) => mockAuthCubit,
          child: const RegisterPage(),
        ),
      ),
    );
  }

  const registerButtonKey = Key('RegisterScreen-register_button');
  final registerButton = find.byKey(registerButtonKey);

  group('RegisterPage Widget Tests', () {
    testWidgets('displays validation errors if inputs are invalid',
        (WidgetTester tester) async {
      when(
        () => mockAuthCubit.state,
      ).thenReturn(
        AuthInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Try to submit with invalid fields
      await tester.tap(registerButton);
      await tester.pump();

      // Expect validation error for required fields
      expect(
        find.text('Required'),
        findsNWidgets(3),
      ); // email and username required
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
      await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');

      await tester.tap(registerButton);
      await tester.pump();

      // Expect email validation error
      expect(find.text('The email is not valid'), findsOneWidget);
    });

    testWidgets('calls signUp on AuthCubit when form is valid',
        (WidgetTester tester) async {
      when(
        () => mockAuthCubit.state,
      ).thenReturn(
        AuthInitial(),
      );
      when(
        () => mockAuthCubit.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          username: any(named: 'username'),
        ),
      ).thenAnswer((_) async {
        return;
      });

      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid values
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@example.com',
      ); // email
      await tester.enterText(
        find.byType(PasswordField),
        'Password123',
      ); // password
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'testuser',
      ); // username

      // Submit the form
      await tester.tap(registerButton);
      await tester.pump();

      // Verify that signUp was called with correct arguments
      verify(
        () => mockAuthCubit.signUp(
          email: 'test@example.com',
          password: 'Password123',
          username: 'testuser',
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
      expect(
        find.text('500: Sign-up failed'),
        findsOneWidget,
      );
    });

    testWidgets(
        'navigates to login page when "I already have an account" is pressed',
        (WidgetTester tester) async {
      when(
        () => mockAuthCubit.state,
      ).thenReturn(
        AuthInitial(),
      );
      when(
        () => mockGoRouter.pushNamed(
          any(),
        ),
      ).thenAnswer(
        (realInvocation) async {
          return null;
        },
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Tap the "I already have an account" button
      final loginButton = find.text('I already have an account');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify navigation to the login page
      verify(() => mockGoRouter.pushNamed(AppRoutes.login.name)).called(1);
    });

    testWidgets('triggers signUp when username field is submitted via keyboard',
        (WidgetTester tester) async {
      when(
        () => mockAuthCubit.state,
      ).thenReturn(
        AuthInitial(),
      );
      when(
        () => mockAuthCubit.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          username: any(named: 'username'),
        ),
      ).thenAnswer((_) async {
        return;
      });

      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid values for email and password
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@example.com',
      ); // email
      await tester.enterText(
        find.byType(PasswordField),
        'Password123',
      ); // password

      // Enter valid username and trigger submit via keyboard
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'testuser',
      ); // username
      await tester.testTextInput
          .receiveAction(TextInputAction.done); // Simulate 'done' press
      await tester.pump();

      // Verify signUp was called
      verify(
        () => mockAuthCubit.signUp(
          email: 'test@example.com',
          password: 'Password123',
          username: 'testuser',
        ),
      ).called(1);
    });
  });
}
