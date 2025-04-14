import 'package:equatable/equatable.dart';

class FilterParam extends Equatable {
  final String typeList;
  final String genres;
  final String translations;
  final String sortField;
  final String sortType;
  final String years;
  final String countries;
  final int limit;

  const FilterParam({
    this.typeList = '',
    this.genres = '',
    this.translations = '',
    this.sortField = 'modified.time',
    this.sortType = 'desc',
    this.years = '',
    this.countries = '',
    this.limit = 24,
  });

  Map<String, dynamic> toQueryParams({required int page}) {
    return {
      if (typeList.isNotEmpty) 'type_list': typeList,
      if (genres.isNotEmpty) 'category': genres,
      if (translations.isNotEmpty) 'sort_lang': translations,
      if (sortField.isNotEmpty) 'sort_field': sortField,
      if (sortType.isNotEmpty) 'sort_type': sortType,
      if (years.isNotEmpty && years != 'all') 'year': years,
      if (countries.isNotEmpty) 'country': countries,
      'limit': limit,
      'page': page,
    };
  }

  @override
  List<Object?> get props => [
        typeList,
        genres,
        translations,
        sortField,
        sortType,
        years,
        countries,
        limit,
      ];
}
