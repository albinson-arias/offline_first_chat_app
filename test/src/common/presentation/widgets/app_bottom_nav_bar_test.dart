import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/src/common/presentation/cubits/bottom_nav_bar_cubit.dart';
import 'package:offline_first_chat_app/src/common/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';

import '../../../../test_utils/common_mocks.dart';
import '../../../../test_utils/utils.dart';

class MockBottomNavBarCubit extends Mock implements BottomNavBarCubit {}

void main() {
  late MockBottomNavBarCubit mockBottomNavBarCubit;
  late MockGoRouter mockGoRouter;

  setUp(() async {
    mockBottomNavBarCubit = MockBottomNavBarCubit();
    mockGoRouter = MockGoRouter();
    await sl.reset();
    sl.registerFactory<BottomNavBarCubit>(() => mockBottomNavBarCubit);
  });

  group('AppBottomNavigationBar Tests', () {
    testWidgets('should display all bottom navigation bar icons',
        (WidgetTester tester) async {
      when(() => mockBottomNavBarCubit.state).thenReturn(0);
      when(() => mockBottomNavBarCubit.stream).thenAnswer(
        (_) => Stream.value(0),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BottomNavBarCubit>.value(
            value: mockBottomNavBarCubit,
            child: const Scaffold(
              bottomNavigationBar: AppBottomNavigationBar(),
            ),
          ),
        ),
      );

      // Check if the home, new chat, and profile icons are present
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(
        find.byType(HugeIcon),
        findsNWidgets(2),
      ); // Home and Profile HugeIcons
    });

    testWidgets('should navigate to home when home icon is tapped',
        (WidgetTester tester) async {
      when(() => mockBottomNavBarCubit.state).thenReturn(1);
      when(() => mockBottomNavBarCubit.stream).thenAnswer(
        (_) => Stream.value(0),
      );
      when(() => mockGoRouter.goNamed(any())).thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: MockGoRouterProvider(
            goRouter: mockGoRouter,
            child: BlocProvider<BottomNavBarCubit>.value(
              value: mockBottomNavBarCubit,
              child: const Scaffold(
                bottomNavigationBar: AppBottomNavigationBar(),
              ),
            ),
          ),
        ),
      );

      // Simulate tapping the home icon
      await tester
          .tap(find.byKey(const Key('AppBottomNavigationBar-home')).first);
      await tester.pumpAndSettle();

      // Verify that navigation to the home route occurred
      verify(() => mockGoRouter.goNamed(AppRoutes.rooms.name)).called(1);
      verify(() => mockBottomNavBarCubit.navigateToHome()).called(1);
    });

    testWidgets('should navigate to profile when profile icon is tapped',
        (WidgetTester tester) async {
      when(() => mockBottomNavBarCubit.state).thenReturn(0);
      when(() => mockBottomNavBarCubit.stream).thenAnswer(
        (_) => Stream.value(0),
      );
      when(() => mockGoRouter.goNamed(any())).thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: MockGoRouterProvider(
            goRouter: mockGoRouter,
            child: BlocProvider<BottomNavBarCubit>.value(
              value: mockBottomNavBarCubit,
              child: const Scaffold(
                bottomNavigationBar: AppBottomNavigationBar(),
              ),
            ),
          ),
        ),
      );

      // Simulate tapping the home icon
      await tester
          .tap(find.byKey(const Key('AppBottomNavigationBar-profile')).first);
      await tester.pumpAndSettle();

      // Verify that navigation to the home route occurred
      verify(() => mockGoRouter.goNamed(AppRoutes.profile.name)).called(1);
      verify(() => mockBottomNavBarCubit.navigateToProfile()).called(1);
    });

    testWidgets('should navigate to contacts when new chat icon is tapped',
        (WidgetTester tester) async {
      when(() => mockBottomNavBarCubit.state).thenReturn(0);
      when(() => mockBottomNavBarCubit.stream).thenAnswer(
        (_) => Stream.value(0),
      );
      when(() => mockGoRouter.pushNamed(any())).thenAnswer((_) async {
        return null;
      });

      await tester.pumpWidget(
        MaterialApp(
          home: MockGoRouterProvider(
            goRouter: mockGoRouter,
            child: BlocProvider<BottomNavBarCubit>.value(
              value: mockBottomNavBarCubit,
              child: const Scaffold(
                bottomNavigationBar: AppBottomNavigationBar(),
              ),
            ),
          ),
        ),
      );

      // Simulate tapping the new chat icon
      await tester.tap(find.text('New Chat').first);
      await tester.pumpAndSettle();

      // Verify that navigation to the contact route occurred
      verify(() => mockGoRouter.pushNamed(AppRoutes.contacts.name)).called(1);
    });

    testWidgets('should highlight correct icon based on the current state',
        (WidgetTester tester) async {
      when(() => mockBottomNavBarCubit.state).thenReturn(1);
      when(() => mockBottomNavBarCubit.stream).thenAnswer(
        (_) => Stream.value(0),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BottomNavBarCubit>.value(
            value: mockBottomNavBarCubit,
            child: const Scaffold(
              bottomNavigationBar: AppBottomNavigationBar(),
            ),
          ),
        ),
      );

      // Verify that the profile icon is highlighted (in blue color)
      final profileIcon = find.byType(HugeIcon).last;
      final profileHugeIcon = tester.widget<HugeIcon>(profileIcon);
      expect(profileHugeIcon.color, equals(Colors.blue));
    });
  });
}
