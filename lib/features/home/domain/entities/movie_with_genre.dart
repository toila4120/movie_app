import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';
import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

class MovieWithGenre {
  final String title;
  final CategoryEntity genre;
  final List<MovieEntity>? movies;

  const MovieWithGenre({
    required this.title,
    required this.genre,
    this.movies,
  });
}
