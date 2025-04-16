import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/features/profile/domain/repository/profile_repository.dart';

class GetFavoriteMoviesUsecase {
  final ProfileRepository profileRepository;
  GetFavoriteMoviesUsecase(this.profileRepository);

  Future<List<MovieEntity>> call(List<String> slug) async {
    return profileRepository.getFavoriteMovies(slug);
  }
}
