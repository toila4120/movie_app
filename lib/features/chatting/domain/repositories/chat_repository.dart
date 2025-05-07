import 'package:dartz/dartz.dart';
import 'package:movie_app/features/chatting/domain/entities/movie_recommendation.dart';

abstract class ChatRepository {
  Future<Either<String, MovieRecommendationResponse>> getChatRecommendations(
      String query);
}
