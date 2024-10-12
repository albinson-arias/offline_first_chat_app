import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:offline_first_chat_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';
import 'package:offline_first_chat_app/src/core/utils/open_flutter_settings.dart';

class NotificationController {
  const NotificationController({
    required FirebaseMessaging messaging,
    required ProfileRepository profileRepository,
    required GlobalStore globalStore,
    required OpenFlutterSettings openFlutterSettings,
  })  : _messaging = messaging,
        _profileRepository = profileRepository,
        _globalStore = globalStore,
        _openFlutterSettings = openFlutterSettings;

  final FirebaseMessaging _messaging;
  final ProfileRepository _profileRepository;
  final GlobalStore _globalStore;
  final OpenFlutterSettings _openFlutterSettings;

  Future<void> requestPermissions({bool goToSettingsIfDenied = false}) async {
    if (_globalStore.userDeniedNotifications) {
      await disableNotifications();
      return;
    }
    final settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await getFcmToken();
    } else {
      if (goToSettingsIfDenied) {
        await _openFlutterSettings.goToNotifications(
          requestPermissions,
        );
        return;
      }
      await disableNotifications();
    }
  }

  Future<void> disableNotifications() async {
    _globalStore.userDeniedNotifications = true;
    await _profileRepository.updateFcmToken(null);
  }

  Future<void> getFcmToken() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final apnsToken = await _messaging.getAPNSToken();
      if (apnsToken == null) {
        return;
      }
    }

    final fcmToken = await _messaging.getToken();

    debugPrint('🚗💨 got fcmToken');
    await _profileRepository.updateFcmToken(fcmToken);
  }

  void listenToFcmTokenChanges() {
    _messaging.onTokenRefresh.listen(
      (event) async {
        debugPrint('🚗💨 got fcmToken');
        await _profileRepository.updateFcmToken(event);
      },
    ).onError(
      (err) {
        _profileRepository.updateFcmToken(null);
      },
    );
  }
}
