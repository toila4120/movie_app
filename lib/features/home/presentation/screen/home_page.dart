part of '../../home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      resizeToAvoidBottomInset: true,
      child: BaseScrollView(
        onRefresh: () async {
          context.read<HomeBloc>().add(
                FetchMovieForBannerMovies(),
              );
        },
        child: ScrollConfiguration(
          behavior: const DisableGlowBehavior(),
          child: Column(
            children: [
              const BannerHome(),
              SizedBox(height: AppPadding.small),
              Padding(
                padding: EdgeInsets.only(
                  left: AppPadding.large,
                  right: AppPadding.large,
                  bottom: AppPadding.small,
                ),
                child: Column(
                  children: [
                    const CategoryWidget(),
                    SizedBox(height: AppPadding.small),
                    const ContinueWatching(),
                    SizedBox(height: AppPadding.small),
                    const Popular(),
                    SizedBox(height: AppPadding.small),
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state.loadingState.isLoading &&
                            state.popularMovies.isEmpty) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.popularMovies.length,
                          itemBuilder: (context, index) {
                            final genre = state.popularMovies[index];
                            if (genre.movies == null || genre.movies!.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: AppPadding.small),
                              child: Popular(
                                title: genre.genre.name,
                                slug: genre.genre.slug,
                                movies: genre.movies,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
