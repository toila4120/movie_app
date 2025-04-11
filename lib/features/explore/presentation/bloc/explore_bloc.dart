import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/features/explore/domain/usecase/search_movie_usecase.dart';
import 'package:movie_app/features/explore/presentation/enum/search_status.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/injection_container.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final Map<String, List<MovieEntity>> _searchCache = {};

  ExploreBloc() : super(ExploreState.init()) {
    on<ExploreEventSearch>(_onExploreEventSearch);
  }

  Future<void> _onExploreEventSearch(
    ExploreEventSearch event,
    Emitter<ExploreState> emit,
  ) async {
    if (state.hasReachedMax && event.page != 1 ||
        (event.page <= state.page && event.page != 1) ||
        event.page >= 4 ||
        event.page != 1 && state.movies.isEmpty) {
      return;
    }
    print(' searching for ${event.query} page ${event.page}');
    if (event.query.isEmpty) {
      emit(state.copyWith(
        loadingState: LoadingState.pure,
        searchStatus: SearchStatus.initial,
        movies: [],
        page: 1,
        hasReachedMax: false,
      ));
      return;
    }

    final cacheKey = '${event.query}_${event.page}';
    if (_searchCache.containsKey(cacheKey)) {
      final cachedMovies = _searchCache[cacheKey]!;
      emit(state.copyWith(
        loadingState: LoadingState.finished,
        searchStatus:
            cachedMovies.isEmpty ? SearchStatus.empty : SearchStatus.success,
        movies:
            event.page == 1 ? cachedMovies : [...state.movies, ...cachedMovies],
        lastQuery: event.query,
        page: event.page,
      ));
      return;
    }

    emit(state.copyWith(
      loadingState: LoadingState.loading,
      searchStatus: SearchStatus.loading,
      movies: event.page == 1 ? [] : state.movies,
      errorMessage: '',
    ));

    try {
      final usecase = getIt<SearchMovieUsecase>();
      final movies = await usecase.searchMovie(event.query, event.page);

      final hasReachedMax = movies.isEmpty || movies.length < 12;
      _searchCache[cacheKey] = movies;
      final updatedMovies =
          event.page == 1 ? movies : [...state.movies, ...movies];

      emit(state.copyWith(
        loadingState: LoadingState.finished,
        searchStatus:
            movies.isEmpty ? SearchStatus.empty : SearchStatus.success,
        movies: updatedMovies,
        lastQuery: event.query,
        page: event.page,
        hasReachedMax: hasReachedMax,
      ));
    } catch (e) {
      String errorMessage = 'Có lỗi xảy ra, vui lòng thử lại sau';
      if (e is SocketException) {
        errorMessage = 'Làm ơn kiểm tra kết nối mạng của bạn';
      } else if (e is TimeoutException) {
        errorMessage = 'Quá thời gian chờ, vui lòng thử lại';
      } else if (e is Exception) {
        errorMessage = 'Có lỗi xảy ra, vui lòng thử lại sau';
      }
      emit(state.copyWith(
        loadingState: LoadingState.error,
        searchStatus: SearchStatus.error,
        errorMessage: errorMessage,
      ));
    }
  }
}
