import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/features/movie/domain/entities/actor_entity.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movie/domain/usecase/fectch_movie_actor_usecase.dart';
import 'package:movie_app/features/movie/domain/usecase/fetch_movie_by_list_usecase.dart';
import 'package:movie_app/features/movie/domain/usecase/fetch_movie_detail_usecase.dart';
import 'package:movie_app/features/movie/domain/usecase/fetch_movies_by_category_usecase.dart';
import 'package:movie_app/features/movie/domain/usecase/fetch_new_movie_usecase.dart';
import 'package:movie_app/injection_container.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieState.init()) {
    on<FetchMoviesByCategory>(_onFetchMoviesByCategory);
    on<FetchMovieDetailEvent>(_onFetchMovieDetail);
    on<FetchMovieByListEvent>(_onFetchMovieByList);
    on<FetchNewMoviesEvent>(_onFetchNewMovies);
    on<ClearMovieStateEvent>(_onClearMovieState);
  }

  Future<void> _onFetchMoviesByCategory(
      FetchMoviesByCategory event, Emitter<MovieState> emit) async {
    if (event.page <= state.page && event.page != 1) {
      return;
    }

    emit(state.copyWith(
      loadingState: LoadingState.loading,
      errorMessage: null,
      page: event.page,
    ));

    try {
      final useCase = getIt<FetchMoviesByCategoryUseCase>();
      final movies = await useCase(event.categorySlug, event.page);
      final updatedMovies =
          event.page == 1 ? movies : [...state.movies, ...movies];
      emit(state.copyWith(
        loadingState: LoadingState.finished,
        movies: updatedMovies,
        hasReachedMax: movies.length < 10,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingState: LoadingState.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchMovieDetail(
      FetchMovieDetailEvent event, Emitter<MovieState> emit) async {
    emit(
        state.copyWith(loadingState: LoadingState.loading, errorMessage: null));

    try {
      final useCase = getIt<FetchMovieDetailUsecase>();
      final actorUseCase = getIt<FectchMovieActorUsecase>();
      final movie = await useCase(event.slug);
      final actors = await actorUseCase(event.slug);
      emit(state.copyWith(
        loadingState: LoadingState.finished,
        movie: movie,
        actor: actors.isNotEmpty ? actors : [],
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingState: LoadingState.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchMovieByList(
      FetchMovieByListEvent event, Emitter<MovieState> emit) async {
    if (event.page <= state.page && event.page != 1) {
      return;
    }

    emit(state.copyWith(
      loadingState: LoadingState.loading,
      errorMessage: null,
      page: event.page,
    ));

    try {
      final useCase = getIt<FetchMovieByListUsecase>();
      final movies = await useCase(event.listSlug, event.page);
      final updatedMovies =
          event.page == 1 ? movies : [...state.movies, ...movies];
      emit(state.copyWith(
        loadingState: LoadingState.finished,
        movies: updatedMovies,
        hasReachedMax: movies.length < 10,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingState: LoadingState.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchNewMovies(
      FetchNewMoviesEvent event, Emitter<MovieState> emit) async {
    if (event.page <= state.page && event.page != 1) {
      return;
    }

    emit(state.copyWith(
      loadingState: LoadingState.loading,
      errorMessage: null,
      page: event.page,
    ));

    try {
      final useCase = getIt<FetchNewMovieUsecase>();
      final movies = await useCase(event.page);
      final updatedMovies =
          event.page == 1 ? movies : [...state.movies, ...movies];
      emit(state.copyWith(
        loadingState: LoadingState.finished,
        movies: updatedMovies,
        hasReachedMax: movies.length < 24,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingState: LoadingState.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onClearMovieState(
      ClearMovieStateEvent event, Emitter<MovieState> emit) {
    emit(state.copyWith(
      movie: null,
      loadingState: LoadingState.pure,
      errorMessage: null,
    ));
  }
}
