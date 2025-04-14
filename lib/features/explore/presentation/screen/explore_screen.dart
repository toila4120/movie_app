part of '../../explore.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    context.read<ExploreBloc>().add(FetchRegionsEvent());
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.8 &&
          !context.read<ExploreBloc>().state.loadingState.isLoading) {
        final state = context.read<ExploreBloc>().state;
        if (!state.hasReachedMax) {
          context.read<ExploreBloc>().add(
                ExploreEventSearch(state.lastQuery, state.page + 1),
              );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        return AppContainer(
          resizeToAvoidBottomInset: true,
          child: Column(
            children: [
              const AppHeaderForExplore(),
              Expanded(
                child: ScrollConfiguration(
                  behavior: const DisableGlowBehavior(),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: AppPadding.small,
                        left: AppPadding.large,
                        right: AppPadding.large,
                        bottom: AppPadding.small,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.searchStatus == SearchStatus.initial)
                            ListMovieWidget(
                              movies:
                                  context.read<HomeBloc>().state.bannerMovies,
                            )
                          else if (state.searchStatus == SearchStatus.empty)
                            Column(
                              children: [
                                const NotFoundMovie(),
                                SizedBox(height: AppPadding.small),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: AppColor.greyScale300,
                                        thickness: 1.w,
                                        height: 1.w,
                                      ),
                                    ),
                                    SizedBox(width: AppPadding.tiny),
                                    Text(
                                      'Gợi ý',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.greyScale900,
                                      ),
                                    ),
                                    SizedBox(width: AppPadding.tiny),
                                    Expanded(
                                      child: Divider(
                                        color: AppColor.greyScale300,
                                        thickness: 1.w,
                                        height: 1.w,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppPadding.small),
                                ListMovieWidget(
                                  movies: context
                                      .read<HomeBloc>()
                                      .state
                                      .bannerMovies,
                                ),
                              ],
                            )
                          else if (state.searchStatus == SearchStatus.error)
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    AppImage.imageNotFound,
                                    width: 100.w,
                                    height: 100.w,
                                  ),
                                  SizedBox(height: AppPadding.tiny),
                                  Text(
                                    state.errorMessage,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.greyScale500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          else
                            ListMovieWidget(movies: state.movies),
                          if (state.loadingState.isLoading)
                            const ItemListMovieShimmer(),
                          if (state.hasReachedMax && state.movies.isNotEmpty ||
                              state.page == 3 ||
                              !state.loadingState.isLoading ||
                              state.searchStatus.isInitial &&
                                  state.movies.isEmpty)
                            Padding(
                              padding: EdgeInsets.all(AppPadding.small),
                              child: const Center(
                                child: Text(
                                  'Không còn phim nào nữa, nếu vẫn không thấy phim nào thì hãy thử lại với từ khóa khác',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.greyScale500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
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
