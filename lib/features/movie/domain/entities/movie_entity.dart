import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String originName;
  final String content;
  final String type;
  final String status;
  final String posterUrl;
  final String thumbUrl;
  final bool subDocquyen;
  final bool chieurap;
  final String trailerUrl;
  final String time;
  final String episodeCurrent;
  final String episodeTotal;
  final String quality;
  final String lang;
  final int year;
  final double voteAverage; 
  final List<String> actor;
  final List<String> director;
  final List<CategoryEntity> categories;
  final List<CountryEntity> countries;
  final List<EpisodeServerEntity> episodes;
  final DateTime modified;

  const MovieEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.content,
    required this.type,
    required this.status,
    required this.posterUrl,
    required this.thumbUrl,
    required this.subDocquyen,
    required this.chieurap,
    required this.trailerUrl,
    required this.time,
    required this.episodeCurrent,
    required this.episodeTotal,
    required this.quality,
    required this.lang,
    required this.year,
    required this.voteAverage, 
    required this.actor,
    required this.director,
    required this.categories,
    required this.countries,
    required this.episodes,
    required this.modified,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        originName,
        content,
        type,
        status,
        posterUrl,
        thumbUrl,
        subDocquyen,
        chieurap,
        trailerUrl,
        time,
        episodeCurrent,
        episodeTotal,
        quality,
        lang,
        year,
        voteAverage, 
        actor,
        director,
        categories,
        countries,
        episodes,
        modified,
      ];
}

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String slug;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, name, slug];
}

class CountryEntity extends Equatable {
  final String id;
  final String name;
  final String slug;

  const CountryEntity({
    required this.id,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, name, slug];
}

class EpisodeServerEntity extends Equatable {
  final String serverName;
  final List<EpisodeEntity> serverData;

  const EpisodeServerEntity({
    required this.serverName,
    required this.serverData,
  });

  @override
  List<Object?> get props => [serverName, serverData];
}

class EpisodeEntity extends Equatable {
  final String name;
  final String slug;
  final String filename;
  final String linkEmbed;
  final String linkM3u8;

  const EpisodeEntity({
    required this.name,
    required this.slug,
    required this.filename,
    required this.linkEmbed,
    required this.linkM3u8,
  });

  @override
  List<Object?> get props => [name, slug, filename, linkEmbed, linkM3u8];
}
