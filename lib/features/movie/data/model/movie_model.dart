import 'package:movie_app/features/movie/domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.originName,
    required super.content,
    required super.type,
    required super.status,
    required super.posterUrl,
    required super.thumbUrl,
    required super.subDocquyen,
    required super.chieurap,
    required super.trailerUrl,
    required super.time,
    required super.episodeCurrent,
    required super.episodeTotal,
    required super.quality,
    required super.lang,
    required super.year,
    required super.voteAverage,
    required super.actor,
    required super.director,
    required List<CategoryModel> super.categories,
    required List<CountryModel> super.countries,
    required List<EpisodeServerModel> super.episodes,
    required super.modified,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      slug: json['slug'] as String? ?? '',
      originName: json['origin_name'] as String? ?? '',
      content: json['content'] as String? ?? '',
      type: json['type'] as String? ?? '',
      status: json['status'] as String? ?? '',
      posterUrl: json['poster_url'] as String? ?? '',
      thumbUrl: json['thumb_url'] as String? ?? '',
      subDocquyen: json['sub_docquyen'] as bool? ?? false,
      chieurap: json['chieurap'] as bool? ?? false,
      trailerUrl: json['trailer_url'] as String? ?? '',
      time: json['time'] as String? ?? '',
      episodeCurrent: json['episode_current'] as String? ?? '',
      episodeTotal: json['episode_total'] as String? ?? '',
      quality: json['quality'] as String? ?? '',
      lang: json['lang'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      voteAverage: (json['tmdb']?['vote_average'] as num?)?.toDouble() ??
          0.0, // Ánh xạ vote_average
      actor: (json['actor'] as List<dynamic>?)?.cast<String>() ?? [],
      director: (json['director'] as List<dynamic>?)?.cast<String>() ?? [],
      categories: (json['category'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      countries: (json['country'] as List<dynamic>?)
              ?.map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      episodes: (json['episodes'] as List<dynamic>?)
              ?.map(
                  (e) => EpisodeServerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      modified: DateTime.parse(
          json['modified']['time'] as String? ?? '1970-01-01T00:00:00.000Z'),
    );
  }
}

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }
}

class CountryModel extends CountryEntity {
  const CountryModel({
    required super.id,
    required super.name,
    required super.slug,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }
}

class EpisodeServerModel extends EpisodeServerEntity {
  const EpisodeServerModel({
    required super.serverName,
    required List<EpisodeModel> super.serverData,
  });

  factory EpisodeServerModel.fromJson(Map<String, dynamic> json) {
    return EpisodeServerModel(
      serverName: json['server_name'] as String? ?? '',
      serverData: (json['server_data'] as List<dynamic>?)
              ?.map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class EpisodeModel extends EpisodeEntity {
  const EpisodeModel({
    required super.name,
    required super.slug,
    required super.filename,
    required super.linkEmbed,
    required super.linkM3u8,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      linkEmbed: json['link_embed'] as String? ?? '',
      linkM3u8: json['link_m3u8'] as String? ?? '',
    );
  }
}
