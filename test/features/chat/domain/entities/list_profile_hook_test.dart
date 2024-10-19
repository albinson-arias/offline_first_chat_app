import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/features/chat/domain/entities/list_profile_hook.dart';

void main() {
  group('ListProfileHook Tests', () {
    const hook = ListProfileHook();

    test('decodes valid JSON string', () {
      const jsonString = '{"id": "123", "name": "John Doe"}';

      final result = hook.beforeDecode(jsonString);

      // The result should be a decoded map from the JSON string
      expect(result, isA<Map<String, dynamic>>());
      expect(result, {'id': '123', 'name': 'John Doe'});
    });

    test('returns non-string values unchanged', () {
      final map = {'id': '123', 'name': 'John Doe'};

      final result = hook.beforeDecode(map);

      // The result should be unchanged since it's not a string
      expect(result, map);
    });

    test('throws an error on invalid JSON string', () {
      const invalidJsonString =
          '{"id": "123", "name": "John Doe"'; // Missing closing brace

      expect(
        () => hook.beforeDecode(invalidJsonString),
        throwsA(isA<FormatException>()),
      );
    });

    test('returns super.beforeDecode value if input is not a string', () {
      const number = 123;

      final result = hook.beforeDecode(number);

      // Non-string values should pass through as-is
      expect(result, 123);
    });
  });
}
