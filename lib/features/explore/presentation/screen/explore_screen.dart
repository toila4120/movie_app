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
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.8 &&
          !context.read<ExploreBloc>().state.loadingState.isLoading) {
        final state = context.read<ExploreBloc>().state;
        context.read<ExploreBloc>().add(
              ExploreEventSearch(state.lastQuery, state.page + 1),
            );
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
                          if (state.searchStatus == SearchStatus.loading)
                            const ItemShimmer()
                          else if (state.searchStatus == SearchStatus.empty)
                            const NotFoundMovie()
                          else if (state.searchStatus == SearchStatus.error)
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(state.errorMessage),
                                ],
                              ),
                            )
                          else if (state.searchStatus == SearchStatus.initial)
                            ListMovieWidget(
                              movies:
                                  context.read<HomeBloc>().state.bannerMovies,
                            )
                          else
                            ListMovieWidget(movies: state.movies),
                          if (state.loadingState.isLoading &&
                              state.searchStatus != SearchStatus.loading)
                            const ItemShimmer(),
                          if (state.hasReachedMax && state.movies.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.all(AppPadding.small),
                              child:
                                  const Center(child: Text('No more movies')),
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
