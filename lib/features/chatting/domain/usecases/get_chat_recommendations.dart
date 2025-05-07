import 'package:dartz/dartz.dart';
import 'package:movie_app/features/chatting/domain/entities/movie_recommendation.dart';
import 'package:movie_app/features/chatting/domain/repositories/chat_repository.dart';

class GetChatRecommendations {
  final ChatRepository repository;

  GetChatRecommendations(this.repository);

  Future<Either<String, MovieRecommendationResponse>> execute(String query) {
    return repository.getChatRecommendations(query);
  }
}
