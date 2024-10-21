import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/pick_profile_pic_cubit/pick_profile_pic_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/profile_screen_loaded.dart';
import 'package:offline_first_chat_app/src/common/presentation/cubits/bottom_nav_bar_cubit.dart';
import 'package:offline_first_chat_app/src/common/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:offline_first_chat_app/src/common/presentation/widgets/loading_view.dart';
import 'package:offline_first_chat_app/src/core/injections/injection_container.dart';

class MockProfileCubit extends Mock implements ProfileCubit {}

class MockBottomNavBarCubit extends Mock implements BottomNavBarCubit {}

class MockPickProfilePicCubit extends Mock implements PickProfilePicCubit {}

void main() {
  late ProfileCubit mockProfileCubit;
  late MockBottomNavBarCubit mockBottomNavBarCubit;
  late PickProfilePicCubit mockPickProfilePicCubit;

  setUp(() {
    mockPickProfilePicCubit = MockPickProfilePicCubit();
    mockProfileCubit = MockProfileCubit();
    mockBottomNavBarCubit = MockBottomNavBarCubit();

    sl.registerSingleton<BottomNavBarCubit>(mockBottomNavBarCubit);
  });

  tearDown(sl.reset);

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: mockProfileCubit,
          ),
          BlocProvider.value(
            value: mockPickProfilePicCubit,
          ),
        ],
        child: const ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen', () {
    testWidgets('renders AppBottomNavigationBar', (tester) async {
      whenListen(
        mockProfileCubit,
        initialState: const ProfileInitial(),
        Stream<ProfileState>.fromIterable([
          const ProfileInitial(),
        ]),
      );

      whenListen(
        mockBottomNavBarCubit,
        initialState: 1,
        Stream<int>.fromIterable([
          1,
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Verify that the bottom navigation bar is displayed
      expect(find.byType(AppBottomNavigationBar), findsOneWidget);
    });

    testWidgets('renders LoadingView when state is not ProfileLoaded',
        (tester) async {
      whenListen(
        mockProfileCubit,
        initialState: const ProfileInitial(),
        Stream<ProfileState>.fromIterable([
          const ProfileInitial(),
        ]),
      );

      whenListen(
        mockBottomNavBarCubit,
        initialState: 1,
        Stream<int>.fromIterable([
          1,
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Verify that the LoadingView is displayed
      expect(find.byType(LoadingView), findsOneWidget);
      expect(find.byType(ProfileScreenLoaded), findsNothing);
    });

    testWidgets('renders ProfileScreenLoaded when state is ProfileLoaded',
        (tester) async {
      final profile = Profile(
        id: '1',
        createdAt: DateTime.now(),
        username: 'Test User',
        bio: 'This is a test bio.',
      );

      whenListen(
        mockProfileCubit,
        initialState: ProfileLoaded(profile),
        Stream<ProfileState>.fromIterable([
          ProfileLoaded(profile),
        ]),
      );

      whenListen(
        mockBottomNavBarCubit,
        initialState: 1,
        Stream<int>.fromIterable([
          1,
        ]),
      );

      whenListen(
        mockPickProfilePicCubit,
        initialState: const PickProfilePicInitial(),
        Stream<PickProfilePicState>.fromIterable([
          const PickProfilePicInitial(),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Verify that ProfileScreenLoaded is displayed
      expect(find.byType(ProfileScreenLoaded), findsOneWidget);
      expect(find.byType(LoadingView), findsNothing);
    });
  });
}
