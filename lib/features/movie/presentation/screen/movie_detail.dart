part of '../../movie.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({
    super.key,
  });

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
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
      builder: (context, state) {
        return state.loadingState.isLoading
            ? const LoadingScreen()
            : AppContainer(
                resizeToAvoidBottomInset: true,
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
                        HeaderMovieDetail(
                          movie: state.movie!,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.large,
                            vertical: AppPadding.small,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.movie!.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.greyScale900,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: AppPadding.small),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_half_rounded,
                                    color: AppColor.primary500,
                                    size: 20.w,
                                  ),
                                  SizedBox(width: AppPadding.superTiny),
                                  Text(
                                    state.movie!.voteAverage == 0
                                        ? "5.0"
                                        : state.movie!.voteAverage
                                            .toStringAsFixed(1),
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
                                    state.movie!.year.toString(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.greyScale800,
                                    ),
                                  ),
                                  SizedBox(width: AppPadding.small),
                                  ItemContainer(
                                    title: state.movie!.countries
                                        .map((countries) => countries.name)
                                        .join(", "),
                                  ),
                                  SizedBox(width: AppPadding.tiny),
                                  ItemContainer(
                                    title: state.movie!.lang,
                                  ),
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
                                        context.push(AppRouter.playMoviePath,
                                            extra: {
                                              'url': state.movie!.episodes.first
                                                  .serverData.first.linkM3u8,
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            AppBorderRadius.r16,
                                          ),
                                          color: AppColor.primary500,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppPadding.small,
                                          vertical: AppPadding.tiny,
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
                                      onPressed: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              AppBorderRadius.r16,
                                            ),
                                            border: Border.all(
                                              color: AppColor.primary500,
                                            )),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppPadding.small,
                                          vertical: AppPadding.tiny,
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
                              SizedBox(height: AppPadding.medium),
                              Text(
                                "Thể loại: ${state.movie!.categories.map((category) => category.name).join(", ")}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColor.greyScale900,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: AppPadding.small),
                              ExpandableText(
                                text: HtmlUnescape()
                                    .convert(state.movie!.content),
                              ),
                              SizedBox(height: AppPadding.medium),
                              state.actor!.isEmpty
                                  ? Text(
                                      "Danh sách diễn viên: ${state.movie!.actor.map((cast) => cast).join(", ")}",
                                      style: TextStyle(
                                        color: AppColor.greyScale900,
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
                                        itemCount: state.actor?.length ?? 0,
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
                                                CircleAvatar(
                                                  radius: 28.w,
                                                  backgroundImage: NetworkImage(
                                                    state.actor![index].image!,
                                                  ),
                                                ),
                                                SizedBox(
                                                    width:
                                                        AppPadding.superTiny),
                                                Text(
                                                  state.actor![index].name!,
                                                  style: TextStyle(
                                                    color:
                                                        AppColor.greyScale900,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              SizedBox(height: AppPadding.medium),
                              Text(
                                "Episodes",
                                style: TextStyle(
                                  color: AppColor.greyScale900,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: AppPadding.superTiny),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 60.w,
                                                  width: 60.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      AppPadding.superTiny,
                                                    ),
                                                    color:
                                                        AppColor.greyScale100,
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
                                                        "Episode 1",
                                                        style: TextStyle(
                                                          color: AppColor
                                                              .greyScale900,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Text(
                                                        "56:00",
                                                        style: TextStyle(
                                                          color: AppColor
                                                              .greyScale500,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomAppButton(
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
              );
      },
    );
  }
}
