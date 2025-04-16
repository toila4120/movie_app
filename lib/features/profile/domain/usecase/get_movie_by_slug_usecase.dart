import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';
import 'package:movie_app/features/profile/domain/repository/profile_repository.dart';

class GetMovieBySlugUsecase {
  final ProfileRepository profileRepository;
  GetMovieBySlugUsecase(this.profileRepository);

  Future<MovieEntity> call(String slug) async {
    return await profileRepository.getMovieBySlug(slug);
  }
}
