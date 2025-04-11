enum SearchStatus {
  initial,
  loading,
  success,
  error,
  empty,
  noInternet,
  noResult,
  noMoreData,
  noMoreResult,
  noMoreSearchResult;

  bool get isLoading => this == SearchStatus.loading;

  bool get isSuccess => this == SearchStatus.success;

  bool get isError => this == SearchStatus.error;

  bool get isEmpty => this == SearchStatus.empty;

  bool get isNoInternet => this == SearchStatus.noInternet;

  bool get isNoResult => this == SearchStatus.noResult;

  bool get isNoMoreData => this == SearchStatus.noMoreData;

  bool get isNoMoreResult => this == SearchStatus.noMoreResult;

  bool get isNoMoreSearchResult => this == SearchStatus.noMoreSearchResult;

  bool isFinished() =>
      isSuccess ||
      isError ||
      isNoMoreData ||
      isNoMoreResult ||
      isNoMoreSearchResult;

  bool isLoadingMore() =>
      isLoading || isNoMoreData || isNoMoreResult || isNoMoreSearchResult;
      
  bool isLoadingMoreResult() =>
      isLoading || isNoMoreResult || isNoMoreSearchResult;

  bool isLoadingMoreSearchResult() => isLoading || isNoMoreSearchResult;
  
  bool isLoadingMoreData() => isLoading || isNoMoreData;
}
