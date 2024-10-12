import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/src/core/utils/open_flutter_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('flutter_open_app_settings');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (message) async {
        if (message.method == 'openSettings') {
          return 'a'; // Return any value or mock behavior
        }
        return null;
      },
    );
  });

  tearDown(() {
    // Remove the mock after the tests
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      null,
    );
  });

  group('OpenFlutterSettings Tests', () {
    test('should open app notification settings and call callback', () async {
      // Arrange
      final mockCallback = MockFunction(); // Create a mock for the callback
      const openFlutterSettings = OpenFlutterSettings();

      // Act
      await openFlutterSettings.goToNotifications(mockCallback.call);

      // Assert
      verify(mockCallback.call).called(1); // Ensure the callback was called
    });
  });
}

// Helper class to mock the callback function
class MockFunction extends Mock {
  void call();
}
