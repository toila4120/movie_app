part of 'authentication_bloc.dart';

enum AuthAction {
  none,
  login,
  register;

  bool isNone() => this == none;
  bool isLogin() => this == login;
  bool isRegister() => this == register;
}

class AuthenticationState extends Equatable {
  final LoadingState isLoading;
  final String? error;
  final UserEntity? user;
  final bool isPasswordResetEmailSent;
  final AuthAction action;

  const AuthenticationState({
    required this.isLoading,
    this.error,
    this.user,
    this.isPasswordResetEmailSent = false,
    this.action = AuthAction.none,
  });

  factory AuthenticationState.init() {
    return const AuthenticationState(
      isLoading: LoadingState.pure,
      error: null,
      user: null,
      isPasswordResetEmailSent: false,
      action: AuthAction.none,
    );
  }

  AuthenticationState copyWith({
    LoadingState? isLoading,
    String? error,
    UserEntity? user,
    bool? isPasswordResetEmailSent,
    AuthAction? action,
  }) {
    return AuthenticationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
      isPasswordResetEmailSent:
          isPasswordResetEmailSent ?? this.isPasswordResetEmailSent,
      action: action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        user,
        isPasswordResetEmailSent,
        action,
      ];
}
