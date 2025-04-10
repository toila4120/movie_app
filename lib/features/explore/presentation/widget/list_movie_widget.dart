part of '../../explore.dart';

class ListMovieWidget extends StatefulWidget {
  const ListMovieWidget({super.key});

  @override
  State<ListMovieWidget> createState() => _ListMovieWidgetState();
}

class _ListMovieWidgetState extends State<ListMovieWidget> {
  @override
  void initState() {
    context.read<HomeBloc>().add(FectchMovieForBannerMovies());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadingState.isLoading) {
          return const ItemShimmer();
        }
        if (state.bannerMovies.isEmpty) {
          return const Center(child: Text('Không có phim nào'));
        }
        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppPadding.small,
            mainAxisSpacing: AppPadding.small,
            childAspectRatio: 186 / 248,
          ),
          itemCount: state.bannerMovies.length,
          itemBuilder: (context, index) {
            final movie = state.bannerMovies[index];
            return CustomAppButton(
              onPressed: () {
                context
                    .read<MovieBloc>()
                    .add(FetchMovieDetailEvent(slug: movie.slug));
                context.push(AppRouter.movieDetailPath);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppBorderRadius.r8),
                child: CachedNetworkImage(
                  imageUrl: movie.posterUrl,
                  height: 248.w,
                  width: 186.w,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 248.w,
                      width: 186.w,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 248.w,
                    width: 186.w,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
