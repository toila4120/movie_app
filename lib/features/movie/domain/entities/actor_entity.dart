import 'package:equatable/equatable.dart';

class ActorEntity extends Equatable {
  const ActorEntity({
    required this.name,
    required this.image,
    required this.character,
  });

  final String? name;
  final String? image;
  final String? character;

  ActorEntity copyWith({
    String? name,
    String? image,
    String? character,
  }) {
    return ActorEntity(
      name: name ?? this.name,
      image: image ?? this.image,
      character: character ?? this.character,
    );
  }

  factory ActorEntity.fromJson(Map<String, dynamic> json) {
    return ActorEntity(
      name: json["name"],
      image: json["image"],
      character: json["character"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "character": character,
      };

  @override
  String toString() {
    return "$name, $image, $character, ";
  }

  @override
  List<Object?> get props => [
        name,
        image,
        character,
      ];
}
