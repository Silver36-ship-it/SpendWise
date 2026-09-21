import 'user.dart';

class AuthSession {
  final User user;
  final String accessToken;
  final String? refreshToken;

  const AuthSession({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });
}