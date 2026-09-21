import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';

  final SharedPreferences preferences;

  const TokenStorage({
    required this.preferences,
  });

  Future<void> saveAccessToken(String token) async {
    await preferences.setString(
      _accessTokenKey,
      token,
    );
  }

  Future<String?> getAccessToken() async {
    return preferences.getString(
      _accessTokenKey,
    );
  }

  Future<void> clear() async {
    await preferences.remove(
      _accessTokenKey,
    );
  }
}