import 'package:dio/dio.dart';
import 'package:movie_app/features/explore/data/model/region_model.dart';
import 'package:movie_app/features/explore/domain/entities/filter_param.dart';
import 'package:movie_app/features/movie/data/model/movie_model.dart';

abstract class ExploreRemoteDatasource {
  Future<List<MovieModel>> searchMovie(String query, int page);
  Future<List<RegionModel>> getRegions();
  Future<List<MovieModel>> filterMovie(FilterParam filterParam, int page);
}

class ExploreRemoteDatasourceImpl implements ExploreRemoteDatasource {
  Dio dio;
  ExploreRemoteDatasourceImpl(this.dio);
  @override
  Future<List<MovieModel>> searchMovie(String query, int page) async {
    try {
      final response = await dio.get(
          'https://phimapi.com/v1/api/tim-kiem?keyword=$query',
          queryParameters: {
            'page': page,
            'sort_field': '_id',
            'sort_type': 'desc',
            'limit': 12,
          });
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

  @override
  Future<List<RegionModel>> getRegions() async {
    try {
      final response = await dio.get('https://phimapi.com/quoc-gia');
      if (response.statusCode == 200) {
        final jsonList = response.data as List<dynamic>;
        return jsonList.map((json) => RegionModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch region: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch region: $e');
    }
  }

  @override
  Future<List<MovieModel>> filterMovie(
      FilterParam filterParam, int page) async {
    try {
      final response = await dio.get(
        'https://phimapi.com/v1/api/danh-sach/duyet-tim',
        queryParameters: filterParam.toQueryParams(page: page),
      );

      if (response.statusCode == 200) {
        final data = response.data['data']['items'] as List<dynamic>? ?? [];
        return data.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch movies: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
