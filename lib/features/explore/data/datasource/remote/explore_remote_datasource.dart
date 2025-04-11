import 'package:dio/dio.dart';
import 'package:movie_app/features/movie/data/model/movie_model.dart';

abstract class ExploreRemoteDatasource {
  Future<List<MovieModel>> searchMovie(String query, int page);
}

class ExploreRemoteDatasourceImpl implements ExploreRemoteDatasource {
  Dio dio;
  ExploreRemoteDatasourceImpl(this.dio);
  @override
  Future<List<MovieModel>> searchMovie(String query, int page) async {
    try {
      final response = await dio.get('https://phimapi.com/v1/api/tim-kiem?keyword=$query',
          queryParameters: {'page': page,'sort_field':'_id','sort_type':'desc',});
      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData['status'] != 'success') {
          throw Exception('Failed to fetch movies: ${jsonData['msg']}');
        }

        final List<dynamic> items = jsonData['data']['items'];
        return items
            .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }
}
