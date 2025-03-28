import 'package:equatable/equatable.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/features/categories/data/model/movie_model.dart';
import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';

class CategoriesState extends Equatable {
  final LoadingState loadingState;
  final List<CategoryEntity> categories;
  final int page;
  final bool hasReachedMax;
  final List<MovieModel> movies;
  final String? errorMessage;

  const CategoriesState({
    required this.loadingState,
    required this.categories,
    required this.page,
    required this.hasReachedMax,
    this.movies = const [],
    this.errorMessage,
  });

  factory CategoriesState.init() {
    return const CategoriesState(
      loadingState: LoadingState.pure,
      page: 0,
      categories: [],
      hasReachedMax: false,
      movies: [],
      errorMessage: null,
    );
  }

  CategoriesState copyWith({
    LoadingState? loadingState,
    List<CategoryEntity>? categories,
    List<MovieModel>? movies,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
  }) {
    return CategoriesState(
      loadingState: loadingState ?? this.loadingState,
      categories: categories ?? this.categories,
      page: page ?? this.page,
      movies: movies ?? this.movies,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        loadingState,
        categories,
        page,
        movies,
        errorMessage,
        hasReachedMax,
      ];
}
