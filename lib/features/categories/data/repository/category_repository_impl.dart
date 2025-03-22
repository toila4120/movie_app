import 'package:dio/dio.dart';
import 'package:movie_app/core/constants/api_constant.dart';
import 'package:movie_app/features/categories/data/model/categories_model.dart';
import 'package:movie_app/features/categories/data/model/category_mapper.dart';
import 'package:movie_app/features/categories/domain/entities/categories_entities.dart';
import 'package:movie_app/features/categories/domain/repository/categories_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final Dio dio;

  CategoryRepositoryImpl(this.dio);

  @override
  Future<List<CategoryEntity>> getAllCategories() async {
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
}
