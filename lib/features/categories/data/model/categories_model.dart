import 'package:equatable/equatable.dart';

class CategoriesModel extends Equatable {
  const CategoriesModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  final String? id;
  final String? name;
  final String? slug;

  CategoriesModel copyWith({
    String? id,
    String? name,
    String? slug,
  }) {
    return CategoriesModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
    );
  }

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json["_id"],
      name: json["name"],
      slug: json["slug"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "slug": slug,
      };

  @override
  String toString() {
    return "$id, $name, $slug, ";
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
      ];
}
