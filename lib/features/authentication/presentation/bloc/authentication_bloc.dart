import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/core/utils/app_utils.dart';
import 'package:movie_app/features/authentication/data/model/user_model.dart';
import 'package:movie_app/features/authentication/domain/entities/subscription_plan.dart';
import 'package:movie_app/features/authentication/domain/entities/user_entity.dart';
import 'package:movie_app/features/authentication/domain/usecase/login_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/login_with_google_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/register_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/update_display_name_usecase.dart';
import 'package:movie_app/features/authentication/domain/usecase/update_user_usecase.dart';
import 'package:movie_app/injection_container.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState.init()) {
    on<AuthenticationLoginEvent>(_onAuthencationLoginEvent);
    on<AuthenticationRegisterEvent>(_onAuthencationRegisterEvent);
    // on<AuthenticationForgotPasswordEvent>(_onAuthencationForgotPasswordEvent);
    on<AuthenticationGoogleLoginEvent>(_onAuthenticationGoogleLoginEvent);
    on<LikeMovieEvent>(_onLikeMovieEvent);
    on<UpdateWatchedMovieEvent>(_onUpdateWatchedMovieEvent);
    on<UpdateSubscriptionPlanEvent>(_onUpdateSubscriptionPlanEvent);
    on<UpdateGenresEvent>(_onUpdateGenresEvent);
  }

  Future<void> _onAuthencationLoginEvent(
    AuthenticationLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.isLoading == LoadingState.loading) {
      return;
    }

    emit(state.copyWith(isLoading: LoadingState.loading, error: null));

    final email = event.email.trim();
    final password = event.password.trim();

    if (email.isEmpty) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Email can't be empty.",
      ));
      return;
    }

    if (!validateEmail(email)) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Invalid email format.",
      ));
      return;
    }

    if (password.isEmpty) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Password can't be empty.",
      ));
      return;
    }

    try {
      final loginUseCase = getIt<LoginUseCase>();
      final user = await loginUseCase(email, password);
      emit(state.copyWith(
        isLoading: LoadingState.finished,
        user: user,
        action: AuthAction.login,
      ));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.code == 'user-not-found'
            ? 'No user found for that email.'
            : e.code == 'wrong-password'
                ? 'Wrong password provided for that user.'
                : e.code == 'invalid-email'
                    ? 'Invalid email provided.'
                    : e.code,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAuthencationRegisterEvent(
    AuthenticationRegisterEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.isLoading == LoadingState.loading) {
      return;
    }

    emit(state.copyWith(isLoading: LoadingState.loading, error: null));

    final email = event.email.trim();
    final password = event.password.trim();
    final passwordConfirm = event.passwordConfirm.trim();
    final name = event.name.trim();

    if (name.isEmpty) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Name can't be empty.",
      ));
      return;
    }

    if (email.isEmpty) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Email can't be empty.",
      ));
      return;
    }

    if (!validateEmail(email)) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Invalid email format.",
      ));
      return;
    }

    if (password.isEmpty || passwordConfirm.isEmpty) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Password can't be empty.",
      ));
      return;
    }

    if (password != passwordConfirm) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: "Passwords do not match.",
      ));
      return;
    }

    try {
      final registerUseCase = getIt<RegisterUseCase>();
      UserEntity user = await registerUseCase(email, password);

      // Cập nhật tên người dùng
      final updateDisplayNameUseCase = getIt<UpdateDisplayNameUseCase>();
      await updateDisplayNameUseCase(name);
      user = user.copyWith(name: name);

      emit(state.copyWith(
        isLoading: LoadingState.finished,
        user: user,
        action: AuthAction.register,
      ));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.code == 'weak-password'
            ? 'The password provided is too weak.'
            : e.code == 'email-already-in-use'
                ? 'The account already exists for that email.'
                : e.code == 'invalid-email'
                    ? 'Invalid email provided.'
                    : e.code,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.toString(),
      ));
    }
  }

  // Future<void> _onAuthencationForgotPasswordEvent(
  //   AuthenticationForgotPasswordEvent event,
  //   Emitter<AuthenticationState> emit,
  // ) async {
  //   if (state.isLoading == LoadingState.loading) {
  //     return;
  //   }

  //   emit(state.copyWith(isLoading: LoadingState.loading, error: null));

  //   final email = event.email.trim();

  //   if (email.isEmpty) {
  //     emit(state.copyWith(
  //       isLoading: LoadingState.error,
  //       error: "Email can't be empty.",
  //     ));
  //     return;
  //   }

  //   if (!validateEmail(email)) {
  //     emit(state.copyWith(
  //       isLoading: LoadingState.error,
  //       error: "Invalid email format.",
  //     ));
  //     return;
  //   }

  //   try {
  //     final forgotPasswordUseCase = getIt<ForgotPasswordUseCase>();
  //     await forgotPasswordUseCase(email);
  //     emit(state.copyWith(
  //       isLoading: LoadingState.finished,
  //       isPasswordResetEmailSent: true,
  //     ));
  //   } on FirebaseAuthException catch (e) {
  //     emit(state.copyWith(
  //       isLoading: LoadingState.error,
  //       error: e.code == 'user-not-found'
  //           ? 'No user found for that email.'
  //           : e.code == 'invalid-email'
  //               ? 'Invalid email provided.'
  //               : e.code,
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(
  //       isLoading: LoadingState.error,
  //       error: e.toString(),
  //     ));
  //   }
  // }

  Future<void> _onAuthenticationGoogleLoginEvent(
    AuthenticationGoogleLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.isLoading == LoadingState.loading) {
      return;
    }

    emit(state.copyWith(isLoading: LoadingState.loading, error: null));

    try {
      final googleLoginUseCase = getIt<LoginWithGoogleUsecase>();
      final user = await googleLoginUseCase();
      emit(state.copyWith(
        isLoading: LoadingState.finished,
        user: user,
        action: AuthAction.login,
      ));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.code == 'account-exists-with-different-credential'
            ? 'Account exists with a different credential.'
            : e.code == 'invalid-credential'
                ? 'Invalid credential provided.'
                : e.code,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLikeMovieEvent(
    LikeMovieEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.user == null) {
      emit(state.copyWith(
        error: 'User not logged in.',
      ));
      return;
    }

    final updatedLikedMovies = List<String>.from(state.user!.likedMovies);
    if (updatedLikedMovies.contains(event.movieId)) {
      updatedLikedMovies.remove(event.movieId);
    } else {
      updatedLikedMovies.add(event.movieId);
    }

    final updatedUser = UserModel(
      uid: state.user!.uid,
      email: state.user!.email,
      name: state.user!.name,
      avatar: state.user!.avatar,
      subscriptionPlan: state.user!.subscriptionPlan,
      likedMovies: updatedLikedMovies,
      watchedMovies: state.user!.watchedMovies,
    );

    try {
      final updateUserUseCase = getIt<UpdateUserUseCase>();
      await updateUserUseCase(updatedUser);
      emit(state.copyWith(user: updatedUser));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdateWatchedMovieEvent(
    UpdateWatchedMovieEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.user == null) {
      emit(state.copyWith(error: 'User not logged in.'));
      return;
    }

    final updatedWatchedMovies =
        List<WatchedMovie>.from(state.user!.watchedMovies);
    final movieIndex =
        updatedWatchedMovies.indexWhere((m) => m.movieId == event.movieId);

    WatchedMovie updatedMovie;

    if (movieIndex == -1) {
      // Create new movie entry
      updatedMovie = WatchedMovie(
        movieId: event.movieId,
        isSeries: event.isSeries,
        name: event.name,
        thumbUrl: event.thumbUrl,
        episodeTotal: event.episodeTotal,
        time: event.time,
        watchedEpisodes: {
          event.episode: WatchedEpisode(
            duration: event.watchedDuration,
            serverName: event.serverName,
          ),
        },
      );
      updatedWatchedMovies.add(updatedMovie);
    } else {
      // Update existing movie
      final existingMovie = updatedWatchedMovies[movieIndex];
      final updatedEpisodes =
          Map<int, WatchedEpisode>.from(existingMovie.watchedEpisodes);
      updatedEpisodes[event.episode] = WatchedEpisode(
        duration: event.watchedDuration,
        serverName: event.serverName,
      );

      updatedMovie = WatchedMovie(
        movieId: existingMovie.movieId,
        isSeries: existingMovie.isSeries,
        name: existingMovie.name,
        thumbUrl: existingMovie.thumbUrl,
        episodeTotal: existingMovie.episodeTotal,
        watchedEpisodes: updatedEpisodes,
        time: existingMovie.time,
      );
      updatedWatchedMovies[movieIndex] = updatedMovie;
    }

    // Move the updated movie to the top of the list
    updatedWatchedMovies.removeWhere((m) => m.movieId == updatedMovie.movieId);
    updatedWatchedMovies.insert(0, updatedMovie);

    final updatedUser = UserModel(
      uid: state.user!.uid,
      email: state.user!.email,
      name: state.user!.name,
      avatar: state.user!.avatar,
      subscriptionPlan: state.user!.subscriptionPlan,
      likedMovies: state.user!.likedMovies,
      watchedMovies: updatedWatchedMovies,
    );

    try {
      final updateUserUseCase = getIt<UpdateUserUseCase>();
      await updateUserUseCase(updatedUser);
      emit(state.copyWith(user: updatedUser));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdateSubscriptionPlanEvent(
    UpdateSubscriptionPlanEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.user == null) {
      emit(state.copyWith(
        error: 'User not logged in.',
      ));
      return;
    }

    final updatedUser = UserModel(
      uid: state.user!.uid,
      email: state.user!.email,
      name: state.user!.name,
      avatar: state.user!.avatar,
      subscriptionPlan: event.subscriptionPlan,
      likedMovies: state.user!.likedMovies,
      watchedMovies: state.user!.watchedMovies,
    );

    try {
      final updateUserUseCase = getIt<UpdateUserUseCase>();
      await updateUserUseCase(updatedUser);
      emit(state.copyWith(
        user: updatedUser,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdateGenresEvent(
    UpdateGenresEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state.user == null) {
      emit(state.copyWith(
        error: 'User not logged in.',
      ));
      return;
    }

    final updatedUser = UserModel(
      uid: state.user!.uid,
      email: state.user!.email,
      name: state.user!.name,
      avatar: state.user!.avatar,
      subscriptionPlan: state.user!.subscriptionPlan,
      likedMovies: state.user!.likedMovies,
      watchedMovies: state.user!.watchedMovies,
      likedGenres: event.genres,
    );

    try {
      final updateUserUseCase = getIt<UpdateUserUseCase>();
      await updateUserUseCase(updatedUser);
      emit(state.copyWith(
        user: updatedUser,
        action: AuthAction.none,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
