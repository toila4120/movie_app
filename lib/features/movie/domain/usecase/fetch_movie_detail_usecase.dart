import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movie/domain/repository/movie_repository.dart';

class FetchMovieDetailUsecase {
  final MovieRepository repository;

  FetchMovieDetailUsecase(this.repository);

  Future<MovieEntity> call(String slug) async {
    return await repository.fetchMovieDetail(slug);
  }
}
