import 'package:equatable/equatable.dart';

class MovieRecommendation extends Equatable {
  final String title;
  final String slug;
  final String description;

  const MovieRecommendation({
    required this.title,
    required this.slug,
    required this.description,
  });

  @override
  List<Object?> get props => [title, slug, description];
}

class MovieRecommendationResponse extends Equatable {
  final List<MovieRecommendation> movies;
  final String aiMessage;

  const MovieRecommendationResponse({
    required this.movies,
    required this.aiMessage,
  });

  @override
  List<Object?> get props => [movies, aiMessage];
}
