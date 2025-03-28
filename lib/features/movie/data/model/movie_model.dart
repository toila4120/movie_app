class MovieModel {
  final String id;
  final String name;
  final String slug;
  final String originName;
  final String type;
  final String posterUrl;
  final String thumbUrl;
  final bool subDocquyen;
  final bool chieurap;
  final String time;
  final String episodeCurrent;
  final String quality;
  final String lang;
  final int year;
  final List<Category> categories;
  final List<Country> countries;
  final DateTime modified;

  MovieModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.type,
    required this.posterUrl,
    required this.thumbUrl,
    required this.subDocquyen,
    required this.chieurap,
    required this.time,
    required this.episodeCurrent,
    required this.quality,
    required this.lang,
    required this.year,
    required this.categories,
    required this.countries,
    required this.modified,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      slug: json['slug'] as String? ?? '',
      originName: json['origin_name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      posterUrl: json['poster_url'] as String? ?? '',
      thumbUrl: json['thumb_url'] as String? ?? '',
      subDocquyen: json['sub_docquyen'] as bool? ?? false,
      chieurap: json['chieurap'] as bool? ?? false,
      time: json['time'] as String? ?? '',
      episodeCurrent: json['episode_current'] as String? ?? '',
      quality: json['quality'] as String? ?? '',
      lang: json['lang'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      categories: (json['category'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      countries: (json['country'] as List<dynamic>?)
              ?.map((e) => Country.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      modified: DateTime.parse(
          json['modified']['time'] as String? ?? '1970-01-01T00:00:00.000Z'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'origin_name': originName,
      'type': type,
      'poster_url': posterUrl,
      'thumb_url': thumbUrl,
      'sub_docquyen': subDocquyen,
      'chieurap': chieurap,
      'time': time,
      'episode_current': episodeCurrent,
      'quality': quality,
      'lang': lang,
      'year': year,
      'category': categories.map((e) => e.toJson()).toList(),
      'country': countries.map((e) => e.toJson()).toList(),
      'modified': {'time': modified.toIso8601String()},
    };
  }
}

class Category {
  final String id;
  final String name;
  final String slug;

  Category({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}

class Country {
  final String id;
  final String name;
  final String slug;

  Country({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}
