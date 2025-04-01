import 'package:movie_app/features/home/domain/entities/movie_for_banner_entity.dart';

abstract class HomeRepository {
  Future<List<MovieForBannerEntity>> getMovieForBanner();
}
