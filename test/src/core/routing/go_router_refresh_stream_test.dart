import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/src/core/routing/go_router_refresh_stream.dart';

void main() {
  group('GoRouterRefreshStream Tests', () {
    late StreamController<dynamic> streamController;
    late GoRouterRefreshStream goRouterRefreshStream;

    setUp(() {
      streamController = StreamController<dynamic>.broadcast();
      goRouterRefreshStream = GoRouterRefreshStream(streamController.stream);
    });

    tearDown(() async {
      // Dispose of the GoRouterRefreshStream after all tests are completed
      goRouterRefreshStream.dispose();
      // Close the stream controller after the test
      await streamController.close();
    });

    test('GoRouterRefreshStream calls notifyListeners on stream event',
        () async {
      var notifyCount = 0;

      // Add a listener to GoRouterRefreshStream to track notifyListener calls
      goRouterRefreshStream.addListener(() {
        notifyCount++;
      });

      // Trigger an event in the stream
      streamController.add('event');

      // Allow the event to propagate asynchronously
      await Future<void>.delayed(Duration.zero);

      // Check if notifyListeners was called
      expect(notifyCount, equals(1));
    });

    test('GoRouterRefreshStream cancels subscription on dispose', () async {
      // Dispose of the stream
      goRouterRefreshStream.dispose();

      // After disposing, adding an event to the stream
      // should not trigger notifyListeners
      // Since the subscription is cancelled, this will
      // ensure no further events are processed
      streamController.add('event');

      // Allow a short delay for event propagation to check the behavior
      await Future<void>.delayed(Duration.zero);

      // Ensure nothing was thrown and no errors occurred
      expect(() => streamController.add('another_event'), returnsNormally);

      // This is here so that the teardown callback doesn't
      // dispose an already disposed GoRouterRefreshStream
      goRouterRefreshStream = GoRouterRefreshStream(streamController.stream);
    });
  });
}
