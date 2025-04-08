import 'package:equatable/equatable.dart';
import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';

class MovieForBannerEntity extends Equatable {
  final String name;
  final String posterUrl;
  final String thumbUrl;
  final String slug;
  final String episodeCurrent;
  final int year;
  final List<CategoryEntity> category;

  const MovieForBannerEntity({
    required this.name,
    required this.posterUrl,
    required this.thumbUrl,
    required this.slug,
    required this.episodeCurrent,
    required this.year,
    required this.category,
  });

  @override
  List<Object?> get props => [
        name,
        posterUrl,
        thumbUrl,
        slug,
        episodeCurrent,
        year,
        category,
      ];
}
