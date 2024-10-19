import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/auth/domain/entities/profile.dart';
import 'package:offline_first_chat_app/features/chat/presentation/views/contact_page.dart';

class MockProfile extends Mock implements Profile {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createWidgetUnderTest({required Profile profile}) {
    return MaterialApp(
      home: ContactPage(profile: profile),
    );
  }

  group('ContactPage Widget Tests', () {
    late Profile mockProfileWithImage;
    late Profile mockProfileWithoutImage;

    setUp(() {
      mockProfileWithImage = MockProfile();

      when(() => mockProfileWithImage.imageUrl).thenReturn('expected');
      when(() => mockProfileWithImage.username).thenReturn('John Doe');
      when(() => mockProfileWithImage.bio).thenReturn('This is a sample bio.');

      mockProfileWithoutImage = MockProfile();
      when(() => mockProfileWithoutImage.imageUrl).thenReturn(null);
      when(() => mockProfileWithoutImage.username).thenReturn('Jane Smith');
      when(() => mockProfileWithoutImage.bio).thenReturn('Another sample bio.');
    });

    testWidgets('Displays AppBar with correct title',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createWidgetUnderTest(profile: mockProfileWithImage));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Contact info'), findsOneWidget);
    });

    testWidgets('Displays profile image when imageUrl is provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          profile: mockProfileWithImage,
        ),
      );

      await tester.pump();

      // Verify that CachedNetworkImage is present
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('Displays default asset image when imageUrl is null',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createWidgetUnderTest(profile: mockProfileWithoutImage));

      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('Displays username correctly', (WidgetTester tester) async {
      await tester
          .pumpWidget(createWidgetUnderTest(profile: mockProfileWithImage));

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('Displays bio correctly', (WidgetTester tester) async {
      await tester
          .pumpWidget(createWidgetUnderTest(profile: mockProfileWithImage));

      expect(find.text('This is a sample bio.'), findsOneWidget);
    });
  });
}
