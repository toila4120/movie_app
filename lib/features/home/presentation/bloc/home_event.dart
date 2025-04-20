part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieForBannerMovies extends HomeEvent {}

class FetchMovieForNewMovies extends HomeEvent {}

class FetchMovieWithGenre extends HomeEvent {
  final List<CategoryEntity> genres;
  const FetchMovieWithGenre({
    required this.genres,
  });

  @override
  List<Object> get props => [
        genres,
      ];
}
