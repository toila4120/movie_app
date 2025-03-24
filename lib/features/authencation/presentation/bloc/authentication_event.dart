part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationLoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const AuthenticationLoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthenticationRegisterEvent extends AuthenticationEvent {
  final String email;
  final String password;
  final String passwordConfirm;
  final String name;

  const AuthenticationRegisterEvent({
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, passwordConfirm, name];
}

class AuthenticationForgotPasswordEvent extends AuthenticationEvent {
  final String email;

  const AuthenticationForgotPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthenticationGoogleLoginEvent extends AuthenticationEvent {}