import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  static const String _emailKey = 'email';
  static const String _onBoardingSeenKey = 'onBoarding_seen';

  static Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  static Future<void> saveEmail(String email) async {
    final prefs = await _prefs();
    await prefs.setString(_emailKey, email);
  }

  static Future<String?> getEmail() async {
    final prefs = await _prefs();
    return prefs.getString(_emailKey);
  }

  static Future<bool> isLoggedIn() async {
    final String? email = await getEmail();
    return email != null && email.isNotEmpty;
  }

  static Future<void> clearEmail() async {
    final prefs = await _prefs();
    await prefs.remove(_emailKey);
  }

  static Future<void> setOnBoardingSeen() async {
    final prefs = await _prefs();
    await prefs.setBool(_onBoardingSeenKey, true);
  }

  static Future<bool> isOnBoardingSeen() async {
    final prefs = await _prefs();
    return prefs.getBool(_onBoardingSeenKey) ?? false;
  }
}