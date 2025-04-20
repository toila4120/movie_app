import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';
import 'package:movie_app/features/home/domain/entities/movie_with_genre.dart';
import 'package:movie_app/features/home/domain/repository/home_repository.dart';

class GetMoviesByListGenre {
  final HomeRepository repository;
  GetMoviesByListGenre(this.repository);

  Future<List<MovieWithGenre>> call(List<CategoryEntity> listGenre) async {
    return await repository.getMoviesByListGenre(listGenre);
  }
}
