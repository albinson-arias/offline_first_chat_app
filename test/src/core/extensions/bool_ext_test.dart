import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/src/core/extensions/bool_ext.dart';

void main() {
  group('BoolExt', () {
    test('toggle() should return false when called on true', () {
      // Arrange
      const value = true;

      // Act
      final toggledValue = value.toggle();

      // Assert
      expect(toggledValue, isFalse);
    });

    test('toggle() should return true when called on false', () {
      // Arrange
      const value = false;

      // Act
      final toggledValue = value.toggle();

      // Assert
      expect(toggledValue, isTrue);
    });
  });
}
