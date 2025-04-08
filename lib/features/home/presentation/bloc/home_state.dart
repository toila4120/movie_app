part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<MovieForBannerEntity> bannerMovies;
  final List<MovieForBannerEntity> hanhDongMovies;
  final List<MovieForBannerEntity> newMovies;
  final List<MovieForBannerEntity> phieuLuuMovies;
  final List<MovieForBannerEntity> kinhDiMovies;
  final LoadingState loadingState;
  final String errorMessage;

  const HomeState({
    required this.bannerMovies,
    required this.loadingState,
    required this.errorMessage,
    this.hanhDongMovies = const [],
    this.newMovies = const [],
    this.phieuLuuMovies = const [],
    this.kinhDiMovies = const [],
  });

  factory HomeState.init() {
    return const HomeState(
      bannerMovies: [],
      hanhDongMovies: [],
      newMovies: [],
      phieuLuuMovies: [],
      kinhDiMovies: [],
      loadingState: LoadingState.pure,
      errorMessage: '',
    );
  }

  HomeState copyWith({
    List<MovieForBannerEntity>? bannerMovies,
    List<MovieForBannerEntity>? hanhDongMovies,
    List<MovieForBannerEntity>? newMovies,
    List<MovieForBannerEntity>? phieuLuuMovies,
    List<MovieForBannerEntity>? kinhDiMovies,
    LoadingState? loadingState,
    String? errorMessage,
  }) {
    return HomeState(
      bannerMovies: bannerMovies ?? this.bannerMovies,
      hanhDongMovies: hanhDongMovies ?? this.hanhDongMovies,
      newMovies: newMovies ?? this.newMovies,
      phieuLuuMovies: phieuLuuMovies ?? this.phieuLuuMovies,
      kinhDiMovies: kinhDiMovies ?? this.kinhDiMovies,
      loadingState: loadingState ?? this.loadingState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        bannerMovies,
        hanhDongMovies,
        newMovies,
        phieuLuuMovies,
        kinhDiMovies,
        loadingState,
        errorMessage,
      ];
}
