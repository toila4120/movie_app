part of '../../home.dart';

class ItemWatching extends StatelessWidget {
  final WatchedMovie watchedMovie;

  const ItemWatching({
    super.key,
    required this.watchedMovie,
  });

  @override
  Widget build(BuildContext context) {
    final latestEpisode = watchedMovie.watchedEpisodes.keys.isNotEmpty
        ? watchedMovie.watchedEpisodes.keys.reduce((a, b) => a > b ? a : b)
        : 1;
    final latestWatchedEpisode = watchedMovie.watchedEpisodes[latestEpisode];
    final serverName = latestWatchedEpisode?.serverName ?? 'Unknown';
    final durationInMinutes = latestWatchedEpisode?.duration.inMinutes ?? 0;

    return CustomAppButton(
      onPressed: () async {
        final movieBloc = context.read<MovieBloc>();
        movieBloc.add(FetchMovieDetailEvent(
          slug: watchedMovie.movieId,
        ));
        await Future.delayed(const Duration(milliseconds: 1000));
        if (!context.mounted) return;
        final movie = movieBloc.state.movie;
        if (movie != null) {
          final serverIndex = movie.episodes.indexWhere(
                    (server) => server.serverName == serverName,
                  ) >=
                  0
              ? movie.episodes
                  .indexWhere((server) => server.serverName == serverName)
              : 0;
          context.push(AppRouter.playMoviePath, extra: {
            'movie': movie,
            'episodeIndex': latestEpisode - 1,
            'serverIndex': serverIndex,
            'currentPosition': watchedMovie
                    .watchedEpisodes[latestEpisode]?.duration.inSeconds ??
                0,
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.tiny,
          vertical: AppPadding.tiny,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.r16),
          border: Border.all(
            color: Theme.of(context).primaryColorDark.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Hero(
                    tag: watchedMovie.movieId,
                    flightShuttleBuilder: (
                      BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: flightDirection == HeroFlightDirection.push
                            ? fromHeroContext.widget
                            : toHeroContext.widget,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppBorderRadius.r16),
                      child: CachedNetworkImage(
                        key: ValueKey(normalizeImageUrl(watchedMovie.thumbUrl)),
                        imageUrl: normalizeImageUrl(watchedMovie.thumbUrl),
                        width: 200.w,
                        height: 144.w,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 120.w,
                            height: 88.w,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 120.w,
                          height: 88.w,
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
                  ),
                  SizedBox(width: AppPadding.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          watchedMovie.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        watchedMovie.isSeries
                            ? SizedBox(height: AppPadding.superTiny)
                            : const SizedBox(height: 0),
                        watchedMovie.isSeries
                            ? Text(
                                "Tập ${latestEpisode.toString()}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColor.greyScale500,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : const SizedBox(height: 0),
                        SizedBox(height: AppPadding.superTiny),
                        Text(
                          "Đã xem ${((durationInMinutes / watchedMovie.time) * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.greyScale500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppPadding.tiny),
            Image.asset(
              AppImage.icRight,
              width: 16.w,
              height: 16.w,
              color: Theme.of(context).primaryColorDark,
            ),
          ],
        ),
      ),
    );
  }
}
