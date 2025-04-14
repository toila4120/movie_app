part of 'explore_bloc.dart';

class ExploreState extends Equatable {
  final List<MovieEntity> movies;
  final LoadingState loadingState;
  final String errorMessage;
  final String lastQuery;
  final int page;
  final DataSource dataSource;
  final FilterParam? filterParam;
  final List<RegionEntities> availableRegions;
  final List<String> genres;
  final List<String> categories;
  final List<String> translations;
  final List<String> regions;
  final List<String> years;
  final String sort;
  final bool hasReachedMax;
  final SearchStatus searchStatus;

  const ExploreState({
    required this.movies,
    required this.loadingState,
    required this.errorMessage,
    required this.lastQuery,
    required this.page,
    required this.dataSource,
    this.filterParam,
    required this.availableRegions,
    required this.genres,
    required this.categories,
    required this.translations,
    required this.regions,
    required this.years,
    required this.sort,
    required this.hasReachedMax,
    this.searchStatus = SearchStatus.initial,
  });

  factory ExploreState.init() => const ExploreState(
        movies: [],
        loadingState: LoadingState.pure,
        errorMessage: '',
        lastQuery: '',
        page: 1,
        dataSource: DataSource.initial,
        availableRegions: [],
        genres: [],
        categories: [],
        translations: [],
        regions: [],
        years: [],
        sort: '',
        hasReachedMax: false,
        searchStatus: SearchStatus.initial,
      );

  ExploreState copyWith({
    List<MovieEntity>? movies,
    LoadingState? loadingState,
    String? errorMessage,
    String? lastQuery,
    int? page,
    DataSource? dataSource,
    FilterParam? filterParam,
    List<RegionEntities>? availableRegions,
    List<String>? genres,
    List<String>? categories,
    List<String>? translations,
    List<String>? regions,
    List<String>? years,
    String? sort,
    bool? hasReachedMax,
    SearchStatus? searchStatus,
  }) {
    return ExploreState(
      movies: movies ?? this.movies,
      loadingState: loadingState ?? this.loadingState,
      errorMessage: errorMessage ?? this.errorMessage,
      lastQuery: lastQuery ?? this.lastQuery,
      page: page ?? this.page,
      dataSource: dataSource ?? this.dataSource,
      filterParam: filterParam ?? this.filterParam,
      availableRegions: availableRegions ?? this.availableRegions,
      genres: genres ?? this.genres,
      categories: categories ?? this.categories,
      translations: translations ?? this.translations,
      regions: regions ?? this.regions,
      years: years ?? this.years,
      sort: sort ?? this.sort,
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
        dataSource,
        availableRegions,
        genres,
        categories,
        translations,
        regions,
        years,
        sort,
        hasReachedMax,
        searchStatus,
      ];
}
