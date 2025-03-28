import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

class FetchCategories extends CategoriesEvent {}

class FetchMoviesByCategory extends CategoriesEvent {
  final String categorySlug;
  final int page;

  const FetchMoviesByCategory({
    required this.categorySlug,
    this.page = 1,
  });

  @override
  List<Object?> get props => [categorySlug, page];
}
