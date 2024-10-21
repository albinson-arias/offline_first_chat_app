import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/features/profile/presentation/widgets/pick_picture_source_dialog_option.dart';

void main() {
  late bool tapped;
  void mockOnTap() {
    tapped = true;
  }

  setUp(() {
    tapped = false;
  });

  Widget createWidgetUnderTest({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: PickPictureSourceDialogOption(
          title: title,
          icon: icon,
          onTap: onTap,
        ),
      ),
    );
  }

  group('PickPictureSourceDialogOption', () {
    testWidgets('renders the icon and title', (tester) async {
      const title = 'Pick from Gallery';
      const icon = Icons.image;

      await tester.pumpWidget(
        createWidgetUnderTest(
          title: title,
          icon: icon,
          onTap: mockOnTap,
        ),
      );

      // Verify that the title is displayed
      expect(find.text(title), findsOneWidget);

      // Verify that the icon is displayed
      expect(find.byIcon(icon), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      const title = 'Pick from Camera';
      const icon = Icons.camera;

      await tester.pumpWidget(
        createWidgetUnderTest(
          title: title,
          icon: icon,
          onTap: mockOnTap,
        ),
      );

      // Tap the widget
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Verify that onTap is called
      expect(tapped, isTrue);
    });
  });
}
