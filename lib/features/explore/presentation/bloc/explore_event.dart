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
