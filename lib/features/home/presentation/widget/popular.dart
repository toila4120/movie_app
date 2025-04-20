part of '../../home.dart';

class Popular extends StatelessWidget {
  final String? title;
  final String? slug;
  const Popular({
    super.key,
    this.title = 'Phim nổi bật',
    this.slug = 'phim-moi-cap-nhat-v3',
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title ?? 'Phim nổi bật',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                CustomAppButton(
                  onPressed: () {
                    context.read<MovieBloc>().add(const FetchNewMoviesEvent(
                          page: 1,
                        ));
                    context.push(
                      AppRouter.listMoviePath,
                      extra: {
                        'input': title,
                        'input2': slug,
                      },
                    );
                  },
                  text: "Xem tất cả",
                  textStyle: TextStyle(
                    fontSize: 12.sp,
                    color: AppColor.primary500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppPadding.tiny),
            slug == "phim-moi-cap-nhat-v3"
                ? SizedBox(
                    height: 190.w,
                    child: ListView.builder(
                      itemCount: state.bannerMovies.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: index == 0
                              ? EdgeInsets.only(
                                  right: AppPadding.superTiny,
                                )
                              : EdgeInsets.symmetric(
                                  horizontal: AppPadding.superTiny,
                                ),
                          child: CustomAppButton(
                            onPressed: () {
                              context
                                  .read<MovieBloc>()
                                  .add(FetchMovieDetailEvent(
                                    slug: state.bannerMovies[index].slug,
                                  ));
                              context.push(AppRouter.movieDetailPath);
                            },
                            child: _ItemFilmPopular(
                              movieForBannerEntity: state.bannerMovies[index],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(
                    height: 190.w,
                    child: ListView.builder(
                      // Flatten the movies from all MovieWithGenre items
                      itemCount: state.popularMovies.fold<int>(
                          0, (sum, genre) => sum + (genre.movies?.length ?? 0)),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        // Find the movie at the flattened index
                        int currentIndex = 0;
                        MovieEntity? targetMovie;
                        for (var genre in state.popularMovies) {
                          if (genre.movies != null) {
                            for (var movie in genre.movies!) {
                              if (currentIndex == index) {
                                targetMovie = movie;
                                break;
                              }
                              currentIndex++;
                            }
                          }
                          if (targetMovie != null) break;
                        }

                        if (targetMovie == null) return SizedBox.shrink();

                        return Container(
                          padding: index == 0
                              ? EdgeInsets.only(
                                  right: AppPadding.superTiny,
                                )
                              : EdgeInsets.symmetric(
                                  horizontal: AppPadding.superTiny,
                                ),
                          child: CustomAppButton(
                            onPressed: () {
                              context
                                  .read<MovieBloc>()
                                  .add(FetchMovieDetailEvent(
                                    slug: targetMovie!.slug,
                                  ));
                              context.push(AppRouter.movieDetailPath);
                            },
                            child: _ItemFilmPopular(
                              movieForBannerEntity: targetMovie,
                            ),
                          ),
                        );
                      },
                    ),
                  )
          ],
        );
      },
    );
  }
}

class _ItemFilmPopular extends StatelessWidget {
  final MovieEntity movieForBannerEntity;
  const _ItemFilmPopular({
    required this.movieForBannerEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppBorderRadius.r8.w),
          child: CachedNetworkImage(
            key: ValueKey(movieForBannerEntity.posterUrl),
            imageUrl: movieForBannerEntity.posterUrl,
            height: 164.w,
            width: 120.w,
            fit: BoxFit.fill,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 164.w,
                width: 120.w,
                color: Colors.grey.shade300,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 164.w,
              width: 120.w,
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
        SizedBox(height: AppPadding.tiny),
        SizedBox(
          width: 120.w,
          child: Text(
            movieForBannerEntity.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColor.greyScale500,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
