import 'package:dartz/dartz.dart';
import 'package:movie_app/features/chatting/data/datasources/gemini_ai_service.dart';
import 'package:movie_app/features/chatting/domain/entities/movie_recommendation.dart';
import 'package:movie_app/features/chatting/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final GeminiAiService geminiAiService;

  ChatRepositoryImpl({required this.geminiAiService});

  @override
  Future<Either<String, MovieRecommendationResponse>> getChatRecommendations(
      String query) async {
    try {
      final response = await geminiAiService.getMovieRecommendations(query);
      return Right(response);
    } catch (e) {
      return const Left('Không thể kết nối đến dịch vụ AI. Vui lòng thử lại sau.');
    }
  }
}
