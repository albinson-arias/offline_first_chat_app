import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock class for SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late GlobalStore globalStore;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    globalStore = GlobalStore(sharedPreferences: mockSharedPreferences);
  });

  group('GlobalStore', () {
    test('should return null when username is not set', () {
      when(() => mockSharedPreferences.getString('GlobalStore-username'))
          .thenReturn(null);

      expect(globalStore.username, isNull);
    });

    test('should return correct username when it is set', () {
      when(() => mockSharedPreferences.getString('GlobalStore-username'))
          .thenReturn('testUser');

      expect(globalStore.username, 'testUser');
    });

    test('should store username correctly', () {
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer(
        (_) => Future.value(true),
      );
      globalStore.username = 'newUser';

      verify(
        () => mockSharedPreferences.setString(
          'GlobalStore-username',
          'newUser',
        ),
      ).called(1);
    });

    test('should remove username when setting to null', () {
      when(() => mockSharedPreferences.remove(any())).thenAnswer(
        (_) => Future.value(true),
      );
      globalStore.username = null;

      verify(() => mockSharedPreferences.remove('GlobalStore-username'))
          .called(1);
    });

    test('should return correct userId when it is set', () {
      when(() => mockSharedPreferences.getString('GlobalStore-userId'))
          .thenReturn('userId123');

      expect(globalStore.userId, 'userId123');
    });

    test('should store userId correctly', () {
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer(
        (_) => Future.value(true),
      );
      globalStore.userId = 'userId456';

      verify(
        () => mockSharedPreferences.setString(
          'GlobalStore-userId',
          'userId456',
        ),
      ).called(1);
    });

    test('should remove userId when setting to null', () {
      when(() => mockSharedPreferences.remove(any())).thenAnswer(
        (_) => Future.value(true),
      );
      globalStore.userId = null;

      verify(() => mockSharedPreferences.remove('GlobalStore-userId'))
          .called(1);
    });

    test('should return false when userDeniedNotifications is not set', () {
      when(
        () => mockSharedPreferences
            .getBool('GlobalStore-userDeniedNotifications'),
      ).thenReturn(null);

      expect(globalStore.userDeniedNotifications, false);
    });

    test('should return correct userDeniedNotifications value', () {
      when(
        () => mockSharedPreferences
            .getBool('GlobalStore-userDeniedNotifications'),
      ).thenReturn(true);

      expect(globalStore.userDeniedNotifications, true);
    });

    test('should store userDeniedNotifications correctly', () {
      when(() => mockSharedPreferences.setBool(any(), any())).thenAnswer(
        (_) => Future.value(true),
      );
      globalStore.userDeniedNotifications = true;

      verify(
        () => mockSharedPreferences.setBool(
          'GlobalStore-userDeniedNotifications',
          true,
        ),
      ).called(1);
    });
  });
}
