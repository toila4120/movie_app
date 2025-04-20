import 'package:movie_app/features/home/domain/repository/home_repository.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

class FetchMovieForBannerUsecase {
  final HomeRepository repository;

  FetchMovieForBannerUsecase(this.repository);

  Future<List<MovieEntity>> call() async {
    return await repository.getMovieForBanner();
  }
}
