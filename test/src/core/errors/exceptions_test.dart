import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_chat_app/src/core/errors/exceptions.dart';

void main() {
  group('ServerException', () {
    test('Equatable comparison returns true for equal values', () {
      const exception1 =
          ServerException(message: 'Error occurred', statusCode: '500');
      const exception2 =
          ServerException(message: 'Error occurred', statusCode: '500');

      // Verify that two ServerException instances with the same
      // values are equal
      expect(exception1, equals(exception2));
    });

    test('Equatable comparison returns false for different values', () {
      const exception1 =
          ServerException(message: 'Error occurred', statusCode: '500');
      const exception2 =
          ServerException(message: 'Another error occurred', statusCode: '400');

      // Verify that two ServerException instances with different
      // values are not equal
      expect(exception1, isNot(equals(exception2)));
    });

    test('toFailure method converts ServerException to ServerFailure', () {
      const exception =
          ServerException(message: 'Error occurred', statusCode: '500');

      final failure = exception.toFailure();

      // Verify that the converted failure has the same message and statusCode
      expect(failure.message, equals('Error occurred'));
      expect(failure.statusCode, equals('500'));
    });
  });
}
