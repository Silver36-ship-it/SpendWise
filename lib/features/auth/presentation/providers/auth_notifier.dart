
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/token_storage_provider.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

import 'auth_providers.dart';
import 'auth_state.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  late final AuthRepository repository;

  @override
  Future<AuthState> build() async {
    repository =
    await ref.watch(authRepositoryProvider.future);

    return _restoreSession();
  }

  Future<AuthState> _restoreSession() async {
    try {
      debugPrint('RESTORING AUTHENTICATION');

      final token = await ref
          .read(tokenStorageProvider)
          .getAccessToken();

      if (token == null) {
        debugPrint('NO SAVED TOKEN');

        return const AuthState();
      }

      final user = await repository.getCurrentUser();

      debugPrint(
        'SESSION RESTORED: ${user.username}',
      );

      return AuthState(
        session: AuthSession(
          user: user,
          accessToken: token,
          refreshToken: null,
        ),
      );
    } catch (e) {
      debugPrint(
        'SESSION RESTORATION FAILED: $e',
      );

      await ref
          .read(tokenStorageProvider)
          .clear();

      return const AuthState();
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final session = await repository.login(
        username: username,
        password: password,
      );

      state = AsyncData(
        AuthState(
          session: session,
        ),
      );
    } catch (e, stackTrace) {
      state = AsyncError(
        e,
        stackTrace,
      );
    }
  }

  Future<void> verifyAuthentication() async {
    try {
      debugPrint('VERIFYING AUTHENTICATION');

      final user = await repository.getCurrentUser();

      debugPrint(
        'AUTHENTICATED USER: ${user.username}',
      );
    } catch (e) {
      debugPrint(
        'AUTHENTICATION FAILED: $e',
      );
    }
  }

  Future<User?> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
  }) async {
    final previousState = state.valueOrNull;

    state = const AsyncLoading();

    try {
      final user = await repository.register(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
      );

      state = AsyncData(
        previousState ?? const AuthState(),
      );

      return user;
    } catch (e, stackTrace) {
      state = AsyncError(
        e,
        stackTrace,
      );

      return null;
    }
  }

  Future<void> loginAfterRegistration({
    required User user,
  }) async {
    state = AsyncData(
      AuthState(
        session: AuthSession(
          user: user,
          accessToken: 'local-demo-token',
          refreshToken: 'local-demo-refresh-token',
        ),
      ),
    );
  }

  Future<void> logout() async {
    try {
      await ref
          .read(tokenStorageProvider)
          .clear();

      state = const AsyncData(
        AuthState(),
      );
    } catch (e, stackTrace) {
      state = AsyncError(
        e,
        stackTrace,
      );
    }
  }
}
