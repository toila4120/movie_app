part of '../../categories.dart';

class ListMovie extends StatefulWidget {
  final String title;
  final String slug;
  const ListMovie({
    super.key,
    required this.title,
    required this.slug,
  });

  @override
  State<ListMovie> createState() => _ListMovieState();
}

class _ListMovieState extends State<ListMovie> {
  List<String> categorySlug = [
    "hoat-hinh",
    "phim-bo",
    "phim-le",
    "tv-shows",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        return AppContainer(
          resizeToAvoidBottomInset: true,
          child: Column(
            children: [
              AppHeader(
                title: widget.title,
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200 &&
                        state.loadingState != LoadingState.loading &&
                        !state.hasReachedMax) {
                      categorySlug.contains(widget.slug)
                          ? context.read<MovieBloc>().add(
                                FetchMovieByListEvent(
                                  listSlug: widget.slug,
                                  page: state.page + 1,
                                ),
                              )
                          : widget.slug == 'phim-moi-cap-nhat-v3'
                              ? context.read<MovieBloc>().add(
                                    FetchNewMoviesEvent(
                                      page: state.page + 1,
                                    ),
                                  )
                              : context.read<MovieBloc>().add(
                                    FetchMoviesByCategory(
                                      categorySlug: widget.slug,
                                      page: state.page + 1,
                                    ),
                                  );
                      return true;
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      top: AppPadding.superTiny,
                      left: AppPadding.large,
                      right: AppPadding.large,
                      bottom: AppPadding.large,
                    ),
                    itemCount: state.movies.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.movies.length) {
                        if (state.loadingState == LoadingState.loading) {
                          return Padding(
                            padding: EdgeInsets.all(AppPadding.medium),
                            child: const ItemMovieShimer(),
                          );
                        }
                        if (state.hasReachedMax) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppPadding.medium),
                              child: const Text('Đã hết phim'),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }
                      final movie = state.movies[index];
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: AppPadding.tiny),
                        child: ItemMovie(
                          movieModel: movie,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
