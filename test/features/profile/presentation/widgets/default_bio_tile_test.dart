import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/default_bio_tile.dart';

class MockProfileCubit extends Mock implements ProfileCubit {}

void main() {
  late ProfileCubit mockProfileCubit;

  setUp(() {
    mockProfileCubit = MockProfileCubit();
  });

  Widget createWidgetUnderTest({
    required String bio,
    String? selectedBio,
    bool showDivider = true,
  }) {
    return MaterialApp(
      home: BlocProvider.value(
        value: mockProfileCubit,
        child: Scaffold(
          body: DefaultBioTile(
            bio: bio,
            selectedBio: selectedBio,
            showDivider: showDivider,
          ),
        ),
      ),
    );
  }

  group('DefaultBioTile', () {
    testWidgets('renders bio text', (tester) async {
      const bio = 'Test bio';
      await tester.pumpWidget(createWidgetUnderTest(bio: bio));

      expect(find.text(bio), findsOneWidget);
    });

    testWidgets('renders check icon when bio is selected', (tester) async {
      const bio = 'Test bio';
      await tester
          .pumpWidget(createWidgetUnderTest(bio: bio, selectedBio: bio));

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('does not render check icon when bio is not selected',
        (tester) async {
      const bio = 'Test bio';
      await tester.pumpWidget(
        createWidgetUnderTest(bio: bio, selectedBio: 'Another bio'),
      );

      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('calls editBio when bio is tapped and not selected',
        (tester) async {
      when(
        () => mockProfileCubit.editBio(
          any(),
        ),
      ).thenAnswer(
        (realInvocation) async {},
      );

      whenListen(
        mockProfileCubit,
        Stream<ProfileState>.value(const ProfileInitial()),
      );

      const bio = 'Test bio';
      await tester.pumpWidget(
        createWidgetUnderTest(bio: bio, selectedBio: 'Another bio'),
      );

      await tester.tap(find.text(bio));

      verify(() => mockProfileCubit.editBio(bio)).called(1);
    });

    testWidgets('does not call editBio when bio is already selected',
        (tester) async {
      const bio = 'Test bio';
      await tester
          .pumpWidget(createWidgetUnderTest(bio: bio, selectedBio: bio));

      await tester.tap(find.text(bio));

      verifyNever(() => mockProfileCubit.editBio(any()));
    });

    testWidgets('renders a divider when showDivider is true', (tester) async {
      const bio = 'Test bio';
      await tester.pumpWidget(createWidgetUnderTest(bio: bio));

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('does not render a divider when showDivider is false',
        (tester) async {
      const bio = 'Test bio';
      await tester
          .pumpWidget(createWidgetUnderTest(bio: bio, showDivider: false));

      expect(find.byType(Divider), findsNothing);
    });
  });
}
