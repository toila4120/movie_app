part of 'movie_bloc.dart';

class MovieState extends Equatable {
  final LoadingState loadingState;
  final int page;
  final bool hasReachedMax;
  final List<MovieModel> movies;
  final String? errorMessage;

  const MovieState({
    required this.loadingState,
    required this.page,
    required this.hasReachedMax,
    this.movies = const [],
    this.errorMessage,
  });
  factory MovieState.init() {
    return const MovieState(
      loadingState: LoadingState.pure,
      page: 0,
      hasReachedMax: false,
      movies: [],
      errorMessage: null,
    );
  }

  MovieState copyWith({
    LoadingState? loadingState,
    List<MovieModel>? movies,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
  }) {
    return MovieState(
      loadingState: loadingState ?? this.loadingState,
      page: page ?? this.page,
      movies: movies ?? this.movies,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        loadingState,
        page,
        movies,
        errorMessage,
        hasReachedMax,
      ];
}
