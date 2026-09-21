import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_session_model.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;
  final TokenStorage tokenStorage;

  const AuthRepositoryImpl({
    required this.dataSource,
    required this.tokenStorage,
  });

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    final json = await dataSource.login(
      username: username,
      password: password,
    );

    final session = AuthSessionModel.fromJson(json);

    await tokenStorage.saveAccessToken(
      session.accessToken,
    );

    return session;
  }

  @override
  Future<User> getCurrentUser() async {
    final json = await dataSource.getCurrentUser();

    return UserModel.fromJson(json);
  }

  @override
  Future<User> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
  }) async {
    final json = await dataSource.register(
      firstName: firstName,
      lastName: lastName,
      username: username,
      password: password,
    );

    return UserModel.fromJson(json);
  }
}