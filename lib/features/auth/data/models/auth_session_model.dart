import '../../domain/entities/auth_session.dart';
import 'user_model.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.user,
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      user: UserModel.fromJson(json),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}