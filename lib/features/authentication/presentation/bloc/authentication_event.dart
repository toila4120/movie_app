part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationLoginEvent extends AuthenticationEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const AuthenticationLoginEvent({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        rememberMe,
      ];
}

class CheckSavedCredentialsEvent extends AuthenticationEvent {}

class SaveRememberMeEvent extends AuthenticationEvent {
  final bool rememberMe;
  final String email;
  final String password;

  const SaveRememberMeEvent({
    required this.rememberMe,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        rememberMe,
        email,
        password,
      ];
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
  List<Object?> get props => [
        name,
        email,
        password,
        passwordConfirm,
        name,
      ];
}

class AuthenticationForgotPasswordEvent extends AuthenticationEvent {
  final String email;

  const AuthenticationForgotPasswordEvent({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];
}

class AuthenticationGoogleLoginEvent extends AuthenticationEvent {
  final bool rememberMe;

  const AuthenticationGoogleLoginEvent({
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [rememberMe];
}

class LikeMovieEvent extends AuthenticationEvent {
  final String movieId;

  const LikeMovieEvent({
    required this.movieId,
  });

  @override
  List<Object?> get props => [
        movieId,
      ];
}

class UpdateWatchedMovieEvent extends AuthenticationEvent {
  final String movieId;
  final bool isSeries;
  final int episode;
  final Duration watchedDuration;
  final String name;
  final String thumbUrl;
  final int episodeTotal;
  final String serverName; // Thêm serverName
  final int time;

  const UpdateWatchedMovieEvent({
    required this.movieId,
    required this.isSeries,
    required this.episode,
    required this.watchedDuration,
    required this.name,
    required this.thumbUrl,
    required this.episodeTotal,
    required this.serverName,
    required this.time,
  });

  @override
  List<Object?> get props => [
        movieId,
        isSeries,
        episode,
        watchedDuration,
        name,
        thumbUrl,
        episodeTotal,
        serverName,
        time,
      ];
}

// class UpdateSubscriptionPlanEvent extends AuthenticationEvent {
//   final SubscriptionPlan subscriptionPlan;

//   const UpdateSubscriptionPlanEvent({
//     required this.subscriptionPlan,
//   });

//   @override
//   List<Object?> get props => [
//         subscriptionPlan,
//       ];
// }

class UpdateGenresEvent extends AuthenticationEvent {
  final List<String> genres;

  const UpdateGenresEvent({
    required this.genres,
  });

  @override
  List<Object?> get props => [
        genres,
      ];
}

class LogoutEvent extends AuthenticationEvent {
  const LogoutEvent();
}

class RemoveWatchedMovieEvent extends AuthenticationEvent {
  final String movieId;

  const RemoveWatchedMovieEvent({
    required this.movieId,
  });

  @override
  List<Object?> get props => [
        movieId,
      ];
}
