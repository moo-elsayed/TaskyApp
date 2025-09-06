import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const String isFirstTimeKey = 'isFirstTime';

  static Future<void> setFirstTime(bool isFirstTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isFirstTimeKey, isFirstTime);
  }

  static Future<bool> getFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isFirstTimeKey) ?? true;
  }
}
