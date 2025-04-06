part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<MovieForBannerEntity> bannerMovies;
  final LoadingState loadingState;
  final String errorMessage;
  
  const HomeState({
    required this.bannerMovies,
    required this.loadingState,
    required this.errorMessage,
  });

  factory HomeState.init() {
    return const HomeState(
      bannerMovies: [],
      loadingState: LoadingState.pure,
      errorMessage: '',
    );
  }

  HomeState copyWith({
    List<MovieForBannerEntity>? bannerMovies,
    LoadingState? loadingState,
    String? errorMessage,
  }) {
    return HomeState(
      bannerMovies: bannerMovies ?? this.bannerMovies,
      loadingState: loadingState ?? this.loadingState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        bannerMovies,
        loadingState,
        errorMessage,
      ];
}
