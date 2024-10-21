import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/pick_profile_pic_cubit/pick_profile_pic_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/pick_picture_source_dialog.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/profile_screen_loaded.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/common/presentation/cubits/bottom_nav_bar_cubit.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';
import 'package:offline_first_chat_app/src/core/routing/app_routes.dart';
import 'package:offline_first_chat_app/src/notifications/notification_controller.dart';
import 'package:record_result/record_result.dart';

import '../../../../test_utils/common_mocks.dart';
import '../../../../test_utils/utils.dart';

class MockPickProfilePicCubit extends Mock implements PickProfilePicCubit {}

class MockNotificationController extends Mock
    implements NotificationController {}

class MockGlobalStore extends Mock implements GlobalStore {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockBottomNavBarCubit extends Mock implements BottomNavBarCubit {}

void main() {
  late MockNotificationController mockNotificationController;
  late MockGlobalStore mockGlobalStore;
  late PickProfilePicCubit mockPickProfilePicCubit;
  late MockGoRouter mockGoRouter;
  late MockAuthRepository mockAuthRepository;
  late MockBottomNavBarCubit mockBottomNavBarCubit;

  setUp(() {
    mockPickProfilePicCubit = MockPickProfilePicCubit();
    mockGoRouter = MockGoRouter();

    mockNotificationController = MockNotificationController();
    mockGlobalStore = MockGlobalStore();
    mockAuthRepository = MockAuthRepository();
    mockBottomNavBarCubit = MockBottomNavBarCubit();

    // Initialize global service locators
    sl
      ..registerSingleton<NotificationController>(mockNotificationController)
      ..registerSingleton<GlobalStore>(mockGlobalStore)
      ..registerSingleton<AuthRepository>(mockAuthRepository)
      ..registerSingleton<BottomNavBarCubit>(mockBottomNavBarCubit);
  });

  tearDown(sl.reset);

  Widget createWidgetUnderTest({required Profile profile}) {
    return MaterialApp(
      home: MockGoRouterProvider(
        goRouter: mockGoRouter,
        child: Scaffold(
          body: BlocProvider.value(
            value: mockPickProfilePicCubit,
            child: ProfileScreenLoaded(profile: profile),
          ),
        ),
      ),
    );
  }

  group('ProfileScreenLoaded', () {
    final profile = Profile(
      id: '1',
      createdAt: DateTime(2002, 06, 11),
      username: 'Test User',
      bio: 'This is a test bio.',
      imageUrl: 'https://example.com/profile.jpg',
      fcmToken: 'test_token',
    );

    testWidgets('renders profile info correctly', (tester) async {
      whenListen(
        mockPickProfilePicCubit,
        initialState: const PickProfilePicInitial(),
        Stream<PickProfilePicState>.value(const PickProfilePicInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest(profile: profile));

      // Verify the profile image, username, and bio are displayed
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('This is a test bio.'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('renders network image when profile has image', (tester) async {
      whenListen(
        mockPickProfilePicCubit,
        initialState: const PickProfilePicInitial(),
        Stream<PickProfilePicState>.value(const PickProfilePicInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest(profile: profile));

      // Verify the profile image, username, and bio are displayed
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('renders svg image when profile doesnt has image',
        (tester) async {
      whenListen(
        mockPickProfilePicCubit,
        initialState: const PickProfilePicInitial(),
        Stream<PickProfilePicState>.value(const PickProfilePicInitial()),
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          profile: profile.copyWith(imageUrl: null),
        ),
      );

      // Verify the profile image, username, and bio are displayed
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('opens PickPictureSourceDialog when profile image is tapped',
        (tester) async {
      whenListen(
        mockPickProfilePicCubit,
        initialState: const PickProfilePicInitial(),
        Stream<PickProfilePicState>.value(const PickProfilePicInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest(profile: profile));

      // Tap the profile image
      await tester.tap(find.byType(InkWell).first);
      await tester.pump();

      // Verify that the bottom sheet for picking a picture is displayed
      expect(find.byType(PickPictureSourceDialog), findsOneWidget);
    });

    testWidgets('navigates to bio edit screen when bio is tapped',
        (tester) async {
      when(
        () => mockGoRouter.pushNamed(
          any(),
        ),
      ).thenAnswer(
        (realInvocation) async {
          return null;
        },
      );

      whenListen(
        mockPickProfilePicCubit,
        initialState: const PickProfilePicInitial(),
        Stream<PickProfilePicState>.value(const PickProfilePicInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest(profile: profile));

      // Tap the bio section
      await tester.tap(find.text('This is a test bio.'));
      await tester.pump();

      // Verify that navigation to the bio edit screen occurred
      verify(
        () => mockGoRouter.pushNamed(
          AppRoutes.bio.name,
        ),
      ).called(1);
    });
  });

  group('ProfileScreenLoaded - PickProfilePicCubit state handling', () {
    final profile = Profile(
      id: '1',
      createdAt: DateTime.now(),
      username: 'Test User',
      bio: 'This is a test bio.',
      imageUrl: 'https://example.com/profile.jpg',
      fcmToken: 'test_token',
    );

    testWidgets('shows loading dialog when PickProfilePicLoading is emitted',
        (tester) async {
      whenListen(
        mockPickProfilePicCubit,
        initialState: const PickProfilePicLoading(),
        Stream<PickProfilePicState>.fromIterable([
          const PickProfilePicLoading(),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest(profile: profile));

      await tester.pump();

      // Verify that the loading dialog is shown
      expect(find.byKey(const Key('loadingDialog')), findsOneWidget);
    });

    testWidgets('shows error snackbar when PickProfilePicFailure is emitted',
        (tester) async {
      final failure = ServerFailure(
        message: 'Error uploading image',
        statusCode: 500,
      );
      whenListen(
        mockPickProfilePicCubit,
        initialState: PickProfilePicFailure(failure),
        Stream<PickProfilePicState>.fromIterable(
          [PickProfilePicFailure(failure)],
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest(profile: profile));

      await tester.pump();

      // Verify that the snackbar with the error message is shown
      expect(find.text(failure.errorMessage), findsOneWidget);
    });

    testWidgets('shows success snackbar when PickProfilePicLoaded is emitted',
        (tester) async {
      whenListen(
        mockPickProfilePicCubit,
        initialState: const PickProfilePicLoaded('Image updated successfully'),
        Stream.fromIterable(
          [const PickProfilePicLoaded('Image updated successfully')],
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest(profile: profile));

      await tester.pump();

      // Verify that the snackbar with the success message is shown
      expect(find.text('Image updated successfully'), findsOneWidget);
    });
  });

  group('ProfileScreenLoaded - Notification Toggle', () {
    final profile = Profile(
      id: '1',
      createdAt: DateTime.now(),
      username: 'Test User',
      bio: 'This is a test bio.',
      imageUrl: 'https://example.com/profile.jpg',
    );

    testWidgets('enables notifications when checkbox is toggled on',
        (tester) async {
      when(
        () => mockNotificationController.requestPermissions(
          goToSettingsIfDenied: any(named: 'goToSettingsIfDenied'),
        ),
      ).thenAnswer(
        (realInvocation) async {},
      );
      whenListen(
        mockPickProfilePicCubit,
        initialState: const PickProfilePicInitial(),
        Stream<PickProfilePicState>.value(const PickProfilePicInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest(profile: profile));

      // Toggle checkbox to on (true)
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Verify that userDeniedNotifications is set to false
      verify(() => mockGlobalStore.userDeniedNotifications = false).called(1);

      // Verify that requestPermissions is called with the correct parameter
      verify(
        () => mockNotificationController.requestPermissions(
          goToSettingsIfDenied: true,
        ),
      ).called(1);
    });

    testWidgets('disables notifications when checkbox is toggled off',
        (tester) async {
      when(
        () => mockNotificationController.disableNotifications(),
      ).thenAnswer(
        (realInvocation) async {},
      );
      whenListen(
        mockPickProfilePicCubit,
        initialState: const PickProfilePicInitial(),
        Stream<PickProfilePicState>.value(const PickProfilePicInitial()),
      );
      // Profile with FCM token enabled
      final updatedProfile = profile.copyWith(fcmToken: 'test_token');
      await tester.pumpWidget(createWidgetUnderTest(profile: updatedProfile));

      // Toggle checkbox to off (false)
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Verify that disableNotifications is called
      verify(mockNotificationController.disableNotifications).called(1);
    });
  });

  group('ProfileScreenLoaded - Logout Button', () {
    final profile = Profile(
      id: '1',
      createdAt: DateTime.now(),
      username: 'Test User',
      bio: 'This is a test bio.',
      imageUrl: 'https://example.com/profile.jpg',
      fcmToken: 'test_token',
    );

    testWidgets(
        'calls signOut and navigates to home when logout button is pressed',
        (tester) async {
      when(
        () => mockAuthRepository.signOut(),
      ).thenAnswer(
        (realInvocation) async => right(null),
      );

      whenListen(
        mockPickProfilePicCubit,
        initialState: const PickProfilePicInitial(),
        Stream<PickProfilePicState>.value(const PickProfilePicInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest(profile: profile));

      // Tap the logout button
      await tester.tap(find.text('Logout'));
      await tester.pump();

      // Verify that signOut is called
      verify(() => mockAuthRepository.signOut()).called(1);

      // Verify that navigateToHome is called
      verify(() => mockBottomNavBarCubit.navigateToHome()).called(1);
    });
  });
}
