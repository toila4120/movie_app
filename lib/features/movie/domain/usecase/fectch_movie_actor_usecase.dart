import 'package:movie_app/features/movie/domain/entities/actor_entity.dart';
import 'package:movie_app/features/movie/domain/repository/movie_repository.dart';

class FectchMovieActorUsecase {
  final MovieRepository movieRepository;

  FectchMovieActorUsecase(this.movieRepository);

  Future<List<ActorEntity>> call(String slug) async {
    return await movieRepository.fetchMovieActors(slug);
  }
}
