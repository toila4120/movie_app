import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/features/movie/data/model/movie_model.dart';
import 'package:movie_app/features/movie/domain/usecase/fetch_movies_by_category_usecase.dart';
import 'package:movie_app/injection_container.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieState.init()) {
    on<FetchMoviesByCategory>(_onFetchMoviesByCategory);
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
}
