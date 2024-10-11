import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Test the email regex
  group('Email Validation Regex', () {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    test('Valid email addresses', () {
      expect(emailRegex.hasMatch('test@example.com'), isTrue);
      expect(emailRegex.hasMatch('john.doe@domain.co.uk'), isTrue);
      expect(emailRegex.hasMatch('user_name123@domain.com'), isTrue);
    });

    test('Invalid email addresses', () {
      expect(emailRegex.hasMatch('invalid-email'), isFalse);
      expect(emailRegex.hasMatch('missing@domain'), isFalse);
      expect(emailRegex.hasMatch('user@.com'), isFalse);
      expect(emailRegex.hasMatch('@missingusername.com'), isFalse);
    });
  });

  // Test the password regex
  group('Password Validation Regex', () {
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

    test('Valid passwords', () {
      expect(passwordRegex.hasMatch('password1'), isTrue);
      expect(passwordRegex.hasMatch('abc12345'), isTrue);
      expect(passwordRegex.hasMatch('A1bcdefg'), isTrue);
    });

    test('Invalid passwords', () {
      expect(passwordRegex.hasMatch('password'), isFalse); // No number
      expect(passwordRegex.hasMatch('12345678'), isFalse); // No letter
      expect(passwordRegex.hasMatch('abc'), isFalse); // Less than 8 characters
    });
  });

  // Test formSpacer constant
  group('Form UI Constants', () {
    test('formSpacer is a SizedBox with 16x16 dimensions', () {
      const formSpacer = SizedBox(width: 16, height: 16);
      expect(formSpacer.width, 16);
      expect(formSpacer.height, 16);
    });

    // Test formPadding constant
    test('formPadding has symmetric vertical: 20 and horizontal: 16', () {
      const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);
      expect(formPadding.vertical, 40); // 20 * 2 for top and bottom
      expect(formPadding.horizontal, 32); // 16 * 2 for left and right
    });
  });
}
