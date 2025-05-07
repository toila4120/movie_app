import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_app/core/constants/api_constant.dart';

class MovieApiClient {
  final Dio dio;

  MovieApiClient(this.dio);

  /// Checks if a movie exists using the given slug
  /// Returns a movie data if it exists, null otherwise
  Future<Map<String, dynamic>?> checkMovieExists(String slug) async {
    if (slug.isEmpty) {
      if (kDebugMode) {
        debugPrint('⚠️ Empty slug provided to checkMovieExists');
      }
      return null;
    }

    try {
      if (kDebugMode) {
        debugPrint('Checking if movie exists: $slug');
      }

      // Thêm các trường hợp test
      if (kDebugMode && slug == 'ngoi-truong-xac-song') {
        return {'status': true, 'title': 'Ngôi Trường Xác Sống'};
      }
      if (kDebugMode && slug == 'venom') {
        return {'status': true, 'title': 'Venom'};
      }

      final response = await dio.get('${ApiConstant.baseUrl}/phim/$slug');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return data;
        }
      }
      return null;
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('Dio error when checking movie: ${e.message}');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Unexpected error when checking movie: $e');
      }
      return null;
    }
  }
}
