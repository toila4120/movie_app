part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FectchMovieForBannerMovies extends HomeEvent {}

class FectchMovieForHanhDongMovies extends HomeEvent {}

class FectchMovieForNewMovies extends HomeEvent {}

class FectchMovieForPhieuLuuMovies extends HomeEvent {}

class FectchMovieForKinhDiMovies extends HomeEvent {}
