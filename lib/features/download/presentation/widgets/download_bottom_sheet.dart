part of '../../download.dart';

class DownloadBottomSheet extends StatefulWidget {
  const DownloadBottomSheet({super.key});

  @override
  State<DownloadBottomSheet> createState() => _DownloadBottomSheetState();
}

class _DownloadBottomSheetState extends State<DownloadBottomSheet> {
  int _selectedServerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, movieState) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authState) {
            final movie = movieState.movie!;
            final watchedMovies = authState.user?.watchedMovies ?? [];
            final watchedMovie = watchedMovies.firstWhere(
              (m) => m.movieId == movie.id,
              orElse: () => WatchedMovie(
                movieId: movie.slug,
                isSeries: movie.episodeTotal != "1",
                name: movie.name,
                thumbUrl: movie.thumbUrl,
                episodeTotal: int.tryParse(movie.episodeTotal) ?? 0,
                time: int.tryParse(
                        movie.time.replaceAll(RegExp(r'[^0-9]'), '')) ??
                    60,
              ),
            );
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Container(
                padding: EdgeInsets.only(
                  left: AppPadding.medium,
                  right: AppPadding.medium,
                  top: AppPadding.medium,
                  bottom: AppPadding.tiny,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppBorderRadius.r28.w),
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(
                            AppBorderRadius.r28.w,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Danh sách tập",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                DropdownButton<int>(
                                  value: _selectedServerIndex,
                                  items: movie.episodes
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    return DropdownMenuItem<int>(
                                      value: entry.key,
                                      child: Text(entry.value.serverName),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedServerIndex = value!;
                                    });
                                  },
                                  underline: const SizedBox.shrink(),
                                ),
                              ],
                            ),
                            SizedBox(height: AppPadding.superTiny),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: movie.episodes[_selectedServerIndex]
                                  .serverData.length,
                              itemBuilder: (context, index) {
                                final episode = movie
                                    .episodes[_selectedServerIndex]
                                    .serverData[index];
                                final watchedEpisode =
                                    watchedMovie.watchedEpisodes[index + 1];
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  AppBorderRadius.r8.w,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: movie.thumbUrl,
                                                  height: 60.w,
                                                  width: 60.w,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    color:
                                                        AppColor.greyScale100,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    color:
                                                        AppColor.greyScale100,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: AppPadding.small),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      episode.name,
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    if (watchedEpisode != null)
                                                      Text(
                                                        "Server: ${watchedEpisode.serverName}",
                                                        style: TextStyle(
                                                          color: AppColor
                                                              .greyScale500,
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        CustomAppButton(
                                          onPressed: () {},
                                          child: CircleAvatar(
                                            radius: 20.w,
                                            backgroundColor:
                                                AppColor.primary500,
                                            child: const Icon(
                                              Icons.download,
                                              color: AppColor.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: AppPadding.small),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
