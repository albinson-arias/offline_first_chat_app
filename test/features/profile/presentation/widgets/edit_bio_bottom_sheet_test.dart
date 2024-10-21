import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/edit_bio_bottom_sheet.dart';

import '../../../../test_utils/common_mocks.dart';
import '../../../../test_utils/utils.dart';

class MockProfileCubit extends Mock implements ProfileCubit {}

void main() {
  late ProfileCubit mockProfileCubit;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockProfileCubit = MockProfileCubit();
    mockGoRouter = MockGoRouter();
  });

  Widget createWidgetUnderTest({required String bio}) {
    return MaterialApp(
      home: MockGoRouterProvider(
        goRouter: mockGoRouter,
        child: BlocProvider.value(
          value: mockProfileCubit,
          child: Scaffold(
            body: EditBioBottomSheet(bio: bio),
          ),
        ),
      ),
    );
  }

  group('EditBioBottomSheet', () {
    testWidgets('renders initial bio text', (tester) async {
      const bio = 'Initial bio';

      await tester.pumpWidget(createWidgetUnderTest(bio: bio));

      expect(find.text(bio), findsOneWidget);
      expect(find.text('Bio(${bio.length})'), findsOneWidget);
    });

    testWidgets('updates bio state when text is entered', (tester) async {
      const bio = 'Initial bio';
      const newBio = 'Updated bio';

      await tester.pumpWidget(createWidgetUnderTest(bio: bio));

      // Enter new text
      await tester.enterText(find.byType(TextFormField), newBio);
      await tester.pump();

      // Check that the bio text and character count are updated
      expect(find.text(newBio), findsOneWidget);
      expect(find.text('Bio(${newBio.length})'), findsOneWidget);
    });

    testWidgets('calls saveBio when Save button is pressed', (tester) async {
      when(
        () => mockProfileCubit.editBio(
          any(),
        ),
      ).thenAnswer(
        (realInvocation) async {},
      );

      when(
        () => mockGoRouter.pop(),
      ).thenAnswer(
        (realInvocation) async {},
      );

      whenListen(
        mockProfileCubit,
        Stream<ProfileState>.value(const ProfileInitial()),
      );

      const bio = 'Initial bio';

      await tester.pumpWidget(createWidgetUnderTest(bio: bio));

      // Tap the Save button
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify that saveBio (which triggers editBio) is called on ProfileCubit
      verify(() => mockProfileCubit.editBio(bio)).called(1);
      verify(() => mockGoRouter.pop()).called(1);
    });

    testWidgets('calls saveBio when bio is submitted via keyboard',
        (tester) async {
      when(
        () => mockProfileCubit.editBio(
          any(),
        ),
      ).thenAnswer(
        (realInvocation) async {},
      );

      when(
        () => mockGoRouter.pop(),
      ).thenAnswer(
        (realInvocation) async {},
      );

      whenListen(
        mockProfileCubit,
        Stream<ProfileState>.value(const ProfileInitial()),
      );

      const bio = 'Initial bio';

      await tester.pumpWidget(createWidgetUnderTest(bio: bio));

      // Submit the text field (simulate keyboard submit)
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Verify that saveBio is called
      verify(() => mockProfileCubit.editBio(bio)).called(1);
      verify(() => mockGoRouter.pop()).called(1);
    });

    testWidgets('closes bottom sheet when Cancel button is pressed',
        (tester) async {
      when(
        () => mockGoRouter.pop(),
      ).thenAnswer(
        (realInvocation) async {},
      );
      const bio = 'Initial bio';

      await tester.pumpWidget(createWidgetUnderTest(bio: bio));

      // Tap the Cancel button
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify that the bottom sheet is closed (pop is called)
      verify(() => mockGoRouter.pop()).called(1);
    });
  });
}
