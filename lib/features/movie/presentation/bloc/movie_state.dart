part of 'movie_bloc.dart';

class MovieState extends Equatable {
  final LoadingState loadingState;
  final int page;
  final bool hasReachedMax;
  final List<MovieEntity> movies;
  final String? errorMessage;
  final MovieEntity? movie;
  final List<ActorEntity>? actor;

  const MovieState({
    required this.loadingState,
    required this.page,
    required this.hasReachedMax,
    this.movies = const [],
    this.actor = const [],
    this.errorMessage,
    this.movie,
  });
  factory MovieState.init() {
    return const MovieState(
      loadingState: LoadingState.pure,
      page: 0,
      hasReachedMax: false,
      movies: [],
      actor: [],
      errorMessage: null,
      movie: null,
    );
  }

  MovieState copyWith({
    LoadingState? loadingState,
    List<MovieEntity>? movies,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
    MovieEntity? movie,
    List<ActorEntity>? actor,
  }) {
    return MovieState(
      loadingState: loadingState ?? this.loadingState,
      page: page ?? this.page,
      movies: movies ?? this.movies,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      movie: movie ?? this.movie,
      actor: actor ?? this.actor,
    );
  }

  @override
  List<Object?> get props => [
        loadingState,
        page,
        movies,
        errorMessage,
        hasReachedMax,
        movie,
        actor,
      ];
}
