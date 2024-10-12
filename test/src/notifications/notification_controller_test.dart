import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_chat_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/core/utils/open_flutter_settings.dart';
import 'package:offline_first_chat_app/src/notifications/notification_controller.dart';
import 'package:record_result/record_result.dart';

// Mock classes using mocktail
class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockGlobalStore extends Mock implements GlobalStore {}

class MockOpenFlutterSettings extends Mock implements OpenFlutterSettings {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockFirebaseMessaging mockFirebaseMessaging;
  late MockProfileRepository mockProfileRepository;
  late MockGlobalStore mockGlobalStore;
  late MockOpenFlutterSettings mockOpenFlutterSettings;
  late NotificationController notificationController;

  setUpAll(() {
    // Register fallback values for arguments that might
    // not be expected during mocking
    registerFallbackValue(
      const NotificationSettings(
        authorizationStatus: AuthorizationStatus.authorized,
        alert: AppleNotificationSetting.enabled,
        announcement: AppleNotificationSetting.disabled,
        badge: AppleNotificationSetting.disabled,
        carPlay: AppleNotificationSetting.disabled,
        criticalAlert: AppleNotificationSetting.disabled,
        lockScreen: AppleNotificationSetting.disabled,
        notificationCenter: AppleNotificationSetting.disabled,
        showPreviews: AppleShowPreviewSetting.always,
        sound: AppleNotificationSetting.disabled,
        timeSensitive: AppleNotificationSetting.disabled,
      ),
    );
    registerFallbackValue(const Stream<String>.empty());
  });

  setUp(() {
    mockFirebaseMessaging = MockFirebaseMessaging();
    mockProfileRepository = MockProfileRepository();
    mockGlobalStore = MockGlobalStore();
    mockOpenFlutterSettings = MockOpenFlutterSettings();
    notificationController = NotificationController(
      messaging: mockFirebaseMessaging,
      profileRepository: mockProfileRepository,
      globalStore: mockGlobalStore,
      openFlutterSettings: mockOpenFlutterSettings,
    );
  });

