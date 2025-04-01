import 'package:movie_app/features/home/domain/entities/movie_for_banner_entity.dart';
import 'package:movie_app/features/home/domain/repository/home_repository.dart';

class FetchMovieForBannerUsecase {
  final HomeRepository repository;

  FetchMovieForBannerUsecase(this.repository);

  Future<List<MovieForBannerEntity>> call() async {
    return await repository.getMovieForBanner();
  }
}
