import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/src/core/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('Debounces the action and runs after the specified duration',
        () async {
      final debouncer = Debouncer(milliseconds: 500);
      var actionExecuted = false;

      debouncer.run(() {
        actionExecuted = true;
      });

      // Initially, the action should not be executed immediately
      expect(actionExecuted, isFalse);

      // Wait for 500ms to let the debounced action execute
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Now the action should be executed
      expect(actionExecuted, isTrue);
    });

    test('Cancels the previous action if a new one is run', () async {
      final debouncer = Debouncer(milliseconds: 500);
      var action1Executed = false;
      var action2Executed = false;

      debouncer.run(() {
        action1Executed = true;
      });

      // Run a second action before the debounce time expires
      await Future<void>.delayed(const Duration(milliseconds: 200));
      debouncer.run(() {
        action2Executed = true;
      });

      // Wait for the total debounce duration
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Action1 should never be executed, but Action2 should be executed
      expect(action1Executed, isFalse);
      expect(action2Executed, isTrue);
    });

    test('Debouncer.dispose cancels any scheduled action', () async {
      final debouncer = Debouncer(milliseconds: 500);
      var actionExecuted = false;

      debouncer
        ..run(() {
          actionExecuted = true;
        })

        // Call dispose before the action can execute
        ..dispose();

      // Wait for the debounce duration
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // The action should never be executed since we disposed the debouncer
      expect(actionExecuted, isFalse);
    });
  });
}
