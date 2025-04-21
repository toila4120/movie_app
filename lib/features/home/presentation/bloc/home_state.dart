part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<MovieEntity> bannerMovies;
  final List<MovieEntity> newMovies;
  final List<MovieWithGenre> popularMovies;
  final LoadingState loadingState;
  final LoadingState loadingPopularMovies;
  final String errorMessage;

  const HomeState({
    required this.bannerMovies,
    required this.loadingState,
    required this.loadingPopularMovies,
    required this.errorMessage,
    this.newMovies = const [],
    this.popularMovies = const [],
  });

  factory HomeState.init() {
    return const HomeState(
      bannerMovies: [],
      newMovies: [],
      popularMovies: [],
      loadingState: LoadingState.pure,
      loadingPopularMovies: LoadingState.pure,
      errorMessage: '',
    );
  }

  HomeState copyWith({
    List<MovieEntity>? bannerMovies,
    List<MovieEntity>? newMovies,
    List<MovieWithGenre>? popularMovies,
    LoadingState? loadingState,
    LoadingState? loadingPopularMovies,
    String? errorMessage,
  }) {
    return HomeState(
      bannerMovies: bannerMovies ?? this.bannerMovies,
      newMovies: newMovies ?? this.newMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      loadingPopularMovies: loadingPopularMovies ?? this.loadingPopularMovies,
      loadingState: loadingState ?? this.loadingState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        bannerMovies,
        newMovies,
        popularMovies,
        loadingState,
        loadingPopularMovies,
        errorMessage,
      ];
}
