import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';

  final FlutterSecureStorage storage;

  const TokenStorage({
    required this.storage,
  });

  Future<void> saveAccessToken(String token) async {
    await storage.write(
      key: _accessTokenKey,
      value: token,
    );
  }

  Future<String?> getAccessToken() async {
    return storage.read(
      key: _accessTokenKey,
    );
  }

  Future<void> clear() async {
    await storage.delete(
      key: _accessTokenKey,
    );
  }
}