  group('NotificationController Tests', () {
    const notificationSettings = NotificationSettings(
      authorizationStatus: AuthorizationStatus.authorized,
      alert: AppleNotificationSetting.enabled,
      announcement: AppleNotificationSetting.disabled,
      badge: AppleNotificationSetting.disabled,
      carPlay: AppleNotificationSetting.disabled,
      criticalAlert: AppleNotificationSetting.disabled,
      lockScreen: AppleNotificationSetting.disabled,
      notificationCenter: AppleNotificationSetting.disabled,
      showPreviews: AppleShowPreviewSetting.always,
      sound: AppleNotificationSetting.disabled,
      timeSensitive: AppleNotificationSetting.disabled,
    );
    const ResultVoid nullSuccess = (failure: null, success: null);
    test('should request permissions and get FCM token if authorized',
        () async {
      // Arrange
      when(() => mockProfileRepository.updateFcmToken(any())).thenAnswer(
        (_) => Future.value(nullSuccess),
      );
      when(() => mockGlobalStore.userDeniedNotifications).thenReturn(false);
      when(() => mockFirebaseMessaging.requestPermission()).thenAnswer(
        (_) async => notificationSettings,
      );
      when(() => mockFirebaseMessaging.getToken())
          .thenAnswer((_) async => 'testToken');

      // Act
      await notificationController.requestPermissions();

      // Assert
      verify(() => mockFirebaseMessaging.requestPermission()).called(1);
      verify(() => mockFirebaseMessaging.getToken()).called(1);
      verify(() => mockProfileRepository.updateFcmToken('testToken')).called(1);
    });

    test('should disable notifications if user denied', () async {
      // Arrange
      when(() => mockGlobalStore.userDeniedNotifications).thenReturn(true);
      when(() => mockProfileRepository.updateFcmToken(any())).thenAnswer(
        (_) => Future.value(nullSuccess),
      );

      // Act
      await notificationController.requestPermissions();

      // Assert
      verify(() => mockProfileRepository.updateFcmToken(null)).called(1);
    });

    test(
        'should open settings if permission denied and '
        'goToSettingsIfDenied is true', () async {
      // Arrange
      when(() => mockGlobalStore.userDeniedNotifications).thenReturn(false);
      when(() => mockFirebaseMessaging.requestPermission()).thenAnswer(
        (_) async => const NotificationSettings(
          authorizationStatus: AuthorizationStatus.denied,
          alert: AppleNotificationSetting.enabled,
          announcement: AppleNotificationSetting.disabled,
          badge: AppleNotificationSetting.disabled,
          carPlay: AppleNotificationSetting.disabled,
          criticalAlert: AppleNotificationSetting.disabled,
          lockScreen: AppleNotificationSetting.disabled,
          notificationCenter: AppleNotificationSetting.disabled,
          showPreviews: AppleShowPreviewSetting.always,
          sound: AppleNotificationSetting.disabled,
          timeSensitive: AppleNotificationSetting.disabled,
        ),
      );
      when(() => mockOpenFlutterSettings.goToNotifications(any())).thenAnswer(
        (_) async {},
      );

      // Act
      await notificationController.requestPermissions(
        goToSettingsIfDenied: true,
      );

      // Assert
      verify(() => mockFirebaseMessaging.requestPermission()).called(1);
      verify(() => mockOpenFlutterSettings.goToNotifications(any())).called(1);
    });

    test(
        'should disable notifications if permission denied'
        ' and goToSettingsIfDenied is false', () async {
      // Arrange
      when(() => mockGlobalStore.userDeniedNotifications).thenReturn(false);
      when(() => mockFirebaseMessaging.requestPermission()).thenAnswer(
        (_) async => const NotificationSettings(
          authorizationStatus: AuthorizationStatus.denied,
          alert: AppleNotificationSetting.enabled,
          announcement: AppleNotificationSetting.disabled,
          badge: AppleNotificationSetting.disabled,
          carPlay: AppleNotificationSetting.disabled,
          criticalAlert: AppleNotificationSetting.disabled,
          lockScreen: AppleNotificationSetting.disabled,
          notificationCenter: AppleNotificationSetting.disabled,
          showPreviews: AppleShowPreviewSetting.always,
          sound: AppleNotificationSetting.disabled,
          timeSensitive: AppleNotificationSetting.disabled,
        ),
      );

      when(() => mockProfileRepository.updateFcmToken(any())).thenAnswer(
        (_) => Future.value(nullSuccess),
      );

      // Act
      await notificationController.requestPermissions();

      // Assert
      verify(() => mockFirebaseMessaging.requestPermission()).called(1);
      verify(() => mockProfileRepository.updateFcmToken(null)).called(1);
    });

    test('should get FCM token on iOS when APNS token is available', () async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      when(() => mockFirebaseMessaging.getAPNSToken())
          .thenAnswer((_) async => 'apnsToken');
      when(() => mockFirebaseMessaging.getToken())
          .thenAnswer((_) async => 'testToken');
      when(() => mockProfileRepository.updateFcmToken(any())).thenAnswer(
        (_) => Future.value(nullSuccess),
      );

      // Act
      await notificationController.getFcmToken();

      // Assert
      verify(() => mockFirebaseMessaging.getAPNSToken()).called(1);
      verify(() => mockProfileRepository.updateFcmToken('testToken')).called(1);
      debugDefaultTargetPlatformOverride = null;
    });

    test('should listen to FCM token changes and set new token', () async {
      // Arrange
      final tokenStream = Stream<String>.fromIterable(['newToken']);
      when(() => mockFirebaseMessaging.onTokenRefresh)
          .thenAnswer((_) => tokenStream);
      when(() => mockProfileRepository.updateFcmToken(any())).thenAnswer(
        (_) => Future.value(nullSuccess),
      );

      // Act
      notificationController.listenToFcmTokenChanges();
      await Future<void>.delayed(Duration.zero);

      // Assert
      verify(() => mockFirebaseMessaging.onTokenRefresh).called(1);
      verify(() => mockProfileRepository.updateFcmToken('newToken')).called(1);
    });
    test(
        'should listen to FCM token changes and set '
        'token to null when error occurs', () async {
      // Arrange
      final tokenStream = Stream<String>.error('');
      when(() => mockFirebaseMessaging.onTokenRefresh)
          .thenAnswer((_) => tokenStream);
      when(() => mockProfileRepository.updateFcmToken(any())).thenAnswer(
        (_) => Future.value(nullSuccess),
      );

      // Act
      notificationController.listenToFcmTokenChanges();
      await Future<void>.delayed(Duration.zero);

      // Assert
      verify(() => mockFirebaseMessaging.onTokenRefresh).called(1);
      verify(() => mockProfileRepository.updateFcmToken(null)).called(1);
    });
  });
}
