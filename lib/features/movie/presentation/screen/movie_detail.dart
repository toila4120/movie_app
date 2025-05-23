part of '../../movie.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({super.key});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  int _selectedServerIndex = 0;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, movieState) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authState) {
            if (movieState.loadingState.isLoading) {
              return const LoadingScreen();
            }
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
            return AppContainer(
              resizeToAvoidBottomInset: true,
              child: BaseScrollView(
                child: ScrollConfiguration(
                  behavior: const DisableGlowBehavior(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast,
                      parent: FixedExtentScrollPhysics(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderMovieDetail(movie: movie),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.large,
                            vertical: AppPadding.small,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: AppPadding.small),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.star_half_rounded,
                                    color: AppColor.primary500,
                                    size: 20.w,
                                  ),
                                  SizedBox(width: AppPadding.superTiny),
                                  Text(
                                    movie.voteAverage == 0
                                        ? "5.0"
                                        : movie.voteAverage.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.primary500,
                                    ),
                                  ),
                                  SizedBox(width: AppPadding.superTiny),
                                  Icon(
                                    Icons.chevron_right_outlined,
                                    color: AppColor.primary500,
                                    size: 20.w,
                                  ),
                                  SizedBox(width: AppPadding.superTiny),
                                  Text(
                                    movie.year.toString(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: AppPadding.small),
                                  ItemContainer(title: movie.lang),
                                ],
                              ),
                              SizedBox(height: AppPadding.medium),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomAppButton(
                                      onPressed: () {
                                        final latestEpisodeIndex = watchedMovie
                                                .watchedEpisodes.keys.isNotEmpty
                                            ? watchedMovie.watchedEpisodes.keys
                                                    .reduce((a, b) =>
                                                        a > b ? a : b) -
                                                1
                                            : 0;
                                        context.push(AppRouter.playMoviePath,
                                            extra: {
                                              'movie': movie,
                                              'episodeIndex':
                                                  latestEpisodeIndex,
                                              'serverIndex':
                                                  _selectedServerIndex,
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppBorderRadius.r16.w),
                                          color: AppColor.primary500,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppPadding.small.w,
                                          vertical: AppPadding.tiny.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 10.w,
                                              backgroundColor: AppColor.white,
                                              child: Image.asset(
                                                AppImage.icPlay1,
                                                fit: BoxFit.cover,
                                                color: AppColor.primary500,
                                                width: 10.w,
                                                height: 10.w,
                                              ),
                                            ),
                                            SizedBox(width: AppPadding.tiny),
                                            Text(
                                              "Xem ngay",
                                              style: TextStyle(
                                                color: AppColor.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: AppPadding.medium),
                                  Expanded(
                                    child: CustomAppButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isDismissible: true,
                                          isScrollControlled: true,
                                          backgroundColor: AppColor.transparent,
                                          builder: (context) {
                                            return const DownloadBottomSheet();
                                          },
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppBorderRadius.r16.w),
                                          border: Border.all(
                                              color: AppColor.primary500),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppPadding.small.w,
                                          vertical: AppPadding.tiny.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppImage.icDownload,
                                              width: 16.w,
                                              color: AppColor.primary500,
                                            ),
                                            SizedBox(width: AppPadding.tiny),
                                            Text(
                                              "Tải xuống",
                                              style: TextStyle(
                                                color: AppColor.primary500,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppPadding.small),
                              Text(
                                "Thể loại: ${movie.categories.map((c) => c.name).join(", ")}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: AppPadding.tiny),
                              Text(
                                "Quốc gia: ${movie.countries.map((c) => c.name).join(", ")}",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: AppPadding.tiny),
                              ExpandableText(
                                  text: HtmlUnescape().convert(movie.content)),
                              SizedBox(height: AppPadding.medium),
                              movieState.actor!.isEmpty
                                  ? Text(
                                      "Danh sách diễn viên: ${movie.actor.join(", ")}",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : SizedBox(
                                      height: 76.w,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: movieState.actor!.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              left: index == 0
                                                  ? 0
                                                  : AppPadding.tiny,
                                              right: AppPadding.tiny,
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 56.w,
                                                  height: 56.w,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      movieState.actor![index]
                                                              .image ??
                                                          '',
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Icon(
                                                          Icons.broken_image,
                                                          size: 28.w,
                                                          color: Colors
                                                              .grey.shade600,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        AppPadding.superTiny),
                                                Text(
                                                  movieState
                                                      .actor![index].name!,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              SizedBox(height: AppPadding.medium),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                    placeholder:
                                                        (context, url) =>
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
                                                SizedBox(
                                                    width: AppPadding.small),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        episode.name,
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      if (watchedEpisode !=
                                                          null)
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
                                            onPressed: () {
                                              context.push(
                                                  AppRouter.playMoviePath,
                                                  extra: {
                                                    'movie': movie,
                                                    'episodeIndex': index,
                                                    'serverIndex':
                                                        _selectedServerIndex,
                                                  });
                                            },
                                            child: CircleAvatar(
                                              radius: 20.w,
                                              backgroundImage: const AssetImage(
                                                  AppImage.icPlay),
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
                      ],
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
