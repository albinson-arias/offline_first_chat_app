import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/src/core/extensions/string_ext.dart';

void main() {
  group('StringExt', () {
    test(r'removeNewLines replaces \n with spaces', () {
      const original = 'This\nis\na\ntest';
      const expected = 'This is a test';

      final result = original.removeNewLines();

      // Verify that '\n' characters are replaced with spaces
      expect(result, equals(expected));
    });

    test(r'removeNewLines replaces \r with spaces', () {
      const original = 'This\ris\ra\rtest';
      const expected = 'This is a test';

      final result = original.removeNewLines();

      // Verify that '\r' characters are replaced with spaces
      expect(result, equals(expected));
    });

    test(r'removeNewLines handles both \n and \r characters', () {
      const original = 'This\nis\ra\rtest\nstring';
      const expected = 'This is a test string';

      final result = original.removeNewLines();

      // Verify that '\n' is replaced with spaces and '\r' is also replaced with spaces
      expect(result, equals(expected));
    });

    test(r'removeNewLines works with strings without \n or \r', () {
      const original = 'This is a test';
      const expected = 'This is a test';

      final result = original.removeNewLines();

      // Verify that the string remains unchanged if there are no '\n' or '\r' characters
      expect(result, equals(expected));
    });
  });
}
