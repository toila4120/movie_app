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
        // Prevent multiple taps
        if (!context.mounted) return;

        try {
          final movieBloc = context.read<MovieBloc>();

          // Clear movie state trước khi fetch movie mới để tránh conflict
          movieBloc.add(const ClearMovieStateEvent());

          // Fetch movie detail mới
          movieBloc.add(FetchMovieDetailEvent(
            slug: watchedMovie.movieId,
          ));

          // Đợi cho đến khi movie được load xong
          await for (final state in movieBloc.stream) {
            if (state.loadingState == LoadingState.finished &&
                state.movie != null) {
              final movie = state.movie!;

              // Validate dữ liệu trước khi navigation
              if (movie.episodes.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Phim này không có tập nào để xem')),
                  );
                }
                return;
              }

              // Tìm server index phù hợp
              int serverIndex = 0;
              if (serverName != 'Unknown') {
                final foundIndex = movie.episodes.indexWhere(
                  (server) => server.serverName == serverName,
                );
                if (foundIndex >= 0) {
                  serverIndex = foundIndex;
                }
              }

              // Validate server index
              if (serverIndex >= movie.episodes.length) {
                serverIndex = 0;
              }

              // Validate episode index
              int episodeIndex = latestEpisode - 1;
              if (episodeIndex < 0) {
                episodeIndex = 0;
              }

              final selectedServer = movie.episodes[serverIndex];
              if (episodeIndex >= selectedServer.serverData.length) {
                episodeIndex = selectedServer.serverData.isNotEmpty
                    ? selectedServer.serverData.length - 1
                    : 0;
              }

              // Validate lần cuối trước khi navigation
              if (selectedServer.serverData.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Server này không có tập nào để xem')),
                  );
                }
                return;
              }

              if (context.mounted) {
                context.push(AppRouter.playMoviePath, extra: {
                  'movie': movie,
                  'episodeIndex': episodeIndex,
                  'serverIndex': serverIndex,
                  'currentPosition': watchedMovie
                          .watchedEpisodes[latestEpisode]?.duration.inSeconds ??
                      0,
                });
              }
              break;
            } else if (state.loadingState == LoadingState.error) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Lỗi tải phim: ${state.errorMessage ?? 'Unknown error'}')),
                );
              }
              break;
            }
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Có lỗi xảy ra: $e')),
            );
          }
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
            SizedBox(
              height: 144.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomAppButton(
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(
                            RemoveWatchedMovieEvent(
                              movieId: watchedMovie.movieId,
                            ),
                          );
                    },
                    child: const Icon(Icons.close_rounded),
                  ),
                  Image.asset(
                    AppImage.icRight,
                    width: 16.w,
                    height: 16.w,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  const SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
