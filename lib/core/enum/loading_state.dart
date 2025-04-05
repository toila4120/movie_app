enum LoadingState {
  pure,
  loading,
  finished,
  error;

  bool get isPure => this == LoadingState.pure;

  bool get isLoading => this == LoadingState.loading;

  bool get isError => this == LoadingState.error;

  bool get isFinished => this == LoadingState.finished;
}
