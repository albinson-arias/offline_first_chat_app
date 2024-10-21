import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/profile/domain/entities/default_bios.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/screens/bio_screen.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/edit_bio_bottom_sheet.dart';

class MockProfileCubit extends Mock implements ProfileCubit {}

void main() {
  late ProfileCubit mockProfileCubit;

  setUp(() {
    mockProfileCubit = MockProfileCubit();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider.value(
        value: mockProfileCubit,
        child: const BioScreen(),
      ),
    );
  }

  group('BioScreen', () {
    testWidgets(
        'renders bio and default bios when ProfileLoaded state is emitted',
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
        Stream<ProfileState>.fromIterable([ProfileLoaded(profile)]),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Verify that the current bio is displayed
      expect(find.text('This is a test bio.'), findsOneWidget);

      // Verify that the default bios are displayed
      for (final bio in DefaultBios.values) {
        expect(find.text(bio.title), findsOneWidget);
      }
    });

    testWidgets('opens EditBioBottomSheet when bio is tapped', (tester) async {
      final profile = Profile(
        id: '1',
        createdAt: DateTime.now(),
        username: 'Test User',
        bio: 'This is a test bio.',
      );

      whenListen(
        mockProfileCubit,
        initialState: ProfileLoaded(profile),
        Stream<ProfileState>.fromIterable([ProfileLoaded(profile)]),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Tap the bio section
      await tester.tap(find.text('This is a test bio.'));
      await tester.pumpAndSettle();

      // Verify that the EditBioBottomSheet is displayed
      expect(find.byType(EditBioBottomSheet), findsOneWidget);
    });

    testWidgets('calls editBio when a default bio is selected', (tester) async {
      final profile = Profile(
        id: '1',
        createdAt: DateTime.now(),
        username: 'Test User',
        bio: 'This is a test bio.',
      );

      when(
        () => mockProfileCubit.editBio(
          any(),
        ),
      ).thenAnswer(
        (realInvocation) async {},
      );

      whenListen(
        mockProfileCubit,
        initialState: ProfileLoaded(profile),
        Stream<ProfileState>.fromIterable([ProfileLoaded(profile)]),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Tap a default bio
      await tester.tap(find.text(DefaultBios.values.first.title));
      await tester.pumpAndSettle();

      // Verify that editBio is called with the selected bio
      verify(() => mockProfileCubit.editBio(DefaultBios.values.first.title))
          .called(1);
    });
  });
}
