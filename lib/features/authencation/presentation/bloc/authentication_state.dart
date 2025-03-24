part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final LoadingState isLoading;
  final String? error;
  final UserEntity? user;
  final bool isPasswordResetEmailSent;

  const AuthenticationState({
    required this.isLoading,
    this.error,
    this.user,
    this.isPasswordResetEmailSent = false,
  });

  factory AuthenticationState.init() {
    return const AuthenticationState(
      isLoading: LoadingState.pure,
      error: null,
      user: null,
      isPasswordResetEmailSent: false,
    );
  }

  AuthenticationState copyWith({
    LoadingState? isLoading,
    String? error,
    UserEntity? user,
    bool? isPasswordResetEmailSent,
  }) {
    return AuthenticationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
      isPasswordResetEmailSent:
          isPasswordResetEmailSent ?? this.isPasswordResetEmailSent,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, user, isPasswordResetEmailSent];
}
