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
          backgroundColor: AppColor.backGroundScreen,
          child: Column(
            children: [
              AppHeader(
                title: widget.title,
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: const DisableGlowBehavior(),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent - 100 &&
                          state.loadingState != LoadingState.loading) {
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
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: AppPadding.superTiny,
                        left: AppPadding.large,
                        right: AppPadding.large,
                        bottom: AppPadding.large,
                      ),
                      child: Column(
                        children: [
                          if (state.loadingState == LoadingState.loading &&
                              state.page == 1)
                            const Center(
                              child: MovieShimmerList(),
                            )
                          else if (state.loadingState == LoadingState.error)
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImage.imageNotFound,
                                    width: 100.w,
                                    height: 100.w,
                                  ),
                                  SizedBox(height: AppPadding.tiny),
                                  Text(
                                      "Đã có lỗi xảy ra: ${state.errorMessage}"),
                                ],
                              ),
                            )
                          else if (state.movies.isEmpty)
                            const Center(
                              child: Text(
                                'Không có phim nào',
                              ),
                            )
                          else
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.movies.length,
                              itemBuilder: (context, index) {
                                final movie = state.movies[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: AppPadding.tiny),
                                  child: ItemMovie(
                                    movieModel: movie,
                                  ),
                                );
                              },
                            ),
                          if (state.loadingState == LoadingState.loading &&
                              state.movies.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.all(AppPadding.medium),
                              child: const ItemMovieShimer(),
                            ),
                        ],
                      ),
                    ),
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
