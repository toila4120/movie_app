import 'package:movie_app/features/explore/domain/entities/region_entities.dart';

class RegionModel {
  const RegionModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  final String id;
  final String name;
  final String slug;

  RegionModel copyWith({
    String? id,
    String? name,
    String? slug,
  }) {
    return RegionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
    );
  }

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'slug': slug,
      };

  RegionEntities toEntity() {
    return RegionEntities(
      id: id,
      name: name,
      slug: slug,
    );
  }

  @override
  String toString() {
    return 'RegionModel(id: $id, name: $name, slug: $slug)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegionModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          slug == other.slug;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ slug.hashCode;
}
