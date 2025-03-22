enum LoadingState {
  pure,
  loading,
  finished,
  error;

  bool get isLoading => this == LoadingState.loading;

  bool get isError => this == LoadingState.error;

  bool get isFinished => this == LoadingState.finished;
}
