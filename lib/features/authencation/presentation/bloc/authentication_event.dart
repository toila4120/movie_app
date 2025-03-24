part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationLoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const AuthenticationLoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthenticationLogoutEvent extends AuthenticationEvent {}

class AuthenticationRegisterEvent extends AuthenticationEvent {
  final String email;
  final String password;
  final String name;
  final String passwordConfirm;

  const AuthenticationRegisterEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.passwordConfirm,
  });

  @override
  List<Object> get props => [email, password];
}
