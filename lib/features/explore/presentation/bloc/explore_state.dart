part of 'explore_bloc.dart';

class ExploreState extends Equatable {
  final List<MovieEntity> movies;
  final LoadingState loadingState;
  final String errorMessage;
  final String lastQuery;
  final int page;
  final bool hasReachedMax;
  final SearchStatus searchStatus;

  const ExploreState({
    required this.movies,
    required this.loadingState,
    required this.errorMessage,
    required this.lastQuery,
    required this.page,
    required this.hasReachedMax,
    this.searchStatus = SearchStatus.initial,
  });

  factory ExploreState.init() => const ExploreState(
        movies: [],
        loadingState: LoadingState.pure,
        errorMessage: '',
        lastQuery: '',
        page: 1,
        hasReachedMax: false,
        searchStatus: SearchStatus.initial,
      );

  ExploreState copyWith({
    List<MovieEntity>? movies,
    LoadingState? loadingState,
    String? errorMessage,
    String? lastQuery,
    int? page,
    bool? hasReachedMax,
    SearchStatus? searchStatus,
  }) {
    return ExploreState(
      movies: movies ?? this.movies,
      loadingState: loadingState ?? this.loadingState,
      errorMessage: errorMessage ?? this.errorMessage,
      lastQuery: lastQuery ?? this.lastQuery,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchStatus: searchStatus ?? this.searchStatus,
    );
  }

  @override
  List<Object> get props => [
        movies,
        loadingState,
        errorMessage,
        lastQuery,
        page,
        hasReachedMax,
        searchStatus,
      ];
}
