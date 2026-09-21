import '../entities/auth_session.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<AuthSession> login({
    required String username,
    required String password,
  });

  Future<User> getCurrentUser();

  Future<User> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
  });


}