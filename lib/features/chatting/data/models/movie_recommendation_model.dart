import 'dart:convert';
import 'package:movie_app/features/chatting/domain/entities/movie_recommendation.dart';

class MovieRecommendationModel extends MovieRecommendation {
  const MovieRecommendationModel({
    required super.title,
    required super.slug,
    required super.description,
  });

  factory MovieRecommendationModel.fromJson(Map<String, dynamic> json) {
    return MovieRecommendationModel(
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class MovieRecommendationResponseModel extends MovieRecommendationResponse {
  const MovieRecommendationResponseModel({
    required super.movies,
    required super.aiMessage,
  });

  factory MovieRecommendationResponseModel.fromGeminiResponse(String response) {
    try {
      // Extract JSON part from the response
      final jsonRegExp = RegExp(r'\{[\s\S]*\}');
      final jsonMatch = jsonRegExp.firstMatch(response);

      if (jsonMatch == null) {
        return MovieRecommendationResponseModel(
          movies: const [],
          aiMessage: response,
        );
      }

      final jsonString = jsonMatch.group(0);
      if (jsonString == null) {
        return MovieRecommendationResponseModel(
          movies: const [],
          aiMessage: response,
        );
      }

      final parsedJson = json.decode(jsonString);

      // Extract movies list
      final List<dynamic> moviesJson = parsedJson['movies'] ?? [];
      final movies = moviesJson
          .map((movie) => MovieRecommendationModel.fromJson(movie))
          .toList();

      // Extract AI message if available
      final aiMessage = parsedJson['message'] ?? response;

      return MovieRecommendationResponseModel(
        movies: movies,
        aiMessage: aiMessage,
      );
    } catch (e) {
      // If JSON parsing fails, return the raw response as the AI message
      return MovieRecommendationResponseModel(
        movies: const [],
        aiMessage: response,
      );
    }
  }
}
