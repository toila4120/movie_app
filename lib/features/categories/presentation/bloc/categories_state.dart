import 'package:equatable/equatable.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/features/movie/data/model/movie_model.dart';
import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';

class CategoriesState extends Equatable {
  final LoadingState loadingState;
  final List<CategoryEntity> categories;
  final String? errorMessage;

  const CategoriesState({
    required this.loadingState,
    required this.categories,
    this.errorMessage,
  });

  factory CategoriesState.init() {
    return const CategoriesState(
      loadingState: LoadingState.pure,
      categories: [],
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
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        loadingState,
        categories,
        errorMessage,
      ];
}
