part of '../../home.dart';

class ContinueWatching extends StatelessWidget {
  const ContinueWatching({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final watchedMovies = state.user?.watchedMovies ?? [];
        if (watchedMovies.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Video đang xem',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                CustomAppButton(
                  text: "Xem tất cả",
                  textStyle: TextStyle(
                    fontSize: 12.sp,
                    color: AppColor.primary500,
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () {
                    context.push(AppRouter.watchedMovieScreenPath);
                  },
                ),
              ],
            ),
            SizedBox(height: AppPadding.tiny),
            SizedBox(
              height: 120.w,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                itemCount: watchedMovies.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: index == 0
                        ? EdgeInsets.only(right: AppPadding.superTiny)
                        : EdgeInsets.symmetric(
                            horizontal: AppPadding.superTiny),
                    child: _ItemFilmContinue(
                      watchedMovie: watchedMovies[index],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ItemFilmContinue extends StatelessWidget {
  final WatchedMovie watchedMovie;

  const _ItemFilmContinue({required this.watchedMovie});

  @override
  Widget build(BuildContext context) {
    final latestEpisode = watchedMovie.watchedEpisodes.keys.isNotEmpty
        ? watchedMovie.watchedEpisodes.keys.reduce((a, b) => a > b ? a : b)
        : 1;
    final latestWatchedEpisode = watchedMovie.watchedEpisodes[latestEpisode];
    final durationInMinutes = latestWatchedEpisode?.duration.inMinutes ?? 0;
    final progress = watchedMovie.isSeries
        ? watchedMovie.watchedEpisodes[latestEpisode]!.duration.inMinutes /
            (watchedMovie.time.toDouble())
        : watchedMovie.watchedEpisodes[latestEpisode]!.duration.inMinutes
                .toDouble() /
            (watchedMovie.time.toDouble());

    return GestureDetector(
      onTap: () {
        context
            .read<MovieBloc>()
            .add(FetchMovieDetailEvent(slug: watchedMovie.movieId));
        context.push(AppRouter.movieDetailPath);
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppBorderRadius.r8.w),
            child: CachedNetworkImage(
              key: ValueKey(watchedMovie.thumbUrl),
              imageUrl: watchedMovie.thumbUrl,
              height: 120.h,
              width: 172.w,
              fit: BoxFit.fill,
              fadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 200),
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  color: Colors.grey.shade300,
                ),
              ),
              errorWidget: (context, url, error) => Container(
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(AppBorderRadius.r8),
              ),
              padding: EdgeInsets.symmetric(
                vertical: AppPadding.superTiny,
                horizontal: AppPadding.tiny,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              watchedMovie.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColor.white,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              watchedMovie.isSeries
                                  ? "Tập $latestEpisode/${watchedMovie.episodeTotal} - ${((durationInMinutes / watchedMovie.time) * 100).toStringAsFixed(1)}%"
                                  : "${((durationInMinutes / watchedMovie.time) * 100).toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColor.white,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppPadding.tiny),
                  LinearProgressIndicator(
                    minHeight: AppPadding.superTiny,
                    borderRadius: BorderRadius.circular(AppBorderRadius.r4),
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: AppColor.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColor.primary500),
                  ),
                  SizedBox(height: AppPadding.superTiny),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
