import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_app_settings/flutter_open_app_settings.dart';
import 'package:offline_first_chat_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:offline_first_chat_app/src/common/data/repositories/global_store.dart';

class NotificationController {
  const NotificationController({
    required FirebaseMessaging messaging,
    required ProfileRepository profileRepository,
    required GlobalStore globalStore,
  })  : _messaging = messaging,
        _profileRepository = profileRepository,
        _globalStore = globalStore;

  final FirebaseMessaging _messaging;
  final ProfileRepository _profileRepository;
  final GlobalStore _globalStore;

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
        await FlutterOpenAppSettings.openAppsSettings(
          settingsCode: SettingsCode.NOTIFICATION,
          onCompletion: requestPermissions,
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
    if (Platform.isIOS) {
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
      (event) {
        debugPrint('🚗💨 got fcmToken');
        _profileRepository.updateFcmToken(event);
      },
    ).onError(
      (err) {
        _profileRepository.updateFcmToken(null);
      },
    );
  }
}
