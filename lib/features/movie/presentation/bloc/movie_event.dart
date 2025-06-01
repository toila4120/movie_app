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

class FetchMovieDetailEvent extends MovieEvent {
  final String slug;

  const FetchMovieDetailEvent({required this.slug});

  @override
  List<Object?> get props => [
        slug,
      ];
}

class FetchMovieByListEvent extends MovieEvent {
  final String listSlug;
  final int page;

  const FetchMovieByListEvent({
    required this.listSlug,
    this.page = 1,
  });

  @override
  List<Object?> get props => [
        listSlug,
        page,
      ];
}

class FetchNewMoviesEvent extends MovieEvent {
  final int page;

  const FetchNewMoviesEvent({this.page = 1});

  @override
  List<Object?> get props => [
        page,
      ];
}

class ClearMovieStateEvent extends MovieEvent {
  const ClearMovieStateEvent();

  @override
  List<Object?> get props => [];
}
