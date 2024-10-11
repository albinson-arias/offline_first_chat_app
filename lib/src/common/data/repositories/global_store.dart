import 'package:shared_preferences/shared_preferences.dart';

class GlobalStore {
  const GlobalStore({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  // Auth
  String? get username {
    return _sharedPreferences.getString('GlobalStore-username');
  }

  set username(String? username) {
    if (username == null) {
      _sharedPreferences.remove('GlobalStore-username');
      return;
    }
    _sharedPreferences.setString('GlobalStore-username', username);
  }

  String? get userId {
    return _sharedPreferences.getString('GlobalStore-userId');
  }

  set userId(String? userId) {
    if (userId == null) {
      _sharedPreferences.remove('GlobalStore-userId');
      return;
    }
    _sharedPreferences.setString('GlobalStore-userId', userId);
  }

  // Notifications
  bool get userDeniedNotifications {
    return _sharedPreferences.getBool('GlobalStore-userDeniedNotifications') ??
        false;
  }

  set userDeniedNotifications(bool userDeniedNotifications) {
    _sharedPreferences.setBool(
      'GlobalStore-userDeniedNotifications',
      userDeniedNotifications,
    );
  }
}
