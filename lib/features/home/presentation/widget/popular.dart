part of '../../home.dart';

class Popular extends StatelessWidget {
  final String? title;
  final String? slug;
  final List<MovieEntity>? movies;
  const Popular({
    super.key,
    this.title = 'Phim nổi bật',
    this.slug = 'phim-moi-cap-nhat-v3',
    this.movies,
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
                    movies == null
                        ? context
                            .read<MovieBloc>()
                            .add(const FetchNewMoviesEvent(
                              page: 1,
                            ))
                        : context.read<MovieBloc>().add(FetchMoviesByCategory(
                              categorySlug: slug!,
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
            movies == null
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
                      itemCount: movies!.length,
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
                                    slug: movies![index].slug,
                                  ));
                              context.push(AppRouter.movieDetailPath);
                            },
                            child: _ItemFilmPopular(
                              movieForBannerEntity: movies![index],
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
          child: ProgressiveImage(
            key: ValueKey(normalizeImageUrl(movieForBannerEntity.posterUrl)),
            imageUrl: normalizeImageUrl(movieForBannerEntity.posterUrl),
            height: 164.w,
            width: 120.w,
            fit: BoxFit.fill,
            forceHighQuality: true,
            memCacheWidth: 120,
            memCacheHeight: 164,
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
