import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:movie_app/features/chatting/data/datasources/movie_api_client.dart';
import 'package:movie_app/features/chatting/data/models/movie_recommendation_model.dart';
import 'package:movie_app/features/chatting/domain/entities/movie_recommendation.dart';

class GeminiAiService {
  final String apiKey;
  final MovieApiClient movieApiClient;

  GeminiAiService({
    required this.apiKey,
    required this.movieApiClient,
  }) {
    // Check API key only once during initialization
    if (apiKey == 'API_KEY_NOT_FOUND' || apiKey.isEmpty) {
      debugPrint('⚠️ WARNING: Gemini API key not configured or empty!');
    } else if (apiKey == 'test_key') {
      debugPrint('ℹ️ Using test mode with test_key');
    } else {
      debugPrint('✅ Gemini API key configured');
    }
  }

  Future<MovieRecommendationResponseModel> getMovieRecommendations(
      String query) async {
    try {
      // Check if API key is valid
      if (apiKey == 'API_KEY_NOT_FOUND' || apiKey.isEmpty) {
        return const MovieRecommendationResponseModel(
          movies: [],
          aiMessage:
              'Chưa cấu hình API key cho Gemini. Vui lòng kiểm tra file .env và thêm GEMINI_API_KEY.',
        );
      }

      // Return test data in debug mode with test key
      if (kDebugMode && apiKey == 'test_key') {
        debugPrint('🧪 Using test data for query: "$query"');
        await Future.delayed(const Duration(seconds: 1)); // Simulate delay
        return MovieRecommendationResponseModel(
          movies: const [
            MovieRecommendationModel(
              title: "Ngôi Trường Xác Sống",
              slug: "ngoi-truong-xac-song",
              description: "Phim kinh dị về zombie trong trường học",
            ),
            MovieRecommendationModel(
              title: "Venom",
              slug: "venom",
              description: "Phim hành động siêu anh hùng Marvel",
            ),
            MovieRecommendationModel(
              title: "Train to Busan",
              slug: "train-to-busan",
              description: "Phim kinh dị Hàn Quốc về đại dịch zombie trên tàu",
            ),
          ],
          aiMessage: "Đây là kết quả test từ API Gemini với yêu cầu: $query",
        );
      }

      final model = GenerativeModel(
        model: 'gemini-2.0-flash-lite',
        apiKey: apiKey,
      );

      final prompt = '''
      Bạn là trợ lý tư vấn phim thông minh. Hãy gợi ý các phim dựa trên yêu cầu của người dùng.
      
      Yêu cầu: $query
      
       Phân tích yêu cầu và đưa ra bộ phim phù hợp. Trả về dữ liệu JSON theo định dạng sau:
      {
        "message": "Tóm tắt gợi ý của bạn",
        "movies": [
          {
            "title": "Tên phim",
            "slug": "tên-phim-đã-được-slugify",
            "description": "Mô tả ngắn về phim"
          }
        ]
      }
      
      Lưu ý:
      - title là tên phim tiếng việt chỉ tiếng việt không cần tên tiếng anh
      - Chuyển đổi tên phim thành slug bằng cách viết thường và thay thế dấu cách bằng dấu gạch ngang
      - Không chứa dấu tiếng Việt, chỉ bao gồm a-z, 0-9 và dấu gạch ngang
      - Slug không được có chữ có dấu tiếng Việt
      - Ví dụ: "Ngôi Trường Xác Sống" thành "ngoi-truong-xac-song"
      - Trả về JSON sau khi tìm kiếm phim mà không in thêm kết quả nào khác.
      ''';

      final content = [Content.text(prompt)];

      // Log prompt in debug mode
      if (kDebugMode) {
        debugPrint('Sending prompt to Gemini: $prompt');
      }

      try {
        // Call Gemini API
        final response = await model.generateContent(content);
        final responseText = response.text ?? '';

        if (kDebugMode) {
          debugPrint('Gemini response: $responseText');
        }

        // Parse the JSON response
        final responseModel =
            MovieRecommendationResponseModel.fromGeminiResponse(responseText);

        // Validate that the recommended movies exist in the API
        final validatedMovies =
            await _validateRecommendedMovies(responseModel.movies);

        if (kDebugMode) {
          debugPrint('Validated movies: ${validatedMovies.length}');
        }

        return MovieRecommendationResponseModel(
          movies: validatedMovies,
          aiMessage: responseModel.aiMessage,
        );
      } catch (apiError) {
        debugPrint('Error calling Gemini API: $apiError');

        // Check if this is a security exception
        if (apiError.toString().contains('SecurityException') ||
            apiError.toString().contains('Unknown calling package name')) {
          return const MovieRecommendationResponseModel(
            movies: [],
            aiMessage:
                'Không thể kết nối với API Gemini do lỗi bảo mật. Trong môi trường phát triển, bạn có thể sử dụng API key test: "test_key"',
          );
        }

        return MovieRecommendationResponseModel(
          movies: const [],
          aiMessage:
              'Tôi gặp sự cố khi kết nối với dịch vụ AI. Vui lòng thử lại sau. Lỗi: ${apiError.toString()}',
        );
      }
    } catch (e) {
      debugPrint('Error in Gemini AI service: $e');
      return MovieRecommendationResponseModel(
        movies: const [],
        aiMessage:
            'Tôi đang gặp sự cố khi tìm phim cho bạn. Vui lòng thử lại sau. Lỗi: ${e.toString()}',
      );
    }
  }

  Future<List<MovieRecommendationModel>> _validateRecommendedMovies(
      List<MovieRecommendation> recommendations) async {
    if (recommendations.isEmpty) {
      return [];
    }

    final validatedMovies = <MovieRecommendationModel>[];

    // In test mode, skip actual API validation
    if (kDebugMode && apiKey == 'test_key') {
      return recommendations
          .map((rec) => MovieRecommendationModel(
                title: rec.title,
                slug: rec.slug,
                description: rec.description,
              ))
          .toList();
    }

    for (final recommendation in recommendations) {
      try {
        final exists =
            await movieApiClient.checkMovieExists(recommendation.slug);
        if (exists != null) {
          validatedMovies.add(MovieRecommendationModel(
            title: recommendation.title,
            slug: recommendation.slug,
            description: recommendation.description,
          ));
        } else if (kDebugMode) {
          debugPrint('Movie not found: ${recommendation.slug}');
        }
      } catch (e) {
        debugPrint('Error validating movie ${recommendation.slug}: $e');
      }
    }

    return validatedMovies;
  }
}
