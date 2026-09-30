
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';

class AuthState {
  final AuthSession? session;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.session,
    this.isLoading = false,
    this.errorMessage,
  });

  User? get user => session?.user;

  String? get accessToken => session?.accessToken;

  AuthState copyWith({
    AuthSession? session,
    bool? isLoading,
    String? errorMessage,
    bool clearSession = false,
    bool clearError = false,
  }) {
    return AuthState(
      session: clearSession ? null : session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
