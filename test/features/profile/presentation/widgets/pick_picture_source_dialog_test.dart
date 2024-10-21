import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/pick_profile_pic_cubit/pick_profile_pic_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/pick_picture_source_dialog.dart';

import '../../../../test_utils/common_mocks.dart';
import '../../../../test_utils/utils.dart';

class MockPickProfilePicCubit extends Mock implements PickProfilePicCubit {}

void main() {
  late MockPickProfilePicCubit mockPickProfilePicCubit;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockPickProfilePicCubit = MockPickProfilePicCubit();
    mockGoRouter = MockGoRouter();
  });

  setUpAll(() {
    registerFallbackValue(ImageSource.camera);
  });

  Widget createWidgetUnderTest({required bool hasProfilePic}) {
    return MaterialApp(
      home: Scaffold(
        body: MockGoRouterProvider(
          goRouter: mockGoRouter,
          child: PickPictureSourceDialog(
            cubit: mockPickProfilePicCubit,
            hasProfilePic: hasProfilePic,
          ),
        ),
      ),
    );
  }

  group('PickPictureSourceDialog', () {
    testWidgets('renders gallery and camera options', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(hasProfilePic: false));

      expect(find.text('Pick From Gallery'), findsOneWidget);
      expect(find.text('Pick From Camera'), findsOneWidget);
      expect(
        find.text('Delete Image'),
        findsNothing,
      ); // No delete option since hasProfilePic is false
    });

    testWidgets('renders delete option when hasProfilePic is true',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(hasProfilePic: true));

      expect(find.text('Delete Image'), findsOneWidget);
    });

    testWidgets(
        'calls pickProfilePicFromSource with gallery when'
        ' "Pick From Gallery" is tapped', (tester) async {
      when(
        () => mockGoRouter.pop(),
      ).thenAnswer(
        (realInvocation) async {},
      );

      when(
        () => mockPickProfilePicCubit.pickProfilePicFromSource(
          any(),
        ),
      ).thenAnswer(
        (realInvocation) async {},
      );

      await tester.pumpWidget(createWidgetUnderTest(hasProfilePic: false));

      await tester.tap(find.text('Pick From Gallery'));
      await tester.pumpAndSettle();

      verify(
        () => mockGoRouter.pop(),
      ).called(1);
      verify(
        () => mockPickProfilePicCubit
            .pickProfilePicFromSource(ImageSource.gallery),
      ).called(1);
    });

    testWidgets(
        'calls pickProfilePicFromSource with camera when'
        ' "Pick From Camera" is tapped', (tester) async {
      when(
        () => mockGoRouter.pop(),
      ).thenAnswer(
        (realInvocation) async {},
      );

      when(
        () => mockPickProfilePicCubit.pickProfilePicFromSource(
          any(),
        ),
      ).thenAnswer(
        (realInvocation) async {},
      );

      await tester.pumpWidget(createWidgetUnderTest(hasProfilePic: false));

      await tester.tap(find.text('Pick From Camera'));
      await tester.pumpAndSettle();

      verify(
        () => mockGoRouter.pop(),
      ).called(1);
      verify(
        () => mockPickProfilePicCubit
            .pickProfilePicFromSource(ImageSource.camera),
      ).called(1);
    });

    testWidgets('calls deleteProfilePic when "Delete Image" is tapped',
        (tester) async {
      when(
        () => mockGoRouter.pop(),
      ).thenAnswer(
        (realInvocation) async {},
      );

      when(
        () => mockPickProfilePicCubit.deleteProfilePic(),
      ).thenAnswer(
        (realInvocation) async {},
      );

      await tester.pumpWidget(createWidgetUnderTest(hasProfilePic: true));

      await tester.tap(find.text('Delete Image'));
      await tester.pumpAndSettle();

      verify(
        () => mockGoRouter.pop(),
      ).called(1);
      verify(() => mockPickProfilePicCubit.deleteProfilePic()).called(1);
    });

    testWidgets('closes dialog when cancel button is tapped', (tester) async {
      when(
        () => mockGoRouter.pop(),
      ).thenAnswer(
        (realInvocation) async {},
      );

      await tester.pumpWidget(createWidgetUnderTest(hasProfilePic: false));

      // Tap the cancel button
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify the dialog is closed
      verify(
        () => mockGoRouter.pop(),
      ).called(1);
    });
  });
}
