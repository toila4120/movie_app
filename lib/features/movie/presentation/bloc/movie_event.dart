part of 'movie_bloc.dart';

sealed class MovieEvent extends Equatable {
  const MovieEvent();
}

class FetchMoviesByCategory extends MovieEvent {
  final String categorySlug;
  final int page;

  const FetchMoviesByCategory({
    required this.categorySlug,
    this.page = 1,
  });

  @override
  List<Object?> get props => [
        categorySlug,
        page,
      ];
}
