import 'package:equatable/equatable.dart';

class RegionEntities extends Equatable {
  const RegionEntities({
    required this.id,
    required this.name,
    required this.slug,
  });

  final String id;
  final String name;
  final String slug;

  RegionEntities copyWith({
    String? id,
    String? name,
    String? slug,
  }) {
    return RegionEntities(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
    );
  }

  @override
  String toString() {
    return 'RegionEntities(id: $id, name: $name, slug: $slug)';
  }

  @override
  List<Object> get props => [id, name, slug];
}
