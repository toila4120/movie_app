part of 'authentication_bloc.dart';

enum AuthAction {
  none,
  login,
  register,
  forgotPassword,
  googleLogin,
}

extension AuthActionExt on AuthAction {
  bool isLogin() => this == AuthAction.login;
  bool isRegister() => this == AuthAction.register;
  bool isForgotPassword() => this == AuthAction.forgotPassword;
  bool isGoogleLogin() => this == AuthAction.googleLogin;
}

class AuthenticationState extends Equatable {
  final LoadingState isLoading;
  final UserEntity? user;
  final String? error;
  final AuthAction action;
  final bool isRememberMe;
  final String? savedEmail;
  final String? savedPassword;

  const AuthenticationState({
    required this.isLoading,
    this.user,
    this.error,
    required this.action,
    this.isRememberMe = false,
    this.savedEmail,
    this.savedPassword,
  });

  factory AuthenticationState.init() {
    return const AuthenticationState(
      isLoading: LoadingState.pure,
      action: AuthAction.none,
    );
  }

  AuthenticationState copyWith({
    LoadingState? isLoading,
    UserEntity? user,
    String? error,
    AuthAction? action,
    bool? isRememberMe,
    String? savedEmail,
    String? savedPassword,
  }) {
    return AuthenticationState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
      action: action ?? this.action,
      isRememberMe: isRememberMe ?? this.isRememberMe,
      savedEmail: savedEmail ?? this.savedEmail,
      savedPassword: savedPassword ?? this.savedPassword,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, user, error, action, isRememberMe, savedEmail, savedPassword];
}
