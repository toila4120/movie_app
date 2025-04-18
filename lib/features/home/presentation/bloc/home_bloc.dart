import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/features/home/data/model/movie_with_genre.dart';
import 'package:movie_app/features/home/domain/entities/movie_for_banner_entity.dart';
import 'package:movie_app/features/home/domain/usecase/fetch_movie_for_banner_usecase.dart';
import 'package:movie_app/injection_container.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.init()) {
    on<FectchMovieForBannerMovies>(_onFectchMovieForBannerMovies);
  }
  Future<void> _onFectchMovieForBannerMovies(
      FectchMovieForBannerMovies event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(
        loadingState: LoadingState.loading,
        errorMessage: null,
      ));
      final useCase = getIt<FetchMovieForBannerUsecase>();
      final movies = await useCase();
      emit(state.copyWith(
        loadingState: LoadingState.finished,
        bannerMovies: movies,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingState: LoadingState.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
