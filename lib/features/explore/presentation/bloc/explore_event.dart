part of 'explore_bloc.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object> get props => [];
}

class ExploreEventSearch extends ExploreEvent {
  final String query;
  final int page;

  const ExploreEventSearch(this.query, this.page);

  @override
  List<Object> get props => [query, page];
}

class UpdateCategoriesEvent extends ExploreEvent {
  final String category;
  const UpdateCategoriesEvent(this.category);

  @override
  List<Object> get props => [category];
}

class UpdategGenreEvent extends ExploreEvent {
  final String genre;
  const UpdategGenreEvent(this.genre);

  @override
  List<Object> get props => [genre];
}

class UpdateTranslationEvent extends ExploreEvent {
  final String translation;
  const UpdateTranslationEvent(this.translation);

  @override
  List<Object> get props => [translation];
}

class UpdateYearEvent extends ExploreEvent {
  final String year;
  const UpdateYearEvent(this.year);

  @override
  List<Object> get props => [year];
}

class UpdateRegionEvent extends ExploreEvent {
  final String region;
  const UpdateRegionEvent(this.region);

  @override
  List<Object> get props => [region];
}

class UpdateSortEvent extends ExploreEvent {
  final String sort;
  const UpdateSortEvent(this.sort);

  @override
  List<Object> get props => [sort];
}

class FetchRegionsEvent extends ExploreEvent {}
