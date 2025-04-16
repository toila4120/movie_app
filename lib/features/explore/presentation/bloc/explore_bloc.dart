import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/features/explore/domain/entities/filter_param.dart';
import 'package:movie_app/features/explore/domain/entities/region_entities.dart';
import 'package:movie_app/features/explore/domain/usecase/filter_movie_usecase.dart';
import 'package:movie_app/features/explore/domain/usecase/get_region_usecase.dart';
import 'package:movie_app/features/explore/domain/usecase/search_movie_usecase.dart';
import 'package:movie_app/features/explore/presentation/enum/data_source.dart';
import 'package:movie_app/features/explore/presentation/enum/search_status.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/injection_container.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final Map<String, List<MovieEntity>> _searchCache = {};

  ExploreBloc() : super(ExploreState.init()) {
    on<ExploreEventSearch>(_onExploreEventSearch);
    on<UpdateCategoriesEvent>(_onUpdateCategoriesEvent);
    on<UpdategGenreEvent>(_onUpdategGenreEvent);
    on<UpdateTranslationEvent>(_onUpdateTranslationEvent);
    on<UpdateYearEvent>(_onUpdateYearEvent);
    on<UpdateRegionEvent>(_onUpdateRegionEvent);
    on<UpdateSortEvent>(_onUpdateSortEvent);
    on<FetchRegionsEvent>(_onFetchRegionsEvent);
    on<FilterMovieEvent>(_onFilterMovieEvent);
    on<ResetFilterEvent>(_onResetFilterEvent);
  }

  Future<void> _onExploreEventSearch(
    ExploreEventSearch event,
    Emitter<ExploreState> emit,
  ) async {
    if (event.page == 1) {
      emit(state.copyWith(
        movies: [],
        categories: [],
        genres: [],
        translations: [],
        years: [],
        regions: [],
        sort: '',
        dataSource: DataSource.search,
      ));
    }
    if (state.hasReachedMax && event.page != 1 ||
        (event.page <= state.page && event.page != 1) ||
        event.page != 1 && state.movies.isEmpty) {
      return;
    }
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

  void _onUpdateCategoriesEvent(
      UpdateCategoriesEvent event, Emitter<ExploreState> emit) {
    List<String> categories = List.from(state.categories);

    if (event.category == 'all' && !categories.contains('all')) {
      categories = ['all'];
    } else if (event.category == 'all' && categories.contains('all')) {
      categories.remove('all');
    } else if (categories.contains('all') && event.category != 'all') {
      categories.remove('all');
      if (!categories.contains(event.category)) {
        categories.add(event.category);
      }
    } else if (categories.contains(event.category)) {
      categories.remove(event.category);
    } else {
      categories.add(event.category);
    }

    emit(state.copyWith(categories: categories));
  }

  void _onUpdategGenreEvent(
      UpdategGenreEvent event, Emitter<ExploreState> emit) {
    List<String> genres = List.from(state.genres);

    if (event.genre == 'all' && !genres.contains('all')) {
      genres = ['all'];
    } else if (event.genre == 'all' && genres.contains('all')) {
      genres.remove('all');
    } else if (genres.contains('all') && event.genre != 'all') {
      genres.remove('all');
      if (!genres.contains(event.genre)) {
        genres.add(event.genre);
      }
    } else if (genres.contains(event.genre)) {
      genres.remove(event.genre);
    } else {
      genres.add(event.genre);
    }

    emit(state.copyWith(genres: genres));
  }

  void _onUpdateTranslationEvent(
      UpdateTranslationEvent event, Emitter<ExploreState> emit) {
    List<String> translations = List.from(state.translations);

    if (event.translation == 'all' && !translations.contains('all')) {
      translations = ['all'];
    } else if (event.translation == 'all' && translations.contains('all')) {
      translations.remove('all');
    } else if (translations.contains('all') && event.translation != 'all') {
      translations.remove('all');
      if (!translations.contains(event.translation)) {
        translations.add(event.translation);
      }
    } else if (translations.contains(event.translation)) {
      translations.remove(event.translation);
    } else {
      translations.add(event.translation);
    }

    emit(state.copyWith(translations: translations));
  }

  void _onUpdateYearEvent(UpdateYearEvent event, Emitter<ExploreState> emit) {
    List<String> years = List.from(state.years);

    if (event.year == 'all' && !years.contains('all')) {
      years = ['all'];
    } else if (event.year == 'all' && years.contains('all')) {
      years.remove('all');
    } else if (years.contains('all') && event.year != 'all') {
      years.remove('all');
      if (!years.contains(event.year)) {
        years.add(event.year);
      }
    } else if (years.contains(event.year)) {
      years.remove(event.year);
    } else {
      years.add(event.year);
    }

    emit(state.copyWith(years: years));
  }

  void _onUpdateRegionEvent(
      UpdateRegionEvent event, Emitter<ExploreState> emit) {
    List<String> regions = List.from(state.regions);

    if (event.region == 'all' && !regions.contains('all')) {
      regions = ['all'];
    } else if (event.region == 'all' && regions.contains('all')) {
      regions.remove('all');
    } else if (regions.contains('all') && event.region != 'all') {
      regions.remove('all');
      if (!regions.contains(event.region)) {
        regions.add(event.region);
      }
    } else if (regions.contains(event.region)) {
      regions.remove(event.region);
    } else {
      regions.add(event.region);
    }

    emit(state.copyWith(regions: regions));
  }

  void _onUpdateSortEvent(UpdateSortEvent event, Emitter<ExploreState> emit) {
    emit(state.copyWith(sort: event.sort));
  }

  Future<void> _onFetchRegionsEvent(
      FetchRegionsEvent event, Emitter<ExploreState> emit) async {
    if (state.availableRegions.isNotEmpty) return;
    emit(state.copyWith(loadingState: LoadingState.loading));
    try {
      final useCase = getIt<GetRegionsUsecase>();
      final regions = await useCase();
      emit(state.copyWith(
        loadingState: LoadingState.finished,
        availableRegions: regions,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingState: LoadingState.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetFilterEvent(ResetFilterEvent event, Emitter<ExploreState> emit) {
    emit(
      state.copyWith(
        categories: [],
        genres: [],
        translations: [],
        years: [],
        regions: [],
        sort: '',
        dataSource: DataSource.initial,
      ),
    );
  }

  String formatYear(List<String> years) {
    if (years.contains('all')) {
      return '';
    }

    if (years.isEmpty) {
      return '';
    }

    List<int> intYears = years.map(int.parse).toList()..sort();
    int minYear = intYears.first;
    int maxYear = intYears.last;

    return '$minYear-$maxYear';
  }

  Future<void> _onFilterMovieEvent(
      FilterMovieEvent event, Emitter<ExploreState> emit) async {
    if (event.page == 1) {
      emit(state.copyWith(
        movies: [],
        dataSource: DataSource.filter,
        loadingState: LoadingState.loading,
      ));
    }
    if (state.hasReachedMax && event.page != 1 ||
        (event.page <= state.page && event.page != 1) ||
        (event.page != 1 && state.movies.isEmpty)) {
      return;
    }

    final filterParam = FilterParam(
      typeList:
          state.categories.contains('all') ? '' : state.categories.join(','),
      genres: state.genres.contains('all') ? '' : state.genres.join(','),
      translations: state.translations.contains('all')
          ? ''
          : state.translations.join(','),
      sortField: state.sort,
      sortType: 'desc',
      years: formatYear(state.years),
      countries: state.regions.contains('all') ? '' : state.regions.join(','),
      limit: 24,
    );

    emit(state.copyWith(
      loadingState: LoadingState.loading,
      dataSource: DataSource.filter,
    ));

    try {
      final usecase = getIt<FilterMovieUsecase>();
      final movies = await usecase.filterMovies(filterParam, event.page);

      final hasReachedMax = movies.isEmpty || movies.length < filterParam.limit;
      final updatedMovies =
          event.page == 1 ? movies : [...state.movies, ...movies];

      emit(state.copyWith(
        loadingState: LoadingState.finished,
        searchStatus:
            movies.isEmpty ? SearchStatus.empty : SearchStatus.success,
        dataSource: DataSource.filter,
        movies: updatedMovies,
        page: event.page,
        hasReachedMax: hasReachedMax,
        filterParam: filterParam,
        errorMessage: null,
      ));
    } catch (e) {
      String errorMessage = 'Có lỗi xảy ra, vui lòng thử lại sau';
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          errorMessage = 'Quá thời gian chờ, vui lòng thử lại';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'Làm ơn kiểm tra kết nối mạng của bạn';
        } else {
          errorMessage =
              'Lỗi máy chủ: ${e.response?.statusCode ?? 'Không xác định'}';
        }
      }

      emit(state.copyWith(
        loadingState: LoadingState.finished,
        searchStatus: SearchStatus.error,
        dataSource: DataSource.filter,
        errorMessage: errorMessage,
      ));
    }
  }
}
