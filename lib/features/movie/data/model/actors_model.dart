import 'package:equatable/equatable.dart';
import 'package:movie_app/features/movie/domain/entities/actor_entity.dart';

class ActorsModel extends Equatable {
  const ActorsModel({
    required this.success,
    required this.actors,
    required this.relatedImages,
    required this.debugInfo,
  });

  final bool? success;
  final List<ActorEntity> actors;
  final List<dynamic> relatedImages;
  final String? debugInfo;

  ActorsModel copyWith({
    bool? success,
    List<ActorEntity>? actors,
    List<dynamic>? relatedImages,
    String? debugInfo,
  }) {
    return ActorsModel(
      success: success ?? this.success,
      actors: actors ?? this.actors,
      relatedImages: relatedImages ?? this.relatedImages,
      debugInfo: debugInfo ?? this.debugInfo,
    );
  }

  factory ActorsModel.fromJson(Map<String, dynamic> json) {
    return ActorsModel(
      success: json["success"],
      actors: json["actors"] == null
          ? []
          : List<ActorEntity>.from(
              json["actors"]!.map((x) => ActorEntity.fromJson(x))),
      relatedImages: json["related_images"] == null
          ? []
          : List<dynamic>.from(json["related_images"]!.map((x) => x)),
      debugInfo: json["debug_info"],
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "actors": actors.map((x) => x.toJson()).toList(),
        "related_images": relatedImages.map((x) => x).toList(),
        "debug_info": debugInfo,
      };

  @override
  String toString() {
    return "$success, $actors, $relatedImages, $debugInfo, ";
  }

  @override
  List<Object?> get props => [
        success,
        actors,
        relatedImages,
        debugInfo,
      ];
}
