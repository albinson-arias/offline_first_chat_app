import 'package:flutter/foundation.dart';
import 'package:flutter_open_app_settings/flutter_open_app_settings.dart';

class OpenFlutterSettings {
  const OpenFlutterSettings();

  /// Goes to app's notification settings and calls callback
  /// when  done
  Future<void> goToNotifications(void Function() callback) async {
    debugPrint('🚗💨 opening App Notifications Settings');
    await FlutterOpenAppSettings.openAppsSettings(
      settingsCode: SettingsCode.NOTIFICATION,
      onCompletion: callback,
    );
  }
}
