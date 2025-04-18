import 'package:movie_app/features/movie/movie.dart';

class MovieWithGenre {
  final String title;
  final String genre;
  final List<Movie>? movies;

  const MovieWithGenre({
    required this.title,
    required this.genre,
    this.movies,
  });
}
