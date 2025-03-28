import 'package:dio/dio.dart';
import 'package:movie_app/core/constants/api_constant.dart';
import 'package:movie_app/features/categories/data/model/categories_model.dart';
import 'package:movie_app/features/categories/data/model/category_mapper.dart';
import 'package:movie_app/features/categories/data/model/movie_model.dart';
import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryEntity>> fetchCategories();
  Future<List<MovieModel>> fetchMoviesByCategory(String categorySlug, int page);
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final Dio dio;

  CategoriesRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CategoryEntity>> fetchCategories() async {
    try {
      final response = await dio.get(ApiConstant.categories);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final categories =
            data.map((json) => CategoriesModel.fromJson(json)).toList();
        return categories.map((model) => model.toEntity()).toList();
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<MovieModel>> fetchMoviesByCategory(
      String categorySlug, int page) async {
    try {
      final response = await dio.get(
        'https://phimapi.com/v1/api/the-loai/$categorySlug',
        queryParameters: {'page': page},
      );
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
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
