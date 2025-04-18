import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/features/authentication/domain/entities/user_entity.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/features/profile/domain/usecase/get_favorite_movies_usecase.dart';
import 'package:movie_app/injection_container.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState.init()) {
    on<GetFavoriteMoviesEvent>(_onGetFavoriteMoviesEvent);
    on<RemoveFavoriteMovieEvent>(_onRemoveFavoriteMovieEvent);
  }

  Future<void> _onGetFavoriteMoviesEvent(
      GetFavoriteMoviesEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: LoadingState.loading, error: null));
    try {
      final user = event.user;
      final useCase = getIt<GetFavoriteMoviesUsecase>();
      final result = await useCase(user.likedMovies);
      emit(state.copyWith(
        isLoading: LoadingState.finished,
        movies: result,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: e.toString(),
      ));
    }
  }

  void _onRemoveFavoriteMovieEvent(
      RemoveFavoriteMovieEvent event, Emitter<ProfileState> emit) {
    try {
      final updatedMovies = List<MovieEntity>.from(state.movies ?? []);
      final movieExists = updatedMovies.any((movie) => movie.slug == event.slug);

      if (movieExists) {
        updatedMovies.removeWhere((movie) => movie.slug == event.slug);
        emit(state.copyWith(
          isLoading: LoadingState.finished,
          movies: updatedMovies,
          error: null,
        ));
      } else {
        emit(state.copyWith(
          isLoading: LoadingState.finished,
          error: 'Không tìm thấy phim với slug: ${event.slug}',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: LoadingState.error,
        error: 'Không thể xóa phim: ${e.toString()}',
      ));
    }
  }
}
