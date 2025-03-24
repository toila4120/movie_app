part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final LoadingState isLoading;
  final String error;

  const AuthenticationState({
    required this.isLoading,
    required this.error,
  });

  factory AuthenticationState.init() {
    return const AuthenticationState(
      isLoading: LoadingState.pure,
      error: "",
    );
  }

  AuthenticationState copyWith({
    LoadingState? isLoading,
    String? error,
  }) {
    return AuthenticationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        isLoading,
        error,
      ];
}
