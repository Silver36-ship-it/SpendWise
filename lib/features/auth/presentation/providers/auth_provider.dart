import 'package:flutter/foundation.dart';
import 'package:spend_wise/core/storage/token_storage.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;
  final TokenStorage tokenStorage;

  AuthProvider({
    required this.repository,
    required this.tokenStorage
  });

  AuthSession? _session;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitializing = true;

  User? get user => _session?.user;

  String? get accessToken => _session?.accessToken;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isInitializing => _isInitializing;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    debugPrint('1. LOGIN METHOD STARTED');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint('2. CALLING REPOSITORY');

      _session = await repository.login(
        username: username,
        password: password,
      );

      debugPrint('3. LOGIN SUCCESSFUL');
      debugPrint('USER: ${_session?.user.username}');
      debugPrint('TOKEN RECEIVED: ${_session?.accessToken.isNotEmpty}');
    } catch (e) {
      debugPrint('4. LOGIN ERROR');
      debugPrint('ERROR: $e');

      _errorMessage = e.toString();
    } finally {
      debugPrint('5. LOGIN FINISHED');

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyAuthentication() async {
    try {
      debugPrint('VERIFYING AUTHENTICATION');

      final user = await repository.getCurrentUser();

      debugPrint('AUTHENTICATION VERIFIED');
      debugPrint('AUTHENTICATED USER: ${user.username}');
    } catch (e) {
      debugPrint('AUTHENTICATION FAILED');
      debugPrint('ERROR: $e');
    }
  }

  Future<User?> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await repository.register(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
      );

      return user;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginAfterRegistration({
    required User user,
  }) async {
    _session = AuthSession(
      user: user,
      accessToken: 'local-demo-token',
      refreshToken: 'local-demo-refresh-token',
    );

    _errorMessage = null;
    notifyListeners();
  }

  Future<void> logout() async {
    _session = null;

    await tokenStorage.clear();

    _errorMessage = null;

    notifyListeners();
  }

  Future<void> restoreSession() async {
    try {
      final token = await tokenStorage.getAccessToken();

      if (token == null) {
        return;
      }

      final user = await repository.getCurrentUser();

      _session = AuthSession(
        user: user,
        accessToken: token,
        refreshToken: null,
      );
    } catch (e) {
      await tokenStorage.clear();
      _session = null;
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }
}