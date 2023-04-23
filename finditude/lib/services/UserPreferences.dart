// ignore: file_names
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setToken(String value) async =>
      await _preferences.setString("token", value);

  static String getToken() => _preferences.getString("token") ?? "";
}
