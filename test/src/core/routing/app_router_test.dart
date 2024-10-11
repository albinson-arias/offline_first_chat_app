import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/local_auth_state.dart';
import 'package:offline_first_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offline_first_chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:offline_first_chat_app/features/auth/presentation/views/register_screen.dart';
import 'package:offline_first_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:offline_first_chat_app/features/chat/presentation/cubits/rooms_cubit/rooms_cubit.dart';
import 'package:offline_first_chat_app/features/chat/presentation/views/rooms_page.dart';
import 'package:offline_first_chat_app/src/common/presentation/cubits/bottom_nav_bar_cubit.dart';
import 'package:offline_first_chat_app/src/core/routing/app_router.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockChatRepository mockChatRepository;

  setUpAll(() {
    GetIt.instance.registerFactory(
      () => AuthCubit(authRepository: mockAuthRepository),
    );
    GetIt.instance.registerFactory(
      () => RoomsCubit(chatRepository: mockChatRepository),
    );
    GetIt.instance.registerFactory(
      BottomNavBarCubit.new,
    );
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockChatRepository = MockChatRepository();
  });

  group('GoRouter Tests', () {
    testWidgets('should redirect to register screen when signed out',
        (tester) async {
      // Arrange
      when(() => mockAuthRepository.authStateChanges()).thenAnswer(
        (_) => Stream.value(LocalAuthState.signedOut),
      );

      // Build the GoRouter using the mock repository
      final router = getRouter(mockAuthRepository);

      // Act
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Check that we're redirected to the register screen
      expect(find.byType(RegisterPage), findsOneWidget);
    });

    testWidgets(
        'should redirect to login screen when signed out '
        'and trying to access rooms', (tester) async {
      // Arrange
      when(() => mockAuthRepository.authStateChanges()).thenAnswer(
        (_) => Stream.value(LocalAuthState.signedOut),
      );

      // Build the GoRouter using the mock repository
      final router = getRouter(mockAuthRepository);

      // Act
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      await tester.pumpAndSettle();

      // Try to navigate to rooms
      router.goNamed(AppRoutes.rooms.name);
      await tester.pumpAndSettle();

      // Assert: Check that we're redirected to the register screen
      expect(find.byType(RegisterPage), findsOneWidget);
    });

    testWidgets('should navigate to rooms screen when signed in',
        (tester) async {
      await tester.runAsync(() async {
        // Arrange
        when(() => mockAuthRepository.authStateChanges()).thenAnswer(
          (_) => Stream.value(LocalAuthState.signedIn),
        );
        when(() => mockChatRepository.getRooms()).thenAnswer(
          (_) => Stream.value([]),
        );

        // Build the GoRouter using the mock repository
        final router = getRouter(mockAuthRepository);

        // Act
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: router,
          ),
        );

        await tester.pumpAndSettle();

        // Assert: Check that we're on the rooms screen
        expect(find.byType(RoomsPage), findsOneWidget);

        await tester.pumpAndSettle();
      });
    });

    testWidgets(
        'should redirect to / when signed in and trying to access login or register',
        (tester) async {
      await tester.runAsync(() async {
        // Arrange
        when(() => mockAuthRepository.authStateChanges()).thenAnswer(
          (_) => Stream.value(LocalAuthState.signedIn),
        );
        when(() => mockChatRepository.getRooms()).thenAnswer(
          (_) => Stream.value([]),
        );

        // Build the GoRouter using the mock repository
        final router = getRouter(mockAuthRepository);

        // Act: Try navigating to the login screen
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: router,
          ),
        );

        router.goNamed(AppRoutes.login.name);
        await tester.pumpAndSettle();

        // Assert: Should redirect to the home screen ('/')
        expect(find.byType(RoomsPage), findsOneWidget);
      });
    });
  });
}
